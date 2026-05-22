import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../dashboard/data/models/environmental_health_model.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/monitoring_remote_datasource.dart';
import '../../data/models/monitoring_models.dart';
import '../../domain/repositories/monitoring_repository.dart';
import '../../data/repositories/monitoring_repository_impl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REPOSITORY
// ─────────────────────────────────────────────────────────────────────────────

final monitoringRepositoryProvider = Provider<MonitoringRepository>((ref) {
  final dataSource = MonitoringRemoteDataSource(ref.watch(dioClientProvider).dio);
  return MonitoringRepositoryImpl(dataSource);
});

// ─────────────────────────────────────────────────────────────────────────────
// REALTIME
// ─────────────────────────────────────────────────────────────────────────────

/// Nilai sensor terkini per ds_id.
/// GET /api/sites/:siteId/reads/updates
final latestReadsProvider = FutureProvider.autoDispose<List<SensorReadUpdate>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getLatestReads(siteId));
});

/// Bacaan sensor hari ini (untuk grafik realtime).
/// GET /api/sites/:siteId/reads/today
final todayReadsProvider = FutureProvider.autoDispose<List<SensorReadModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getTodayReads(siteId));
});

/// Log payload MQTT terbaru.
/// GET /api/sites/logs
final logsProvider = FutureProvider.autoDispose<List<LogModel>>((ref) async {
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getLogs());
});

// ─────────────────────────────────────────────────────────────────────────────
// HISTORY — filter state
// ─────────────────────────────────────────────────────────────────────────────

enum HistoryFilter { sevenDay, dateRange, plantingDate }

final historyFilterProvider = StateProvider<HistoryFilter>(
  (_) => HistoryFilter.sevenDay,
);

final historyStartDateProvider = StateProvider<DateTime>(
  (_) => DateTime.now().subtract(const Duration(days: 7)),
);

final historyEndDateProvider = StateProvider<DateTime>((_) => DateTime.now());

/// Parameter sensor yang sedang dipilih di history tab.
final selectedSensorParamProvider = StateProvider<String?>((_) => null);

/// Bacaan sensor historis sesuai filter aktif.
final historyReadsProvider = FutureProvider.autoDispose<List<SensorReadModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];

  final repo = ref.watch(monitoringRepositoryProvider);
  final filter = ref.watch(historyFilterProvider);

  String fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  return ref.retryOnError(() {
    switch (filter) {
      case HistoryFilter.sevenDay:
        final start = DateTime.now().subtract(const Duration(days: 7));
        final end = DateTime.now();
        return repo.getDateRangeReads(
          siteId,
          startDate: fmt(start),
          endDate: fmt(end),
        );

      case HistoryFilter.dateRange:
        final start = ref.read(historyStartDateProvider);
        final end = ref.read(historyEndDateProvider);
        return repo.getDateRangeReads(
          siteId,
          startDate: fmt(start),
          endDate: fmt(end),
        );

      case HistoryFilter.plantingDate:
        final start = DateTime.now().subtract(const Duration(days: 120));
        final end = DateTime.now();
        return repo.getDateRangeReads(
          siteId,
          startDate: fmt(start),
          endDate: fmt(end),
        );
    }
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// MAPS
// ─────────────────────────────────────────────────────────────────────────────

/// Device beserta koordinat dan nested sensor list.
/// GET /api/sites/:siteId/devices
final devicesProvider = FutureProvider.autoDispose<List<DeviceModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getDevices(siteId));
});

/// Total sensor terdaftar di site (dari endpoint /sensors).
/// GET /api/sites/:siteId/sensors
final monitoringSensorCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return 0;
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getSensorCount(siteId));
});

// ─────────────────────────────────────────────────────────────────────────────
// ANALYTICS
// ─────────────────────────────────────────────────────────────────────────────

/// Environmental health score + per-sensor persentase.
/// GET /api/sites/:siteId/agro/environmental-health
final envHealthProvider = FutureProvider.autoDispose<EnvironmentalHealth>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return EnvironmentalHealth.empty();

  final raw = await ref.retryOnError(() => ref
      .read(monitoringRepositoryProvider)
      .getEnvironmentalHealth(siteId));

  if (raw.isEmpty) return EnvironmentalHealth.empty();
  return EnvironmentalHealth.fromJson(raw);
});

/// Rekomendasi tanaman berdasarkan kondisi sensor.
/// GET /api/sites/:siteId/recommendations/plant-by-site
final plantRecommendationProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return {};
      return ref.retryOnError(() => ref
          .read(monitoringRepositoryProvider)
          .getPlantRecommendation(siteId));
    });

/// Agregasi harian sensor (avg/min/max).
/// GET /api/sites/:siteId/reads/daily
final dailyReadsProvider = FutureProvider.autoDispose<List<SensorDailyModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getDailyReads(siteId));
});

// ─────────────────────────────────────────────────────────────────────────────
// ALARMS
// ─────────────────────────────────────────────────────────────────────────────

/// Alarm lengkap beserta kode alarm (join).
/// GET /api/sites/alarms/data
final alarmDataProvider = FutureProvider.autoDispose<List<AlarmDataModel>>((
  ref,
) async {
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getAlarmData());
});

// ─────────────────────────────────────────────────────────────────────────────
// MONTHLY REKAP
// ─────────────────────────────────────────────────────────────────────────────

/// Rekap bulanan sensor (avg/min/max).
/// GET /api/sites/:siteId/reads/mounth
final monthlyReadsProvider =
    FutureProvider.autoDispose<List<MonthlyRekapModel>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.retryOnError(() => ref.read(monitoringRepositoryProvider).getMonthlyReads(siteId));
});
