import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDatasource {
  final Dio _dio;

  ProfileRemoteDatasource(this._dio);

  /// GET /api/profile/me
  /// Mendapatkan informasi user yang sedang login
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profileMe);

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
      final response = await _dio.get(ApiEndpoints.profilePermissions);

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
    throw const UnsupportedBackendEndpointException(
      'Update profil belum didukung oleh server',
    );
  }
}
