import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/provider_utils.dart';
import '../../../dashboard/domain/entities/dashboard_entity.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../phase/domain/entities/phase.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/recommendation_request.dart';
import 'recommendation_provider.dart';

final recommendationAutomationRefreshSeedProvider = StateProvider<int>(
  (_) => 0,
);
final _recommendationAutomationLastSiteProvider = StateProvider<String?>(
  (_) => null,
);
final _recommendationAutomationLastSeedProvider = StateProvider<int>((_) => 0);
final _recommendationCardLastSiteProvider = StateProvider<String?>((_) => null);
final _recommendationCardLastSeedProvider = StateProvider<int>((_) => 0);
final _recommendationAutomationLastAutoSaveProvider =
    StateProvider<Map<String, DateTime>>((_) => <String, DateTime>{});
final recommendationAutomationLastUpdatedProvider = StateProvider<DateTime?>(
  (_) => null,
);

void triggerRecommendationAutomationRefresh(WidgetRef ref) {
  final current = ref.read(recommendationAutomationRefreshSeedProvider);
  ref.read(recommendationAutomationRefreshSeedProvider.notifier).state =
      current + 1;
}

class CurrentRecommendationSnapshot {
  const CurrentRecommendationSnapshot({
    required this.items,
    required this.current,
    required this.total,
    required this.updatedAt,
  });

  final List<Recommendation> items;
  final Recommendation? current;
  final int total;
  final DateTime? updatedAt;
}

final recommendationDashboardSnapshotProvider =
    FutureProvider.autoDispose<CurrentRecommendationSnapshot>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) {
        return const CurrentRecommendationSnapshot(
          items: [],
          current: null,
          total: 0,
          updatedAt: null,
        );
      }

      final seed = ref.watch(recommendationAutomationRefreshSeedProvider);

      final lastSite = ref.read(_recommendationCardLastSiteProvider);
      final lastSeed = ref.read(_recommendationCardLastSeedProvider);
      final siteChanged = lastSite != siteId;
      final manualRefresh = seed != lastSeed;
      final forceRefresh = siteChanged || manualRefresh;

      Future.microtask(() {
        ref.read(_recommendationCardLastSiteProvider.notifier).state = siteId;
        ref.read(_recommendationCardLastSeedProvider.notifier).state = seed;
      });

      final bySiteUseCase = ref.watch(getRecommendationsBySiteUseCaseProvider);
      final historyUseCase = ref.watch(getRecommendationHistoryUseCaseProvider);

      Future<List<Recommendation>> safeList(
        Future<List<Recommendation>> Function() task,
      ) async {
        try {
          return await task();
        } catch (_) {
          return const [];
        }
      }

      final responses = await safeList(() async {
        final result = await bySiteUseCase(siteId, refresh: forceRefresh);
        return result.fold((failure) => throw failure, (data) => data);
      });

      var merged = _merge(responses);
      if (merged.isEmpty) {
        final history = await safeList(() async {
          final result = await historyUseCase(siteId);
          return result.fold((failure) => throw failure, (data) => data);
        });
        merged = _merge(history);
      }

      if (merged.isNotEmpty) {
        ref.read(recommendationAutomationLastUpdatedProvider.notifier).state =
            DateTime.now();
      }
      final current = _selectCurrentRecommendation(merged);
      return CurrentRecommendationSnapshot(
        items: merged,
        current: current,
        total: merged.length,
        updatedAt: ref.read(recommendationAutomationLastUpdatedProvider),
      );
    });

final recommendationAllProvider =
    FutureProvider.autoDispose<List<Recommendation>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return const [];

      final seed = ref.watch(recommendationAutomationRefreshSeedProvider);

      final lastSite = ref.read(_recommendationAutomationLastSiteProvider);
      final lastSeed = ref.read(_recommendationAutomationLastSeedProvider);
      final siteChanged = lastSite != siteId;
      final manualRefresh = seed != lastSeed;
      final forceRefresh = siteChanged || manualRefresh;

      ref.read(_recommendationAutomationLastSiteProvider.notifier).state =
          siteId;
      ref.read(_recommendationAutomationLastSeedProvider.notifier).state = seed;

      final bySiteUseCase = ref.watch(getRecommendationsBySiteUseCaseProvider);
      final latestBySiteUseCase = ref.watch(
        getLatestRecommendationsForSiteUseCaseProvider,
      );
      final historyUseCase = ref.watch(getRecommendationHistoryUseCaseProvider);
      final byPhaseUseCase = ref.watch(
        getRecommendationsByPhaseUseCaseProvider,
      );
      final byPlantUseCase = ref.watch(
        createPlantRecommendationUseCaseProvider,
      );
      final previewUseCase = ref.watch(previewLabRecommendationUseCaseProvider);
      final saveUseCase = ref.watch(saveLabRecommendationUseCaseProvider);

      Future<List<Recommendation>> safeList(
        Future<List<Recommendation>> Function() task,
      ) async {
        try {
          return await task();
        } catch (_) {
          return const [];
        }
      }

      final phase = await _resolveActivePhase(ref);
      final plantPayload = await _buildPlantPayload(ref);

      Future<List<Recommendation>> loadSection(
        Future<List<Recommendation>> Function() task,
      ) async {
        final data = await safeList(task);
        await Future<void>.delayed(const Duration(milliseconds: 180));
        return data;
      }

      final live = await loadSection(() async {
        final result = await bySiteUseCase(siteId, refresh: forceRefresh);
        return result.fold((failure) => throw failure, (data) => data);
      });
      final latest = await loadSection(() async {
        final result = await latestBySiteUseCase(siteId);
        return result.fold((failure) => throw failure, (data) => data);
      });
      final history = await loadSection(() async {
        final result = await historyUseCase(siteId);
        return result.fold((failure) => throw failure, (data) => data);
      });
      final phaseItems = await loadSection(() async {
        final phaseId = phase?.id;
        if (phaseId == null) return const [];
        final result = await byPhaseUseCase(siteId, phaseId);
        return result.fold((failure) => throw failure, (data) => data);
      });
      final plantItems = await loadSection(() async {
        if (plantPayload == null) return const [];
        final result = await byPlantUseCase(siteId, plantPayload);
        return result.fold((failure) => throw failure, (data) => data);
      });

      var merged = _merge([
        ...latest,
        ...live,
        ...phaseItems,
        ...plantItems,
        ...history,
      ]);

      if (merged.isNotEmpty) {
        ref.read(recommendationAutomationLastUpdatedProvider.notifier).state =
            DateTime.now();
        return merged;
      }

      final labInput = await _buildLabPayload(
        ref,
        baseInput: plantPayload,
        phaseName: phase?.phaseName,
      );
      if (!forceRefresh || labInput == null) return merged;

      await safeList(() async {
        final previewResult = await previewUseCase(siteId, labInput);
        return previewResult.fold((failure) => throw failure, (_) => const []);
      });

      final lastAutoSave = ref.read(
        _recommendationAutomationLastAutoSaveProvider,
      );
      final now = DateTime.now();
      final latestSavedAt = lastAutoSave[siteId];
      final shouldSave =
          latestSavedAt == null || now.difference(latestSavedAt).inHours >= 12;

      if (shouldSave) {
        await safeList(() async {
          final saveResult = await saveUseCase(siteId, labInput);
          return saveResult.fold((failure) => throw failure, (_) => const []);
        });
        final updated = Map<String, DateTime>.from(lastAutoSave)
          ..[siteId] = now;
        ref.read(_recommendationAutomationLastAutoSaveProvider.notifier).state =
            updated;
      }

      final regenerated = await safeList(() async {
        final result = await bySiteUseCase(siteId, refresh: true);
        return result.fold((failure) => throw failure, (data) => data);
      });
      merged = _merge([...regenerated, ...history]);
      if (merged.isNotEmpty) {
        ref.read(recommendationAutomationLastUpdatedProvider.notifier).state =
            DateTime.now();
      }
      return merged;
    });

final recommendationCurrentSnapshotProvider =
    Provider<AsyncValue<CurrentRecommendationSnapshot>>((ref) {
      final allAsync = ref.watch(recommendationAllProvider);
      final updatedAt = ref.watch(recommendationAutomationLastUpdatedProvider);
      return allAsync.whenData((items) {
        final current = _selectCurrentRecommendation(items);

        return CurrentRecommendationSnapshot(
          items: items,
          current: current,
          total: items.length,
          updatedAt: updatedAt,
        );
      });
    });

final recommendationAutomationDetailProvider =
    FutureProvider.family<Recommendation, String>((
      ref,
      recommendationId,
    ) async {
      final all = await ref.read(recommendationAllProvider.future);
      for (final rec in all) {
        if (rec.recommendationId == recommendationId) return rec;
      }

      final current = ref.read(recommendationAutomationRefreshSeedProvider);
      ref.read(recommendationAutomationRefreshSeedProvider.notifier).state =
          current + 1;
      final refreshed = await ref.read(recommendationAllProvider.future);
      for (final rec in refreshed) {
        if (rec.recommendationId == recommendationId) return rec;
      }
      throw StateError('Rekomendasi tidak ditemukan');
    });

Future<Phase?> _resolveActivePhase(Ref ref) async {
  final selected = ref.read(selectedPhaseIdForRecProvider);
  try {
    final phases = await ref.read(phasesForSelectedSiteProvider.future);
    if (phases.isNotEmpty && selected != null) {
      final selectedPhase = phases
          .where((phase) => phase.id == selected)
          .firstOrNull;
      if (selectedPhase != null) return selectedPhase;
    }
  } catch (_) {}

  try {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId != null) {
      final current = await ref.read(currentPhaseProvider(siteId).future);
      if (current != null) return current;
    }
  } catch (_) {}

  final phases = await ref.read(phasesForSelectedSiteProvider.future);
  if (phases.isEmpty) return null;
  final active = phases.where((phase) => phase.isActive).firstOrNull;
  if (active != null) return active;

  Phase? latest;
  for (final phase in phases) {
    if (latest == null || phase.phaseOrder > latest.phaseOrder) {
      latest = phase;
    }
  }
  return latest;
}

Future<PlantRecommendationInput?> _buildPlantPayload(Ref ref) async {
  final ongoingPlant = await ref.read(ongoingPlantProvider.future);
  if (ongoingPlant == null || !ongoingPlant.isCurrentPlanting) return null;

  final health = await ref.read(environmentalHealthProvider.future);
  if (health == null) return null;

  final values = _readSensorValues(health);
  final required = [
    'soil_nitro',
    'soil_phos',
    'soil_pot',
    'env_temp',
    'env_hum',
    'soil_ph',
  ];
  if (!required.every(values.containsKey)) return null;

  return PlantRecommendationInput(
    soilNitro: values['soil_nitro']!,
    soilPhos: values['soil_phos']!,
    soilPot: values['soil_pot']!,
    envTemp: values['env_temp']!,
    envHum: values['env_hum']!,
    soilPh: values['soil_ph']!,
  );
}

Future<RecommendationLabInput?> _buildLabPayload(
  Ref ref, {
  PlantRecommendationInput? baseInput,
  String? phaseName,
}) async {
  final base = baseInput ?? await _buildPlantPayload(ref);
  if (base == null) return null;

  final resolvedPhaseName =
      phaseName ?? (await _resolveActivePhase(ref))?.phaseName;
  if (resolvedPhaseName == null) return null;

  final values = await ref.read(environmentalHealthProvider.future);
  final sensor = values == null
      ? <String, double>{}
      : _readSensorValues(values);

  return RecommendationLabInput(
    phase: resolvedPhaseName,
    soilNitro: base.soilNitro,
    soilPhos: base.soilPhos,
    soilPot: base.soilPot,
    envTemp: base.envTemp,
    envHum: base.envHum,
    soilTemp: sensor['soil_temp'] ?? 0,
    soilHum: sensor['soil_hum'] ?? 0,
    soilPh: base.soilPh,
  );
}

Map<String, double> _readSensorValues(EnvironmentalHealthEntity health) {
  final values = <String, double>{};
  for (final sensor in health.sensors) {
    final parsed = double.tryParse(sensor.readUpdateValue.replaceAll(',', '.'));
    if (parsed == null) continue;
    values[sensor.dsId] = parsed;
  }
  return values;
}

List<Recommendation> _merge(List<Recommendation> items) {
  final map = <String, Recommendation>{};
  for (final item in items) {
    final id = item.recommendationId.trim();
    if (id.isEmpty) continue;
    final prev = map[id];
    if (prev == null) {
      map[id] = item;
      continue;
    }

    final a = prev.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final b = item.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (b.isAfter(a)) {
      map[id] = item;
    }
  }

  final merged = map.values.toList()
    ..sort((x, y) {
      final xTime = x.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final yTime = y.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return yTime.compareTo(xTime);
    });
  return merged;
}

Recommendation? _selectCurrentRecommendation(List<Recommendation> items) {
  for (final item in items) {
    if (item.status == RecommendationStatus.pending) {
      return item;
    }
  }
  return items.isNotEmpty ? items.first : null;
}
