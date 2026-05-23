import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../../data/models/environmental_health_model.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_device_summary_usecase.dart';
import '../../domain/usecases/get_environmental_health_usecase.dart';
import '../../domain/usecases/get_latest_sensor_reads_usecase.dart';
import '../../domain/usecases/get_plant_summary_usecase.dart';
import '../../domain/usecases/get_sensor_summary_usecase.dart';
import '../../domain/usecases/get_seven_day_reads_usecase.dart';

final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dioClient.dio);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dataSource = ref.watch(dashboardDataSourceProvider);
  return DashboardRepositoryImpl(dataSource);
});

final getEnvironmentalHealthUseCaseProvider = Provider<GetEnvironmentalHealthUseCase>((ref) {
  return GetEnvironmentalHealthUseCase(ref.watch(dashboardRepositoryProvider));
});

final getDeviceSummaryUseCaseProvider = Provider<GetDeviceSummaryUseCase>((ref) {
  return GetDeviceSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final getSensorSummaryUseCaseProvider = Provider<GetSensorSummaryUseCase>((ref) {
  return GetSensorSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final getPlantSummaryUseCaseProvider = Provider<GetPlantSummaryUseCase>((ref) {
  return GetPlantSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final getLatestSensorReadsUseCaseProvider = Provider<GetLatestSensorReadsUseCase>((ref) {
  return GetLatestSensorReadsUseCase(ref.watch(dashboardRepositoryProvider));
});

final getSevenDayReadsUseCaseProvider = Provider<GetSevenDayReadsUseCase>((ref) {
  return GetSevenDayReadsUseCase(ref.watch(dashboardRepositoryProvider));
});

// ─── Environmental Health ─────────────────────────────────────────────────────
/// GET /api/sites/:siteId/agro/environmental-health
final environmentalHealthProvider =
    FutureProvider.autoDispose<EnvironmentalHealth?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final useCase = ref.watch(getEnvironmentalHealthUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (data) => data,
        );
      });
    });

// ─── Device Summary ───────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/devices
final deviceSummaryProvider =
    FutureProvider.autoDispose<DashboardDeviceSummary?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final useCase = ref.watch(getDeviceSummaryUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (data) => data,
        );
      });
    });

// ─── Sensor Summary ───────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/sensors
final sensorSummaryProvider =
    FutureProvider.autoDispose<DashboardSensorSummary?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final useCase = ref.watch(getSensorSummaryUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (data) => data,
        );
      });
    });

// ─── Plant Summary ────────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/plants
final plantSummaryProvider = FutureProvider.autoDispose<DashboardPlantSummary?>(
  (ref) async {
    final siteId = ref.watch(selectedSiteIdProvider);
    if (siteId == null) return null;
    final useCase = ref.watch(getPlantSummaryUseCaseProvider);
    return ref.retryOnError(() async {
      final result = await useCase(siteId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
    });
  },
);

// ─── Latest Sensor Reads ──────────────────────────────────────────────────────
/// GET /api/sites/:siteId/reads/updates
final latestSensorReadsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final useCase = ref.watch(getLatestSensorReadsUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (data) => data,
        );
      });
    });

// ─── Seven Day Reads ──────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/reads/seven-day
final sevenDayReadsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final useCase = ref.watch(getSevenDayReadsUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (data) => data,
        );
      });
    });
