import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
import '../models/device_model.dart';

/// Remote datasource for Device operations
/// Handles all HTTP requests related to devices
abstract class DeviceRemoteDatasource {
  /// Get all devices for a specific site
  Future<List<DeviceModel>> getDevicesBySite(String siteId);

  /// Get device by ID
  Future<DeviceModel> getDeviceById(String siteId, String deviceId);

  /// Create new device
  Future<DeviceModel> createDevice(String siteId, Map<String, dynamic> data);

  /// Update existing device
  Future<DeviceModel> updateDevice(
    String siteId,
    String deviceId,
    Map<String, dynamic> data,
  );

  /// Delete device
  Future<void> deleteDevice(String siteId, String deviceId);
}

class DeviceRemoteDatasourceImpl implements DeviceRemoteDatasource {
  final Dio dio;

  DeviceRemoteDatasourceImpl(this.dio);

  @override
  Future<List<DeviceModel>> getDevicesBySite(String siteId) async {
    try {
      final response = await dio.get(ApiEndpoints.devices(siteId));

      final devicesData = ResponseParser.extractDataList(response.data);

      return devicesData
          .whereType<Map>()
          .map(
            (json) => DeviceModel.fromJson(
              _normalizeDevice(Map<String, dynamic>.from(json)),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get devices: $e');
    }
  }

  @override
  Future<DeviceModel> getDeviceById(String siteId, String deviceId) async {
    try {
      final response = await dio.get(ApiEndpoints.deviceById(siteId, deviceId));

      return DeviceModel.fromJson(
        _normalizeDevice(ResponseParser.extractDataMap(response.data)),
      );
    } on DioException catch (e) {
      if (_shouldFallbackToList(e)) {
        return _findDeviceFromList(siteId, deviceId);
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get device: $e');
    }
  }

  Future<DeviceModel> _findDeviceFromList(String siteId, String deviceId) async {
    final devices = await getDevicesBySite(siteId);
    final normalizedId = deviceId.trim();
    final matches = devices.where((device) => device.devId == normalizedId);
    if (matches.isEmpty) {
      throw Exception('Device tidak ditemukan');
    }
    return matches.first;
  }

  bool _shouldFallbackToList(DioException e) {
    final code = e.response?.statusCode;
    return code == 404 || code == 405 || code == 501;
  }

  @override
  Future<DeviceModel> createDevice(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.addDevice(siteId),
        data: data,
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      return DeviceModel.fromJson(
        _normalizeDevice(ResponseParser.extractDataMap(responseData)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create device: $e');
    }
  }

  @override
  Future<DeviceModel> updateDevice(
    String siteId,
    String deviceId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiEndpoints.deviceById(siteId, deviceId),
        data: data,
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      return DeviceModel.fromJson(
        _normalizeDevice(ResponseParser.extractDataMap(responseData)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update device: $e');
    }
  }

  @override
  Future<void> deleteDevice(String siteId, String deviceId) async {
    try {
      await dio.delete(ApiEndpoints.deviceById(siteId, deviceId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete device: $e');
    }
  }

  /// Normalize device JSON — API sometimes returns sts as String
  Map<String, dynamic> _normalizeDevice(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    const stringKeys = [
      'dev_id',
      'site_id',
      'user_id',
      'dev_name',
      'dev_token',
      'dev_location',
      'dev_number_id',
      'dev_ip',
      'dev_port',
      'dev_img',
    ];
    for (final key in stringKeys) {
      final value = normalized[key];
      if (value != null && value is! String) {
        normalized[key] = value.toString();
      }
    }
    normalized['dev_sts'] = _toInt(normalized['dev_sts']);
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
            return Exception('Device tidak ditemukan');
          case 409:
            return Exception('Device dengan ID ini sudah ada');
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
