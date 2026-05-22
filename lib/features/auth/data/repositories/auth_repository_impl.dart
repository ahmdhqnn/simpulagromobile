import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _storage;
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._remoteDataSource, this._storage, this._tokenManager);

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final response = await _remoteDataSource.login(username, password);

      // Persist dual tokens securely
      await _tokenManager.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresInSeconds: response.expiresIn,
      );

      // Cache user data for offline access
      await _storage.saveUserData(response.user.toJsonString());

      return Right(response.user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Invalid username or password'));
      }
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final user = await _remoteDataSource.getProfile();
      await _storage.saveUserData(user.toJsonString());
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPermissions() async {
    try {
      final permissions = await _remoteDataSource.getPermissions();
      return Right(permissions);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Best-effort server-side token invalidation
      final refreshToken = await _storage.getRefreshToken();
      await _remoteDataSource.logout(refreshToken);

      // Clear all session data locally
      await _storage.clearSession();
      return const Right(null);
    } on DioException catch (e) {
      // Even if server fails, clear local session
      await _storage.clearSession();
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      await _storage.clearSession();
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _tokenManager.hasValidSession();
  }

  @override
  Future<User?> getCachedUser() async {
    final userData = await _storage.getUserData();
    if (userData == null) return null;
    try {
      return UserModel.fromJsonString(userData);
    } catch (_) {
      return null;
    }
  }
}
