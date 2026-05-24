import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../dashboard/data/models/environmental_health_model.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../data/datasources/monitoring_remote_datasource.dart';
import '../../data/models/monitoring_models.dart';
import '../../domain/repositories/monitoring_repository.dart';
import '../../data/repositories/monitoring_repository_impl.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REPOSITORY
// ─────────────────────────────────────────────────────────────────────────────

final monitoringRepositoryProvider = Provider<MonitoringRepository>((ref) {
  final dataSource = MonitoringRemoteDataSource(
    ref.watch(dioClientProvider).dio,
  );
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

  // Decouple data streaming if no active plant
  final activePlant = ref.watch(currentPlantProvider);
  if (activePlant == null) return [];

  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getLatestReads(siteId);
    return result.fold((f) => throw f, (data) => data);
  });
});

/// Bacaan sensor hari ini (untuk grafik realtime).
/// GET /api/sites/:siteId/reads/today
final todayReadsProvider = FutureProvider.autoDispose<List<SensorReadModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];

  // Decouple data streaming if no active plant
  final activePlant = ref.watch(currentPlantProvider);
  if (activePlant == null) return [];

  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getTodayReads(siteId);
    return result.fold((f) => throw f, (data) => data);
  });
});

/// Log payload MQTT terbaru.
/// GET /api/sites/logs
final logsProvider = FutureProvider.autoDispose<List<LogModel>>((ref) async {
  return ref.retryOnError(() async {
    final result = await ref.read(monitoringRepositoryProvider).getLogs();
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// HISTORY — filter state
// ─────────────────────────────────────────────────────────────────────────────

enum HistoryFilter { today, singleDate, sevenDay, dateRange, plantingDate }

final historySingleDateProvider = StateProvider<DateTime>((_) => DateTime.now());

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
        result = await repo.getSevenDayReads(siteId);
        break;
      case HistoryFilter.dateRange:
        final start = ref.read(historyStartDateProvider);
        final end = ref.read(historyEndDateProvider);
        result = await repo.getDateRangeReads(
          siteId,
          startDate: fmt(start),
          endDate: fmt(end),
        );
        break;
      case HistoryFilter.plantingDate:
        result = await repo.getPlantingDateReads(siteId);
        break;
    }
    return result.fold((f) => throw f, (data) => data);
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
  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getDevices(siteId);
    return result.fold((f) => throw f, (data) => data);
  });
});

/// Total sensor terdaftar di site (dari endpoint /sensors).
/// GET /api/sites/:siteId/sensors
final monitoringSensorCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return 0;
  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getSensorCount(siteId);
    return result.fold((f) => throw f, (data) => data);
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
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return EnvironmentalHealth.empty();

  // Decouple data streaming if no active plant
  final activePlant = ref.watch(currentPlantProvider);
  if (activePlant == null) return EnvironmentalHealth.empty();

  final raw = await ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getEnvironmentalHealth(siteId);
    return result.fold((f) => throw f, (data) => data);
  });

  if (raw.isEmpty) return EnvironmentalHealth.empty();
  return EnvironmentalHealth.fromJson(raw);
});

/// Rekomendasi tanaman berdasarkan kondisi sensor.
/// GET /api/sites/:siteId/recommendations/plant-by-site
final plantRecommendationProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return {};

      // Decouple recommendation if no active plant
      final activePlant = ref.watch(currentPlantProvider);
      if (activePlant == null) return {};

      return ref.retryOnError(() async {
        final result = await ref
            .read(monitoringRepositoryProvider)
            .getPlantRecommendation(siteId);
        return result.fold((f) => throw f, (data) => data);
      });
    });

/// Agregasi harian sensor (avg/min/max).
/// GET /api/sites/:siteId/reads/daily
final dailyReadsProvider = FutureProvider.autoDispose<List<SensorDailyModel>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];

  // Decouple data streaming if no active plant
  final activePlant = ref.watch(currentPlantProvider);
  if (activePlant == null) return [];

  return ref.retryOnError(() async {
    final result = await ref
        .read(monitoringRepositoryProvider)
        .getDailyReads(siteId);
    return result.fold((f) => throw f, (data) => data);
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
final dailyTodayProvider =
    FutureProvider.autoDispose<List<SensorDailyModel>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) {
        throw StateError('Pilih site terlebih dahulu');
      }

      // Decouple data streaming if no active plant
      final activePlant = ref.watch(currentPlantProvider);
      if (activePlant == null) return [];

      return ref.retryOnError(() async {
        final result = await ref
            .read(monitoringRepositoryProvider)
            .getDailyToday(siteId);
        return result.fold((f) => throw f, (data) => data);
      });
    });

final dailyByDayDateProvider = StateProvider<DateTime>((_) => DateTime.now());

/// Rekap harian per tanggal.
/// GET /sites/{siteId}/reads/daily/by-day?day=
final dailyByDayProvider =
    FutureProvider.autoDispose<List<SensorDailyModel>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) {
        throw StateError('Pilih site terlebih dahulu');
      }

      // Decouple data streaming if no active plant
      final activePlant = ref.watch(currentPlantProvider);
      if (activePlant == null) return [];

      final d = ref.watch(dailyByDayDateProvider);
      final day =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      return ref.retryOnError(() async {
        final result = await ref
            .read(monitoringRepositoryProvider)
            .getDailyByDay(siteId, day);
        return result.fold((f) => throw f, (data) => data);
      });
    });

/// Rekap bulanan sensor (avg/min/max).
/// GET /api/sites/:siteId/reads/mounth
final monthlyReadsProvider =
    FutureProvider.autoDispose<List<MonthlyRekapModel>>((ref) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];

      // Decouple data streaming if no active plant
      final activePlant = ref.watch(currentPlantProvider);
      if (activePlant == null) return [];

      return ref.retryOnError(() async {
        final result = await ref
            .read(monitoringRepositoryProvider)
            .getMonthlyReads(siteId);
        return result.fold((f) => throw f, (data) => data);
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
