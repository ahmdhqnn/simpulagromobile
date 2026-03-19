import 'package:dio/dio.dart';
import '../models/plant_model.dart';

class PlantRemoteDataSource {
  final Dio _dio;

  PlantRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/plants
  Future<List<PlantModel>> getPlants(String siteId) async {
    final response = await _dio.get('/sites/$siteId/plants');
    final data = response.data['data'] as List? ?? [];
    return data.map((json) => PlantModel.fromJson(json)).toList();
  }

  /// GET /api/sites/:siteId/plants/:plantId
  Future<PlantModel> getPlantById(String siteId, String plantId) async {
    final response = await _dio.get('/sites/$siteId/plants/$plantId');
    return PlantModel.fromJson(response.data['data'] ?? {});
  }

  /// POST /api/sites/:siteId/plants
  Future<PlantModel> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post('/sites/$siteId/plants', data: data);
    return PlantModel.fromJson(response.data['data'] ?? {});
  }

  /// PUT /api/sites/:siteId/plants/:plantId
  Future<PlantModel> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(
      '/sites/$siteId/plants/$plantId',
      data: data,
    );
    return PlantModel.fromJson(response.data['data'] ?? {});
  }

  /// POST /api/sites/:siteId/plants/:plantId/harvest
  Future<PlantModel> harvestPlant(String siteId, String plantId) async {
    final response = await _dio.post('/sites/$siteId/plants/$plantId/harvest');
    return PlantModel.fromJson(response.data['data'] ?? {});
  }

  /// GET /api/varietas
  /// Get all varietas (plant varieties) for dropdown
  Future<List<VarietasModel>> getVarietas() async {
    final response = await _dio.get('/varietas');
    final data = response.data['data'] as List? ?? [];
    return data.map((json) => VarietasModel.fromJson(json)).toList();
  }

  /// GET /api/varietas/:varietasId
  Future<VarietasModel> getVarietasById(String varietasId) async {
    final response = await _dio.get('/varietas/$varietasId');
    return VarietasModel.fromJson(response.data['data'] ?? {});
  }
}
