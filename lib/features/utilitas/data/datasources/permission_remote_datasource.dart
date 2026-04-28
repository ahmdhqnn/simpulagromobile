import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/permission_model.dart';

abstract class PermissionRemoteDatasource {
  Future<List<PermissionModel>> getAllPermissions();
  Future<List<PermissionModel>> getPermissionsByRole(String roleId);
}

class PermissionRemoteDatasourceImpl implements PermissionRemoteDatasource {
  final Dio dio;

  PermissionRemoteDatasourceImpl(this.dio);

  @override
  Future<List<PermissionModel>> getAllPermissions() async {
    try {
      final response = await dio.get(ApiEndpoints.permissions);
      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      final permsData = data['data'] ?? data;
      if (permsData is! List) throw Exception('Invalid response format');

      return permsData
          .map((json) => PermissionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get permissions: $e');
    }
  }

  @override
  Future<List<PermissionModel>> getPermissionsByRole(String roleId) async {
    try {
      final response = await dio.get(ApiEndpoints.permissionsByRole(roleId));
      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      final permsData = data['data'] ?? data;
      if (permsData is! List) throw Exception('Invalid response format');

      return permsData
          .map((json) => PermissionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get permissions by role: $e');
    }
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
          case 401:
            return Exception(
              'Sesi Anda telah berakhir. Silakan login kembali.',
            );
          case 403:
            return Exception('Anda tidak memiliki izin');
          case 404:
            return Exception('Permission tidak ditemukan');
          default:
            return Exception(message ?? 'Terjadi kesalahan: $statusCode');
        }
      case DioExceptionType.connectionError:
        return Exception('Tidak dapat terhubung ke server.');
      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
