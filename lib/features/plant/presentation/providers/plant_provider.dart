import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/plant_remote_datasource.dart';
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

// ─── Data providers ───────────────────────────────────────────────────────────

/// Semua tanaman untuk site yang dipilih.
final plantsProvider = FutureProvider.autoDispose<List<Plant>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final useCase = ref.watch(getPlantsUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase(siteId);
    return result.fold((f) => throw f, (plants) => plants);
  });
});

/// Tanaman aktif pertama untuk site yang dipilih.
final currentPlantProvider = Provider<Plant?>((ref) {
  return ref
      .watch(plantsProvider)
      .whenOrNull(
        data: (plants) => plants.where((p) => p.isCurrentPlanting).firstOrNull,
      );
});

/// Detail satu tanaman berdasarkan ID.
/// Non-autoDispose agar bisa di-invalidate secara eksplisit dari notifier
/// dan tidak throw saat provider masih aktif di screen lain.
final plantDetailProvider = FutureProvider.family<Plant, String>((
  ref,
  plantId,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) throw Exception('No site selected');
  final useCase = ref.watch(getPlantByIdUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase(siteId, plantId);
    return result.fold((f) => throw f, (plant) => plant);
  });
});

/// Semua varietas untuk dropdown.
final varietasProvider = FutureProvider.autoDispose<List<Varietas>>((
  ref,
) async {
  final useCase = ref.watch(getVarietasUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase();
    return result.fold((f) => throw f, (v) => v);
  });
});

// ─── Plant screen state ───────────────────────────────────────────────────────

enum PlantScreenState { loading, empty, input, hasData }

final plantScreenStateProvider = StateProvider<PlantScreenState>((ref) {
  return PlantScreenState.loading;
});

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

  Future<bool> createPlant({
    required String siteId,
    required String plantName,
    required String varietasId,
    required CropType plantType,
    required DateTime plantDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = {
        'plant_name': plantName.trim(),
        'varietas_id': varietasId.trim(),
        'plant_type': plantType.name,
        'plant_date': plantDate.toIso8601String().split('T').first,
      };
      debugPrint('📤 createPlant payload: $data (siteId: $siteId)');
      final result = await _useCase(siteId, data);
      return await result.fold<Future<bool>>(
        (f) async {
          state = state.copyWith(isLoading: false, error: f.message);
          return false;
        },
        (plant) async {
          state = CreatePlantState(plant: plant);
          await refreshPlantCache(_ref);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() => state = const CreatePlantState();
}

final createPlantProvider =
    StateNotifierProvider.autoDispose<CreatePlantNotifier, CreatePlantState>((
      ref,
    ) {
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

  Future<bool> updatePlant({
    required String siteId,
    required String plantId,
    required String plantName,
    required String varietasId,
    required CropType plantType,
    required DateTime plantDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = {
        'plant_name': plantName.trim(),
        'varietas_id': varietasId.trim(),
        'plant_type': plantType.name,
        'plant_date': plantDate.toIso8601String().split('T').first,
      };
      debugPrint(
        '📤 updatePlant payload: $data (siteId: $siteId, plantId: $plantId)',
      );
      final result = await _useCase(siteId, plantId, data);
      return await result.fold<Future<bool>>(
        (f) async {
          state = state.copyWith(isLoading: false, error: f.message);
          return false;
        },
        (plant) async {
          state = UpdatePlantState(plant: plant);
          await refreshPlantCache(_ref, plantId: plantId);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() => state = const UpdatePlantState();
}

final updatePlantFormProvider =
    StateNotifierProvider.autoDispose<UpdatePlantNotifier, UpdatePlantState>((
      ref,
    ) {
      return UpdatePlantNotifier(ref.watch(updatePlantUseCaseProvider), ref);
    });

/// Refresh semua provider yang memegang data plant dan tunggu fetch baru selesai.
///
/// Dipakai setelah create/update/harvest/delete supaya screen yang sedang aktif
/// tidak menampilkan cache lama saat kembali dari form atau action sheet.
Future<void> refreshPlantCache(
  dynamic ref, {
  String? plantId,
  bool refreshDetail = true,
}) async {
  if (ref is Ref || ref is WidgetRef) {
    ref.invalidate(plantsProvider);
    if (plantId != null) {
      ref.invalidate(plantDetailProvider(plantId));
    }
  } else {
    throw ArgumentError('ref must be either Ref or WidgetRef');
  }

  final futures = <Future<Object?>>[
    _safe(ref.read(plantsProvider.future)),
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
