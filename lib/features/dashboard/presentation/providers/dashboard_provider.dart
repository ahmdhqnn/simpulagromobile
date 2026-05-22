import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../../data/models/environmental_health_model.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';

final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dioClient.dio);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dataSource = ref.watch(dashboardDataSourceProvider);
  return DashboardRepositoryImpl(dataSource);
});

// ─── Environmental Health ─────────────────────────────────────────────────────
/// GET /api/sites/:siteId/agro/environmental-health
final environmentalHealthProvider =
    FutureProvider.autoDispose<EnvironmentalHealth?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final repository = ref.watch(dashboardRepositoryProvider);
      return ref.retryOnError(() async {
        final result = await repository.getEnvironmentalHealth(siteId);
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
      final repository = ref.watch(dashboardRepositoryProvider);
      return ref.retryOnError(() async {
        final result = await repository.getDeviceSummary(siteId);
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
      final repository = ref.watch(dashboardRepositoryProvider);
      return ref.retryOnError(() async {
        final result = await repository.getSensorSummary(siteId);
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
    final repository = ref.watch(dashboardRepositoryProvider);
    return ref.retryOnError(() async {
      final result = await repository.getPlantSummary(siteId);
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
      final repository = ref.watch(dashboardRepositoryProvider);
      return ref.retryOnError(() async {
        final result = await repository.getLatestSensorReads(siteId);
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
      final repository = ref.watch(dashboardRepositoryProvider);
      return ref.retryOnError(() async {
        final result = await repository.getSevenDayReads(siteId);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (data) => data,
        );
      });
    });
