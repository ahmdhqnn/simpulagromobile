import 'package:dio/dio.dart';
import '../models/environmental_health_model.dart';

class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/agro/environmental-health
  Future<EnvironmentalHealth> getEnvironmentalHealth(String siteId) async {
    final response =
        await _dio.get('/sites/$siteId/agro/environmental-health');
    return EnvironmentalHealth.fromJson(response.data['data'] ?? {});
  }

  /// GET /api/sites/:siteId/reads/updates
  Future<List<Map<String, dynamic>>> getLatestSensorReads(
      String siteId) async {
    final response = await _dio.get('/sites/$siteId/reads/updates');
    final data = response.data['data'] as List? ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  /// GET /api/sites/:siteId/reads/today
  Future<List<Map<String, dynamic>>> getTodayReads(String siteId) async {
    final response = await _dio.get('/sites/$siteId/reads/today');
    final data = response.data['data'] as List? ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  /// GET /api/sites/:siteId/reads/seven-day
  Future<List<Map<String, dynamic>>> getSevenDayReads(String siteId) async {
    final response = await _dio.get('/sites/$siteId/reads/seven-day');
    final data = response.data['data'] as List? ?? [];
    return data.cast<Map<String, dynamic>>();
  }
}
