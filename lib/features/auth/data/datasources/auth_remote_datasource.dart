import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// POST /api/auth/login
  /// Returns access_token, refresh_token, expires_in, token_type, user
  Future<LoginResponseModel> login(String username, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'username': username, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data);
  }

  /// POST /api/auth/logout (optional server-side invalidation)
  Future<void> logout(String? refreshToken) async {
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _dio.post(
          ApiEndpoints.logout,
          data: {'refresh_token': refreshToken},
        );
      }
    } catch (_) {
      // Logout is best-effort — don't block on server errors
    }
  }

  /// GET /api/profile/me
  Future<UserModel> getProfile() async {
    final response = await _dio.get(ApiEndpoints.profileMe);
    return UserModel.fromJson(response.data['data']);
  }

  /// GET /api/profile/permissions
  Future<List<String>> getPermissions() async {
    final response = await _dio.get(ApiEndpoints.profilePermissions);
    final data = response.data['data'];
    if (data is Map && data.containsKey('permissions')) {
      final permissions = data['permissions'] as List;
      return permissions.map((p) => p.toString()).toList();
    }
    if (data is List) {
      return data.map((p) => p['perm_name']?.toString() ?? '').toList();
    }
    return [];
  }
}
