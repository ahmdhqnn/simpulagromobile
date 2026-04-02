import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/models/plant_model.dart';
import '../../domain/entities/plant.dart';

final plantRemoteDataSourceProvider = Provider<PlantRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PlantRemoteDataSource(dioClient.dio);
});

/// Plants for selected site
final plantsProvider = FutureProvider.autoDispose<List<Plant>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final ds = ref.watch(plantRemoteDataSourceProvider);
  final models = await ds.getPlants(siteId);
  return models.map((m) => m.toEntity()).toList();
});

/// First plant for the selected site (most recent)
final currentPlantProvider = Provider<Plant?>((ref) {
  final plantsAsync = ref.watch(plantsProvider);
  return plantsAsync.whenOrNull(
    data: (plants) => plants.isNotEmpty ? plants.first : null,
  );
});

/// All varietas for dropdown
final varietasProvider = FutureProvider.autoDispose<List<VarietasModel>>((
  ref,
) async {
  final ds = ref.watch(plantRemoteDataSourceProvider);
  return ds.getVarietas();
});

/// Create plant state
class CreatePlantState {
  final bool isLoading;
  final String? error;
  final PlantModel? plant;

  const CreatePlantState({this.isLoading = false, this.error, this.plant});

  CreatePlantState copyWith({
    bool? isLoading,
    String? error,
    PlantModel? plant,
  }) {
    return CreatePlantState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      plant: plant ?? this.plant,
    );
  }
}

class CreatePlantNotifier extends StateNotifier<CreatePlantState> {
  final PlantRemoteDataSource _dataSource;
  final Ref _ref;

  CreatePlantNotifier(this._dataSource, this._ref)
    : super(const CreatePlantState());

  Future<bool> createPlant({
    required String siteId,
    required String plantName,
    required String varietasId,
    required CropType plantType,
    String? plantSpecies,
    required DateTime plantDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final plant = await _dataSource.createPlant(siteId, {
        'plant_name': plantName,
        'varietas_id': varietasId,
        'plant_type': plantType.displayName,
        'plant_species': plantSpecies,
        'plant_date': plantDate.toIso8601String().split('T').first,
      });

      state = state.copyWith(isLoading: false, plant: plant);

      // Invalidate the plants provider to refresh the list
      _ref.invalidate(plantsProvider);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const CreatePlantState();
  }
}

final createPlantProvider =
    StateNotifierProvider<CreatePlantNotifier, CreatePlantState>((ref) {
      final dataSource = ref.watch(plantRemoteDataSourceProvider);
      return CreatePlantNotifier(dataSource, ref);
    });

/// Plant detail provider
final plantDetailProvider = FutureProvider.family<Plant, String>((
  ref,
  plantId,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) throw Exception('No site selected');

  final ds = ref.watch(plantRemoteDataSourceProvider);
  final model = await ds.getPlantById(siteId, plantId);
  return model.toEntity();
});

/// Plant screen state for managing UI flow
enum PlantScreenState { loading, empty, input, hasData }

final plantScreenStateProvider = StateProvider<PlantScreenState>((ref) {
  return PlantScreenState.loading;
});
