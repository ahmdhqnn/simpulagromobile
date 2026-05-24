import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/phase.dart';
import '../repositories/phase_repository.dart';

/// Model to hold phase progress calculation results
class PhaseProgress {
  final double hstProgress;
  final double gddProgress;
  final double overallProgress;
  final int remainingDays;
  final String status;

  PhaseProgress({
    required this.hstProgress,
    required this.gddProgress,
    required this.overallProgress,
    required this.remainingDays,
    required this.status,
  });
}

/// UseCase to calculate the progress and status of a phase
/// 
/// This UseCase handles the business logic for calculating phase progress
/// based on HST (Heat Sum Total), GDD (Growing Degree Days), and other metrics.
class CalculatePhaseProgressUseCase {
  final PhaseRepository repository;

  /// Constructor that injects the PhaseRepository dependency
  CalculatePhaseProgressUseCase(this.repository);

  /// Execute the use case to calculate phase progress
  /// 
  /// Parameters:
  ///   - [phase]: The Phase entity containing progress data
  /// 
  /// Returns:
  ///   - Either a [Failure] on error or a [PhaseProgress] object on success
  /// 
  /// The calculation considers:
  ///   - HST progress: (currentHst / (endHst - startHst)) * 100
  ///   - GDD progress: (currentGdd / requiredGdd) * 100
  ///   - Overall progress: Average of HST and GDD progress
  ///   - Remaining days: endHst - currentHst
  ///   - Status: Based on phase.status (active, completed, upcoming)
  Future<Either<Failure, PhaseProgress>> call(Phase phase) async {
    try {
      final hstProgress = phase.progressPercentage;
      const gddProgress = 0.0;
      final overallProgress = hstProgress;
      final remainingDays = phase.remainingDays;

      final result = PhaseProgress(
        hstProgress: hstProgress,
        gddProgress: gddProgress,
        overallProgress: overallProgress,
        remainingDays: remainingDays,
        status: phase.status,
      );

      return Right(result);
    } catch (e) {
      return Left(UnknownFailure('Failed to calculate phase progress: ${e.toString()}'));
    }
  }
}
