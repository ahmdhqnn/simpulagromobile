import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/plant.dart';
import '../../data/models/plant_model.dart';

abstract class PlantRepository {
  Future<Either<Failure, List<Plant>>> getPlants(String siteId);
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId);
  Future<Either<Failure, Plant>> createPlant(String siteId, Map<String, dynamic> data);
  Future<Either<Failure, Plant>> updatePlant(String siteId, String plantId, Map<String, dynamic> data);
  Future<Either<Failure, Plant>> harvestPlant(String siteId, String plantId);
  Future<Either<Failure, List<VarietasModel>>> getVarietas();
  Future<Either<Failure, VarietasModel>> getVarietasById(String varietasId);
}
