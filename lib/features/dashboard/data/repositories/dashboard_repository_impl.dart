import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/environmental_health_model.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EnvironmentalHealth>> getEnvironmentalHealth(
    String siteId,
  ) async {
    try {
      final data = await remoteDataSource.getEnvironmentalHealth(siteId);
      return Right(data);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DashboardDeviceSummary>> getDeviceSummary(
    String siteId,
  ) async {
    try {
      final data = await remoteDataSource.getDeviceSummary(siteId);
      return Right(data);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DashboardSensorSummary>> getSensorSummary(
    String siteId,
  ) async {
    try {
      final data = await remoteDataSource.getSensorSummary(siteId);
      return Right(data);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DashboardPlantSummary>> getPlantSummary(
    String siteId,
  ) async {
    try {
      final data = await remoteDataSource.getPlantSummary(siteId);
      return Right(data);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLatestSensorReads(
    String siteId,
  ) async {
    try {
      final data = await remoteDataSource.getLatestSensorReads(siteId);
      return Right(data);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSevenDayReads(
    String siteId,
  ) async {
    try {
      final data = await remoteDataSource.getSevenDayReads(siteId);
      return Right(data);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTodayReads(
    String siteId,
  ) async {
    try {
      final data = await remoteDataSource.getTodayReads(siteId);
      return Right(data);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
