import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendation_repository.dart';

/// Get recommendations for a specific site
///
/// This use case handles retrieving recommendations from the backend for a given site.
/// It manages the business logic for fetching recommendations and handling any errors
/// that may occur during the API call.
///
/// Usage:
/// ```dart
/// final usecase = GetRecommendationsUseCase(repository);
/// final result = await usecase(siteId: '123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (recommendations) => print('Got ${recommendations.length} recommendations'),
/// );
/// ```
class GetRecommendationsUseCase {
  final RecommendationRepository repository;

  GetRecommendationsUseCase(this.repository);

  /// Get recommendations for a site
  ///
  /// Returns a list of recommendations or a Failure if the operation fails.
  /// The result is wrapped in an Either type from dartz package for functional
  /// error handling.
  ///
  /// Parameters:
  ///   - siteId: The ID of the site to fetch recommendations for
  ///
  /// Returns:
  ///   Either<Failure, List<Recommendation>> - Success with list or Failure
  Future<Either<Failure, List<Recommendation>>> call({
    required String siteId,
  }) {
    return repository.getRecommendationsBySite(siteId);
  }
}
