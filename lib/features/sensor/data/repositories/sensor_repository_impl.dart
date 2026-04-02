import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/sensor_remote_datasource.dart';

class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDataSource _remoteDataSource;

  SensorRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Sensor>> getSensors(String deviceId) async {
    try {
      final models = await _remoteDataSource.getSensors(deviceId);
      return models.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Sensor> getSensorById(String id) async {
    try {
      final model = await _remoteDataSource.getSensorById(id);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Sensor> createSensor(
    String deviceId,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await _remoteDataSource.createSensor(deviceId, data);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Sensor> updateSensor(String id, Map<String, dynamic> data) async {
    try {
      final model = await _remoteDataSource.updateSensor(id, data);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteSensor(String id) async {
    try {
      await _remoteDataSource.deleteSensor(id);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'Server error';
        if (statusCode == 401) {
          return const AuthFailure('Unauthorized');
        }
        return ServerFailure(message);
      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled');
      default:
        return const NetworkFailure('Network error');
    }
  }
}
