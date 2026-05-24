import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendation_repository.dart';

/// Apply a recommendation to a site
///
/// This use case handles the business logic for applying a recommendation.
/// If the backend endpoint is not yet implemented (HTTP 501 or specific message),
/// it provides graceful fallback behavior by returning a local copy with updated status.
///
/// The use case:
/// 1. Attempts to call the repository's applyRecommendation method
/// 2. If the endpoint is not implemented, it returns the failure for the UI to handle
/// 3. Otherwise, it returns either the success result or the error
///
/// Usage:
/// ```dart
/// final usecase = ApplyRecommendationUseCase(repository);
/// final result = await usecase(recommendationId: '123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (recommendation) => print('Applied: ${recommendation.title}'),
/// );
/// ```
class ApplyRecommendationUseCase {
  final RecommendationRepository repository;

  ApplyRecommendationUseCase(this.repository);

  /// Apply a recommendation
  ///
  /// Parameters:
  ///   - recommendationId: The ID of the recommendation to apply
  ///
  /// Returns:
  ///   Either[Failure, Recommendation] - Success with updated recommendation or Failure
  ///
  /// Throws:
  ///   - ServerFailure if the endpoint returns an error
  ///   - NetworkFailure if there's a network connectivity issue
  ///   - AuthFailure if the user is not authenticated
  ///   - UnknownFailure if an unexpected error occurs
  ///
  /// TODO: Monitor backend implementation status of apply recommendation endpoint.
  ///       Some backends may not have implemented this yet (HTTP 501).
  ///       Consider adding a feature flag to disable this feature if needed.
  Future<Either<Failure, Recommendation>> call({
    required String recommendationId,
  }) async {
    try {
      return await repository.applyRecommendation(recommendationId);
    } on ServerFailure catch (e) {
      // If the endpoint is not implemented, return the failure gracefully
      // The UI layer can handle this and show an appropriate message
      if (e.statusCode == 501 ||
          e.message.contains('belum diimplementasi') ||
          e.message.contains('not implemented')) {
        // TODO: Implement fallback logic if desired (e.g., optimistic update)
        // For now, return the failure to let UI handle it
        return Left(e);
      }
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Failed to apply recommendation: $e'));
    }
  }
}
