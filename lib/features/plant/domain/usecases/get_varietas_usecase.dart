import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/varietas.dart';
import '../repositories/plant_repository.dart';

class GetVarietasUseCase {
  final PlantRepository repository;
  GetVarietasUseCase(this.repository);

  Future<Either<Failure, List<Varietas>>> call() async {
    return await repository.getVarietas();
  }
}

class GetVarietasByIdUseCase {
  final PlantRepository repository;
  GetVarietasByIdUseCase(this.repository);

  Future<Either<Failure, Varietas>> call(String varietasId) async {
    return await repository.getVarietasById(varietasId);
  }
}
