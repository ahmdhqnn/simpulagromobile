import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/phase.dart';
import '../../domain/repositories/phase_repository.dart';
import '../datasources/phase_remote_datasource.dart';

class PhaseRepositoryImpl implements PhaseRepository {
  final PhaseRemoteDatasource remoteDatasource;

  PhaseRepositoryImpl(this.remoteDatasource);

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
          message = e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan';
        } else {
          message = e.message ?? 'Terjadi kesalahan';
        }
        
        switch (statusCode) {
          case 401:
            return AuthFailure(message);
          case 403:
            return PermissionFailure(message);
          case 404:
            return const NotFoundFailure('Data fase tidak ditemukan');
          default:
            return ServerFailure(message, statusCode: statusCode);
        }
      default:
        return const NetworkFailure('Terjadi kesalahan jaringan.');
    }
  }

  @override
  Future<Either<Failure, List<Phase>>> getPhasesByPlant(String plantId) async {
    try {
      final models = await remoteDatasource.getPhasesByPlant(plantId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Phase>> getPhaseById(String id) async {
    try {
      final model = await remoteDatasource.getPhaseById(id);
      if (model == null) return const Left(NotFoundFailure('Fase tidak ditemukan'));
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Phase?>> getCurrentPhase(String plantId) async {
    try {
      final model = await remoteDatasource.getCurrentPhase(plantId);
      return Right(model?.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Phase>>> getPhaseHistory(String plantId) async {
    try {
      final models = await remoteDatasource.getPhaseHistory(plantId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
