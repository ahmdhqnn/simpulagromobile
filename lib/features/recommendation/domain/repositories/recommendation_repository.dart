import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../entities/recommendation_request.dart';

/// Recommendation repository interface
abstract class RecommendationRepository {
  /// Get all recommendations
  Future<Either<Failure, List<Recommendation>>> getRecommendations();

  /// Get recommendations by site
  Future<Either<Failure, List<Recommendation>>> getRecommendationsBySite(
    String siteId,
  );

  /// Get recommendations by plant
  Future<Either<Failure, List<Recommendation>>> getRecommendationsByPlant(
    String siteId,
    String plantId,
  );

  /// Get recommendations by type
  Future<Either<Failure, List<Recommendation>>> getRecommendationsByType(
    RecommendationType type,
  );

  /// Get recommendation by ID
  Future<Either<Failure, Recommendation>> getRecommendationById(
    String recommendationId,
  );

  /// Apply recommendation
  Future<Either<Failure, Recommendation>> applyRecommendation(
    String recommendationId,
  );

  /// Dismiss recommendation
  Future<Either<Failure, Recommendation>> dismissRecommendation(
    String recommendationId,
  );

  /// Generate new recommendations based on current data
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

  Future<Either<Failure, RecommendationPreviewResult>> previewLabRecommendation(
    String siteId,
    RecommendationLabInput input,
  );

  Future<Either<Failure, RecommendationPreviewResult>> saveLabRecommendation(
    String siteId,
    RecommendationLabInput input,
  );
}
