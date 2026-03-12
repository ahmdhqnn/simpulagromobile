import 'package:dio/dio.dart';

class PlantRemoteDataSource {
  final Dio _dio;

  PlantRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/plants
  Future<List<Map<String, dynamic>>> getPlants(String siteId) async {
    final response = await _dio.get('/sites/$siteId/plants');
    final data = response.data['data'] as List? ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  /// GET /api/sites/:siteId/plants/:plantId
  Future<Map<String, dynamic>> getPlantById(
      String siteId, String plantId) async {
    final response = await _dio.get('/sites/$siteId/plants/$plantId');
    return response.data['data'] ?? {};
  }

  /// POST /api/sites/:siteId/plants
  Future<Map<String, dynamic>> createPlant(
      String siteId, Map<String, dynamic> data) async {
    final response = await _dio.post('/sites/$siteId/plants', data: data);
    return response.data['data'] ?? {};
  }

  /// POST /api/sites/:siteId/plants/:plantId/harvest
  Future<Map<String, dynamic>> harvestPlant(
      String siteId, String plantId) async {
    final response =
        await _dio.post('/sites/$siteId/plants/$plantId/harvest');
    return response.data['data'] ?? {};
  }
}
