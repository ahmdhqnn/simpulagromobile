import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
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

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      final devicesData = data['data'] ?? data;

      if (devicesData is! List) {
        throw Exception('Invalid response format: expected List');
      }

      return devicesData
          .map(
            (json) => DeviceModel.fromJson(
              _normalizeDevice(json as Map<String, dynamic>),
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

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      final deviceData = data['data'] ?? data;

      return DeviceModel.fromJson(
        _normalizeDevice(deviceData as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get device: $e');
    }
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

      final deviceData = responseData['data'] ?? responseData;

      return DeviceModel.fromJson(
        _normalizeDevice(deviceData as Map<String, dynamic>),
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

      final deviceData = responseData['data'] ?? responseData;

      return DeviceModel.fromJson(
        _normalizeDevice(deviceData as Map<String, dynamic>),
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
    final sts = normalized['dev_sts'];
    if (sts is String) {
      normalized['dev_sts'] = int.tryParse(sts);
    }
    return normalized;
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
        final message = error.response?.data?['message'];

        switch (statusCode) {
          case 400:
            return Exception(message ?? 'Data tidak valid');
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
            return Exception(message ?? 'Terjadi kesalahan: $statusCode');
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
