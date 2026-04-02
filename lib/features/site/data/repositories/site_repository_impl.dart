import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/site.dart';
import '../../domain/repositories/site_repository.dart';
import '../datasources/site_remote_datasource.dart';

class SiteRepositoryImpl implements SiteRepository {
  final SiteRemoteDataSource _remoteDataSource;

  SiteRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Site>> getSites() async {
    try {
      final models = await _remoteDataSource.getSites();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch sites: $e');
    }
  }

  @override
  Future<Site> getSiteById(String siteId) async {
    try {
      final model = await _remoteDataSource.getSiteById(siteId);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch site: $e');
    }
  }

  @override
  Future<Site> createSite(Site site) async {
    try {
      final model = await _remoteDataSource.createSite(site);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to create site: $e');
    }
  }

  @override
  Future<Site> updateSite(String siteId, Site site) async {
    try {
      final model = await _remoteDataSource.updateSite(siteId, site);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to update site: $e');
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
