import 'package:simpulagromobile/core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _storage;

  AuthRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<({String token, User user})> login(
    String username,
    String password,
  ) async {
    final response = await _remoteDataSource.login(username, password);

    await _storage.saveToken(response.token);
    await _storage.saveUserData(response.user.toJsonString());
    return (token: response.token, user: response.user as User);
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
    await _storage.clearAll();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
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
