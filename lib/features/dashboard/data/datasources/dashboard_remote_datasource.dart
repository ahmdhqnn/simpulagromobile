import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../models/environmental_health_model.dart';
import '../models/dashboard_summary_model.dart';

/// Constants for dashboard field names
class _DashboardFields {
  static const String dataKey = 'data';
  static const String devStsField = 'dev_sts';
  static const String plantStsField = 'plant_sts';
  static const String plantHarvestField = 'plant_harvest';
}

class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource(this._dio);

  // ─── Environmental Health ─────────────────────────────
  /// GET /api/sites/:siteId/agro/environmental-health
  ///
  /// Response structure (nested):
  /// { "message": "Success", "data": { "status": 200, "data": { "overall_health": ..., "sensors": [...] } } }
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<EnvironmentalHealth> getEnvironmentalHealth(String siteId) async {
    try {
      final response = await _dio.get(
        '/sites/$siteId/agro/environmental-health',
      );

      // Handle nested response: response.data.data.data
      final outer = response.data;
      if (outer == null) return EnvironmentalHealth.empty();

      dynamic inner = outer[_DashboardFields.dataKey];
      if (inner == null) return EnvironmentalHealth.empty();

      // Agro endpoint wraps data twice: { data: { status, data: { ... } } }
      if (inner is Map && inner.containsKey(_DashboardFields.dataKey)) {
        inner = inner[_DashboardFields.dataKey];
      }

      if (inner == null || inner is! Map<String, dynamic>) {
        return EnvironmentalHealth.empty();
      }

      try {
        return EnvironmentalHealth.fromJson(inner);
      } catch (e) {
        debugPrint('⚠️ Failed to parse environmental health: $e');
        return EnvironmentalHealth.empty();
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
  /// GET /api/sites/:siteId/devices
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardDeviceSummary> getDeviceSummary(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/devices');
      final data = response.data[_DashboardFields.dataKey] as List? ?? [];

      final total = data.length;
      final active = data.where((d) {
        if (d is! Map) return false;
        final sts = d[_DashboardFields.devStsField];
        return sts == 1 || sts == '1';
      }).length;

      return DashboardDeviceSummary(total: total, active: active);
    } on DioException catch (e) {
      debugPrint('❌ Device summary error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getDeviceSummary: $e');
      rethrow;
    }
  }

  // ─── Sensors ──────────────────────────────────────────
  /// GET /api/sites/:siteId/sensors
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardSensorSummary> getSensorSummary(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/sensors');
      final data = response.data[_DashboardFields.dataKey] as List? ?? [];

      final total = data.length;
      // Sensor tidak memiliki field sens_sts di response — hitung semua sebagai aktif
      return DashboardSensorSummary(total: total, active: total);
    } on DioException catch (e) {
      debugPrint('❌ Sensor summary error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getSensorSummary: $e');
      rethrow;
    }
  }

  // ─── Plants ───────────────────────────────────────────
  /// GET /api/sites/:siteId/plants
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardPlantSummary> getPlantSummary(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/plants');
      final data = response.data[_DashboardFields.dataKey] as List? ?? [];

      final total = data.length;
      final active = data.where((p) {
        if (p is! Map) return false;
        final harvest = p['plant_harvest'];
        if (harvest != null) return false; // Sudah panen berarti tidak aktif

        dynamic sts = p['plant_sts'] ?? p['status'];
        if (sts == 1 || sts == '1' || sts == true) return true;
        
        if (sts is String) {
          final s = sts.toLowerCase();
          if (s == 'active' || s == 'semai' || s == 'aktif') return true;
          if (s == 'inactive' || s == 'tidak aktif') return false;
        }
        
        // Default to active if harvest is null and status is unclear/missing
        return true;
      }).length;

      return DashboardPlantSummary(total: total, active: active);
    } on DioException catch (e) {
      debugPrint('❌ Plant summary error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getPlantSummary: $e');
      rethrow;
    }
  }

  // ─── Latest Sensor Reads ──────────────────────────────
  /// GET /api/sites/:siteId/reads/updates
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<Map<String, dynamic>>> getLatestSensorReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/updates');
      final data = response.data[_DashboardFields.dataKey] as List? ?? [];

      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      debugPrint('❌ Latest sensor reads error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getLatestSensorReads: $e');
      rethrow;
    }
  }

  // ─── Seven Day Reads ──────────────────────────────────
  /// GET /api/sites/:siteId/reads/seven-day
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<Map<String, dynamic>>> getSevenDayReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/seven-day');
      final data = response.data[_DashboardFields.dataKey] as List? ?? [];

      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      debugPrint('❌ Seven day reads error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getSevenDayReads: $e');
      rethrow;
    }
  }

  // ─── Today Reads ──────────────────────────────────────
  /// GET /api/sites/:siteId/reads/today
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<Map<String, dynamic>>> getTodayReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/today');
      final data = response.data[_DashboardFields.dataKey] as List? ?? [];

      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      debugPrint('❌ Today reads error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in getTodayReads: $e');
      rethrow;
    }
  }
}
