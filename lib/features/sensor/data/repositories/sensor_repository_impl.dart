import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/sensor_remote_datasource.dart';

class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDataSource _remoteDataSource;

  SensorRepositoryImpl(this._remoteDataSource);

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          'Koneksi timeout. Periksa koneksi internet Anda.',
        );
      case DioExceptionType.connectionError:
        return const NetworkFailure('Tidak dapat terhubung ke server.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        String message = 'Terjadi kesalahan';
        if (e.response?.data is Map) {
          message =
              e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan';
        } else {
          message = e.message ?? 'Terjadi kesalahan';
        }
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
      default:
        return const NetworkFailure('Terjadi kesalahan jaringan.');
    }
  }

  @override
  Future<Either<Failure, List<Sensor>>> getSensors(String siteId) async {
    try {
      final models = await _remoteDataSource.getSensors(siteId);
      return Right(models.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Sensor>> getSensorById(
    String siteId,
    String sensId,
  ) async {
    try {
      final model = await _remoteDataSource.getSensorById(siteId, sensId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Sensor>> createSensor(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await _remoteDataSource.createSensor(siteId, data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Sensor>> updateSensor(
    String siteId,
    String sensId,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await _remoteDataSource.updateSensor(siteId, sensId, data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSensor(
    String siteId,
    String sensId,
  ) async {
    try {
      await _remoteDataSource.deleteSensor(siteId, sensId);
      return const Right(null);
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
