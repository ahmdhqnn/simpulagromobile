import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/models/plant_model.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/repositories/plant_repository.dart';
import '../../domain/entities/plant.dart';
import '../../domain/entities/varietas.dart';
import '../../domain/usecases/get_plants_usecase.dart';
import '../../domain/usecases/create_plant_usecase.dart';
import '../../domain/usecases/update_plant_usecase.dart';
import '../../domain/usecases/harvest_plant_usecase.dart';
import '../../domain/usecases/delete_plant_usecase.dart';
import '../../domain/usecases/get_varietas_usecase.dart';

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

final getVarietasUseCaseProvider = Provider<GetVarietasUseCase>((ref) {
  return GetVarietasUseCase(ref.watch(plantRepositoryProvider));
});

// ─── List plants (AsyncNotifier) ─────────────────────────────────────────────

/// Mengelola daftar tanaman per site — non-autoDispose agar mutation tidak
/// memicu "Notifier after dispose" saat form ditutup setelah submit.
class PlantsNotifier extends AsyncNotifier<List<Plant>> {
  @override
  Future<List<Plant>> build() async {
    ref.watch(selectedSiteIdProvider);
    return _fetchPlants();
  }

  Future<List<Plant>> _fetchPlants({bool? isOnGoingPlant}) async {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId == null) return [];

    final useCase = ref.read(getPlantsUseCaseProvider);
    final result = await useCase(siteId, isOnGoingPlant: isOnGoingPlant);
    return result.fold(
      (failure) => throw failure,
      (plants) => plants,
    );
  }

  /// Refresh daftar penuh (semua planting).
  Future<void> refresh() async {
    final previous = state.valueOrNull;
    state = previous == null
        ? const AsyncValue.loading()
        : AsyncValue<List<Plant>>.loading().copyWithPrevious(AsyncData(previous));

    state = await AsyncValue.guard(() => _fetchPlants());
  }
}

final plantsProvider =
    AsyncNotifierProvider<PlantsNotifier, List<Plant>>(PlantsNotifier.new);

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

/// Detail satu tanaman berdasarkan ID.
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

final varietasProvider = FutureProvider.autoDispose<List<Varietas>>((
  ref,
) async {
  final useCase = ref.watch(getVarietasUseCaseProvider);
  final result = await useCase();
  return result.fold((failure) => throw failure, (v) => v);
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

      final result = await _useCase(
        siteId.trim(),
        plantId.trim(),
        payload,
      );

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
