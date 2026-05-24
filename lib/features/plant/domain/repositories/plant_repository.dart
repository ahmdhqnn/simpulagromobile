import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/plant.dart';

abstract class PlantRepository {
  Future<Either<Failure, List<Plant>>> getPlants(
    String siteId, {
    bool? isOnGoingPlant,
  });
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId);
  Future<Either<Failure, Plant>> createPlant(
    String siteId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, Plant>> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, Plant>> harvestPlant(String siteId, String plantId);
  Future<Either<Failure, void>> deletePlant(String siteId, String plantId);
}
