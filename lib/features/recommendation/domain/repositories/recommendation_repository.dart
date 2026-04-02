import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';

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
}
