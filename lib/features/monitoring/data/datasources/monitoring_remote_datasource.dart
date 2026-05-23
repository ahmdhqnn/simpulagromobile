import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/monitoring_models.dart';

class MonitoringRemoteDataSource {
  final Dio _dio;

  const MonitoringRemoteDataSource(this._dio);

  // ── Realtime ────────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads/updates
  /// Nilai sensor terkini per ds_id.
  Future<List<SensorReadUpdate>> getLatestReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsUpdates(siteId));
    return ResponseParser.extractDataList(res.data)
        .whereType<Map<String, dynamic>>()
        .map(SensorReadUpdate.fromJson)
        .toList();
  }

  // ── History ─────────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads/today
  Future<List<SensorReadModel>> getTodayReads(String siteId) async {
    throw const UnsupportedBackendEndpointException();
  }

  /// GET /api/sites/:siteId/reads/seven-day
  Future<List<SensorReadModel>> getSevenDayReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsSevenDay(siteId));
    return ResponseParser.extractDataList(res.data)
        .whereType<Map<String, dynamic>>()
        .map(SensorReadModel.fromJson)
        .toList();
  }

  /// GET /api/sites/:siteId/reads/date-range?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD
  Future<List<SensorReadModel>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  }) async {
    throw const UnsupportedBackendEndpointException();
  }

  /// GET /api/sites/:siteId/reads/planting-date
  Future<List<SensorReadModel>> getPlantingDateReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsPlantingDate(siteId));
    return ResponseParser.extractDataList(res.data)
        .whereType<Map<String, dynamic>>()
        .map(SensorReadModel.fromJson)
        .toList();
  }

  /// GET /api/sites/:siteId/reads/daily
  /// Agregasi harian (avg/min/max) per ds_id.
  Future<List<SensorDailyModel>> getDailyReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsDaily(siteId));
    return ResponseParser.extractDataList(res.data)
        .whereType<Map<String, dynamic>>()
        .map(SensorDailyModel.fromJson)
        .toList();
  }

  // ── Devices & Sensors ───────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/devices
  /// Device beserta nested sensor list (key 'sensor' atau 'sensors').
  Future<List<DeviceModel>> getDevices(String siteId) async {
    final res = await _dio.get(ApiEndpoints.devices(siteId));
    return ResponseParser.extractDataList(res.data)
        .whereType<Map<String, dynamic>>()
        .map(DeviceModel.fromJson)
        .toList();
  }

  /// GET /api/sites/:siteId/sensors
  /// Jumlah total sensor yang terdaftar di site.
  Future<int> getSensorCount(String siteId) async {
    final res = await _dio.get(ApiEndpoints.sensors(siteId));
    return ResponseParser.extractDataList(res.data).length;
  }

  // ── Logs ────────────────────────────────────────────────────────────────────

  /// GET /api/sites/logs
  /// Log payload MQTT terbaru.
  Future<List<LogModel>> getLogs() async {
    throw const UnsupportedBackendEndpointException();
  }

  // ── Analytics ───────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/agro/environmental-health
  Future<Map<String, dynamic>> getEnvironmentalHealth(String siteId) async {
    final res = await _dio.get(ApiEndpoints.envHealth(siteId));
    return ResponseParser.extractDataMap(res.data);
  }

  /// GET /api/sites/:siteId/recommendations/plant-by-site
  Future<Map<String, dynamic>> getPlantRecommendation(String siteId) async {
    final res = await _dio.get(ApiEndpoints.plantRecBySite(siteId));
    return res.data as Map<String, dynamic>? ?? {};
  }

  // ── Alarms ──────────────────────────────────────────────────────────────────

  /// GET /api/sites/alarms/data
  /// Alarm lengkap beserta kode alarm (join).
  Future<List<AlarmDataModel>> getAlarmData() async {
    throw const UnsupportedBackendEndpointException();
  }

  // ── Monthly Rekap ────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads/mounth
  /// Rekap bulanan sensor (avg/min/max) per ds_id.
  Future<List<MonthlyRekapModel>> getMonthlyReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsMonthly(siteId));
    return ResponseParser.extractDataList(res.data)
        .whereType<Map<String, dynamic>>()
        .map(MonthlyRekapModel.fromJson)
        .toList();
  }
}
