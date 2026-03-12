import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// POST /api/auth/login
  Future<LoginResponseModel> login(String username, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data);
  }

  /// GET /api/profile/me
  Future<UserModel> getProfile() async {
    final response = await _dio.get('/profile/me');
    return UserModel.fromJson(response.data['data']);
  }

  /// GET /api/profile/permissions
  Future<List<String>> getPermissions() async {
    final response = await _dio.get('/profile/permissions');
    final data = response.data['data'];
    final permissions = data['permissions'] as List;
    return permissions.map((p) => p.toString()).toList();
  }
}
