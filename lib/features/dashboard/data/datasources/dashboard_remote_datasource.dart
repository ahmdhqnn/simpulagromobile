import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/response_parser.dart';
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
    final response = await _dio.get(ApiEndpoints.envHealth(siteId));
    final data = ResponseParser.extractDataMap(response.data);
    return EnvironmentalHealthModel.fromJson(data);
  }

  // ─── Devices ──────────────────────────────────────────
  /// GET /sites/{siteId}/devices
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardDeviceSummaryModel> getDeviceSummary(String siteId) async {
    final response = await _dio.get(ApiEndpoints.devices(siteId));
    final data = ResponseParser.extractDataList(response.data);

    final total = data.length;
    final active = data.where((d) {
      if (d is! Map) return false;
      final sts = d['dev_sts'];
      return sts == 1 || sts == '1';
    }).length;

    return DashboardDeviceSummaryModel(total: total, active: active);
  }

  // ─── Sensors ──────────────────────────────────────────
  /// GET /sites/{siteId}/sensors
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardSensorSummaryModel> getSensorSummary(String siteId) async {
    final response = await _dio.get(ApiEndpoints.sensors(siteId));
    final data = ResponseParser.extractDataList(response.data);

    final total = data.length;
    return DashboardSensorSummaryModel(total: total, active: total);
  }

  // ─── Plants ───────────────────────────────────────────
  /// GET /sites/{siteId}/plants
  /// plant_sts = 1 → aktif, plant_sts = 0 → harvest
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<DashboardPlantSummaryModel> getPlantSummary(String siteId) async {
    final response = await _dio.get(ApiEndpoints.plants(siteId));
    final data = ResponseParser.extractDataList(response.data);

    final total = data.length;
    final active = data.where((p) {
      if (p is! Map) return false;
      final sts = p['plant_sts'];
      if (sts == 0 || sts == '0') return false;
      if (sts == 1 || sts == '1' || sts == true) return true;
      if (sts is String) {
        final s = sts.toLowerCase();
        if (s == 'active' || s == 'semai' || s == 'aktif') return true;
        if (s == 'inactive' || s == 'tidak aktif') return false;
      }
      return true;
    }).length;

    return DashboardPlantSummaryModel(total: total, active: active);
  }

  // ─── Latest Sensor Reads ──────────────────────────────
  /// GET /sites/{siteId}/reads/updates
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<SensorReadModel>> getLatestSensorReads(String siteId) async {
    final response = await _dio.get(ApiEndpoints.readsUpdates(siteId));
    final data = ResponseParser.extractDataList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => SensorReadModel.fromJson(json))
        .toList();
  }

  // ─── Daily Reads ──────────────────────────────────────
  /// GET /sites/{siteId}/reads/seven-day
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<SensorReadModel>> getDailyReads(String siteId) async {
    final response = await _dio.get(ApiEndpoints.readsSevenDay(siteId));
    final data = ResponseParser.extractDataList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => SensorReadModel.fromJson(json))
        .toList();
  }

  // ─── Today Reads ──────────────────────────────────────
  /// GET /sites/{siteId}/reads?today=true
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<SensorReadModel>> getTodayReads(String siteId) async {
    final response = await _dio.get(
      ApiEndpoints.reads(siteId),
      queryParameters: const {'today': 'true'},
    );
    final data = ResponseParser.extractDataList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => SensorReadModel.fromJson(json))
        .toList();
  }
}
