import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/recommendation_remote_datasource.dart';
import '../../data/repositories/recommendation_repository_impl.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';

/// Recommendation datasource provider
final recommendationDatasourceProvider =
    Provider<RecommendationRemoteDatasource>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return RecommendationRemoteDatasourceImpl(dioClient.dio);
    });

/// Recommendation repository provider
final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  final datasource = ref.watch(recommendationDatasourceProvider);
  return RecommendationRepositoryImpl(datasource);
});

/// Recommendation list provider
final recommendationListProvider = FutureProvider<List<Recommendation>>((
  ref,
) async {
  final repository = ref.watch(recommendationRepositoryProvider);
  final result = await repository.getRecommendations();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (recommendations) => List<Recommendation>.from(recommendations),
  );
});

/// Recommendations by site provider
final recommendationsBySiteProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, siteId) async {
      final repository = ref.watch(recommendationRepositoryProvider);
      final result = await repository.getRecommendationsBySite(siteId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (recommendations) => List<Recommendation>.from(recommendations),
      );
    });

/// Recommendations by plant provider
final recommendationsByPlantProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, plantId) async {
      final repository = ref.watch(recommendationRepositoryProvider);
      final result = await repository.getRecommendationsByPlant(plantId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (recommendations) => List<Recommendation>.from(recommendations),
      );
    });

/// Recommendations by type provider
final recommendationsByTypeProvider =
    FutureProvider.family<List<Recommendation>, RecommendationType>((
      ref,
      type,
    ) async {
      final repository = ref.watch(recommendationRepositoryProvider);
      final result = await repository.getRecommendationsByType(type);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (recommendations) => List<Recommendation>.from(recommendations),
      );
    });

/// Recommendation detail provider
final recommendationDetailProvider =
    FutureProvider.family<Recommendation, String>((
      ref,
      recommendationId,
    ) async {
      final repository = ref.watch(recommendationRepositoryProvider);
      final result = await repository.getRecommendationById(recommendationId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (recommendation) => recommendation,
      );
    });

/// Recommendation filter provider
final recommendationFilterProvider = StateProvider<RecommendationFilter>(
  (ref) => RecommendationFilter.all,
);

/// Filtered recommendations provider
final filteredRecommendationsProvider =
    Provider<AsyncValue<List<Recommendation>>>((ref) {
      final recommendationsAsync = ref.watch(recommendationListProvider);
      final filter = ref.watch(recommendationFilterProvider);

      return recommendationsAsync.whenData((recommendations) {
        switch (filter) {
          case RecommendationFilter.all:
            return recommendations;
          case RecommendationFilter.pending:
            return recommendations
                .where((r) => r.status == RecommendationStatus.pending)
                .toList();
          case RecommendationFilter.applied:
            return recommendations
                .where((r) => r.status == RecommendationStatus.applied)
                .toList();
          case RecommendationFilter.highPriority:
            return recommendations
                .where(
                  (r) =>
                      r.priority == RecommendationPriority.high ||
                      r.priority == RecommendationPriority.critical,
                )
                .toList();
          case RecommendationFilter.actionable:
            return recommendations.where((r) => r.isActionable).toList();
        }
      });
    });

/// Recommendation statistics provider
final recommendationStatsProvider = Provider<RecommendationStats>((ref) {
  final recommendationsAsync = ref.watch(recommendationListProvider);

  return recommendationsAsync.when(
    data: (recommendations) {
      final total = recommendations.length;
      final pending = recommendations
          .where((r) => r.status == RecommendationStatus.pending)
          .length;
      final applied = recommendations
          .where((r) => r.status == RecommendationStatus.applied)
          .length;
      final dismissed = recommendations
          .where((r) => r.status == RecommendationStatus.dismissed)
          .length;
      final highPriority = recommendations
          .where(
            (r) =>
                r.priority == RecommendationPriority.high ||
                r.priority == RecommendationPriority.critical,
          )
          .length;

      return RecommendationStats(
        total: total,
        pending: pending,
        applied: applied,
        dismissed: dismissed,
        highPriority: highPriority,
      );
    },
    loading: () => const RecommendationStats(),
    error: (_, __) => const RecommendationStats(),
  );
});

/// Recommendation filter enum
enum RecommendationFilter {
  all,
  pending,
  applied,
  highPriority,
  actionable;

  String get label {
    switch (this) {
      case RecommendationFilter.all:
        return 'Semua';
      case RecommendationFilter.pending:
        return 'Menunggu';
      case RecommendationFilter.applied:
        return 'Diterapkan';
      case RecommendationFilter.highPriority:
        return 'Prioritas Tinggi';
      case RecommendationFilter.actionable:
        return 'Perlu Tindakan';
    }
  }
}

/// Recommendation statistics model
class RecommendationStats {
  final int total;
  final int pending;
  final int applied;
  final int dismissed;
  final int highPriority;

  const RecommendationStats({
    this.total = 0,
    this.pending = 0,
    this.applied = 0,
    this.dismissed = 0,
    this.highPriority = 0,
  });

  double get applicationRate {
    if (total == 0) return 0;
    return (applied / total) * 100;
  }
}
