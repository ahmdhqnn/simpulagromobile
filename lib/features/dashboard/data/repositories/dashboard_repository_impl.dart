import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EnvironmentalHealthEntity>> getEnvironmentalHealth(
    String siteId,
  ) async {
    try {
      final model = await remoteDataSource.getEnvironmentalHealth(siteId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DeviceSummaryEntity>> getDeviceSummary(
    String siteId,
  ) async {
    try {
      final model = await remoteDataSource.getDeviceSummary(siteId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SensorSummaryEntity>> getSensorSummary(
    String siteId,
  ) async {
    try {
      final model = await remoteDataSource.getSensorSummary(siteId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PlantSummaryEntity>> getPlantSummary(
    String siteId,
  ) async {
    try {
      final model = await remoteDataSource.getPlantSummary(siteId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SensorReadEntity>>> getLatestSensorReads(
    String siteId,
  ) async {
    try {
      final models = await remoteDataSource.getLatestSensorReads(siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SensorReadEntity>>> getDailyReads(
    String siteId,
  ) async {
    try {
      final models = await remoteDataSource.getDailyReads(siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SensorReadEntity>>> getTodayReads(
    String siteId,
  ) async {
    try {
      final models = await remoteDataSource.getTodayReads(siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
