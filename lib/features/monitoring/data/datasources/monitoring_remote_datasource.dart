import 'package:dio/dio.dart';
import '../models/monitoring_models.dart';

class MonitoringRemoteDataSource {
  final Dio _dio;

  MonitoringRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/reads/updates — latest sensor values
  Future<List<SensorReadUpdate>> getLatestReads(String siteId) async {
    final response = await _dio.get('/sites/$siteId/reads/updates');
    final data = response.data['data'] as List? ?? [];
    return data
        .map((e) => SensorReadUpdate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/sites/:siteId/reads/today — today's readings
  Future<List<SensorReadModel>> getTodayReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/today');
      final responseData = response.data;

      // Handle jika data adalah Map (single object) atau List
      if (responseData['data'] is List) {
        final data = responseData['data'] as List? ?? [];
        return data
            .map((e) => SensorReadModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (responseData['data'] is Map) {
        // Jika backend mengembalikan object, wrap dalam list
        return [
          SensorReadModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          ),
        ];
      }

      return [];
    } catch (e) {
      // Jika error atau data kosong, return empty list
      return [];
    }
  }

  /// GET /api/sites/:siteId/reads/seven-day
  Future<List<SensorReadModel>> getSevenDayReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/seven-day');
      final responseData = response.data;

      // Handle jika data adalah Map atau List
      if (responseData['data'] is List) {
        final data = responseData['data'] as List? ?? [];
        return data
            .map((e) => SensorReadModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (responseData['data'] is Map) {
        return [
          SensorReadModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          ),
        ];
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/reads/date-range?startDate=&endDate=
  Future<List<SensorReadModel>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/sites/$siteId/reads/date-range',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );
      final responseData = response.data;

      if (responseData['data'] is List) {
        final data = responseData['data'] as List? ?? [];
        return data
            .map((e) => SensorReadModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (responseData['data'] is Map) {
        return [
          SensorReadModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          ),
        ];
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/reads/planting-date
  Future<List<SensorReadModel>> getPlantingDateReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/planting-date');
      final responseData = response.data;

      if (responseData['data'] is List) {
        final data = responseData['data'] as List? ?? [];
        return data
            .map((e) => SensorReadModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (responseData['data'] is Map) {
        return [
          SensorReadModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          ),
        ];
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/devices — devices with coordinates
  Future<List<DeviceModel>> getDevices(String siteId) async {
    final response = await _dio.get('/sites/$siteId/devices');
    final data = response.data['data'] as List? ?? [];
    return data
        .map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/sites/logs — MQTT logs
  Future<List<LogModel>> getLogs() async {
    final response = await _dio.get('/sites/logs');
    final data = response.data['data'] as List? ?? [];
    return data
        .map((e) => LogModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/sites/:siteId/recommendations/plant-by-site
  Future<Map<String, dynamic>> getPlantRecommendation(String siteId) async {
    try {
      final response = await _dio.get(
        '/sites/$siteId/recommendations/plant-by-site',
      );
      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      // Return empty map if endpoint returns 404 or any error
      return {};
    }
  }

  /// GET /api/sites/:siteId/agro/environmental-health
  Future<Map<String, dynamic>> getEnvironmentalHealth(String siteId) async {
    try {
      final response = await _dio.get(
        '/sites/$siteId/agro/environmental-health',
      );
      return response.data['data'] as Map<String, dynamic>? ?? {};
    } catch (e) {
      // Return empty map if error
      return {};
    }
  }

  /// GET /api/sites/:siteId/reads/daily — daily recap
  Future<List<SensorDailyModel>> getDailyReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/daily');
      final responseData = response.data;

      // Handle if data is Map or List
      if (responseData['data'] is List) {
        final data = responseData['data'] as List? ?? [];
        return data
            .map((e) => SensorDailyModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (responseData['data'] is Map) {
        // If backend returns single object, wrap in list
        return [
          SensorDailyModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          ),
        ];
      }

      return [];
    } catch (e) {
      // Return empty list if error
      return [];
    }
  }
}
