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
final utilitasPlantListProvider = FutureProvider.autoDispose<List<Plant>>((
  ref,
) async {
  final repository = ref.watch(plantRepositoryProvider);
  final selectedSite = ref.watch(selectedSiteProvider);

  if (selectedSite == null) {
    throw Exception('Tidak ada site yang dipilih');
  }

  final result = await repository.getPlantsBySite(selectedSite.siteId);
  return result.fold((f) => throw f, (data) => data);
});

// ═══════════════════════════════════════════════════════════
// PLANT DETAIL PROVIDER (by ID)
// ═══════════════════════════════════════════════════════════
final utilitasPlantDetailProvider = FutureProvider.autoDispose
    .family<Plant, String>((ref, plantId) async {
      final repository = ref.watch(plantRepositoryProvider);
      final selectedSite = ref.watch(selectedSiteProvider);

      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final result = await repository.getPlantById(
        selectedSite.siteId,
        plantId,
      );
      return result.fold((f) => throw f, (data) => data);
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

    final selectedSite = _ref.read(selectedSiteProvider);
    if (selectedSite == null) {
      state = const PlantFormState(error: 'Tidak ada site yang dipilih');
      return false;
    }

    final result = await _repository.createPlant(selectedSite.siteId, plant);

    return result.fold(
      (failure) {
        state = PlantFormState(error: failure.message);
        return false;
      },
      (savedPlant) {
        state = PlantFormState(savedPlant: savedPlant);
        _ref.invalidate(utilitasPlantListProvider);
        return true;
      },
    );
  }

  /// Update existing plant
  Future<bool> updatePlant(String plantId, Plant plant) async {
    state = state.copyWith(isLoading: true, error: null);

    final selectedSite = _ref.read(selectedSiteProvider);
    if (selectedSite == null) {
      state = const PlantFormState(error: 'Tidak ada site yang dipilih');
      return false;
    }

    final result = await _repository.updatePlant(
      selectedSite.siteId,
      plantId,
      plant,
    );

    return result.fold(
      (failure) {
        state = PlantFormState(error: failure.message);
        return false;
      },
      (savedPlant) {
        state = PlantFormState(savedPlant: savedPlant);
        _ref.invalidate(utilitasPlantListProvider);
        _ref.invalidate(utilitasPlantDetailProvider(plantId));
        return true;
      },
    );
  }

  /// Harvest plant (special operation)
  Future<bool> harvestPlant(String plantId) async {
    state = state.copyWith(isLoading: true, error: null);

    final selectedSite = _ref.read(selectedSiteProvider);
    if (selectedSite == null) {
      state = const PlantFormState(error: 'Tidak ada site yang dipilih');
      return false;
    }

    final result = await _repository.harvestPlant(selectedSite.siteId, plantId);

    return result.fold(
      (failure) {
        state = PlantFormState(error: failure.message);
        return false;
      },
      (harvestedPlant) {
        state = PlantFormState(savedPlant: harvestedPlant);
        _ref.invalidate(utilitasPlantListProvider);
        _ref.invalidate(utilitasPlantDetailProvider(plantId));
        return true;
      },
    );
  }

  /// Delete plant
  Future<bool> deletePlant(String plantId) async {
    state = state.copyWith(isLoading: true, error: null);

    final selectedSite = _ref.read(selectedSiteProvider);
    if (selectedSite == null) {
      state = const PlantFormState(error: 'Tidak ada site yang dipilih');
      return false;
    }

    final result = await _repository.deletePlant(selectedSite.siteId, plantId);

    return result.fold(
      (failure) {
        state = PlantFormState(error: failure.message);
        return false;
      },
      (_) {
        state = const PlantFormState();
        _ref.invalidate(utilitasPlantListProvider);
        return true;
      },
    );
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
    StateNotifierProvider.autoDispose<PlantFormNotifier, PlantFormState>((ref) {
      final repository = ref.watch(plantRepositoryProvider);
      return PlantFormNotifier(repository, ref);
    });
