import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_device_summary_usecase.dart';
import '../../domain/usecases/get_environmental_health_usecase.dart';
import '../../domain/usecases/get_latest_sensor_reads_usecase.dart';
import '../../domain/usecases/get_plant_summary_usecase.dart';
import '../../domain/usecases/get_sensor_summary_usecase.dart';
import '../../domain/usecases/get_seven_day_reads_usecase.dart';
import '../../domain/usecases/get_today_reads_usecase.dart';

Future<void> _watchDashboardRefresh(Ref ref, int slot) async {
  ref.watch(realtimeRefreshTickProvider);
  if (slot <= 0) return;
  await Future<void>.delayed(Duration(milliseconds: 350 * slot));
}

// ─── DataSource Provider ─────────────────────────────────
final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dioClient.dio);
});

// ─── Repository Provider ─────────────────────────────────
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dataSource = ref.watch(dashboardDataSourceProvider);
  return DashboardRepositoryImpl(dataSource);
});

// ─── UseCase Providers ────────────────────────────────────
final getEnvironmentalHealthUseCaseProvider =
    Provider<GetEnvironmentalHealthUseCase>((ref) {
      return GetEnvironmentalHealthUseCase(
        ref.watch(dashboardRepositoryProvider),
      );
    });

final getDeviceSummaryUseCaseProvider = Provider<GetDeviceSummaryUseCase>((
  ref,
) {
  return GetDeviceSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final getSensorSummaryUseCaseProvider = Provider<GetSensorSummaryUseCase>((
  ref,
) {
  return GetSensorSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final getPlantSummaryUseCaseProvider = Provider<GetPlantSummaryUseCase>((ref) {
  return GetPlantSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final getLatestSensorReadsUseCaseProvider =
    Provider<GetLatestSensorReadsUseCase>((ref) {
      return GetLatestSensorReadsUseCase(
        ref.watch(dashboardRepositoryProvider),
      );
    });

final getSevenDayReadsUseCaseProvider = Provider<GetSevenDayReadsUseCase>((
  ref,
) {
  return GetSevenDayReadsUseCase(ref.watch(dashboardRepositoryProvider));
});

final getTodayReadsUseCaseProvider = Provider<GetTodayReadsUseCase>((ref) {
  return GetTodayReadsUseCase(ref.watch(dashboardRepositoryProvider));
});

// ─── Environmental Health ─────────────────────────────────
/// GET /sites/{siteId}/agro/environmental-health
final environmentalHealthProvider =
    FutureProvider.autoDispose<EnvironmentalHealthEntity?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final useCase = ref.watch(getEnvironmentalHealthUseCaseProvider);
      await _watchDashboardRefresh(ref, 0);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold((failure) => throw failure, (entity) => entity);
      });
    });

// ─── Device Summary ───────────────────────────────────────
/// GET /sites/{siteId}/devices
final deviceSummaryProvider = FutureProvider.autoDispose<DeviceSummaryEntity?>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return null;
  final useCase = ref.watch(getDeviceSummaryUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase(siteId);
    return result.fold((failure) => throw failure, (entity) => entity);
  });
});

// ─── Sensor Summary ───────────────────────────────────────
/// GET /sites/{siteId}/sensors
final sensorSummaryProvider = FutureProvider.autoDispose<SensorSummaryEntity?>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return null;
  final useCase = ref.watch(getSensorSummaryUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase(siteId);
    return result.fold((failure) => throw failure, (entity) => entity);
  });
});

// ─── Plant Summary ────────────────────────────────────────
/// GET /sites/{siteId}/plants
final plantSummaryProvider = FutureProvider.autoDispose<PlantSummaryEntity?>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return null;
  final useCase = ref.watch(getPlantSummaryUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase(siteId);
    return result.fold((failure) => throw failure, (entity) => entity);
  });
});

// ─── Latest Sensor Reads ──────────────────────────────────
/// GET /sites/{siteId}/reads/updates
final latestSensorReadsProvider =
    FutureProvider.autoDispose<List<SensorReadEntity>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final useCase = ref.watch(getLatestSensorReadsUseCaseProvider);
      await _watchDashboardRefresh(ref, 1);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold((failure) => throw failure, (entities) => entities);
      });
    });

// ─── Daily Reads ──────────────────────────────────────────
/// GET /sites/{siteId}/reads/daily
final sevenDayReadsProvider =
    FutureProvider.autoDispose<List<SensorReadEntity>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final useCase = ref.watch(getSevenDayReadsUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold((failure) => throw failure, (entities) => entities);
      });
    });

// ─── Today Reads ──────────────────────────────────────────
/// GET /sites/{siteId}/reads/today
final dashboardTodayReadsProvider =
    FutureProvider.autoDispose<List<SensorReadEntity>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final useCase = ref.watch(getTodayReadsUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold((failure) => throw failure, (entities) => entities);
      });
    });
