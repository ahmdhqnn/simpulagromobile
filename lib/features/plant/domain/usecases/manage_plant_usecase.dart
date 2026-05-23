import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';
import '../repositories/plant_repository.dart';

class CreatePlantUseCase {
  final PlantRepository repository;
  CreatePlantUseCase(this.repository);

  Future<Either<Failure, Plant>> call(String siteId, Map<String, dynamic> data) async {
    return await repository.createPlant(siteId, data);
  }
}

class UpdatePlantUseCase {
  final PlantRepository repository;
  UpdatePlantUseCase(this.repository);

  Future<Either<Failure, Plant>> call(String siteId, String plantId, Map<String, dynamic> data) async {
    return await repository.updatePlant(siteId, plantId, data);
  }
}

class HarvestPlantUseCase {
  final PlantRepository repository;
  HarvestPlantUseCase(this.repository);

  Future<Either<Failure, void>> call(String siteId, String plantId) async {
    return await repository.harvestPlant(siteId, plantId);
  }
}
