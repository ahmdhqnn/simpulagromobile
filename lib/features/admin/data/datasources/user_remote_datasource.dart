import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../auth/domain/entities/user.dart';

/// Remote datasource for User operations
abstract class UserRemoteDatasource {
  Future<List<User>> getAllUsers();
  Future<User> getUserById(String userId);
  Future<User> createUser(Map<String, dynamic> data);
  Future<User> updateUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasourceImpl(this.dio);

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final response = await dio.get(ApiEndpoints.users);

      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      // Handle both {"data": [...]} and direct list
      final usersData = data['data'] ?? data;

      if (usersData is! List) {
        // Some backends return empty object on no data
        return [];
      }

      return usersData
          .map((json) => _userFromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    try {
      final response = await dio.get(ApiEndpoints.userById(userId));

      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      final userData = data['data'] ?? data;

      return _userFromJson(userData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<User> createUser(Map<String, dynamic> data) async {
    try {
      // Create user uses /auth/new-users endpoint
      final response = await dio.post(ApiEndpoints.register, data: data);

      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      final userData = responseData['data'] ?? responseData;

      return _userFromJson(userData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<User> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(ApiEndpoints.userById(userId), data: data);

      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      final userData = responseData['data'] ?? responseData;

      return _userFromJson(userData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await dio.delete(ApiEndpoints.userById(userId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  User _userFromJson(Map<String, dynamic> json) {
    return User(
      userId: (json['user_id'] ?? json['id'] ?? '').toString(),
      userName: (json['user_name'] ?? json['name'] ?? '').toString(),
      userEmail: json['user_email']?.toString(),
      userPhone: json['user_phone']?.toString(),
      userSts: json['user_sts']?.toString(),
      roleId: json['role_id']?.toString(),
    );
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Koneksi timeout. Periksa koneksi internet Anda.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'];
        switch (statusCode) {
          case 400:
            return Exception(message ?? 'Data tidak valid');
          case 401:
            return Exception(
              'Sesi Anda telah berakhir. Silakan login kembali.',
            );
          case 403:
            return Exception(
              'Anda tidak memiliki izin untuk melakukan aksi ini',
            );
          case 404:
            return Exception('User tidak ditemukan');
          case 409:
            return Exception('User dengan ID ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
          default:
            return Exception(message ?? 'Terjadi kesalahan: $statusCode');
        }
      case DioExceptionType.cancel:
        return Exception('Request dibatalkan');
      case DioExceptionType.connectionError:
        return Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );
      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
