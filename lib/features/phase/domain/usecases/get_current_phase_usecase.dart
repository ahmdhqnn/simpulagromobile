import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/phase.dart';
import '../repositories/phase_repository.dart';

class GetCurrentPhaseUseCase {
  final PhaseRepository repository;
  GetCurrentPhaseUseCase(this.repository);

  Future<Either<Failure, Phase?>> call(String plantId) async {
    return await repository.getCurrentPhase(plantId);
  }
}
