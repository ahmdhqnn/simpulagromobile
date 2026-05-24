import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';
import '../repositories/plant_repository.dart';

/// UseCase for marking a plant as harvested.
class HarvestPlantUseCase {
  final PlantRepository repository;

  HarvestPlantUseCase(this.repository);

  Future<Either<Failure, Plant>> call(String siteId, String plantId) async {
    return repository.harvestPlant(siteId, plantId);
  }
}
