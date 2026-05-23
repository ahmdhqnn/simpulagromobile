import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../models/environmental_health_model.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource(this._dio);

  // ─── Environmental Health ─────────────────────────────
  /// GET /sites/{siteId}/agro/environmental-health
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<EnvironmentalHealthModel> getEnvironmentalHealth(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.envHealth(siteId));

      final outer = response.data;
      if (outer == null) return EnvironmentalHealthModel.empty();

      dynamic inner = outer['data'];
      if (inner == null) return EnvironmentalHealthModel.empty();

      // Agro endpoint kadang double-wrap: { data: { status, data: { ... } } }
      if (inner is Map && inner.containsKey('data')) {
        inner = inner['data'];
      }

      if (inner == null || inner is! Map<String, dynamic>) {
        return EnvironmentalHealthModel.empty();
      }

      try {
        return EnvironmentalHealthModel.fromJson(inner);
      } catch (e) {
        debugPrint('⚠️ Failed to parse environmental health: $e');
        return EnvironmentalHealthModel.empty();
      }
    } on DioException catch (e) {
      debugPrint('❌ Environmental health error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getEnvironmentalHealth: $e');
      rethrow;
    }
  }

  // ─── Devices ──────────────────────────────────────────
  /// GET /sites/{siteId}/devices
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardDeviceSummaryModel> getDeviceSummary(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.devices(siteId));
      final data = response.data['data'] as List? ?? [];

      final total = data.length;
      final active = data.where((d) {
        if (d is! Map) return false;
        final sts = d['dev_sts'];
        return sts == 1 || sts == '1';
      }).length;

      return DashboardDeviceSummaryModel(total: total, active: active);
    } on DioException catch (e) {
      debugPrint('❌ Device summary error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getDeviceSummary: $e');
      rethrow;
    }
  }

  // ─── Sensors ──────────────────────────────────────────
  /// GET /sites/{siteId}/sensors
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardSensorSummaryModel> getSensorSummary(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.sensors(siteId));
      final data = response.data['data'] as List? ?? [];

      final total = data.length;
      // Sensor tidak memiliki field status di response — semua dihitung aktif
      return DashboardSensorSummaryModel(total: total, active: total);
    } on DioException catch (e) {
      debugPrint('❌ Sensor summary error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getSensorSummary: $e');
      rethrow;
    }
  }

  // ─── Plants ───────────────────────────────────────────
  /// GET /sites/{siteId}/plants
  /// plant_sts = 1 → aktif, plant_sts = 0 → harvest
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardPlantSummaryModel> getPlantSummary(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.plants(siteId));
      final data = response.data['data'] as List? ?? [];

      final total = data.length;
      final active = data.where((p) {
        if (p is! Map) return false;
        // plant_sts = 1 → aktif, plant_sts = 0 → harvest
        final sts = p['plant_sts'];
        if (sts == 0 || sts == '0') return false;
        if (sts == 1 || sts == '1' || sts == true) return true;
        if (sts is String) {
          final s = sts.toLowerCase();
          if (s == 'active' || s == 'semai' || s == 'aktif') return true;
          if (s == 'inactive' || s == 'tidak aktif') return false;
        }
        // Default aktif jika status tidak jelas
        return true;
      }).length;

      return DashboardPlantSummaryModel(total: total, active: active);
    } on DioException catch (e) {
      debugPrint('❌ Plant summary error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getPlantSummary: $e');
      rethrow;
    }
  }

  // ─── Latest Sensor Reads ──────────────────────────────
  /// GET /sites/{siteId}/reads/updates
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<SensorReadModel>> getLatestSensorReads(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.readsUpdates(siteId));
      final data = response.data['data'] as List? ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => SensorReadModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ Latest sensor reads error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getLatestSensorReads: $e');
      rethrow;
    }
  }

  // ─── Daily Reads ──────────────────────────────────────
  /// GET /sites/{siteId}/reads/daily
  /// Menggantikan endpoint /reads/seven-day yang tidak ada di Swagger
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<SensorReadModel>> getDailyReads(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.readsDaily(siteId));
      final data = response.data['data'] as List? ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => SensorReadModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ Daily reads error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getDailyReads: $e');
      rethrow;
    }
  }

  // ─── Today Reads ──────────────────────────────────────
  /// GET /sites/{siteId}/reads/today
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<SensorReadModel>> getTodayReads(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.readsToday(siteId));
      final data = response.data['data'] as List? ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => SensorReadModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ Today reads error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getTodayReads: $e');
      rethrow;
    }
  }
}
