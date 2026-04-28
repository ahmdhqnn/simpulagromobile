import '../../domain/entities/plant.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_remote_datasource.dart';
import '../models/plant_model.dart';

/// Implementation of PlantRepository
/// Converts between domain entities and data models
class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDatasource remoteDatasource;

  PlantRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Plant>> getPlantsBySite(String siteId) async {
    try {
      final models = await remoteDatasource.getPlantsBySite(siteId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Plant> getPlantById(String siteId, String plantId) async {
    try {
      final model = await remoteDatasource.getPlantById(siteId, plantId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Plant> createPlant(String siteId, Plant plant) async {
    try {
      final model = PlantModel.fromEntity(plant);
      final data = model.toJson();

      // Remove null values and fields that shouldn't be sent on create
      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'plant_created' ||
            key == 'plant_update' ||
            key == 'plant_harvest',
      );

      final createdModel = await remoteDatasource.createPlant(siteId, data);
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Plant> updatePlant(String siteId, String plantId, Plant plant) async {
    try {
      final model = PlantModel.fromEntity(plant);
      final data = model.toJson();

      // Remove null values and fields that shouldn't be sent on update
      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'plant_id' ||
            key == 'plant_created' ||
            key == 'plant_update' ||
            key == 'plant_harvest',
      );

      final updatedModel = await remoteDatasource.updatePlant(
        siteId,
        plantId,
        data,
      );
      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Plant> harvestPlant(String siteId, String plantId) async {
    try {
      final harvestedModel = await remoteDatasource.harvestPlant(
        siteId,
        plantId,
      );
      return harvestedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePlant(String siteId, String plantId) async {
    try {
      await remoteDatasource.deletePlant(siteId, plantId);
    } catch (e) {
      rethrow;
    }
  }
}
