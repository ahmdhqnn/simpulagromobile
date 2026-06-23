import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/sensor_model.dart';

/// Remote datasource for Sensor operations
/// Handles all HTTP requests related to sensors
abstract class SensorRemoteDatasource {
  /// Get all sensors for a specific site
  Future<List<SensorModel>> getSensorsBySite(String siteId);

  /// Get all sensors (global)
  Future<List<SensorModel>> getAllSensors(String siteId);

  /// Get sensor by ID
  Future<SensorModel> getSensorById(String siteId, String sensorId);

  /// Create new sensor
  Future<SensorModel> createSensor(String siteId, Map<String, dynamic> data);

  /// Update existing sensor
  Future<SensorModel> updateSensor(
    String siteId,
    String sensorId,
    Map<String, dynamic> data,
  );

  /// Delete sensor
  Future<void> deleteSensor(String siteId, String sensorId);
}

class SensorRemoteDatasourceImpl implements SensorRemoteDatasource {
  final Dio dio;

  SensorRemoteDatasourceImpl(this.dio);

  @override
  Future<List<SensorModel>> getSensorsBySite(String siteId) async {
    try {
      final response = await dio.get(ApiEndpoints.sensors(siteId));

      final sensorsData = ResponseParser.extractDataList(response.data);

      return sensorsData
          .whereType<Map>()
          .map(
            (json) => SensorModel.fromJson(
              _normalizeSensor(Map<String, dynamic>.from(json)),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get sensors: $e');
    }
  }

  @override
  Future<List<SensorModel>> getAllSensors(String siteId) async {
    return getSensorsBySite(siteId);
  }

  @override
  Future<SensorModel> getSensorById(String siteId, String sensorId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.sensorDetail(siteId, sensorId),
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      // Extract sensor data from response
      final sensorData = _extractSensorData(data, sensorId);
      final model = SensorModel.fromJson(_normalizeSensor(sensorData));
      if (model.sensId.isEmpty) {
        return _findSensorFromList(siteId, sensorId);
      }
      return model;
    } on DioException catch (e) {
      if (_shouldFallbackToList(e)) {
        return _findSensorFromList(siteId, sensorId);
      }
      throw _handleDioError(e);
    } catch (e) {
      try {
        return await _findSensorFromList(siteId, sensorId);
      } catch (_) {
        throw Exception('Failed to get sensor: $e');
      }
    }
  }

  @override
  Future<SensorModel> createSensor(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(ApiEndpoints.sensors(siteId), data: data);

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      final sensorData = _extractSensorData(responseData);
      return SensorModel.fromJson(_normalizeSensor(sensorData));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create sensor: $e');
    }
  }

  @override
  Future<SensorModel> updateSensor(
    String siteId,
    String sensorId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiEndpoints.sensorById(siteId, sensorId),
        data: data,
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      final sensorData = _extractSensorData(responseData);
      return SensorModel.fromJson(_normalizeSensor(sensorData));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update sensor: $e');
    }
  }

  @override
  Future<void> deleteSensor(String siteId, String sensorId) async {
    throw const UnsupportedBackendEndpointException(
      'Hapus sensor belum didukung oleh server',
    );
  }

  Future<SensorModel> _findSensorFromList(
    String siteId,
    String sensorId,
  ) async {
    final sensors = await getSensorsBySite(siteId);
    final normalizedId = sensorId.trim();
    final matches = sensors.where((sensor) => sensor.sensId == normalizedId);
    if (matches.isEmpty) {
      throw Exception('Sensor tidak ditemukan');
    }
    return matches.first;
  }

  bool _shouldFallbackToList(DioException e) {
    final code = e.response?.statusCode;
    return code == 404 || code == 405 || code == 501;
  }

  Map<String, dynamic> _extractSensorData(dynamic body, [String? sensorId]) {
    final rows = ResponseParser.extractDataList(
      body,
    ).whereType<Map>().map((json) => Map<String, dynamic>.from(json)).toList();
    if (rows.isNotEmpty) {
      return rows.firstWhere(
        (row) => sensorId != null && _matchesSensorId(row, sensorId),
        orElse: () => rows.first,
      );
    }

    return ResponseParser.extractDataMap(body);
  }

  bool _matchesSensorId(Map<String, dynamic> json, String sensorId) {
    final id =
        json['sens_id'] ??
        json['sensId'] ??
        json['sensor_id'] ??
        json['sensorId'] ??
        json['id'];
    return id?.toString().trim() == sensorId.trim();
  }

  Map<String, dynamic> _normalizeSensor(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    const stringKeys = [
      'sens_id',
      'dev_id',
      'sens_name',
      'sens_address',
      'sens_location',
    ];
    for (final key in stringKeys) {
      final value = normalized[key];
      if (value != null && value is! String) {
        normalized[key] = value.toString();
      }
    }
    normalized['sens_sts'] = _toInt(normalized['sens_sts']);
    return normalized;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is bool) return value ? 1 : 0;
    if (value is String) {
      final text = value.trim().toLowerCase();
      if (text == 'active' ||
          text == 'aktif' ||
          text == 'enabled' ||
          text == 'true') {
        return 1;
      }
      if (text == 'inactive' ||
          text == 'nonaktif' ||
          text == 'disabled' ||
          text == 'false') {
        return 0;
      }
      return int.tryParse(text);
    }
    return null;
  }

  /// Handle Dio errors and convert to user-friendly messages
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Koneksi timeout. Periksa koneksi internet Anda.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = ResponseParser.extractMessage(
          error.response?.data,
          'Terjadi kesalahan: $statusCode',
        );

        switch (statusCode) {
          case 400:
            return Exception(message);
          case 401:
            return Exception(
              'Sesi Anda telah berakhir. Silakan login kembali.',
            );
          case 403:
            return Exception(
              'Anda tidak memiliki izin untuk melakukan aksi ini',
            );
          case 404:
            return Exception('Sensor tidak ditemukan');
          case 409:
            return Exception('Sensor dengan ID ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
          default:
            return Exception(message);
        }

      case DioExceptionType.cancel:
        return Exception('Request dibatalkan');

      case DioExceptionType.connectionError:
        return Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );

      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
