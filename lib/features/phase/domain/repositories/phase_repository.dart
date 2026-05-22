import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/phase.dart';

/// Repository interface for phase operations
abstract class PhaseRepository {
  /// Get all phases for a plant
  Future<Either<Failure, List<Phase>>> getPhasesByPlant(String plantId);

  /// Get phase by ID
  Future<Either<Failure, Phase>> getPhaseById(String id);

  /// Get current active phase for a plant
  Future<Either<Failure, Phase?>> getCurrentPhase(String plantId);

  /// Get phase history for a plant
  Future<Either<Failure, List<Phase>>> getPhaseHistory(String plantId);
}
