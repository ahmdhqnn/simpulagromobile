import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/entities/plant.dart';
import '../../domain/repositories/plant_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE PROVIDER
// ═══════════════════════════════════════════════════════════
final plantRemoteDatasourceProvider = Provider<PlantRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PlantRemoteDatasourceImpl(dioClient.dio);
});

// ═══════════════════════════════════════════════════════════
// REPOSITORY PROVIDER
// ═══════════════════════════════════════════════════════════
final plantRepositoryProvider = Provider<PlantRepository>((ref) {
  final datasource = ref.watch(plantRemoteDatasourceProvider);
  return PlantRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// PLANT LIST PROVIDER (by selected site)
// ═══════════════════════════════════════════════════════════
final utilitasPlantListProvider = FutureProvider<List<Plant>>((ref) async {
  final repository = ref.watch(plantRepositoryProvider);
  final selectedSite = ref.watch(selectedSiteProvider);

  if (selectedSite == null) {
    throw Exception('Tidak ada site yang dipilih');
  }

  return repository.getPlantsBySite(selectedSite.siteId);
});

// ═══════════════════════════════════════════════════════════
// PLANT DETAIL PROVIDER (by ID)
// ═══════════════════════════════════════════════════════════
final utilitasPlantDetailProvider = FutureProvider.family<Plant, String>((
  ref,
  plantId,
) async {
  final repository = ref.watch(plantRepositoryProvider);
  final selectedSite = ref.watch(selectedSiteProvider);

  if (selectedSite == null) {
    throw Exception('Tidak ada site yang dipilih');
  }

  return repository.getPlantById(selectedSite.siteId, plantId);
});

// ═══════════════════════════════════════════════════════════
// PLANT FORM STATE
// ═══════════════════════════════════════════════════════════
class PlantFormState {
  final bool isLoading;
  final String? error;
  final Plant? savedPlant;

  const PlantFormState({this.isLoading = false, this.error, this.savedPlant});

  PlantFormState copyWith({bool? isLoading, String? error, Plant? savedPlant}) {
    return PlantFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedPlant: savedPlant ?? this.savedPlant,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PLANT FORM NOTIFIER
// ═══════════════════════════════════════════════════════════
class PlantFormNotifier extends StateNotifier<PlantFormState> {
  final PlantRepository _repository;
  final Ref _ref;

  PlantFormNotifier(this._repository, this._ref)
    : super(const PlantFormState());

  /// Create new plant
  Future<bool> createPlant(Plant plant) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final savedPlant = await _repository.createPlant(
        selectedSite.siteId,
        plant,
      );

      state = PlantFormState(savedPlant: savedPlant);

      // Invalidate list to refresh
      _ref.invalidate(utilitasPlantListProvider);

      return true;
    } catch (e) {
      state = PlantFormState(error: e.toString());
      return false;
    }
  }

  /// Update existing plant
  Future<bool> updatePlant(String plantId, Plant plant) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final savedPlant = await _repository.updatePlant(
        selectedSite.siteId,
        plantId,
        plant,
      );

      state = PlantFormState(savedPlant: savedPlant);

      // Invalidate list and detail to refresh
      _ref.invalidate(utilitasPlantListProvider);
      _ref.invalidate(utilitasPlantDetailProvider(plantId));

      return true;
    } catch (e) {
      state = PlantFormState(error: e.toString());
      return false;
    }
  }

  /// Harvest plant (special operation)
  Future<bool> harvestPlant(String plantId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final harvestedPlant = await _repository.harvestPlant(
        selectedSite.siteId,
        plantId,
      );

      state = PlantFormState(savedPlant: harvestedPlant);

      // Invalidate list and detail to refresh
      _ref.invalidate(utilitasPlantListProvider);
      _ref.invalidate(utilitasPlantDetailProvider(plantId));

      return true;
    } catch (e) {
      state = PlantFormState(error: e.toString());
      return false;
    }
  }

  /// Delete plant
  Future<bool> deletePlant(String plantId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      await _repository.deletePlant(selectedSite.siteId, plantId);

      state = const PlantFormState();

      // Invalidate list to refresh
      _ref.invalidate(utilitasPlantListProvider);

      return true;
    } catch (e) {
      state = PlantFormState(error: e.toString());
      return false;
    }
  }

  /// Reset form state
  void reset() {
    state = const PlantFormState();
  }
}

// ═══════════════════════════════════════════════════════════
// PLANT FORM PROVIDER
// ═══════════════════════════════════════════════════════════
final plantFormProvider =
    StateNotifierProvider<PlantFormNotifier, PlantFormState>((ref) {
      final repository = ref.watch(plantRepositoryProvider);
      return PlantFormNotifier(repository, ref);
    });
