import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendation_repository.dart';

class GetRecommendationsUseCase {
  final RecommendationRepository repository;
  GetRecommendationsUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call() async {
    return await repository.getRecommendations();
  }
}

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

class GetRecommendationsByPlantUseCase {
  final RecommendationRepository repository;
  GetRecommendationsByPlantUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(
    String siteId,
    String plantId,
  ) async {
    return await repository.getRecommendationsByPlant(siteId, plantId);
  }
}

class GetRecommendationsByTypeUseCase {
  final RecommendationRepository repository;
  GetRecommendationsByTypeUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(
    RecommendationType type,
  ) async {
    return await repository.getRecommendationsByType(type);
  }
}

class GetRecommendationByIdUseCase {
  final RecommendationRepository repository;
  GetRecommendationByIdUseCase(this.repository);

  Future<Either<Failure, Recommendation>> call(String id) async {
    return await repository.getRecommendationById(id);
  }
}
