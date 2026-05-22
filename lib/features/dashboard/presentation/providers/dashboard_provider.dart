import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../../data/models/environmental_health_model.dart';

final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dioClient.dio);
});

// ─── Environmental Health ─────────────────────────────────────────────────────
/// GET /api/sites/:siteId/agro/environmental-health
final environmentalHealthProvider =
    FutureProvider.autoDispose<EnvironmentalHealth?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final ds = ref.watch(dashboardDataSourceProvider);
      return ref.retryOnError(() => ds.getEnvironmentalHealth(siteId));
    });

// ─── Device Summary ───────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/devices
final deviceSummaryProvider =
    FutureProvider.autoDispose<DashboardDeviceSummary?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final ds = ref.watch(dashboardDataSourceProvider);
      return ref.retryOnError(() => ds.getDeviceSummary(siteId));
    });

// ─── Sensor Summary ───────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/sensors
final sensorSummaryProvider =
    FutureProvider.autoDispose<DashboardSensorSummary?>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return null;
      final ds = ref.watch(dashboardDataSourceProvider);
      return ref.retryOnError(() => ds.getSensorSummary(siteId));
    });

// ─── Plant Summary ────────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/plants
final plantSummaryProvider = FutureProvider.autoDispose<DashboardPlantSummary?>(
  (ref) async {
    final siteId = ref.watch(selectedSiteIdProvider);
    if (siteId == null) return null;
    final ds = ref.watch(dashboardDataSourceProvider);
    return ref.retryOnError(() => ds.getPlantSummary(siteId));
  },
);

// ─── Latest Sensor Reads ──────────────────────────────────────────────────────
/// GET /api/sites/:siteId/reads/updates
final latestSensorReadsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final ds = ref.watch(dashboardDataSourceProvider);
      return ref.retryOnError(() => ds.getLatestSensorReads(siteId));
    });

// ─── Seven Day Reads ──────────────────────────────────────────────────────────
/// GET /api/sites/:siteId/reads/seven-day
final sevenDayReadsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final ds = ref.watch(dashboardDataSourceProvider);
      return ref.retryOnError(() => ds.getSevenDayReads(siteId));
    });
