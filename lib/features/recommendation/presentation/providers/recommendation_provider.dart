import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../data/datasources/recommendation_remote_datasource.dart';
import '../../data/repositories/recommendation_repository_impl.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../../domain/usecases/generate_recommendation_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';

final recommendationDatasourceProvider =
    Provider<RecommendationRemoteDatasource>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return RecommendationRemoteDatasourceImpl(dioClient.dio);
    });

final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  return RecommendationRepositoryImpl(
    ref.watch(recommendationDatasourceProvider),
  );
});

final recommendationRefreshTickProvider = StreamProvider.autoDispose<int>((
  ref,
) {
  final enabled = ref.watch(appAutoRefreshEnabledProvider);
  if (!enabled) return const Stream<int>.empty();

  final baseInterval = ref.watch(appRealtimeRefreshIntervalProvider);
  final interval = Duration(microseconds: baseInterval.inMicroseconds * 4);
  return Stream<int>.periodic(interval, (tick) => tick + 1);
});

final getRecommendationsBySiteUseCaseProvider =
    Provider<GetRecommendationsBySiteUseCase>((ref) {
      return GetRecommendationsBySiteUseCase(
        ref.watch(recommendationRepositoryProvider),
      );
    });

final getLatestRecommendationsForSiteUseCaseProvider =
    Provider<GetLatestRecommendationsForSiteUseCase>((ref) {
      return GetLatestRecommendationsForSiteUseCase(
        ref.watch(recommendationRepositoryProvider),
      );
    });

final getRecommendationsByPhaseUseCaseProvider =
    Provider<GetRecommendationsByPhaseUseCase>((ref) {
      return GetRecommendationsByPhaseUseCase(
        ref.watch(recommendationRepositoryProvider),
      );
    });

typedef SitePhaseRecommendationKey = ({String siteId, String phaseId});

final recommendationsBySiteProvider = FutureProvider.autoDispose
    .family<List<Recommendation>, String>((ref, rawSiteId) async {
      ref.cacheFor(dataCardCacheDuration);
      final siteId = rawSiteId.trim();
      if (siteId.isEmpty) return const [];
      ref.watch(recommendationRefreshTickProvider);

      final useCase = ref.watch(getRecommendationsBySiteUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw failure,
          (items) => List<Recommendation>.unmodifiable(items),
        );
      });
    });

final plantRecommendationsBySiteProvider = FutureProvider.autoDispose
    .family<List<Recommendation>, String>((ref, rawSiteId) async {
      ref.cacheFor(dataCardCacheDuration);
      final siteId = rawSiteId.trim();
      if (siteId.isEmpty) return const [];
      ref.watch(recommendationRefreshTickProvider);

      final useCase = ref.watch(getLatestRecommendationsForSiteUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw failure,
          (items) => List<Recommendation>.unmodifiable(items),
        );
      });
    });

final recommendationsBySitePhaseProvider = FutureProvider.autoDispose
    .family<List<Recommendation>, SitePhaseRecommendationKey>((ref, key) async {
      ref.cacheFor(dataCardCacheDuration);
      final siteId = key.siteId.trim();
      final phaseId = key.phaseId.trim();
      if (siteId.isEmpty || phaseId.isEmpty) return const [];
      ref.watch(recommendationRefreshTickProvider);

      final useCase = ref.watch(getRecommendationsByPhaseUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId, phaseId);
        return result.fold(
          (failure) => throw failure,
          (items) => List<Recommendation>.unmodifiable(items),
        );
      });
    });

bool isRecommendationFromToday(Recommendation recommendation, {DateTime? now}) {
  final createdAt = recommendation.createdAt;
  if (createdAt == null) return true;

  final localCreatedAt = createdAt.toLocal();
  final localNow = (now ?? DateTime.now()).toLocal();
  return localCreatedAt.year == localNow.year &&
      localCreatedAt.month == localNow.month &&
      localCreatedAt.day == localNow.day;
}

List<Recommendation> sortRecommendationOverviewItems(
  List<Recommendation> items,
) {
  final byId = <String, ({Recommendation item, int index})>{};
  for (var index = 0; index < items.length; index++) {
    final item = items[index];
    final id = item.recommendationId.trim();
    if (id.isEmpty) continue;

    final previous = byId[id];
    if (previous == null) {
      byId[id] = (item: item, index: index);
      continue;
    }

    final previousDate =
        previous.item.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final currentDate =
        item.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (currentDate.isAfter(previousDate)) {
      byId[id] = (item: item, index: previous.index);
    }
  }

  final rows = byId.values.toList()
    ..sort((left, right) {
      final errorComparison = (left.item.hasError ? 1 : 0).compareTo(
        right.item.hasError ? 1 : 0,
      );
      if (errorComparison != 0) return errorComparison;

      final leftDate =
          left.item.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rightDate =
          right.item.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateComparison = rightDate.compareTo(leftDate);
      if (dateComparison != 0) return dateComparison;

      final priorityComparison = right.item.priority.index.compareTo(
        left.item.priority.index,
      );
      if (priorityComparison != 0) return priorityComparison;

      final leftConfidence = left.item.confidenceScore ?? -1;
      final rightConfidence = right.item.confidenceScore ?? -1;
      final confidenceComparison = rightConfidence.compareTo(leftConfidence);
      if (confidenceComparison != 0) return confidenceComparison;

      return left.index.compareTo(right.index);
    });

  return rows.map((row) => row.item).toList(growable: false);
}

Recommendation? primaryRecommendationForOverview(List<Recommendation> items) {
  final sortedItems = sortRecommendationOverviewItems(items);
  return sortedItems.isEmpty ? null : sortedItems.first;
}

final getRecommendationHistoryUseCaseProvider =
    Provider<GetRecommendationHistoryUseCase>((ref) {
      return GetRecommendationHistoryUseCase(
        ref.watch(recommendationRepositoryProvider),
      );
    });

final recommendationHistoryProvider = FutureProvider.autoDispose
    .family<List<Recommendation>, String>((ref, rawSiteId) async {
      ref.cacheFor(dataCardCacheDuration);
      final siteId = rawSiteId.trim();
      if (siteId.isEmpty) return const [];

      final useCase = ref.watch(getRecommendationHistoryUseCaseProvider);
      return ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw failure,
          (items) => List<Recommendation>.unmodifiable(items),
        );
      });
    });
