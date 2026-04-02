import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/monitoring_remote_datasource.dart';
import '../../data/models/monitoring_models.dart';

// ─── DataSource ──────────────────────────────────────────
final monitoringDataSourceProvider = Provider<MonitoringRemoteDataSource>((
  ref,
) {
  return MonitoringRemoteDataSource(ref.watch(dioClientProvider).dio);
});

// ─── Realtime ────────────────────────────────────────────
final latestReadsProvider = FutureProvider.autoDispose<List<SensorReadUpdate>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.watch(monitoringDataSourceProvider).getLatestReads(siteId);
});

final todayReadsProvider = FutureProvider.autoDispose<List<SensorReadModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.watch(monitoringDataSourceProvider).getTodayReads(siteId);
});

final logsProvider = FutureProvider.autoDispose<List<LogModel>>((ref) async {
  return ref.watch(monitoringDataSourceProvider).getLogs();
});

// ─── History filter state ────────────────────────────────
enum HistoryFilter { sevenDay, dateRange, plantingDate }

final historyFilterProvider = StateProvider<HistoryFilter>(
  (ref) => HistoryFilter.sevenDay,
);

final historyStartDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now().subtract(const Duration(days: 7)),
);

final historyEndDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final selectedSensorParamProvider = StateProvider<String?>((ref) => null);

final historyReadsProvider = FutureProvider.autoDispose<List<SensorReadModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final ds = ref.watch(monitoringDataSourceProvider);
  final filter = ref.watch(historyFilterProvider);

  switch (filter) {
    case HistoryFilter.sevenDay:
      return ds.getSevenDayReads(siteId);
    case HistoryFilter.dateRange:
      final start = ref.watch(historyStartDateProvider);
      final end = ref.watch(historyEndDateProvider);
      String fmt(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      return ds.getDateRangeReads(
        siteId,
        startDate: fmt(start),
        endDate: fmt(end),
      );
    case HistoryFilter.plantingDate:
      return ds.getPlantingDateReads(siteId);
  }
});

// ─── Maps ────────────────────────────────────────────────
final devicesProvider = FutureProvider.autoDispose<List<DeviceModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.watch(monitoringDataSourceProvider).getDevices(siteId);
});

// ─── Analytics ───────────────────────────────────────────
final envHealthProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return {};
  return ref.watch(monitoringDataSourceProvider).getEnvironmentalHealth(siteId);
});

final plantRecommendationProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return {};
      return ref
          .watch(monitoringDataSourceProvider)
          .getPlantRecommendation(siteId);
    });

final dailyReadsProvider = FutureProvider.autoDispose<List<SensorDailyModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.watch(monitoringDataSourceProvider).getDailyReads(siteId);
});
