import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/role_model.dart';

abstract class RoleRemoteDatasource {
  Future<List<RoleModel>> getAllRoles();
  Future<RoleModel> getRoleById(String roleId);
  Future<RoleModel> createRole(Map<String, dynamic> data);
  Future<RoleModel> updateRole(String roleId, Map<String, dynamic> data);
  Future<void> deleteRole(String roleId);
  Future<void> assignPermissions(String roleId, List<String> permissionIds);
  Future<void> removePermission(String permId, String roleId);
}

class RoleRemoteDatasourceImpl implements RoleRemoteDatasource {
  final Dio dio;

  RoleRemoteDatasourceImpl(this.dio);

  @override
  Future<List<RoleModel>> getAllRoles() async {
    try {
      final response = await dio.get(ApiEndpoints.roles);
      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      final rolesData = data['data'] ?? data;
      if (rolesData is! List) throw Exception('Invalid response format');

      return rolesData
          .map(
            (json) => RoleModel.fromJson(
              _normalizeRole(json as Map<String, dynamic>),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get roles: $e');
    }
  }

  @override
  Future<RoleModel> getRoleById(String roleId) async {
    try {
      final response = await dio.get(ApiEndpoints.roleById(roleId));
      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      final roleData = data['data'] ?? data;
      return RoleModel.fromJson(
        _normalizeRole(roleData as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get role: $e');
    }
  }

  @override
  Future<RoleModel> createRole(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(ApiEndpoints.roles, data: data);
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      final roleData = responseData['data'] ?? responseData;
      return RoleModel.fromJson(
        _normalizeRole(roleData as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create role: $e');
    }
  }

  @override
  Future<RoleModel> updateRole(String roleId, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(ApiEndpoints.roleById(roleId), data: data);
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      final roleData = responseData['data'] ?? responseData;
      return RoleModel.fromJson(
        _normalizeRole(roleData as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update role: $e');
    }
  }

  /// Normalize role JSON — API sometimes returns sts as String
  Map<String, dynamic> _normalizeRole(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    // Normalize role_sts
    final sts = normalized['role_sts'];
    if (sts is String) normalized['role_sts'] = int.tryParse(sts);

    // Normalize list_permission rp_sts
    final perms = normalized['list_permission'];
    if (perms is List) {
      normalized['list_permission'] = perms.map((p) {
        if (p is Map<String, dynamic>) {
          final pNorm = Map<String, dynamic>.from(p);
          final rpSts = pNorm['rp_sts'];
          if (rpSts is String) pNorm['rp_sts'] = int.tryParse(rpSts) ?? 1;
          return pNorm;
        }
        return p;
      }).toList();
    }

    return normalized;
  }

  @override
  Future<void> deleteRole(String roleId) async {
    try {
      await dio.delete(ApiEndpoints.roleById(roleId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete role: $e');
    }
  }

  @override
  Future<void> assignPermissions(
    String roleId,
    List<String> permissionIds,
  ) async {
    try {
      await dio.post(
        ApiEndpoints.newRolePermission,
        data: {'role_id': roleId, 'perm_ids': permissionIds},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to assign permissions: $e');
    }
  }

  @override
  Future<void> removePermission(String permId, String roleId) async {
    try {
      await dio.delete(ApiEndpoints.deleteRolePermission(permId, roleId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to remove permission: $e');
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
            return Exception('Role tidak ditemukan');
          case 409:
            return Exception('Role dengan ID ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
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
