import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/phase.dart';
import '../repositories/phase_repository.dart';

class GetPhaseHistoryUseCase {
  final PhaseRepository repository;
  GetPhaseHistoryUseCase(this.repository);

  Future<Either<Failure, List<Phase>>> call(String plantId) async {
    return await repository.getPhaseHistory(plantId);
  }
}
