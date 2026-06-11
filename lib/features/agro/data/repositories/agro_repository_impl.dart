import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/agro_entity.dart';
import '../../domain/repositories/agro_repository.dart';
import '../datasources/agro_remote_datasource.dart';

class AgroRepositoryImpl implements AgroRepository {
  final AgroRemoteDataSource remoteDataSource;

  AgroRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AgroEntity>> getAgroData(String siteId) async {
    try {
      final model = await remoteDataSource.getAgroData(siteId);
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
  Future<Either<Failure, VdpEntity>> getVdpData(String siteId) async {
    try {
      final model = await remoteDataSource.getAgroData(siteId);
      final entity = model.toEntity();
      if (entity.vdp == null) {
        return const Left(NotFoundFailure('Data VDP tidak tersedia'));
      }
      return Right(entity.vdp!);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, GddEntity>> getGddData(String siteId) async {
    try {
      final model = await remoteDataSource.getAgroData(siteId);
      final entity = model.toEntity();
      if (entity.gdd == null) {
        return const Left(NotFoundFailure('Data GDD tidak tersedia'));
      }
      return Right(entity.gdd!);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<EtcDailyEntity>>> getEtcData(
    String siteId,
  ) async {
    try {
      final model = await remoteDataSource.getAgroData(siteId);
      return Right(model.toEntity().etc);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AgroEnvironmentalHealthEntity>> getEnvironmentalHealth(
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
}
