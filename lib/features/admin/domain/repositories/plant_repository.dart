import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';

abstract class PlantRepository {
  Future<Either<Failure, List<Plant>>> getPlantsBySite(String siteId);
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId);
  Future<Either<Failure, Plant>> createPlant(String siteId, Plant plant);
  Future<Either<Failure, Plant>> updatePlant(
    String siteId,
    String plantId,
    Plant plant,
  );
  Future<Either<Failure, Plant>> harvestPlant(String siteId, String plantId);
  Future<Either<Failure, void>> deletePlant(String siteId, String plantId);
}
