import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/device_sensor_model.dart';

abstract class DeviceSensorRemoteDatasource {
  Future<List<DeviceSensorModel>> getAllDeviceSensors();
  Future<DeviceSensorModel> getDeviceSensorById(String dsId);
  Future<DeviceSensorModel> createDeviceSensor(Map<String, dynamic> data);
  Future<DeviceSensorModel> updateDeviceSensor(
    String dsId,
    String devId,
    Map<String, dynamic> data,
  );
  Future<void> deleteDeviceSensor(String dsId, String devId);
}

class DeviceSensorRemoteDatasourceImpl implements DeviceSensorRemoteDatasource {
  final Dio dio;

  DeviceSensorRemoteDatasourceImpl(this.dio);

  @override
  Future<List<DeviceSensorModel>> getAllDeviceSensors() async {
    try {
      final response = await dio.get(ApiEndpoints.deviceSensors);
      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      // API returns {"message":"...", "data":[]} — handle empty gracefully
      final dsData = data['data'];
      if (dsData == null || (dsData is List && dsData.isEmpty)) return [];
      if (dsData is! List) throw Exception('Invalid response format');

      return dsData
          .map(
            (json) => DeviceSensorModel.fromJson(
              _normalizeDs(json as Map<String, dynamic>),
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
  Future<DeviceSensorModel> getDeviceSensorById(String dsId) async {
    try {
      // Fetch all and filter — avoids "not found" on single endpoint
      final all = await getAllDeviceSensors();
      final found = all.where((ds) => ds.dsId == dsId).firstOrNull;
      if (found == null) throw Exception('Device Sensor tidak ditemukan');
      return found;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensorModel> createDeviceSensor(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(ApiEndpoints.deviceSensors, data: data);
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      final dsData = responseData['data'] ?? responseData;
      return DeviceSensorModel.fromJson(
        _normalizeDs(dsData as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create device sensor: $e');
    }
  }

  @override
  Future<DeviceSensorModel> updateDeviceSensor(
    String dsId,
    String devId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiEndpoints.deviceSensorById(dsId, devId),
        data: data,
      );
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      final dsData = responseData['data'] ?? responseData;
      return DeviceSensorModel.fromJson(
        _normalizeDs(dsData as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update device sensor: $e');
    }
  }

  @override
  Future<void> deleteDeviceSensor(String dsId, String devId) async {
    try {
      await dio.delete(ApiEndpoints.deviceSensorById(dsId, devId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete device sensor: $e');
    }
  }

  /// Normalize device sensor JSON — API sometimes returns sts/seq as String
  Map<String, dynamic> _normalizeDs(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final sts = normalized['ds_sts'];
    if (sts is String) normalized['ds_sts'] = int.tryParse(sts);
    final seq = normalized['ds_seq'];
    if (seq is String) normalized['ds_seq'] = int.tryParse(seq);
    return normalized;
  }

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
            return Exception('Device Sensor tidak ditemukan');
          case 409:
            return Exception('Mapping ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
          default:
            return Exception(message ?? 'Terjadi kesalahan: $statusCode');
        }
      case DioExceptionType.connectionError:
        return Exception('Tidak dapat terhubung ke server.');
      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
