import 'package:dio/dio.dart';

class RecommendationRemoteDataSource {
  final Dio _dio;

  RecommendationRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/recommendations/
  Future<Map<String, dynamic>> getRecommendations(String siteId) async {
    final response = await _dio.get('/sites/$siteId/recommendations/');
    return response.data;
  }

  /// GET /api/sites/:siteId/recommendations/history
  Future<List<Map<String, dynamic>>> getHistory(String siteId) async {
    final response =
        await _dio.get('/sites/$siteId/recommendations/history');
    final data = response.data['data'] as List? ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  /// GET /api/sites/:siteId/recommendations/plant-by-site
  Future<Map<String, dynamic>> getPlantRecommendation(String siteId) async {
    final response =
        await _dio.get('/sites/$siteId/recommendations/plant-by-site');
    return response.data;
  }
}
