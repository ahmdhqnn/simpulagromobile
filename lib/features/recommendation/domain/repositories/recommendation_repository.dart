import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../entities/recommendation_request.dart';

/// Recommendation repository interface
abstract class RecommendationRepository {
  Future<Either<Failure, List<Recommendation>>> getRecommendationsBySite(
    String siteId, {
    bool refresh = false,
  });

  Future<Either<Failure, List<Recommendation>>> getLatestRecommendationsForSite(
    String siteId,
  );

  Future<Either<Failure, List<Recommendation>>> generateRecommendations(
    String siteId,
  );

  Future<Either<Failure, List<Recommendation>>> getRecommendationHistory(
    String siteId,
  );

  Future<Either<Failure, List<Recommendation>>> getRecommendationsByPhase(
    String siteId,
    String phaseId,
  );

  Future<Either<Failure, List<Recommendation>>> createPlantRecommendation(
    String siteId,
    PlantRecommendationInput input,
  );
}
