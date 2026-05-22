import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/models/plant_model.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/repositories/plant_repository.dart';
import '../../domain/entities/plant.dart';

final plantRemoteDataSourceProvider = Provider<PlantRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PlantRemoteDataSource(dioClient.dio);
});

final plantRepositoryProvider = Provider<PlantRepository>((ref) {
  final dataSource = ref.watch(plantRemoteDataSourceProvider);
  return PlantRepositoryImpl(dataSource);
});

/// Plants for selected site
final plantsProvider = FutureProvider.autoDispose<List<Plant>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final repository = ref.watch(plantRepositoryProvider);
  return ref.retryOnError(() async {
    final result = await repository.getPlants(siteId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (plants) => plants,
    );
  });
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
  final repository = ref.watch(plantRepositoryProvider);
  return ref.retryOnError(() async {
    final result = await repository.getVarietas();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (varietas) => varietas,
    );
  });
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
  final PlantRepository _repository;
  final Ref _ref;

  CreatePlantNotifier(this._repository, this._ref)
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
      final result = await _repository.createPlant(siteId, {
        'plant_name': plantName,
        'varietas_id': varietasId,
        'plant_type': plantType.name,
        'plant_species': plantSpecies,
        'plant_date': plantDate.toIso8601String().split('T').first,
      });

      return result.fold(
        (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        },
        (plant) {
          state = state.copyWith(isLoading: false, plant: PlantModel.fromEntity(plant));
          _ref.invalidate(plantsProvider);
          return true;
        },
      );
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
      final repository = ref.watch(plantRepositoryProvider);
      return CreatePlantNotifier(repository, ref);
    });

/// Plant detail provider
final plantDetailProvider = FutureProvider.family<Plant, String>((
  ref,
  plantId,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) throw Exception('No site selected');

  final repository = ref.watch(plantRepositoryProvider);
  return ref.retryOnError(() async {
    final result = await repository.getPlantById(siteId, plantId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (plant) => plant,
    );
  });
});

/// Plant screen state for managing UI flow
enum PlantScreenState { loading, empty, input, hasData }

final plantScreenStateProvider = StateProvider<PlantScreenState>((ref) {
  return PlantScreenState.loading;
});
