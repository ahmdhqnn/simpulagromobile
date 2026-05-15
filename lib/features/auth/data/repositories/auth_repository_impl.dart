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
  Future<User> login(String username, String password) async {
    final response = await _remoteDataSource.login(username, password);

    // Persist dual tokens securely
    await _tokenManager.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresInSeconds: response.expiresIn,
    );

    // Cache user data for offline access
    await _storage.saveUserData(response.user.toJsonString());

    return response.user;
  }

  @override
  Future<User> getProfile() async {
    final user = await _remoteDataSource.getProfile();
    await _storage.saveUserData(user.toJsonString());
    return user;
  }

  @override
  Future<List<String>> getPermissions() async {
    return await _remoteDataSource.getPermissions();
  }

  @override
  Future<void> logout() async {
    // Best-effort server-side token invalidation
    final refreshToken = await _storage.getRefreshToken();
    await _remoteDataSource.logout(refreshToken);

    // Clear all session data locally
    await _storage.clearSession();
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
