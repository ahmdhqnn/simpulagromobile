import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/device_sensor_model.dart';

abstract class DeviceSensorRemoteDatasource {
  Future<List<DeviceSensorModel>> getAllDeviceSensors(String siteId);
  Future<List<Map<String, dynamic>>> getThresholdValues(String siteId);
  Future<DeviceSensorModel> getDeviceSensorById(String siteId, String dsId);
  Future<DeviceSensorModel> createDeviceSensor(
    String siteId,
    Map<String, dynamic> data,
  );
  Future<DeviceSensorModel> updateDeviceSensor(
    String siteId,
    String dsId,
    String devId,
    Map<String, dynamic> data,
  );
  Future<void> deleteDeviceSensor(String siteId, String dsId, String devId);
}

class DeviceSensorRemoteDatasourceImpl implements DeviceSensorRemoteDatasource {
  final Dio dio;

  DeviceSensorRemoteDatasourceImpl(this.dio);

  @override
  Future<List<DeviceSensorModel>> getAllDeviceSensors(String siteId) async {
    try {
      final response = await dio.get(ApiEndpoints.deviceSensors(siteId));
      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      // API returns {"message":"...", "data":[]} — handle empty gracefully
      final dsData = ResponseParser.extractDataList(data);

      return dsData
          .whereType<Map>()
          .map(
            (json) => DeviceSensorModel.fromJson(
              _normalizeDs(Map<String, dynamic>.from(json)),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get device sensors: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getThresholdValues(String siteId) async {
    try {
      final response = await dio.get(ApiEndpoints.deviceSensorValues(siteId));
      return ResponseParser.extractDataList(response.data)
          .whereType<Map>()
          .map((json) => Map<String, dynamic>.from(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<DeviceSensorModel> getDeviceSensorById(
    String siteId,
    String dsId,
  ) async {
    try {
      // Fetch all and filter — avoids "not found" on single endpoint
      final all = await getAllDeviceSensors(siteId);
      final found = all.where((ds) => ds.dsId == dsId).firstOrNull;
      if (found == null) throw Exception('Device Sensor tidak ditemukan');
      return found;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensorModel> createDeviceSensor(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.deviceSensors(siteId),
        data: data,
      );
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      return DeviceSensorModel.fromJson(
        _normalizeDs(ResponseParser.extractDataMap(responseData)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create device sensor: $e');
    }
  }

  @override
  Future<DeviceSensorModel> updateDeviceSensor(
    String siteId,
    String dsId,
    String devId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiEndpoints.deviceSensorById(siteId, dsId, devId),
        data: data,
      );
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      return DeviceSensorModel.fromJson(
        _normalizeDs(ResponseParser.extractDataMap(responseData)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update device sensor: $e');
    }
  }

  @override
  Future<void> deleteDeviceSensor(
    String siteId,
    String dsId,
    String devId,
  ) async {
    throw const UnsupportedBackendEndpointException(
      'Hapus device sensor belum didukung oleh server',
    );
  }

  /// Normalize device sensor JSON — API sometimes returns sts/seq as String
  Map<String, dynamic> _normalizeDs(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    const stringKeys = [
      'ds_id',
      'dev_id',
      'unit_id',
      'sens_id',
      'ds_name',
      'ds_address',
    ];
    for (final key in stringKeys) {
      final value = normalized[key];
      if (value != null && value is! String) {
        normalized[key] = value.toString();
      }
    }
    normalized['ds_sts'] = _toInt(normalized['ds_sts']);
    normalized['ds_seq'] = _toInt(normalized['ds_seq']);
    normalized['ds_seq'] ??= _toInt(normalized['ds_sequence']);
    return normalized;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is bool) return value ? 1 : 0;
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

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
            return Exception('Device Sensor tidak ditemukan');
          case 409:
            return Exception('Mapping ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
          default:
            return Exception(message);
        }
      case DioExceptionType.connectionError:
        return Exception('Tidak dapat terhubung ke server.');
      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
