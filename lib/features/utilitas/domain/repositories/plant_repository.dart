import '../entities/plant.dart';

abstract class PlantRepository {
  Future<List<Plant>> getPlantsBySite(String siteId);
  Future<Plant> getPlantById(String siteId, String plantId);
  Future<Plant> createPlant(String siteId, Plant plant);
  Future<Plant> updatePlant(String siteId, String plantId, Plant plant);
  Future<Plant> harvestPlant(String siteId, String plantId);
  Future<void> deletePlant(String siteId, String plantId);
}
