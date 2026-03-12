import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/recommendation_remote_datasource.dart';

final recRemoteDataSourceProvider =
    Provider<RecommendationRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RecommendationRemoteDataSource(dioClient.dio);
});

/// NPK + pH Recommendations for selected site
final recommendationsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return null;
  final ds = ref.watch(recRemoteDataSourceProvider);
  return ds.getRecommendations(siteId);
});

/// Recommendation history
final recHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final ds = ref.watch(recRemoteDataSourceProvider);
  return ds.getHistory(siteId);
});
