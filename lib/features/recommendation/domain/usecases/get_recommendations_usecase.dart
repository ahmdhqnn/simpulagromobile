import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendation_repository.dart';

class GetRecommendationsBySiteUseCase {
  final RecommendationRepository repository;
  GetRecommendationsBySiteUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(
    String siteId, {
    bool refresh = false,
  }) async {
    return await repository.getRecommendationsBySite(siteId, refresh: refresh);
  }
}

class GetLatestRecommendationsForSiteUseCase {
  final RecommendationRepository repository;
  GetLatestRecommendationsForSiteUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(String siteId) async {
    return await repository.getLatestRecommendationsForSite(siteId);
  }
}
