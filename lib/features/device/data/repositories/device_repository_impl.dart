import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_datasource.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource _remoteDataSource;

  DeviceRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Device>> getDevices(String siteId) async {
    try {
      final models = await _remoteDataSource.getDevices(siteId);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch devices: $e');
    }
  }

  @override
  Future<Device> getDeviceById(String siteId, String devId) async {
    try {
      final model = await _remoteDataSource.getDeviceById(siteId, devId);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch device: $e');
    }
  }

  @override
  Future<List<Device>> getDeviceCoordinates(String siteId) async {
    try {
      final models = await _remoteDataSource.getDeviceCoordinates(siteId);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch device coordinates: $e');
    }
  }

  @override
  Future<Device> createDevice(String siteId, Device device) async {
    try {
      final model = await _remoteDataSource.createDevice(siteId, device);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to create device: $e');
    }
  }

  @override
  Future<Device> updateDevice(
    String siteId,
    String devId,
    Device device,
  ) async {
    try {
      final model = await _remoteDataSource.updateDevice(siteId, devId, device);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to update device: $e');
    }
  }

  @override
  Future<void> deleteDevice(String siteId, String devId) async {
    try {
      await _remoteDataSource.deleteDevice(siteId, devId);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to delete device: $e');
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('No internet connection');
    }

    final statusCode = e.response?.statusCode;
    final message = e.response?.data['message'] ?? e.message ?? 'Unknown error';

    switch (statusCode) {
      case 401:
        return AuthFailure(message);
      case 403:
        return PermissionFailure(message);
      case 404:
        return NotFoundFailure(message);
      case 409:
        return ValidationFailure(message);
      default:
        return ServerFailure(message, statusCode: statusCode);
    }
  }
}
