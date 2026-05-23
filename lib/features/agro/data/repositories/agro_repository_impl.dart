import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/agro_repository.dart';
import '../datasources/agro_remote_datasource.dart';
import '../models/agro_model.dart';

class AgroRepositoryImpl implements AgroRepository {
  final AgroRemoteDataSource remoteDataSource;

  AgroRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AgroModel>> getAgroData(String siteId) async {
    try {
      final data = await remoteDataSource.getAgroData(siteId);
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
  Future<Either<Failure, VdpModel>> getVdpData(String siteId) async {
    try {
      final data = await remoteDataSource.getAgroData(siteId);
      if (data.vdp == null) {
        return Left(NotFoundFailure('VDP data not available'));
      }
      return Right(data.vdp!);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, GddModel>> getGddData(String siteId) async {
    try {
      final data = await remoteDataSource.getAgroData(siteId);
      if (data.gdd == null) {
        return Left(NotFoundFailure('GDD data not available'));
      }
      return Right(data.gdd!);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<EtcDailyModel>>> getEtcData(String siteId) async {
    try {
      final data = await remoteDataSource.getAgroData(siteId);
      return Right(data.etc);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
