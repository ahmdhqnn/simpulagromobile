import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = rawSiteId.trim();
      if (siteId.isEmpty) return const [];

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
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = rawSiteId.trim();
      if (siteId.isEmpty) return const [];

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
      ref.cacheFor(const Duration(minutes: 5));
      final siteId = key.siteId.trim();
      final phaseId = key.phaseId.trim();
      if (siteId.isEmpty || phaseId.isEmpty) return const [];

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
