import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/response_parser.dart';
import '../../domain/entities/site.dart';
import '../../domain/repositories/site_repository.dart';
import '../datasources/site_remote_datasource.dart';

class SiteRepositoryImpl implements SiteRepository {
  final SiteRemoteDataSource _remoteDataSource;

  SiteRepositoryImpl(this._remoteDataSource);

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('No internet connection');
    }

    final statusCode = e.response?.statusCode;
    final message = ResponseParser.extractMessage(
      e.response?.data,
      e.message ?? 'Unknown error',
    );

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

  @override
  Future<Either<Failure, List<Site>>> getSites() async {
    try {
      final models = await _remoteDataSource.getSites();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch sites: $e'));
    }
  }

  @override
  Future<Either<Failure, Site>> getSiteById(String siteId) async {
    try {
      final model = await _remoteDataSource.getSiteById(siteId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch site: $e'));
    }
  }

  @override
  Future<Either<Failure, Site>> createSite(Site site) async {
    try {
      final model = await _remoteDataSource.createSite(site);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to create site: $e'));
    }
  }

  @override
  Future<Either<Failure, Site>> updateSite(String siteId, Site site) async {
    try {
      final model = await _remoteDataSource.updateSite(siteId, site);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to update site: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> inviteMember(
    String siteId,
    String userId,
  ) async {
    try {
      await _remoteDataSource.inviteMember(siteId, userId);
      return const Right(null);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 400:
          return const Left(ValidationFailure('INVITE_BAD_REQUEST'));
        case 403:
          return const Left(PermissionFailure('INVITE_FORBIDDEN'));
        case 409:
          return const Left(ValidationFailure('INVITE_CONFLICT'));
      }
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to invite member: $e'));
    }
  }
}
