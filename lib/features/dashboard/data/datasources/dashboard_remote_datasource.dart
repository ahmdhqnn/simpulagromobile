import 'package:dio/dio.dart';
import '../models/environmental_health_model.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource(this._dio);

  // ─── Environmental Health ─────────────────────────────
  /// GET /api/sites/:siteId/agro/environmental-health
  ///
  /// Response structure (nested):
  /// { "message": "Success", "data": { "status": 200, "data": { "overall_health": ..., "sensors": [...] } } }
  Future<EnvironmentalHealth> getEnvironmentalHealth(String siteId) async {
    try {
      final response = await _dio.get(
        '/sites/$siteId/agro/environmental-health',
      );

      // Handle nested response: response.data.data.data
      final outer = response.data;
      if (outer == null) return EnvironmentalHealth.empty();

      dynamic inner = outer['data'];
      if (inner == null) return EnvironmentalHealth.empty();

      // Agro endpoint wraps data twice: { data: { status, data: { ... } } }
      if (inner is Map && inner.containsKey('data')) {
        inner = inner['data'];
      }

      if (inner == null || inner is! Map<String, dynamic>) {
        return EnvironmentalHealth.empty();
      }

      return EnvironmentalHealth.fromJson(inner);
    } catch (_) {
      return EnvironmentalHealth.empty();
    }
  }

  // ─── Devices ──────────────────────────────────────────
  /// GET /api/sites/:siteId/devices
  Future<DashboardDeviceSummary> getDeviceSummary(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/devices');
      final data = response.data['data'] as List? ?? [];
      final total = data.length;
      final active = data.where((d) {
        final sts = d['dev_sts'];
        return sts == 1 || sts == '1';
      }).length;
      return DashboardDeviceSummary(total: total, active: active);
    } catch (_) {
      return const DashboardDeviceSummary(total: 0, active: 0);
    }
  }

  // ─── Sensors ──────────────────────────────────────────
  /// GET /api/sites/:siteId/sensors
  Future<DashboardSensorSummary> getSensorSummary(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/sensors');
      final data = response.data['data'] as List? ?? [];
      final total = data.length;
      // Sensor tidak memiliki field sens_sts di response — hitung semua sebagai aktif
      return DashboardSensorSummary(total: total, active: total);
    } catch (_) {
      return const DashboardSensorSummary(total: 0, active: 0);
    }
  }

  // ─── Plants ───────────────────────────────────────────
  /// GET /api/sites/:siteId/plants
  Future<DashboardPlantSummary> getPlantSummary(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/plants');
      final data = response.data['data'] as List? ?? [];
      final total = data.length;
      // Active = plant_sts == 1 dan belum panen (plant_harvest == null)
      final active = data.where((p) {
        final sts = p['plant_sts'];
        final harvest = p['plant_harvest'];
        return (sts == 1 || sts == '1') && harvest == null;
      }).length;
      return DashboardPlantSummary(total: total, active: active);
    } catch (_) {
      return const DashboardPlantSummary(total: 0, active: 0);
    }
  }

  // ─── Latest Sensor Reads ──────────────────────────────
  /// GET /api/sites/:siteId/reads/updates
  Future<List<Map<String, dynamic>>> getLatestSensorReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/updates');
      final data = response.data['data'] as List? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ─── Seven Day Reads ──────────────────────────────────
  /// GET /api/sites/:siteId/reads/seven-day
  Future<List<Map<String, dynamic>>> getSevenDayReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/seven-day');
      final data = response.data['data'] as List? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ─── Today Reads ──────────────────────────────────────
  /// GET /api/sites/:siteId/reads/today
  Future<List<Map<String, dynamic>>> getTodayReads(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/reads/today');
      final data = response.data['data'] as List? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}
