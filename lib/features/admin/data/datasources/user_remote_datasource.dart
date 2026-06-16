import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
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
      final usersData = ResponseParser.extractDataList(response.data);
      return usersData
          .whereType<Map>()
          .map((json) => _userFromJson(Map<String, dynamic>.from(json)))
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
      final users = await getAllUsers();
      return users.firstWhere(
        (user) => user.userId == userId,
        orElse: () => throw Exception('User tidak ditemukan'),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<User> createUser(Map<String, dynamic> data) async {
    try {
      // Backend contract: POST /sites/users/new-users.
      final response = await dio.post(ApiEndpoints.register, data: data);

      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');
      return _userFromJson(ResponseParser.extractDataMap(responseData));
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
      return _userFromJson(ResponseParser.extractDataMap(responseData));
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
      userSts: _statusValue(json['user_sts']),
      roleId: json['role_id']?.toString(),
    );
  }

  String? _statusValue(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value ? 'active' : 'inactive';
    if (value is num) return value.toInt() == 1 ? 'active' : 'inactive';
    final text = value.toString().trim();
    if (text == '1') return 'active';
    if (text == '0') return 'inactive';
    return text.isEmpty ? null : text;
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Koneksi timeout. Periksa koneksi internet Anda.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = ResponseParser.extractMessage(
          error.response?.data,
          'Terjadi kesalahan: $statusCode',
        );
        switch (statusCode) {
          case 400:
            return Exception(message);
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
            return Exception(message);
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
