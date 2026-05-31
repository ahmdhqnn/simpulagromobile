import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/models/plant_model.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/repositories/plant_repository.dart';
import '../../domain/entities/plant.dart';
import '../../domain/usecases/get_plants_usecase.dart';
import '../../domain/usecases/create_plant_usecase.dart';
import '../../domain/usecases/update_plant_usecase.dart';
import '../../domain/usecases/harvest_plant_usecase.dart';
import '../../domain/usecases/delete_plant_usecase.dart';

// ─── Infrastructure providers ─────────────────────────────────────────────────

final plantRemoteDataSourceProvider = Provider<PlantRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PlantRemoteDataSource(dioClient.dio);
});

final plantRepositoryProvider = Provider<PlantRepository>((ref) {
  final dataSource = ref.watch(plantRemoteDataSourceProvider);
  return PlantRepositoryImpl(dataSource);
});

// ─── UseCase providers ────────────────────────────────────────────────────────

final getPlantsUseCaseProvider = Provider<GetPlantsUseCase>((ref) {
  return GetPlantsUseCase(ref.watch(plantRepositoryProvider));
});

final getPlantByIdUseCaseProvider = Provider<GetPlantByIdUseCase>((ref) {
  return GetPlantByIdUseCase(ref.watch(plantRepositoryProvider));
});

final createPlantUseCaseProvider = Provider<CreatePlantUseCase>((ref) {
  return CreatePlantUseCase(ref.watch(plantRepositoryProvider));
});

final updatePlantUseCaseProvider = Provider<UpdatePlantUseCase>((ref) {
  return UpdatePlantUseCase(ref.watch(plantRepositoryProvider));
});

final harvestPlantUseCaseProvider = Provider<HarvestPlantUseCase>((ref) {
  return HarvestPlantUseCase(ref.watch(plantRepositoryProvider));
});

final deletePlantUseCaseProvider = Provider<DeletePlantUseCase>((ref) {
  return DeletePlantUseCase(ref.watch(plantRepositoryProvider));
});

// ─── List plants (AsyncNotifier) ─────────────────────────────────────────────

/// Mengelola daftar tanaman per site dengan polling otomatis.
///
/// - Polling follows the configured realtime refresh interval.
/// - Polling berhenti otomatis saat provider di-dispose (navigasi keluar).
/// - Saat polling, data lama tetap tampil (tidak ada loading flicker).
/// - non-autoDispose agar mutation tidak memicu "Notifier after dispose".
class PlantsNotifier extends AsyncNotifier<List<Plant>> {
  bool _disposed = false;
  bool _polling = false;

  @override
  Future<List<Plant>> build() async {
    ref.watch(selectedSiteIdProvider);
    ref.listen<AsyncValue<int>>(realtimeRefreshTickProvider, (previous, next) {
      next.whenData((_) => unawaited(_pollSilently()));
    });

    // Centralized tick keeps polling aligned with app-level refresh settings.
    ref.onDispose(() => _disposed = true);

    final plants = await _fetchPlants();
    _syncScreenState(plants);
    return plants;
  }

  /// Poll tanpa menampilkan loading — data lama tetap tampil sampai data baru tiba.
  Future<void> _pollSilently() async {
    if (_disposed || _polling) return;

    // Jangan poll saat user sedang di form input
    final screenState = ref.read(plantScreenStateProvider);
    if (screenState == PlantScreenState.input) return;

    _polling = true;
    try {
      final fresh = await _fetchPlants();

      // Timer sudah di-cancel (provider disposed) — hentikan
      if (_disposed) return;

      // Update state hanya jika data berubah
      final current = state.valueOrNull;
      if (_hasChanged(current, fresh)) {
        state = AsyncData(fresh);
        _syncScreenState(fresh);
      }
    } catch (_) {
      // Polling gagal — abaikan, data lama tetap tampil
    } finally {
      _polling = false;
    }
  }

  Future<List<Plant>> _fetchPlants({bool? isOnGoingPlant}) async {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId == null) return [];

    final useCase = ref.read(getPlantsUseCaseProvider);
    final result = await useCase(siteId, isOnGoingPlant: isOnGoingPlant);
    return result.fold((failure) => throw failure, (plants) => plants);
  }

  /// Refresh manual (pull-to-refresh) — tampilkan loading di atas data lama.
  Future<void> refresh() async {
    final previous = state.valueOrNull;
    state = previous == null
        ? const AsyncValue.loading()
        : AsyncValue<List<Plant>>.loading().copyWithPrevious(
            AsyncData(previous),
          );

    final next = await AsyncValue.guard(() => _fetchPlants());
    state = next.hasError && previous != null
        ? AsyncValue<List<Plant>>.error(
            next.error!,
            next.stackTrace ?? StackTrace.current,
          ).copyWithPrevious(AsyncData(previous))
        : next;

    if (state.hasValue) _syncScreenState(state.value!);
  }

  /// Sinkronkan [plantScreenStateProvider] berdasarkan data terbaru.
  void _syncScreenState(List<Plant> plants) {
    if (_disposed) return;
    final screenState = ref.read(plantScreenStateProvider);
    // Jangan override saat user sedang di form input
    if (screenState == PlantScreenState.input) return;

    final hasActive = plants.any((p) => p.isCurrentPlanting);
    ref.read(plantScreenStateProvider.notifier).state = hasActive
        ? PlantScreenState.hasData
        : PlantScreenState.empty;
  }

  /// Cek apakah list tanaman berubah (berdasarkan ID + status + harvest).
  bool _hasChanged(List<Plant>? current, List<Plant> fresh) {
    if (current == null) return true;
    if (current.length != fresh.length) return true;

    for (var i = 0; i < current.length; i++) {
      final a = current[i];
      final b = fresh[i];
      if (a.plantId != b.plantId ||
          a.plantSts != b.plantSts ||
          a.plantHarvest != b.plantHarvest ||
          a.plantName != b.plantName ||
          a.plantType != b.plantType) {
        return true;
      }
    }
    return false;
  }
}

final plantsProvider = AsyncNotifierProvider<PlantsNotifier, List<Plant>>(
  PlantsNotifier.new,
);

/// Tanaman aktif via query `isOnGoingPlant=true` (sesuai Swagger).
final ongoingPlantProvider = FutureProvider<Plant?>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return null;

  final result = await ref.read(getPlantsUseCaseProvider)(
    siteId,
    isOnGoingPlant: true,
  );
  return result.fold((_) => null, (plants) => plants.firstOrNull);
});

/// Tanaman aktif pertama — untuk guard form create & banner.
final currentPlantProvider = Provider<Plant?>((ref) {
  return ref.watch(ongoingPlantProvider).valueOrNull;
});

/// Detail satu tanaman berdasarkan ID — dengan polling otomatis.
final plantDetailProvider = FutureProvider.family<Plant, String>((
  ref,
  plantId,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) throw Exception('No site selected');

  final useCase = ref.read(getPlantByIdUseCaseProvider);
  final result = await useCase(siteId, plantId);
  return result.fold((failure) => throw failure, (plant) => plant);
});

// ─── Plant screen state ───────────────────────────────────────────────────────

enum PlantScreenState { loading, empty, input, hasData }

final plantScreenStateProvider = StateProvider<PlantScreenState>((ref) {
  return PlantScreenState.loading;
});

// ─── Mutation result ──────────────────────────────────────────────────────────

@immutable
class PlantMutationResult {
  final bool success;
  final String? errorMessage;
  final Plant? plant;

  const PlantMutationResult.success([this.plant])
    : success = true,
      errorMessage = null;

  const PlantMutationResult.failure(this.errorMessage)
    : success = false,
      plant = null;
}

// ─── Create plant ─────────────────────────────────────────────────────────────

class CreatePlantState {
  final bool isLoading;
  final String? error;
  final Plant? plant;

  const CreatePlantState({this.isLoading = false, this.error, this.plant});

  CreatePlantState copyWith({bool? isLoading, String? error, Plant? plant}) {
    return CreatePlantState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      plant: plant ?? this.plant,
    );
  }
}

class CreatePlantNotifier extends StateNotifier<CreatePlantState> {
  final CreatePlantUseCase _useCase;
  final Ref _ref;

  CreatePlantNotifier(this._useCase, this._ref)
    : super(const CreatePlantState());

  Future<PlantMutationResult> createPlant({
    required String siteId,
    required String plantName,
    required String varietasId,
    required CropType plantType,
    required DateTime plantDate,
  }) async {
    if (!mounted) {
      return const PlantMutationResult.failure('Form sudah ditutup');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final payload = PlantWritePayload(
        plantName: plantName,
        varietasId: varietasId,
        plantDate: plantDate,
        plantType: plantType.name,
      ).toJson();

      final result = await _useCase(siteId, payload);

      if (!mounted) {
        return const PlantMutationResult.failure('Form sudah ditutup');
      }

      return result.fold(
        (failure) {
          if (!mounted) {
            return PlantMutationResult.failure(failure.message);
          }
          state = state.copyWith(isLoading: false, error: failure.message);
          return PlantMutationResult.failure(failure.message);
        },
        (plant) {
          if (!mounted) {
            return PlantMutationResult.success(plant);
          }
          state = state.copyWith(isLoading: false, plant: plant, error: null);
          unawaited(refreshPlantLists(_ref));
          return PlantMutationResult.success(plant);
        },
      );
    } catch (e) {
      if (!mounted) {
        return PlantMutationResult.failure(e.toString());
      }
      state = state.copyWith(isLoading: false, error: e.toString());
      return PlantMutationResult.failure(e.toString());
    }
  }

  void reset() => state = const CreatePlantState();
}

final createPlantProvider =
    StateNotifierProvider<CreatePlantNotifier, CreatePlantState>((ref) {
      return CreatePlantNotifier(ref.watch(createPlantUseCaseProvider), ref);
    });

// ─── Update plant ─────────────────────────────────────────────────────────────

class UpdatePlantState {
  final bool isLoading;
  final String? error;
  final Plant? plant;

  const UpdatePlantState({this.isLoading = false, this.error, this.plant});

  UpdatePlantState copyWith({bool? isLoading, String? error, Plant? plant}) {
    return UpdatePlantState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      plant: plant ?? this.plant,
    );
  }
}

class UpdatePlantNotifier extends StateNotifier<UpdatePlantState> {
  final UpdatePlantUseCase _useCase;
  final Ref _ref;

  UpdatePlantNotifier(this._useCase, this._ref)
    : super(const UpdatePlantState());

  Future<PlantMutationResult> updatePlant({
    required String siteId,
    required String plantId,
    required String plantName,
    required String varietasId,
    required CropType plantType,
    required DateTime plantDate,
  }) async {
    if (!mounted) {
      return const PlantMutationResult.failure('Form sudah ditutup');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final payload = PlantWritePayload(
        plantName: plantName,
        varietasId: varietasId,
        plantDate: plantDate,
        plantType: plantType.name,
      ).toJson();

      final result = await _useCase(siteId.trim(), plantId.trim(), payload);

      if (!mounted) {
        return const PlantMutationResult.failure('Form sudah ditutup');
      }

      return result.fold(
        (failure) {
          final message = _mapUpdateFailureMessage(failure);
          if (!mounted) {
            return PlantMutationResult.failure(message);
          }
          state = state.copyWith(isLoading: false, error: message);
          return PlantMutationResult.failure(message);
        },
        (plant) {
          if (!mounted) {
            return PlantMutationResult.success(plant);
          }
          state = state.copyWith(isLoading: false, plant: plant, error: null);
          unawaited(refreshPlantLists(_ref, plantId: plantId));
          return PlantMutationResult.success(plant);
        },
      );
    } catch (e) {
      if (!mounted) {
        return PlantMutationResult.failure(e.toString());
      }
      state = state.copyWith(isLoading: false, error: e.toString());
      return PlantMutationResult.failure(e.toString());
    }
  }

  void reset() => state = const UpdatePlantState();
}

String _mapUpdateFailureMessage(Failure failure) {
  if (failure is ServerFailure && failure.statusCode == 500) {
    return 'Server gagal memproses update (HTTP 500). '
        'Payload aplikasi sudah sesuai Swagger — mohon tim backend cek log handler '
        'PUT /sites/{siteId}/plants/{plantId}.';
  }
  return failure.message;
}

final updatePlantFormProvider =
    StateNotifierProvider<UpdatePlantNotifier, UpdatePlantState>((ref) {
      return UpdatePlantNotifier(ref.watch(updatePlantUseCaseProvider), ref);
    });

// ─── Harvest plant ────────────────────────────────────────────────────────────

class HarvestPlantState {
  final bool isLoading;
  final String? error;

  const HarvestPlantState({this.isLoading = false, this.error});

  HarvestPlantState copyWith({bool? isLoading, String? error}) {
    return HarvestPlantState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HarvestPlantNotifier extends StateNotifier<HarvestPlantState> {
  final HarvestPlantUseCase _useCase;
  final Ref _ref;

  HarvestPlantNotifier(this._useCase, this._ref)
    : super(const HarvestPlantState());

  Future<PlantMutationResult> harvest({
    required String siteId,
    required String plantId,
  }) async {
    if (!mounted) {
      return const PlantMutationResult.failure('Operasi dibatalkan');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _useCase(siteId.trim(), plantId.trim());

      if (!mounted) {
        return const PlantMutationResult.failure('Operasi dibatalkan');
      }

      return result.fold(
        (failure) {
          if (mounted) {
            state = state.copyWith(isLoading: false, error: failure.message);
          }
          return PlantMutationResult.failure(failure.message);
        },
        (plant) {
          if (mounted) {
            state = state.copyWith(isLoading: false, error: null);
          }
          unawaited(refreshPlantLists(_ref, plantId: plantId));
          return PlantMutationResult.success(plant);
        },
      );
    } catch (e) {
      if (!mounted) {
        return PlantMutationResult.failure(e.toString());
      }
      state = state.copyWith(isLoading: false, error: e.toString());
      return PlantMutationResult.failure(e.toString());
    }
  }

  void reset() => state = const HarvestPlantState();
}

final harvestPlantProvider =
    StateNotifierProvider<HarvestPlantNotifier, HarvestPlantState>((ref) {
      return HarvestPlantNotifier(ref.watch(harvestPlantUseCaseProvider), ref);
    });

// ─── Delete plant ─────────────────────────────────────────────────────────────

class DeletePlantState {
  final bool isLoading;
  final String? error;

  const DeletePlantState({this.isLoading = false, this.error});

  DeletePlantState copyWith({bool? isLoading, String? error}) {
    return DeletePlantState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DeletePlantNotifier extends StateNotifier<DeletePlantState> {
  final DeletePlantUseCase _useCase;
  final Ref _ref;

  DeletePlantNotifier(this._useCase, this._ref)
    : super(const DeletePlantState());

  Future<PlantMutationResult> delete({
    required String siteId,
    required String plantId,
  }) async {
    if (!mounted) {
      return const PlantMutationResult.failure('Operasi dibatalkan');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _useCase(siteId.trim(), plantId.trim());

      if (!mounted) {
        return const PlantMutationResult.failure('Operasi dibatalkan');
      }

      return result.fold(
        (failure) {
          if (mounted) {
            state = state.copyWith(isLoading: false, error: failure.message);
          }
          return PlantMutationResult.failure(failure.message);
        },
        (_) {
          if (mounted) {
            state = state.copyWith(isLoading: false, error: null);
          }
          unawaited(
            refreshPlantLists(_ref, plantId: plantId, refreshDetail: false),
          );
          return const PlantMutationResult.success();
        },
      );
    } catch (e) {
      if (!mounted) {
        return PlantMutationResult.failure(e.toString());
      }
      state = state.copyWith(isLoading: false, error: e.toString());
      return PlantMutationResult.failure(e.toString());
    }
  }

  void reset() => state = const DeletePlantState();
}

final deletePlantProvider =
    StateNotifierProvider<DeletePlantNotifier, DeletePlantState>((ref) {
      return DeletePlantNotifier(ref.watch(deletePlantUseCaseProvider), ref);
    });

// ─── Cache refresh ────────────────────────────────────────────────────────────

/// Refresh list + detail setelah create / update / harvest / delete.
Future<void> refreshPlantCache(
  dynamic ref, {
  String? plantId,
  bool refreshDetail = true,
}) async {
  await refreshPlantLists(ref, plantId: plantId, refreshDetail: refreshDetail);
}

Future<void> refreshPlantLists(
  dynamic ref, {
  String? plantId,
  bool refreshDetail = true,
}) async {
  if (ref is! Ref && ref is! WidgetRef) {
    throw ArgumentError('ref must be either Ref or WidgetRef');
  }

  ref.invalidate(ongoingPlantProvider);

  if (plantId != null && refreshDetail) {
    ref.invalidate(plantDetailProvider(plantId));
  }

  // Gunakan refresh() agar polling di-restart dan screenState di-sync otomatis
  await ref.read(plantsProvider.notifier).refresh();

  final futures = <Future<Object?>>[
    _safe(ref.read(ongoingPlantProvider.future)),
    if (plantId != null && refreshDetail)
      _safe(ref.read(plantDetailProvider(plantId).future)),
  ];
  await Future.wait(futures);
}

Future<Object?> _safe(Future<Object?> future) async {
  try {
    return await future;
  } catch (_) {
    return null;
  }
}
