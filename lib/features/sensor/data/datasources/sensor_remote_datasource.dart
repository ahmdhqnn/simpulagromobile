import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/sensor_model.dart';

class SensorRemoteDataSource {
  final Dio _dio;

  SensorRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/sensors
  Future<List<SensorModel>> getSensors(String siteId) async {
    final response = await _dio.get(ApiEndpoints.sensors(siteId));
    return _extractSensorList(response.data)
        .map(_normalizeSensor)
        .where((json) => (json['_id']?.toString() ?? '').isNotEmpty)
        .map(SensorModel.fromJson)
        .toList();
  }

  /// GET /api/sites/:siteId/sensors/detail/:sensId
  Future<SensorModel> getSensorById(String siteId, String sensId) async {
    final response = await _dio.get(ApiEndpoints.sensorDetail(siteId, sensId));
    return SensorModel.fromJson(
      _normalizeSensor(_extractSensorData(response.data)),
    );
  }

  /// POST /api/sites/:siteId/sensors
  Future<SensorModel> createSensor(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(ApiEndpoints.sensors(siteId), data: data);
    return SensorModel.fromJson(
      _normalizeSensor(_extractSensorData(response.data)),
    );
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
    return SensorModel.fromJson(
      _normalizeSensor(_extractSensorData(response.data)),
    );
  }

  /// DELETE /api/sites/:siteId/sensors/:sensId
  Future<void> deleteSensor(String siteId, String sensId) async {
    throw const UnsupportedBackendEndpointException(
      'Hapus sensor belum didukung oleh server',
    );
  }

  List<Map<String, dynamic>> _extractSensorList(dynamic body) {
    final rows = ResponseParser.extractDataList(
      body,
    ).whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    if (rows.isNotEmpty) return rows;

    final data = _safeMap(body);
    for (final key in const ['sensors', 'sensor', 'items', 'rows', 'results']) {
      final value = data[key];
      if (value is List) {
        return value
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    }
    return [];
  }

  Map<String, dynamic> _extractSensorData(dynamic body) {
    final raw = _safeMap(body);
    for (final key in const ['sensor', 'item', 'result']) {
      final value = raw[key];
      if (value is Map) return Map<String, dynamic>.from(value);
    }
    final data = raw['data'];
    if (data is Map) {
      final nested = Map<String, dynamic>.from(data);
      for (final key in const ['sensor', 'item', 'result']) {
        final value = nested[key];
        if (value is Map) return Map<String, dynamic>.from(value);
      }
      return nested;
    }
    return raw;
  }

  Map<String, dynamic> _safeMap(dynamic body) {
    if (body is Map) {
      final data = body['data'];
      if (data is Map) return Map<String, dynamic>.from(data);
      return Map<String, dynamic>.from(body);
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _normalizeSensor(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final sensor = normalized['sensor'] is Map
        ? Map<String, dynamic>.from(normalized['sensor'] as Map)
        : const <String, dynamic>{};
    final unit = normalized['unit'] is Map
        ? Map<String, dynamic>.from(normalized['unit'] as Map)
        : const <String, dynamic>{};

    normalized['_id'] ??=
        normalized['sens_id'] ??
        normalized['sensor_id'] ??
        normalized['id'] ??
        sensor['sens_id'];
    normalized['device_id'] ??=
        normalized['dev_id'] ?? normalized['deviceId'] ?? sensor['dev_id'];
    normalized['name'] ??=
        normalized['sens_name'] ??
        normalized['sensor_name'] ??
        normalized['sensName'] ??
        sensor['sens_name'];
    normalized['type'] ??=
        normalized['sens_type'] ??
        normalized['sensor_type'] ??
        normalized['ds_id'] ??
        sensor['sens_type'] ??
        _inferSensorType(
          normalized['sens_id'] ?? normalized['_id'] ?? normalized['name'],
        );
    normalized['unit'] ??=
        normalized['sens_unit'] ??
        normalized['unit_symbol'] ??
        unit['unit_symbol'] ??
        _unitForType(normalized['type']);
    normalized['description'] ??=
        normalized['description'] ??
        normalized['sens_location'] ??
        normalized['sens_address'];

    if (!normalized.containsKey('is_active') &&
        normalized.containsKey('sens_sts')) {
      final sts = normalized['sens_sts'];
      normalized['is_active'] = sts == 1 || sts == '1' || sts == true;
    }
    normalized['created_at'] ??=
        normalized['sens_created'] ??
        normalized['createdAt'] ??
        normalized['created_date'];
    normalized['updated_at'] ??=
        normalized['sens_update'] ??
        normalized['updatedAt'] ??
        normalized['updated_date'];

    final now = DateTime.now().toIso8601String();
    normalized['_id'] ??= '';
    normalized['device_id'] ??= '';
    normalized['name'] ??= normalized['sens_name'] ?? '';
    normalized['type'] ??= 'unknown';
    normalized['unit'] ??= '';
    normalized['is_active'] ??= true;
    normalized['created_at'] ??= now;
    normalized['updated_at'] ??= now;

    return normalized;
  }

  String _inferSensorType(dynamic value) {
    final text = value?.toString().toLowerCase() ?? '';
    if (text.contains('env_temp') || text.contains('suhu udara')) {
      return 'env_temp';
    }
    if (text.contains('env_hum') || text.contains('kelembaban udara')) {
      return 'env_hum';
    }
    if (text.contains('soil_temp') || text.contains('suhu tanah')) {
      return 'soil_temp';
    }
    if (text.contains('soil_hum') || text.contains('kelembaban tanah')) {
      return 'soil_hum';
    }
    if (text.contains('nitro') || text.contains('nitrogen')) {
      return 'soil_nitro';
    }
    if (text.contains('phos') || text.contains('fosfor')) {
      return 'soil_phos';
    }
    if (text.contains('pot') || text.contains('kalium')) {
      return 'soil_pot';
    }
    if (text.contains('ph')) return 'soil_ph';
    return 'unknown';
  }

  String _unitForType(dynamic value) {
    switch (value?.toString()) {
      case 'env_temp':
      case 'soil_temp':
      case 'temperature':
        return '\u00B0C';
      case 'env_hum':
      case 'soil_hum':
      case 'humidity':
      case 'soil_moisture':
        return '%';
      case 'soil_nitro':
      case 'soil_phos':
      case 'soil_pot':
        return 'mg/kg';
      default:
        return '';
    }
  }
}
