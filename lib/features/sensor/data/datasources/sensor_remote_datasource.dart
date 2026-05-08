import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/sensor_model.dart';

class SensorRemoteDataSource {
  final Dio _dio;

  SensorRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/sensors
  Future<List<SensorModel>> getSensors(String siteId) async {
    final response = await _dio.get(ApiEndpoints.sensors(siteId));
    final data = response.data['data'] as List? ?? [];
    return data
        .map(
          (json) => SensorModel.fromJson(
            _normalizeSensor(json as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  /// GET /api/sites/:siteId/sensors/:sensId
  Future<SensorModel> getSensorById(String siteId, String sensId) async {
    final response = await _dio.get(ApiEndpoints.sensorById(siteId, sensId));
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return SensorModel.fromJson(_normalizeSensor(data));
  }

  /// POST /api/sites/:siteId/sensors
  Future<SensorModel> createSensor(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(ApiEndpoints.sensors(siteId), data: data);
    final responseData = response.data['data'] as Map<String, dynamic>? ?? {};
    return SensorModel.fromJson(_normalizeSensor(responseData));
  }

  /// PUT /api/sites/:siteId/sensors/:sensId
  Future<SensorModel> updateSensor(
    String siteId,
    String sensId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(
      ApiEndpoints.sensorById(siteId, sensId),
      data: data,
    );
    final responseData = response.data['data'] as Map<String, dynamic>? ?? {};
    return SensorModel.fromJson(_normalizeSensor(responseData));
  }

  /// DELETE /api/sites/:siteId/sensors/:sensId
  Future<void> deleteSensor(String siteId, String sensId) async {
    await _dio.delete(ApiEndpoints.sensorById(siteId, sensId));
  }

  /// Normalize sensor JSON — handle type mismatches from API
  Map<String, dynamic> _normalizeSensor(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    // Map backend fields to model fields
    // Backend: sens_id, sens_name, dev_id, etc.
    // Model expects: _id, device_id, name, type, unit, is_active, created_at, updated_at
    if (!normalized.containsKey('_id') && normalized.containsKey('sens_id')) {
      normalized['_id'] = normalized['sens_id'];
    }
    if (!normalized.containsKey('device_id') &&
        normalized.containsKey('dev_id')) {
      normalized['device_id'] = normalized['dev_id'];
    }
    if (!normalized.containsKey('name') &&
        normalized.containsKey('sens_name')) {
      normalized['name'] = normalized['sens_name'];
    }
    if (!normalized.containsKey('type') &&
        normalized.containsKey('sens_type')) {
      normalized['type'] = normalized['sens_type'];
    }
    if (!normalized.containsKey('unit') &&
        normalized.containsKey('sens_unit')) {
      normalized['unit'] = normalized['sens_unit'];
    }
    if (!normalized.containsKey('is_active') &&
        normalized.containsKey('sens_sts')) {
      final sts = normalized['sens_sts'];
      normalized['is_active'] = sts == 1 || sts == '1' || sts == true;
    }
    if (!normalized.containsKey('created_at') &&
        normalized.containsKey('sens_created')) {
      normalized['created_at'] = normalized['sens_created'];
    }
    if (!normalized.containsKey('updated_at') &&
        normalized.containsKey('sens_update')) {
      normalized['updated_at'] = normalized['sens_update'];
    }

    // Ensure required fields have fallback values
    normalized['_id'] ??= '';
    normalized['device_id'] ??= '';
    normalized['name'] ??= normalized['sens_name'] ?? '';
    normalized['type'] ??= 'unknown';
    normalized['unit'] ??= '';
    normalized['is_active'] ??= true;
    normalized['created_at'] ??= DateTime.now().toIso8601String();
    normalized['updated_at'] ??= DateTime.now().toIso8601String();

    return normalized;
  }
}
