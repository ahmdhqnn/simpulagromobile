import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
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
    return UserModel.fromJson(ResponseParser.extractDataMap(response.data));
  }

  /// GET /api/profile/permissions
  Future<List<String>> getPermissions() async {
    final response = await _dio.get(ApiEndpoints.profilePermissions);
    if (response.data is List) {
      return _normalizePermissions(response.data);
    }
    final data = ResponseParser.extractDataMap(response.data);
    if (data.containsKey('permissions')) {
      return _normalizePermissions(data['permissions']);
    }
    final rows = ResponseParser.extractDataList(response.data);
    if (rows.isNotEmpty) {
      return _normalizePermissions(rows);
    }
    return [];
  }

  /// POST /api/auth/change-password
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.authChangePassword,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
    return ResponseParser.extractMessage(
      response.data,
      'Password berhasil diubah',
    );
  }

  List<String> _normalizePermissions(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .map((item) {
          if (item is Map) {
            final permission = item['permission'];
            return item['perm_name'] ??
                item['perm_slug'] ??
                (permission is Map ? permission['perm_name'] : null) ??
                (permission is Map ? permission['perm_slug'] : null);
          }
          return item;
        })
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
