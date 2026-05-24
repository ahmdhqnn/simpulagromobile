import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';
import '../repositories/plant_repository.dart';

class GetPlantsUseCase {
  final PlantRepository repository;
  GetPlantsUseCase(this.repository);

  Future<Either<Failure, List<Plant>>> call(
    String siteId, {
    bool? isOnGoingPlant,
  }) async {
    return repository.getPlants(siteId, isOnGoingPlant: isOnGoingPlant);
  }
}

class GetPlantByIdUseCase {
  final PlantRepository repository;
  GetPlantByIdUseCase(this.repository);

  Future<Either<Failure, Plant>> call(String siteId, String plantId) async {
    return await repository.getPlantById(siteId, plantId);
  }
}
