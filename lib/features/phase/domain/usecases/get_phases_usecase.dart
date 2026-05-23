import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/phase.dart';
import '../repositories/phase_repository.dart';

class GetPhasesByPlantUseCase {
  final PhaseRepository repository;
  GetPhasesByPlantUseCase(this.repository);

  Future<Either<Failure, List<Phase>>> call(String plantId) async {
    return await repository.getPhasesByPlant(plantId);
  }
}

class GetPhaseByIdUseCase {
  final PhaseRepository repository;
  GetPhaseByIdUseCase(this.repository);

  Future<Either<Failure, Phase>> call(String id) async {
    return await repository.getPhaseById(id);
  }
}
