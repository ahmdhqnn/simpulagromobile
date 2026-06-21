import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../../../monitoring/presentation/providers/monitoring_provider.dart';

class DashboardSummarySnapshot {
  const DashboardSummarySnapshot({
    this.deviceSummary,
    this.sensorSummary,
    this.plantSummary,
  });

  final DeviceSummaryEntity? deviceSummary;
  final SensorSummaryEntity? sensorSummary;
  final PlantSummaryEntity? plantSummary;
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

final dashboardSummaryProvider =
    FutureProvider.autoDispose<DashboardSummarySnapshot>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return const DashboardSummarySnapshot();
      ref.watch(monitoringRefreshTickProvider(4));

      final deviceUseCase = ref.watch(getDeviceSummaryUseCaseProvider);
      final sensorUseCase = ref.watch(getSensorSummaryUseCaseProvider);
      final plantUseCase = ref.watch(getPlantSummaryUseCaseProvider);

      final deviceFuture = deviceUseCase(
        siteId,
      ).then((result) => result.fold((_) => null, (entity) => entity));
      final sensorFuture = sensorUseCase(
        siteId,
      ).then((result) => result.fold((_) => null, (entity) => entity));
      final plantFuture = plantUseCase(
        siteId,
      ).then((result) => result.fold((_) => null, (entity) => entity));

      final results = await Future.wait<Object?>([
        deviceFuture,
        sensorFuture,
        plantFuture,
      ]);

      return DashboardSummarySnapshot(
        deviceSummary: results[0] as DeviceSummaryEntity?,
        sensorSummary: results[1] as SensorSummaryEntity?,
        plantSummary: results[2] as PlantSummaryEntity?,
      );
    });

// ─── Environmental Health ─────────────────────────────────
/// GET /sites/{siteId}/agro/environmental-health
final environmentalHealthProvider =
    FutureProvider.autoDispose<EnvironmentalHealthEntity?>((ref) async {
      ref.cacheFor(const Duration(minutes: 3));
      final mHealth = await ref.watch(envHealthProvider.future);
      return mHealth.toEntity();
    });

// ─── Device Summary ───────────────────────────────────────
/// GET /sites/{siteId}/devices
final deviceSummaryProvider = FutureProvider.autoDispose<DeviceSummaryEntity?>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 5));
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
  ref.cacheFor(const Duration(minutes: 5));
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
  ref.cacheFor(const Duration(minutes: 5));
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
      ref.cacheFor(const Duration(minutes: 2));
      final updates = await ref.watch(latestReadsProvider.future);
      return updates
          .map(
            (update) => SensorReadEntity(
              devId: update.devId,
              dsId: update.dsId,
              value: update.readUpdateValue ?? '0',
              readAt: update.readUpdateDate,
            ),
          )
          .toList();
    });

// ─── Daily Reads ──────────────────────────────────────────
/// GET /sites/{siteId}/reads/daily
final sevenDayReadsProvider =
    FutureProvider.autoDispose<List<SensorReadEntity>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
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
      ref.cacheFor(const Duration(minutes: 3));
      final reads = await ref.watch(todayReadsProvider.future);
      return reads
          .map(
            (read) => SensorReadEntity(
              devId: read.devId ?? '',
              dsId: read.dsId ?? '',
              value: read.readValue ?? '0',
              readAt: read.readDate,
            ),
          )
          .toList();
    });
