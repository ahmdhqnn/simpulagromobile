import 'package:dio/dio.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDatasource {
  final Dio _dio;

  ProfileRemoteDatasource(this._dio);

  /// GET /api/profile/me
  /// Mendapatkan informasi user yang sedang login
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dio.get('/profile/me');

      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserProfileModel.fromJson(response.data['data']);
      }

      throw Exception('Failed to load profile');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized - Token expired');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// GET /api/profile/permissions
  /// Mendapatkan daftar permissions yang dimiliki user saat ini
  Future<List<String>> getUserPermissions() async {
    try {
      final response = await _dio.get('/profile/permissions');

      if (response.statusCode == 200 && response.data['data'] != null) {
        final permissions =
            response.data['data']['permissions'] as List<dynamic>?;
        return permissions?.map((e) => e.toString()).toList() ?? [];
      }

      return [];
    } on DioException catch (_) {
      return [];
    }
  }

  Future<UserProfileModel> updateProfile(
    String name,
    String email,
    String phone,
  ) async {
    // TODO: Implement update profile API when available
    await Future.delayed(const Duration(seconds: 1));

    throw UnimplementedError('Update profile API not yet implemented');

    /* Real API (when available):
    final response = await _dio.put(
      '/profile/update',
      data: {
        'user_name': name,
        'user_email': email,
        'user_phone': phone,
      },
    );
    return UserProfileModel.fromJson(response.data['data']);
    */
  }
}
