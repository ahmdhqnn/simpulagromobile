import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDatasource {
  final Dio _dio;

  ProfileRemoteDatasource(this._dio);

  /// GET /api/profile/me
  /// Mendapatkan informasi user yang sedang login
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profileMe);

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(
          ResponseParser.extractDataMap(response.data),
        );
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

      if (response.statusCode == 200) {
        if (response.data is List) {
          return _normalizePermissions(response.data);
        }
        final data = ResponseParser.extractDataMap(response.data);
        if (data.containsKey('permissions')) {
          return _normalizePermissions(data['permissions']);
        }
        return _normalizePermissions(
          ResponseParser.extractDataList(response.data),
        );
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
