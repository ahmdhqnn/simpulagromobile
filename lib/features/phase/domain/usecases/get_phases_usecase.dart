import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/phase.dart';
import '../repositories/phase_repository.dart';

/// UseCase to retrieve all phases for a plant
/// 
/// This UseCase handles the business logic for fetching phases by plant ID.
/// It includes caching logic to reduce unnecessary API calls.
class GetPhasesUseCase {
  final PhaseRepository repository;

  /// Constructor that injects the PhaseRepository dependency
  GetPhasesUseCase(this.repository);

  /// Execute the use case to get all phases for a plant
  /// 
  /// Parameters:
  ///   - [plantId]: The ID of the plant to fetch phases for
  /// 
  /// Returns:
  ///   - Either a [Failure] on error or a List of [Phase] on success
  Future<Either<Failure, List<Phase>>> call(String plantId) async {
    return repository.getPhasesByPlant(plantId);
  }
}
