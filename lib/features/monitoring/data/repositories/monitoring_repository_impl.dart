import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/monitoring_repository.dart';
import '../datasources/monitoring_remote_datasource.dart';
import '../models/monitoring_models.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  final MonitoringRemoteDataSource remoteDataSource;

  MonitoringRepositoryImpl(this.remoteDataSource);

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timeout');
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('No internet connection');
    }
    final statusCode = e.response?.statusCode;
    String message = 'Unknown error';
    if (e.response?.data is Map) {
      message = e.response?.data['message'] ?? e.message ?? 'Unknown error';
    } else {
      message = e.message ?? 'Unknown error';
    }

    switch (statusCode) {
      case 401: return AuthFailure(message);
      case 403: return PermissionFailure(message);
      case 404: return NotFoundFailure(message);
      case 409: return ValidationFailure(message);
      default: return ServerFailure(message, statusCode: statusCode);
    }
  }

  @override
  Future<Either<Failure, List<SensorReadUpdate>>> getLatestReads(String siteId) async {
    try {
      final res = await remoteDataSource.getLatestReads(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SensorReadModel>>> getTodayReads(String siteId) async {
    try {
      final res = await remoteDataSource.getTodayReads(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SensorReadModel>>> getSevenDayReads(String siteId) async {
    try {
      final res = await remoteDataSource.getSevenDayReads(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SensorReadModel>>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  }) async {
    try {
      final res = await remoteDataSource.getDateRangeReads(
        siteId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SensorReadModel>>> getPlantingDateReads(String siteId) async {
    try {
      final res = await remoteDataSource.getPlantingDateReads(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SensorDailyModel>>> getDailyReads(String siteId) async {
    try {
      final res = await remoteDataSource.getDailyReads(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DeviceModel>>> getDevices(String siteId) async {
    try {
      final res = await remoteDataSource.getDevices(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getSensorCount(String siteId) async {
    try {
      final res = await remoteDataSource.getSensorCount(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LogModel>>> getLogs() async {
    try {
      final res = await remoteDataSource.getLogs();
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getEnvironmentalHealth(String siteId) async {
    try {
      final res = await remoteDataSource.getEnvironmentalHealth(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPlantRecommendation(String siteId) async {
    try {
      final res = await remoteDataSource.getPlantRecommendation(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AlarmDataModel>>> getAlarmData() async {
    try {
      final res = await remoteDataSource.getAlarmData();
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyRekapModel>>> getMonthlyReads(String siteId) async {
    try {
      final res = await remoteDataSource.getMonthlyReads(siteId);
      return Right(res);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
