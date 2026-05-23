import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/phase.dart';
import '../repositories/phase_repository.dart';

/// UseCase to retrieve the current active phase for a plant
/// 
/// This UseCase handles the business logic for fetching the currently active
/// growth phase of a plant based on HST (Heat Sum Total) and other factors.
class GetCurrentPhaseUseCase {
  final PhaseRepository repository;

  /// Constructor that injects the PhaseRepository dependency
  GetCurrentPhaseUseCase(this.repository);

  /// Execute the use case to get the current active phase
  /// 
  /// Parameters:
  ///   - [plantId]: The ID of the plant to fetch the current phase for
  /// 
  /// Returns:
  ///   - Either a [Failure] on error or an optional [Phase] on success
  ///   - Returns null if no active phase is found
  Future<Either<Failure, Phase?>> call(String plantId) async {
    return repository.getCurrentPhase(plantId);
  }
}
