import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/phase.dart';
import '../../domain/repositories/phase_repository.dart';
import '../datasources/phase_remote_datasource.dart';

class PhaseRepositoryImpl implements PhaseRepository {
  final PhaseRemoteDatasource remoteDatasource;

  PhaseRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Phase>>> getPhasesByPlant(String plantId) async {
    try {
      final models = await remoteDatasource.getPhasesByPlant(plantId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Phase>> getPhaseById(String id) async {
    try {
      final model = await remoteDatasource.getPhaseById(id);
      if (model == null) return const Left(NotFoundFailure('Fase tidak ditemukan'));
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Phase?>> getCurrentPhase(String plantId) async {
    try {
      final model = await remoteDatasource.getCurrentPhase(plantId);
      return Right(model?.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Phase>>> getPhaseHistory(String plantId) async {
    try {
      final models = await remoteDatasource.getPhaseHistory(plantId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
