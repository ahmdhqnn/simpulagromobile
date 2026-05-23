import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

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
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final model = await remoteDatasource.getUserProfile();
      return Right(model.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    String name,
    String email,
    String phone,
  ) async {
    try {
      final model = await remoteDatasource.updateProfile(name, email, phone);
      return Right(model.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Handled by auth feature
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
