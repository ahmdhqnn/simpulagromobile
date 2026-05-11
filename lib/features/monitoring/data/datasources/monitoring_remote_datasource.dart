import 'package:dio/dio.dart';
import '../models/monitoring_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RESPONSE PARSING HELPERS
//
// Backend API memiliki dua pola response:
//   Single-nested : { "data": [ ... ] }
//   Double-nested : { "data": { "status": 200, "data": [ ... ] } }
//
// Helper di bawah menangani keduanya secara transparan.
// ─────────────────────────────────────────────────────────────────────────────

/// Ekstrak List dari response (single-nested atau double-nested).
List<dynamic> _extractList(dynamic responseData) {
  if (responseData == null) return [];
  final first = responseData['data'];
  if (first == null) return [];
  if (first is Map && first.containsKey('data')) {
    final second = first['data'];
    if (second is List) return second;
    if (second is Map) return [second];
    return [];
  }
  if (first is List) return first;
  if (first is Map) return [first];
  return [];
}

/// Ekstrak Map dari response (single-nested atau double-nested).
Map<String, dynamic>? _extractMap(dynamic responseData) {
  if (responseData == null) return null;
  final first = responseData['data'];
  if (first == null) return null;
  if (first is Map && first.containsKey('data') && first['data'] is Map) {
    return Map<String, dynamic>.from(first['data'] as Map);
  }
  if (first is Map) return Map<String, dynamic>.from(first);
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// DATASOURCE
// ─────────────────────────────────────────────────────────────────────────────

class MonitoringRemoteDataSource {
  final Dio _dio;

  const MonitoringRemoteDataSource(this._dio);

  // ── Realtime ────────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads/updates
  /// Nilai sensor terkini per ds_id.
  Future<List<SensorReadUpdate>> getLatestReads(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/reads/updates');
      return _extractList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(SensorReadUpdate.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── History ─────────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads/today
  Future<List<SensorReadModel>> getTodayReads(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/reads/today');
      return _extractList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(SensorReadModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/reads/seven-day
  Future<List<SensorReadModel>> getSevenDayReads(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/reads/seven-day');
      return _extractList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(SensorReadModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/reads/date-range?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD
  Future<List<SensorReadModel>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  }) async {
    try {
      final res = await _dio.get(
        '/sites/$siteId/reads/date-range',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );
      return _extractList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(SensorReadModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/reads/planting-date
  Future<List<SensorReadModel>> getPlantingDateReads(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/reads/planting-date');
      return _extractList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(SensorReadModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/reads/daily
  /// Agregasi harian (avg/min/max) per ds_id.
  Future<List<SensorDailyModel>> getDailyReads(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/reads/daily');
      return _extractList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(SensorDailyModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Devices & Sensors ───────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/devices
  /// Device beserta nested sensor list (key 'sensor' atau 'sensors').
  Future<List<DeviceModel>> getDevices(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/devices');
      return _extractList(
        res.data,
      ).whereType<Map<String, dynamic>>().map(DeviceModel.fromJson).toList();
    } catch (_) {
      return [];
    }
  }

  /// GET /api/sites/:siteId/sensors
  /// Jumlah total sensor yang terdaftar di site.
  Future<int> getSensorCount(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/sensors');
      return _extractList(res.data).length;
    } catch (_) {
      return 0;
    }
  }

  // ── Logs ────────────────────────────────────────────────────────────────────

  /// GET /api/sites/logs
  /// Log payload MQTT terbaru.
  Future<List<LogModel>> getLogs() async {
    try {
      final res = await _dio.get('/sites/logs');
      return _extractList(
        res.data,
      ).whereType<Map<String, dynamic>>().map(LogModel.fromJson).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Analytics ───────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/agro/environmental-health
  ///
  /// Response double-nested:
  /// { "data": { "status": 200, "data": { "overall_health": ..., "sensors": [...] } } }
  Future<Map<String, dynamic>> getEnvironmentalHealth(String siteId) async {
    try {
      final res = await _dio.get('/sites/$siteId/agro/environmental-health');
      return _extractMap(res.data) ?? {};
    } catch (_) {
      return {};
    }
  }

  /// GET /api/sites/:siteId/recommendations/plant-by-site
  Future<Map<String, dynamic>> getPlantRecommendation(String siteId) async {
    try {
      final res = await _dio.get(
        '/sites/$siteId/recommendations/plant-by-site',
      );
      return res.data as Map<String, dynamic>? ?? {};
    } catch (_) {
      return {};
    }
  }
}
