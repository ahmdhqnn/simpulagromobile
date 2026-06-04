import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../phase/domain/entities/phase.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/recommendation.dart';
import 'recommendation_provider.dart';

enum RecommendationScope {
  all,
  site,
  plant,
  phase;

  String get queryValue {
    switch (this) {
      case RecommendationScope.all:
        return 'all';
      case RecommendationScope.site:
        return 'site';
      case RecommendationScope.plant:
        return 'plant';
      case RecommendationScope.phase:
        return 'phase';
    }
  }

  String get label {
    switch (this) {
      case RecommendationScope.all:
        return 'Semua';
      case RecommendationScope.site:
        return 'Site';
      case RecommendationScope.plant:
        return 'Plant';
      case RecommendationScope.phase:
        return 'Phase';
    }
  }
}

RecommendationScope recommendationScopeFromQuery(String? raw) {
  switch (raw?.trim().toLowerCase()) {
    case 'site':
      return RecommendationScope.site;
    case 'plant':
      return RecommendationScope.plant;
    case 'phase':
      return RecommendationScope.phase;
    default:
      return RecommendationScope.all;
  }
}

enum RecommendationStatusFilter {
  all,
  pending,
  applied,
  highPriority,
  actionable;

  String get label {
    switch (this) {
      case RecommendationStatusFilter.all:
        return 'Semua Status';
      case RecommendationStatusFilter.pending:
        return 'Menunggu';
      case RecommendationStatusFilter.applied:
        return 'Diterapkan';
      case RecommendationStatusFilter.highPriority:
        return 'Prioritas Tinggi';
      case RecommendationStatusFilter.actionable:
        return 'Perlu Tindakan';
    }
  }
}

class RecommendationPhaseSelection {
  const RecommendationPhaseSelection({
    required this.phaseId,
    required this.phaseName,
  });

  final String phaseId;
  final String phaseName;
}

class RecommendationPhaseSnapshot {
  const RecommendationPhaseSnapshot({
    required this.phaseId,
    required this.phaseName,
    required this.items,
    this.currentHst,
  });

  final String? phaseId;
  final String? phaseName;
  final List<Recommendation> items;
  final int? currentHst;
}

class RecommendationCatalogItem {
  const RecommendationCatalogItem({
    required this.recommendation,
    required this.scopes,
  });

  final Recommendation recommendation;
  final Set<RecommendationScope> scopes;
}

class RecommendationHubStats {
  const RecommendationHubStats({
    this.total = 0,
    this.pending = 0,
    this.applied = 0,
    this.highPriority = 0,
  });

  final int total;
  final int pending;
  final int applied;
  final int highPriority;
}

class RecommendationDashboardSnapshot {
  const RecommendationDashboardSnapshot({
    required this.siteItems,
    required this.plantItems,
    required this.phaseSnapshot,
  });

  final List<Recommendation> siteItems;
  final List<Recommendation> plantItems;
  final RecommendationPhaseSnapshot phaseSnapshot;
}

final recommendationScopeFilterProvider = StateProvider<RecommendationScope>(
  (_) => RecommendationScope.all,
);

final recommendationStatusFilterProvider =
    StateProvider<RecommendationStatusFilter>(
      (_) => RecommendationStatusFilter.all,
    );

final recommendationSearchQueryProvider = StateProvider<String>((_) => '');

final _recommendationPhaseSelectionSiteProvider = StateProvider<String?>(
  (_) => null,
);

void resetRecommendationHubFilters(
  WidgetRef ref, {
  RecommendationScope? scope,
}) {
  ref.read(recommendationScopeFilterProvider.notifier).state =
      scope ?? RecommendationScope.all;
  ref.read(recommendationStatusFilterProvider.notifier).state =
      RecommendationStatusFilter.all;
  ref.read(recommendationSearchQueryProvider.notifier).state = '';
  ref.read(selectedPhaseIdForRecProvider.notifier).state = null;
}

void invalidateRecommendationHubData(WidgetRef ref) {
  ref.invalidate(recommendationSiteFeedProvider);
  ref.invalidate(recommendationPlantFeedProvider);
  ref.invalidate(recommendationPhaseSelectionProvider);
  ref.invalidate(recommendationPhaseFeedProvider);
  ref.invalidate(recommendationActivePhaseFeedProvider);
  ref.invalidate(recommendationHubDashboardSnapshotProvider);
  ref.invalidate(recommendationCatalogProvider);
}

bool _isTransientRecommendationFailure(Failure failure) {
  if (failure is NetworkFailure) return true;
  if (failure is ServerFailure) {
    final code = failure.statusCode ?? 0;
    return code == 429 || (code >= 500 && code <= 599);
  }
  return false;
}

final recommendationSiteFeedProvider =
    FutureProvider.autoDispose<List<Recommendation>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return const [];

      final useCase = ref.watch(getRecommendationsBySiteUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId, refresh: false);
        return result.fold((failure) {
          if (_isTransientRecommendationFailure(failure)) {
            return const <Recommendation>[];
          }
          throw failure;
        }, (items) => List<Recommendation>.from(items));
      });
    });

final recommendationPlantFeedProvider =
    FutureProvider.autoDispose<List<Recommendation>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return const [];

      final useCase = ref.watch(getLatestRecommendationsForSiteUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold((failure) {
          if (_isTransientRecommendationFailure(failure)) {
            return const <Recommendation>[];
          }
          throw failure;
        }, (items) => List<Recommendation>.from(items));
      });
    });

final recommendationPhaseSelectionProvider =
    FutureProvider.autoDispose<RecommendationPhaseSelection?>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      final lastSiteId = ref.read(_recommendationPhaseSelectionSiteProvider);
      final siteChanged = siteId != lastSiteId;
      final selectedPhaseId = siteChanged
          ? null
          : ref.watch(selectedPhaseIdForRecProvider);
      if (siteChanged) {
        Future.microtask(() {
          ref.read(_recommendationPhaseSelectionSiteProvider.notifier).state =
              siteId;
          ref.read(selectedPhaseIdForRecProvider.notifier).state = null;
        });
      }
      final phases = await ref.watch(phasesForSelectedSiteProvider.future);
      if (phases.isEmpty) return null;

      Phase? selected;
      if (selectedPhaseId != null) {
        selected = phases
            .where((phase) => phase.id == selectedPhaseId)
            .firstOrNull;
      }
      selected ??= phases.where((phase) => phase.isActive).firstOrNull;
      selected ??= phases.first;

      if (selected.id != selectedPhaseId) {
        ref.read(selectedPhaseIdForRecProvider.notifier).state = selected.id;
      }

      return RecommendationPhaseSelection(
        phaseId: selected.id,
        phaseName: selected.phaseName,
      );
    });

final recommendationPhaseFeedProvider =
    FutureProvider.autoDispose<RecommendationPhaseSnapshot>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) {
        return const RecommendationPhaseSnapshot(
          phaseId: null,
          phaseName: null,
          items: <Recommendation>[],
        );
      }

      final selected = await ref.watch(
        recommendationPhaseSelectionProvider.future,
      );
      if (selected == null) {
        return const RecommendationPhaseSnapshot(
          phaseId: null,
          phaseName: null,
          items: <Recommendation>[],
        );
      }

      final useCase = ref.watch(getRecommendationsByPhaseUseCaseProvider);
      final items = await ref.retryOnError(() async {
        final result = await useCase(siteId, selected.phaseId);
        return result.fold((failure) {
          if (_isTransientRecommendationFailure(failure)) {
            return const <Recommendation>[];
          }
          throw failure;
        }, (data) => List<Recommendation>.from(data));
      });

      return RecommendationPhaseSnapshot(
        phaseId: selected.phaseId,
        phaseName: selected.phaseName,
        items: items,
      );
    });

final recommendationActivePhaseFeedProvider =
    FutureProvider.autoDispose<RecommendationPhaseSnapshot>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) {
        return const RecommendationPhaseSnapshot(
          phaseId: null,
          phaseName: null,
          items: <Recommendation>[],
        );
      }

      final phases = await ref.watch(phasesForSelectedSiteProvider.future);
      final active = phases.where((phase) => phase.isActive).firstOrNull;
      if (active == null) {
        return const RecommendationPhaseSnapshot(
          phaseId: null,
          phaseName: null,
          items: <Recommendation>[],
        );
      }

      final useCase = ref.watch(getRecommendationsByPhaseUseCaseProvider);
      final items = await ref.retryOnError(() async {
        final result = await useCase(siteId, active.id);
        return result.fold((failure) {
          if (_isTransientRecommendationFailure(failure)) {
            return const <Recommendation>[];
          }
          throw failure;
        }, (data) => List<Recommendation>.from(data));
      });

      return RecommendationPhaseSnapshot(
        phaseId: active.id,
        phaseName: active.phaseName,
        currentHst: active.currentHst,
        items: items,
      );
    });

final recommendationCatalogProvider =
    FutureProvider.autoDispose<List<RecommendationCatalogItem>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteItems = await ref.watch(recommendationSiteFeedProvider.future);
      final plantItems = await ref.watch(
        recommendationPlantFeedProvider.future,
      );
      final phaseSnapshot = await ref.watch(
        recommendationPhaseFeedProvider.future,
      );

      final raw = <RecommendationCatalogItem>[
        ...siteItems.map(
          (item) => RecommendationCatalogItem(
            recommendation: item,
            scopes: const {RecommendationScope.site},
          ),
        ),
        ...plantItems.map(
          (item) => RecommendationCatalogItem(
            recommendation: item,
            scopes: const {RecommendationScope.plant},
          ),
        ),
        ...phaseSnapshot.items.map(
          (item) => RecommendationCatalogItem(
            recommendation: item,
            scopes: const {RecommendationScope.phase},
          ),
        ),
      ];

      return _mergeRecommendationCatalog(raw);
    });

final recommendationHubDashboardSnapshotProvider =
    FutureProvider.autoDispose<RecommendationDashboardSnapshot>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));

      final siteItems = await _loadRecommendationSection(
        ref.watch(recommendationSiteFeedProvider.future),
        const <Recommendation>[],
      );
      await Future<void>.delayed(const Duration(milliseconds: 180));

      final plantItems = await _loadRecommendationSection(
        ref.watch(recommendationPlantFeedProvider.future),
        const <Recommendation>[],
      );
      await Future<void>.delayed(const Duration(milliseconds: 180));

      final phaseSnapshot = await _loadRecommendationSection(
        ref.watch(recommendationActivePhaseFeedProvider.future),
        const RecommendationPhaseSnapshot(
          phaseId: null,
          phaseName: null,
          items: <Recommendation>[],
        ),
      );

      return RecommendationDashboardSnapshot(
        siteItems: siteItems,
        plantItems: plantItems,
        phaseSnapshot: phaseSnapshot,
      );
    });

final filteredRecommendationCatalogProvider =
    Provider<AsyncValue<List<RecommendationCatalogItem>>>((ref) {
      final catalogAsync = ref.watch(recommendationCatalogProvider);
      final scopeFilter = ref.watch(recommendationScopeFilterProvider);
      final statusFilter = ref.watch(recommendationStatusFilterProvider);
      final query = ref
          .watch(recommendationSearchQueryProvider)
          .trim()
          .toLowerCase();

      return catalogAsync.whenData((rows) {
        return rows.where((entry) {
          if (scopeFilter != RecommendationScope.all &&
              !entry.scopes.contains(scopeFilter)) {
            return false;
          }

          final recommendation = entry.recommendation;
          if (!_matchStatusFilter(recommendation, statusFilter)) return false;

          if (query.isEmpty) return true;
          final haystack = [
            recommendation.title,
            recommendation.description,
            recommendation.type.label,
            recommendation.siteName ?? '',
            recommendation.plantName ?? '',
          ].join(' ').toLowerCase();
          return haystack.contains(query);
        }).toList();
      });
    });

final recommendationHubStatsProvider =
    Provider<AsyncValue<RecommendationHubStats>>((ref) {
      final filteredAsync = ref.watch(filteredRecommendationCatalogProvider);
      return filteredAsync.whenData((rows) {
        final total = rows.length;
        final pending = rows
            .where(
              (entry) =>
                  entry.recommendation.status == RecommendationStatus.pending,
            )
            .length;
        final applied = rows
            .where(
              (entry) =>
                  entry.recommendation.status == RecommendationStatus.applied,
            )
            .length;
        final highPriority = rows
            .where(
              (entry) =>
                  entry.recommendation.priority ==
                      RecommendationPriority.high ||
                  entry.recommendation.priority ==
                      RecommendationPriority.critical,
            )
            .length;

        return RecommendationHubStats(
          total: total,
          pending: pending,
          applied: applied,
          highPriority: highPriority,
        );
      });
    });

final recommendationHubDetailProvider = FutureProvider.autoDispose
    .family<Recommendation, String>((ref, recommendationId) async {
      Recommendation? findInCatalog(List<RecommendationCatalogItem> rows) {
        for (final entry in rows) {
          if (entry.recommendation.recommendationId == recommendationId) {
            return entry.recommendation;
          }
        }
        return null;
      }

      Recommendation? findInList(List<Recommendation> rows) {
        for (final item in rows) {
          if (item.recommendationId == recommendationId) return item;
        }
        return null;
      }

      Future<Recommendation?> findInFutureList(
        Future<List<Recommendation>> future,
      ) async {
        try {
          return findInList(await future);
        } on Failure catch (failure) {
          if (failure is AuthFailure || failure is PermissionFailure) {
            rethrow;
          }
          return null;
        } catch (_) {
          return null;
        }
      }

      Future<Recommendation?> findInPhaseSnapshot(
        Future<RecommendationPhaseSnapshot> future,
      ) async {
        try {
          return findInList((await future).items);
        } on Failure catch (failure) {
          if (failure is AuthFailure || failure is PermissionFailure) {
            rethrow;
          }
          return null;
        } catch (_) {
          return null;
        }
      }

      Future<Recommendation?> findInCatalogFuture(
        Future<List<RecommendationCatalogItem>> future,
      ) async {
        try {
          return findInCatalog(await future);
        } on Failure catch (failure) {
          if (failure is AuthFailure || failure is PermissionFailure) {
            rethrow;
          }
          return null;
        } catch (_) {
          return null;
        }
      }

      Future<Recommendation?> findInSecondaryFeeds() async {
        final sources = <Future<Recommendation?> Function()>[
          () =>
              findInFutureList(ref.read(recommendationSiteFeedProvider.future)),
          () => findInFutureList(
            ref.read(recommendationPlantFeedProvider.future),
          ),
          () =>
              findInFutureList(ref.read(recommendationHistoryProvider.future)),
          () => findInPhaseSnapshot(
            ref.read(recommendationPhaseFeedProvider.future),
          ),
          () => findInPhaseSnapshot(
            ref.read(recommendationActivePhaseFeedProvider.future),
          ),
        ];

        for (final source in sources) {
          final found = await source();
          if (found != null) return found;
        }
        return null;
      }

      final firstCatalog = await findInCatalogFuture(
        ref.read(recommendationCatalogProvider.future),
      );
      final cached = firstCatalog ?? await findInSecondaryFeeds();
      if (cached != null) return cached;

      ref.invalidate(recommendationSiteFeedProvider);
      ref.invalidate(recommendationPlantFeedProvider);
      ref.invalidate(recommendationHistoryProvider);
      ref.invalidate(recommendationPhaseSelectionProvider);
      ref.invalidate(recommendationPhaseFeedProvider);
      ref.invalidate(recommendationActivePhaseFeedProvider);
      ref.invalidate(recommendationCatalogProvider);
      final refreshedCatalog = await findInCatalogFuture(
        ref.read(recommendationCatalogProvider.future),
      );
      final loaded = refreshedCatalog ?? await findInSecondaryFeeds();
      if (loaded != null) return loaded;

      throw const NotFoundFailure(
        'Rekomendasi tidak ditemukan. Coba muat ulang daftar rekomendasi.',
      );
    });

List<RecommendationCatalogItem> _mergeRecommendationCatalog(
  List<RecommendationCatalogItem> rows,
) {
  final map = <String, RecommendationCatalogItem>{};
  for (final row in rows) {
    final id = row.recommendation.recommendationId.trim();
    if (id.isEmpty) continue;

    final previous = map[id];
    if (previous == null) {
      map[id] = row;
      continue;
    }

    final mergedScopes = {...previous.scopes, ...row.scopes};
    final prevDate =
        previous.recommendation.createdAt ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final nextDate =
        row.recommendation.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final newest = nextDate.isAfter(prevDate)
        ? row.recommendation
        : previous.recommendation;

    map[id] = RecommendationCatalogItem(
      recommendation: newest,
      scopes: mergedScopes,
    );
  }

  final merged = map.values.toList()
    ..sort((left, right) {
      final leftDate =
          left.recommendation.createdAt ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final rightDate =
          right.recommendation.createdAt ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return rightDate.compareTo(leftDate);
    });

  return merged;
}

bool _matchStatusFilter(
  Recommendation recommendation,
  RecommendationStatusFilter filter,
) {
  switch (filter) {
    case RecommendationStatusFilter.all:
      return true;
    case RecommendationStatusFilter.pending:
      return recommendation.status == RecommendationStatus.pending;
    case RecommendationStatusFilter.applied:
      return recommendation.status == RecommendationStatus.applied;
    case RecommendationStatusFilter.highPriority:
      return recommendation.priority == RecommendationPriority.high ||
          recommendation.priority == RecommendationPriority.critical;
    case RecommendationStatusFilter.actionable:
      return recommendation.isActionable;
  }
}

Future<T> _loadRecommendationSection<T>(Future<T> future, T fallback) async {
  try {
    return await future;
  } on Failure catch (failure) {
    if (failure is AuthFailure || failure is PermissionFailure) {
      rethrow;
    }
    return fallback;
  } catch (_) {
    return fallback;
  }
}
