import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/recommendation.dart';
import 'recommendation_provider.dart';

enum RecommendationScope {
  all,
  site,
  plant,
  phase;

  String get queryValue => name;
}

RecommendationScope recommendationScopeFromQuery(String? raw) {
  return RecommendationScope.values.firstWhere(
    (scope) => scope.name == raw?.trim().toLowerCase(),
    orElse: () => RecommendationScope.all,
  );
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
    this.site = 0,
    this.plant = 0,
    this.phase = 0,
  });

  final int total;
  final int site;
  final int plant;
  final int phase;
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

enum RecommendationHubTab { active, history }

final recommendationHubTabProvider = StateProvider<RecommendationHubTab>(
  (_) => RecommendationHubTab.active,
);

enum RecommendationHubFilter {
  all,
  site,
  plant,
  phase,
  history,
}

final recommendationHubFilterProvider = StateProvider<RecommendationHubFilter>(
  (_) => RecommendationHubFilter.all,
);

final recommendationScopeFilterProvider = StateProvider<RecommendationScope>(
  (_) => RecommendationScope.all,
);

final recommendationSearchQueryProvider = StateProvider<String>((_) => '');

void resetRecommendationHubFilters(
  WidgetRef ref, {
  RecommendationScope? scope,
}) {
  final resolvedScope = scope ?? RecommendationScope.all;
  ref.read(recommendationScopeFilterProvider.notifier).state = resolvedScope;
  ref.read(recommendationSearchQueryProvider.notifier).state = '';
  
  final filter = switch (resolvedScope) {
    RecommendationScope.all => RecommendationHubFilter.all,
    RecommendationScope.site => RecommendationHubFilter.site,
    RecommendationScope.plant => RecommendationHubFilter.plant,
    RecommendationScope.phase => RecommendationHubFilter.phase,
  };
  ref.read(recommendationHubFilterProvider.notifier).state = filter;
  ref.read(recommendationHubTabProvider.notifier).state = RecommendationHubTab.active;
}

void invalidateRecommendationHubData(WidgetRef ref) {
  final siteId = ref.read(selectedSiteIdProvider);
  if (siteId != null) {
    ref.invalidate(recommendationsBySiteProvider(siteId));
    ref.invalidate(plantRecommendationsBySiteProvider(siteId));
    ref.invalidate(currentPhaseProvider(siteId));
    ref.invalidate(recommendationHistoryProvider(siteId));
  }
  ref.invalidate(recommendationSiteFeedProvider);
  ref.invalidate(recommendationPlantFeedProvider);
  ref.invalidate(recommendationActivePhaseFeedProvider);
  ref.invalidate(recommendationHubDashboardSnapshotProvider);
  ref.invalidate(recommendationCatalogProvider);
}

Future<void> invalidateRecommendationHubDataSpaced(WidgetRef ref) {
  final siteId = ref.read(selectedSiteIdProvider);
  return runSpacedInvalidations([
    if (siteId != null)
      () => ref.invalidate(recommendationsBySiteProvider(siteId)),
    if (siteId != null)
      () => ref.invalidate(plantRecommendationsBySiteProvider(siteId)),
    if (siteId != null) () => ref.invalidate(currentPhaseProvider(siteId)),
    if (siteId != null) () => ref.invalidate(recommendationHistoryProvider(siteId)),
    () => ref.invalidate(recommendationSiteFeedProvider),
    () => ref.invalidate(recommendationPlantFeedProvider),
    () => ref.invalidate(recommendationActivePhaseFeedProvider),
    () => ref.invalidate(recommendationHubDashboardSnapshotProvider),
    () => ref.invalidate(recommendationCatalogProvider),
  ]);
}

final recommendationSiteFeedProvider =
    FutureProvider.autoDispose<List<Recommendation>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return const [];
      return ref.watch(recommendationsBySiteProvider(siteId).future);
    });

final recommendationPlantFeedProvider =
    FutureProvider.autoDispose<List<Recommendation>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return const [];
      return ref.watch(plantRecommendationsBySiteProvider(siteId).future);
    });

final recommendationActivePhaseFeedProvider =
    FutureProvider.autoDispose<RecommendationPhaseSnapshot>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return _emptyPhaseSnapshot;

      final activePhase = await ref.watch(currentPhaseProvider(siteId).future);
      if (activePhase == null) return _emptyPhaseSnapshot;

      final items = await ref.watch(
        recommendationsBySitePhaseProvider((
          siteId: siteId,
          phaseId: activePhase.id,
        )).future,
      );
      return RecommendationPhaseSnapshot(
        phaseId: activePhase.id,
        phaseName: activePhase.phaseName,
        currentHst: activePhase.currentHst,
        items: items,
      );
    });

final recommendationCatalogProvider =
    FutureProvider.autoDispose<List<RecommendationCatalogItem>>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteFuture = ref.watch(recommendationSiteFeedProvider.future);
      final plantFuture = ref.watch(recommendationPlantFeedProvider.future);
      final phaseFuture = ref.watch(
        recommendationActivePhaseFeedProvider.future,
      );

      final siteItems = await siteFuture;
      final plantItems = await plantFuture;
      final phaseSnapshot = await phaseFuture;

      return _mergeRecommendationCatalog([
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
      ]);
    });

final recommendationHubDashboardSnapshotProvider =
    FutureProvider.autoDispose<RecommendationDashboardSnapshot>((ref) async {
      ref.cacheFor(const Duration(minutes: 5));
      final siteFuture = ref.watch(recommendationSiteFeedProvider.future);
      final plantFuture = ref.watch(recommendationPlantFeedProvider.future);
      final phaseFuture = ref.watch(
        recommendationActivePhaseFeedProvider.future,
      );

      return RecommendationDashboardSnapshot(
        siteItems: await _loadRecommendationSection(siteFuture, const []),
        plantItems: await _loadRecommendationSection(plantFuture, const []),
        phaseSnapshot: await _loadRecommendationSection(
          phaseFuture,
          _emptyPhaseSnapshot,
        ),
      );
    });

final filteredRecommendationCatalogProvider =
    Provider<AsyncValue<List<RecommendationCatalogItem>>>((ref) {
      final catalogAsync = ref.watch(recommendationCatalogProvider);
      final scope = ref.watch(recommendationScopeFilterProvider);
      final query = ref
          .watch(recommendationSearchQueryProvider)
          .trim()
          .toLowerCase();

      return catalogAsync.whenData((rows) {
        return rows
            .where((entry) {
              if (scope != RecommendationScope.all &&
                  !entry.scopes.contains(scope)) {
                return false;
              }
              if (query.isEmpty) return true;

              final item = entry.recommendation;
              return [
                item.title,
                item.description,
                item.type.label,
                item.siteName ?? '',
                item.plantName ?? '',
                item.reason ?? '',
              ].join(' ').toLowerCase().contains(query);
            })
            .toList(growable: false);
      });
    });

final recommendationHubStatsProvider =
    Provider<AsyncValue<RecommendationHubStats>>((ref) {
      return ref.watch(recommendationCatalogProvider).whenData((rows) {
        return RecommendationHubStats(
          total: rows.length,
          site: rows
              .where((row) => row.scopes.contains(RecommendationScope.site))
              .length,
          plant: rows
              .where((row) => row.scopes.contains(RecommendationScope.plant))
              .length,
          phase: rows
              .where((row) => row.scopes.contains(RecommendationScope.phase))
              .length,
        );
      });
    });

final recommendationHubDetailItemProvider = FutureProvider.autoDispose
    .family<RecommendationCatalogItem, String>((ref, recommendationId) async {
      RecommendationCatalogItem? find(
        List<RecommendationCatalogItem> rows,
        List<Recommendation> history,
      ) {
        for (final row in rows) {
          if (row.recommendation.recommendationId == recommendationId) {
            return row;
          }
        }
        for (final item in history) {
          if (item.recommendationId == recommendationId) {
            return RecommendationCatalogItem(
              recommendation: item,
              scopes: const {RecommendationScope.site},
            );
          }
        }
        return null;
      }

      final siteId = ref.read(selectedSiteIdProvider);
      final activeCatalog = await ref.read(recommendationCatalogProvider.future);
      final historyItems = siteId != null
          ? await ref.read(recommendationHistoryProvider(siteId).future).catchError((_) => <Recommendation>[])
          : const <Recommendation>[];

      final current = find(activeCatalog, historyItems);
      if (current != null) return current;

      ref.invalidate(recommendationSiteFeedProvider);
      ref.invalidate(recommendationPlantFeedProvider);
      ref.invalidate(recommendationActivePhaseFeedProvider);
      ref.invalidate(recommendationCatalogProvider);
      if (siteId != null) {
        ref.invalidate(recommendationHistoryProvider(siteId));
      }

      final refCatalog = await ref.read(recommendationCatalogProvider.future);
      final refHistory = siteId != null
          ? await ref.read(recommendationHistoryProvider(siteId).future).catchError((_) => <Recommendation>[])
          : const <Recommendation>[];

      final refreshed = find(refCatalog, refHistory);
      if (refreshed != null) return refreshed;

      throw const NotFoundFailure(
        'Rekomendasi tidak ditemukan pada data aktif maupun riwayat saat ini.',
      );
    });

final recommendationHubDetailProvider = FutureProvider.autoDispose
    .family<Recommendation, String>((ref, recommendationId) async {
      final item = await ref.watch(
        recommendationHubDetailItemProvider(recommendationId).future,
      );
      return item.recommendation;
    });

const _emptyPhaseSnapshot = RecommendationPhaseSnapshot(
  phaseId: null,
  phaseName: null,
  items: <Recommendation>[],
);

List<RecommendationCatalogItem> _mergeRecommendationCatalog(
  List<RecommendationCatalogItem> rows,
) {
  final merged = <String, RecommendationCatalogItem>{};
  for (final row in rows) {
    final id = row.recommendation.recommendationId.trim();
    if (id.isEmpty) continue;

    final previous = merged[id];
    if (previous == null) {
      merged[id] = row;
      continue;
    }

    final previousDate =
        previous.recommendation.createdAt ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final nextDate =
        row.recommendation.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    merged[id] = RecommendationCatalogItem(
      recommendation: nextDate.isAfter(previousDate)
          ? row.recommendation
          : previous.recommendation,
      scopes: {...previous.scopes, ...row.scopes},
    );
  }

  return merged.values.toList()..sort((left, right) {
    final leftDate =
        left.recommendation.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final rightDate =
        right.recommendation.createdAt ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final dateComparison = rightDate.compareTo(leftDate);
    if (dateComparison != 0) return dateComparison;
    return right.recommendation.priority.index.compareTo(
      left.recommendation.priority.index,
    );
  });
}

Future<T> _loadRecommendationSection<T>(Future<T> future, T fallback) async {
  try {
    return await future;
  } on Failure catch (failure) {
    if (failure is AuthFailure || failure is PermissionFailure) rethrow;
    return fallback;
  } catch (_) {
    return fallback;
  }
}
