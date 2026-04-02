import 'package:dio/dio.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDatasource {
  // ignore: unused_field
  final Dio _dio;

  ProfileRemoteDatasource(this._dio);

  Future<UserProfileModel> getUserProfile() async {
    // TODO: Replace with real API
    await Future.delayed(const Duration(milliseconds: 500));

    return UserProfileModel(
      id: 'user-1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+62 812-3456-7890',
      role: 'Admin',
      permissions: ['read', 'write', 'delete', 'manage_users'],
      avatar: null,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
    );

    /* Real API:
    final response = await _dio.get('/profile');
    return UserProfileModel.fromJson(response.data['data']);
    */
  }

  Future<UserProfileModel> updateProfile(
    String name,
    String email,
    String phone,
  ) async {
    // TODO: Replace with real API
    await Future.delayed(const Duration(seconds: 1));

    return UserProfileModel(
      id: 'user-1',
      name: name,
      email: email,
      phone: phone,
      role: 'Admin',
      permissions: ['read', 'write', 'delete', 'manage_users'],
      avatar: null,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
    );

    /* Real API:
    final response = await _dio.put(
      '/profile',
      data: {'name': name, 'email': email, 'phone': phone},
    );
    return UserProfileModel.fromJson(response.data['data']);
    */
  }
}
