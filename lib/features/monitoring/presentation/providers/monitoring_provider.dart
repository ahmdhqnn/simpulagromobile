import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../dashboard/data/models/environmental_health_model.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/monitoring_remote_datasource.dart';
import '../../data/models/monitoring_models.dart';
import '../../domain/repositories/monitoring_repository.dart';
import '../../data/repositories/monitoring_repository_impl.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../utils/monitoring_display_utils.dart';
import '../utils/sensor_metadata_adapter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REPOSITORY
// ─────────────────────────────────────────────────────────────────────────────

final monitoringRepositoryProvider = Provider<MonitoringRepository>((ref) {
  final dataSource = MonitoringRemoteDataSource(
    ref.watch(dioClientProvider).dio,
  );
  return MonitoringRepositoryImpl(dataSource);
});

class MonitoringSyncStatus {
  final DateTime? lastUpdated;
  final Duration refreshInterval;
  final bool autoRefreshEnabled;
  final bool isStale;

  const MonitoringSyncStatus({
    required this.lastUpdated,
    required this.refreshInterval,
    required this.autoRefreshEnabled,
    required this.isStale,
  });
}

final monitoringLastUpdatedProvider = StateProvider<DateTime?>((_) => null);

final monitoringSyncStatusProvider = Provider<MonitoringSyncStatus>((ref) {
  final lastUpdated = ref.watch(monitoringLastUpdatedProvider);
  final refreshInterval = ref.watch(appRealtimeRefreshIntervalProvider);
  final autoRefreshEnabled = ref.watch(appAutoRefreshEnabledProvider);
  ref.watch(realtimeRefreshTickProvider);

  return MonitoringSyncStatus(
    lastUpdated: lastUpdated,
    refreshInterval: refreshInterval,
    autoRefreshEnabled: autoRefreshEnabled,
    isStale: isMonitoringStale(
      lastUpdated: lastUpdated,
      now: DateTime.now(),
      refreshInterval: refreshInterval,
    ),
  );
});

final monitoringRefreshTickProvider = StreamProvider.autoDispose
    .family<int, int>((ref, intervalMultiplier) {
      final enabled = ref.watch(appAutoRefreshEnabledProvider);
      if (!enabled) return const Stream<int>.empty();

      final multiplier = intervalMultiplier < 1 ? 1 : intervalMultiplier;
      final baseInterval = ref.watch(appRealtimeRefreshIntervalProvider);
      final interval = Duration(
        microseconds: baseInterval.inMicroseconds * multiplier,
      );

      return Stream<int>.periodic(interval, (tick) => tick + 1);
    });

void _markMonitoringSynced(Ref ref) {
  ref.read(monitoringLastUpdatedProvider.notifier).state = DateTime.now();
}

Future<void> _watchMonitoringRealtimeRefresh(
  Ref ref,
  int slot, {
  int intervalMultiplier = 1,
}) async {
  ref.watch(monitoringRefreshTickProvider(intervalMultiplier));
  if (slot <= 0) return;
  await Future<void>.delayed(Duration(milliseconds: 500 * slot));
}

// ─────────────────────────────────────────────────────────────────────────────
// REALTIME
// ─────────────────────────────────────────────────────────────────────────────

/// Nilai sensor terkini per ds_id.
/// GET /api/sites/:siteId/reads/updates
final latestReadsProvider = FutureProvider.autoDispose<List<SensorReadUpdate>>((
  ref,
) async {
  ref.cacheFor(const Duration(seconds: 45));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  await _watchMonitoringRealtimeRefresh(ref, 0);

  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getLatestReads(siteId);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });
});

/// Threshold metadata canonical source.
/// GET /api/sites/:siteId/device-sensors/values
final deviceSensorThresholdValuesProvider =
    FutureProvider.autoDispose<List<DeviceSensorThresholdModel>>((ref) async {
      ref.cacheFor(const Duration(minutes: 10));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];

      return ref.retryOnError(() async {
        final result = await ref
            .read(monitoringRepositoryProvider)
            .getDeviceSensorThresholdValues(siteId);
        return result.fold((f) => throw f, (data) {
          _markMonitoringSynced(ref);
          return data;
        });
      });
    });

final deviceSensorThresholdByDsIdProvider =
    Provider.autoDispose<Map<String, DeviceSensorThresholdModel>>((ref) {
      final rows = ref.watch(deviceSensorThresholdValuesProvider).valueOrNull;
      if (rows == null || rows.isEmpty) return const {};
      final map = <String, DeviceSensorThresholdModel>{};
      for (final row in rows) {
        if (row.dsId.isEmpty) continue;
        map.putIfAbsent(row.dsId, () => row);
      }
      return map;
    });

final sensorMetadataAdapterProvider =
    Provider.autoDispose<SensorMetadataAdapter>((ref) {
      final rows = ref.watch(deviceSensorThresholdValuesProvider).valueOrNull;
      return SensorMetadataAdapter(rows ?? const []);
    });

/// Bacaan sensor hari ini (untuk grafik realtime).
/// GET /api/sites/:siteId/reads/today
final todayReadsProvider = FutureProvider.autoDispose<List<SensorReadModel>>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 2));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  await _watchMonitoringRealtimeRefresh(ref, 1, intervalMultiplier: 4);

  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getTodayReads(siteId);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });
});

/// Log payload MQTT terbaru.
/// GET /api/sites/logs
final logsProvider = FutureProvider.autoDispose<List<LogModel>>((ref) async {
  ref.cacheFor(const Duration(minutes: 2));
  return ref.retryOnError(() async {
    final result = await ref.read(monitoringRepositoryProvider).getLogs();
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// HISTORY — filter state
// ─────────────────────────────────────────────────────────────────────────────

enum HistoryFilter { today, singleDate, sevenDay, dateRange, plantingDate }

final historySingleDateProvider = StateProvider<DateTime>(
  (_) => DateTime.now(),
);

final historyFilterProvider = StateProvider<HistoryFilter>(
  (_) => HistoryFilter.today,
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
  ref.cacheFor(const Duration(seconds: 45));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];

  final repo = ref.watch(monitoringRepositoryProvider);
  final filter = ref.watch(historyFilterProvider);

  String fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  return ref.retryOnError(() async {
    Either<Failure, List<SensorReadModel>> result;
    switch (filter) {
      case HistoryFilter.today:
        result = await repo.getTodayReads(siteId);
        break;
      case HistoryFilter.singleDate:
        final d = ref.read(historySingleDateProvider);
        result = await repo.getReadsByDate(siteId, fmt(d));
        break;
      case HistoryFilter.sevenDay:
        final end = DateTime.now();
        final start = end.subtract(const Duration(days: 6));
        result = await repo.getDateRangeReads(
          siteId,
          startDate: fmt(start),
          endDate: fmt(end),
        );
        break;
      case HistoryFilter.dateRange:
        final start = ref.read(historyStartDateProvider);
        final end = ref.read(historyEndDateProvider);
        final boundedStart = boundedHistoryStartDate(start, end);
        result = await repo.getDateRangeReads(
          siteId,
          startDate: fmt(boundedStart),
          endDate: fmt(end),
        );
        break;
      case HistoryFilter.plantingDate:
        result = await repo.getPlantingDateReads(siteId);
        break;
    }
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
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
  ref.cacheFor(const Duration(minutes: 5));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getDevices(siteId);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });
});

/// Total sensor terdaftar di site (dari endpoint /sensors).
/// GET /api/sites/:siteId/sensors
final monitoringSensorCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 5));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return 0;
  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getSensorCount(siteId);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// ANALYTICS
// ─────────────────────────────────────────────────────────────────────────────

/// Environmental health score + per-sensor persentase.
/// GET /api/sites/:siteId/agro/environmental-health
final envHealthProvider = FutureProvider.autoDispose<EnvironmentalHealth>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 1));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return EnvironmentalHealth.empty();

  final raw = await ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getEnvironmentalHealth(siteId);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });

  if (raw.isEmpty) return EnvironmentalHealth.empty();
  return EnvironmentalHealth.fromJson(raw);
});

/// Rekomendasi tanaman berdasarkan kondisi sensor.
/// GET /api/sites/:siteId/recommendations/plant-by-site
final plantRecommendationProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      ref.cacheFor(const Duration(minutes: 10));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return {};

      return ref.retryOnError(() async {
        final result = await ref
            .read(monitoringRepositoryProvider)
            .getPlantRecommendation(siteId);
        return result.fold((f) => throw f, (data) {
          _markMonitoringSynced(ref);
          return data;
        });
      });
    });

/// Agregasi harian sensor (avg/min/max).
/// GET /api/sites/:siteId/reads/daily
final dailyReadsProvider = FutureProvider.autoDispose<List<SensorDailyModel>>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 5));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];

  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getDailyReads(siteId);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// ALARMS
// ─────────────────────────────────────────────────────────────────────────────

/// Alarm lengkap beserta kode alarm (join).
/// GET /api/sites/alarms/data
final alarmDataProvider = FutureProvider.autoDispose<List<AlarmDataModel>>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 2));
  return ref.retryOnError(() async {
    final result = await ref.read(monitoringRepositoryProvider).getAlarmData();
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// MONTHLY REKAP
// ─────────────────────────────────────────────────────────────────────────────

/// Rekap harian hari ini.
/// GET /sites/{siteId}/reads/daily/today
final dailyTodayProvider = FutureProvider.autoDispose<List<SensorDailyModel>>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 5));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) {
    throw StateError('Pilih site terlebih dahulu');
  }

  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getDailyToday(siteId);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });
});

final dailyByDayDateProvider = StateProvider<DateTime>((_) => DateTime.now());

/// Rekap harian per tanggal.
/// GET /sites/{siteId}/reads/daily/by-day?day=
final dailyByDayProvider = FutureProvider.autoDispose<List<SensorDailyModel>>((
  ref,
) async {
  ref.cacheFor(const Duration(minutes: 5));
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) {
    throw StateError('Pilih site terlebih dahulu');
  }

  final d = ref.watch(dailyByDayDateProvider);
  final day =
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getDailyByDay(siteId, day);
    return result.fold((f) => throw f, (data) {
      _markMonitoringSynced(ref);
      return data;
    });
  });
});

/// Rekap bulanan sensor (avg/min/max).
/// GET /api/sites/:siteId/reads/mounth
final monthlyReadsProvider =
    FutureProvider.autoDispose<List<MonthlyRekapModel>>((ref) async {
      ref.cacheFor(const Duration(minutes: 10));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];

      return ref.retryOnError(() async {
        final result = await ref
            .read(monitoringRepositoryProvider)
            .getMonthlyReads(siteId);
        return result.fold((f) => throw f, (data) {
          _markMonitoringSynced(ref);
          return data;
        });
      });
    });

// ─── Admin: read correction & daily rekap trigger ───────────────────────────

class ReadCorrectionNotifier extends StateNotifier<AsyncValue<void>> {
  ReadCorrectionNotifier(this._repo) : super(const AsyncData(null));

  final MonitoringRepository _repo;

  Future<bool> updateRead(
    String siteId,
    String readId, {
    double? readValue,
    String? readSts,
  }) async {
    state = const AsyncLoading();
    final result = await _repo.updateRead(
      siteId,
      readId,
      readValue: readValue,
      readSts: readSts,
    );
    return result.fold(
      (f) {
        state = AsyncError(f, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}

final readCorrectionProvider =
    StateNotifierProvider<ReadCorrectionNotifier, AsyncValue<void>>((ref) {
      return ReadCorrectionNotifier(ref.watch(monitoringRepositoryProvider));
    });

class DailyRekapTriggerNotifier extends StateNotifier<AsyncValue<void>> {
  DailyRekapTriggerNotifier(this._repo) : super(const AsyncData(null));

  final MonitoringRepository _repo;

  Future<bool> trigger(String siteId, String day) async {
    state = const AsyncLoading();
    final result = await _repo.triggerDailyRekap(siteId, day);
    return result.fold(
      (f) {
        state = AsyncError(f, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}

final dailyRekapTriggerProvider =
    StateNotifierProvider<DailyRekapTriggerNotifier, AsyncValue<void>>((ref) {
      return DailyRekapTriggerNotifier(ref.watch(monitoringRepositoryProvider));
    });
