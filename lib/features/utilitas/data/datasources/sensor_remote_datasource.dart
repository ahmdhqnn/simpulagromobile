import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
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

      // Handle response structure
      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      // Check if data has 'data' field
      final sensorsData = data['data'] ?? data;

      if (sensorsData is! List) {
        throw Exception('Invalid response format: expected List');
      }

      return sensorsData
          .map((json) => SensorModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get sensors: $e');
    }
  }

  @override
  Future<List<SensorModel>> getAllSensors(String siteId) async {
    try {
      final response = await dio.get(ApiEndpoints.sensorsAll(siteId));

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      final sensorsData = data['data'] ?? data;

      if (sensorsData is! List) {
        throw Exception('Invalid response format: expected List');
      }

      return sensorsData
          .map((json) => SensorModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get all sensors: $e');
    }
  }

  @override
  Future<SensorModel> getSensorById(String siteId, String sensorId) async {
    try {
      final response = await dio.get(ApiEndpoints.sensorById(siteId, sensorId));

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      // Extract sensor data from response
      final sensorData = data['data'] ?? data;

      return SensorModel.fromJson(sensorData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get sensor: $e');
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

      final sensorData = responseData['data'] ?? responseData;

      return SensorModel.fromJson(sensorData as Map<String, dynamic>);
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

      final sensorData = responseData['data'] ?? responseData;

      return SensorModel.fromJson(sensorData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update sensor: $e');
    }
  }

  @override
  Future<void> deleteSensor(String siteId, String sensorId) async {
    try {
      await dio.delete(ApiEndpoints.sensorById(siteId, sensorId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete sensor: $e');
    }
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
            return Exception('Sensor tidak ditemukan');
          case 409:
            return Exception('Sensor dengan ID ini sudah ada');
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
