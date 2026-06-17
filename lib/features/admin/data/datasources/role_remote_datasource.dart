import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
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
      final rolesData = ResponseParser.extractDataList(response.data);

      return rolesData
          .whereType<Map>()
          .map(
            (json) => RoleModel.fromJson(
              _normalizeRole(Map<String, dynamic>.from(json)),
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
      return RoleModel.fromJson(
        _normalizeRole(ResponseParser.extractDataMap(response.data)),
      );
    } on DioException catch (e) {
      if (_shouldFallbackToList(e)) {
        return _findRoleFromList(roleId);
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get role: $e');
    }
  }

  Future<RoleModel> _findRoleFromList(String roleId) async {
    final roles = await getAllRoles();
    final normalizedId = roleId.trim();
    final matches = roles.where((role) => role.roleId == normalizedId);
    if (matches.isEmpty) {
      throw Exception('Role tidak ditemukan');
    }
    return matches.first;
  }

  bool _shouldFallbackToList(DioException e) {
    final code = e.response?.statusCode;
    return code == 404 || code == 405 || code == 501;
  }

  @override
  Future<RoleModel> createRole(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(ApiEndpoints.roles, data: data);
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      return RoleModel.fromJson(
        _normalizeRole(ResponseParser.extractDataMap(responseData)),
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

      return RoleModel.fromJson(
        _normalizeRole(ResponseParser.extractDataMap(responseData)),
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
    const roleStringKeys = ['role_id', 'role_name', 'role_desc'];
    for (final key in roleStringKeys) {
      final value = normalized[key];
      if (value != null && value is! String) {
        normalized[key] = value.toString();
      }
    }

    // Normalize role_sts
    normalized['role_sts'] = _toInt(normalized['role_sts']);

    // Normalize list_permission rp_sts
    final perms = normalized['list_permission'];
    if (perms is List) {
      normalized['list_permission'] = perms.map((p) {
        if (p is Map) {
          final pNorm = Map<String, dynamic>.from(p);
          const relationStringKeys = ['rp_id', 'role_id', 'perm_id'];
          for (final key in relationStringKeys) {
            final value = pNorm[key];
            if (value != null && value is! String) {
              pNorm[key] = value.toString();
            }
          }
          pNorm['rp_sts'] = _toInt(pNorm['rp_sts']) ?? 1;
          pNorm['can_view'] = _toBool(pNorm['can_view']);
          pNorm['can_create'] = _toBool(pNorm['can_create']);
          pNorm['can_edit'] = _toBool(pNorm['can_edit']);
          pNorm['can_delete'] = _toBool(pNorm['can_delete']);
          final permission = pNorm['permission'];
          if (permission is Map) {
            pNorm['permission'] = _normalizePermission(
              Map<String, dynamic>.from(permission),
            );
          }
          return pNorm;
        }
        return p;
      }).toList();
    }

    return normalized;
  }

  Map<String, dynamic> _normalizePermission(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    const stringKeys = [
      'perm_id',
      'perm_name',
      'perm_slug',
      'perm_desc',
      'perm_page',
    ];
    for (final key in stringKeys) {
      final value = normalized[key];
      if (value != null && value is! String) {
        normalized[key] = value.toString();
      }
    }
    normalized['perm_sts'] = _toInt(normalized['perm_sts']);
    return normalized;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is bool) return value ? 1 : 0;
    if (value is String) return int.tryParse(value.trim());
    return null;
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
    if (permissionIds.isEmpty) {
      return;
    }

    try {
      for (final permId in permissionIds) {
        await dio.post(
          ApiEndpoints.permissionsNewRolePermission,
          data: {
            'rp_id': _buildRolePermissionId(roleId, permId),
            'role_id': roleId,
            'perm_id': permId,
            'rp_sts': 1,
            'can_view': true,
            'can_create': true,
            'can_edit': true,
            'can_delete': true,
          },
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to assign permissions: $e');
    }
  }

  @override
  Future<void> removePermission(String permId, String roleId) async {
    try {
      await dio.delete(
        ApiEndpoints.permissionsDeleteRolePermission(permId, roleId),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to remove permission from role: $e');
    }
  }

  String _buildRolePermissionId(String roleId, String permId) {
    final safeRole = roleId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final safePerm = permId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    return 'RP_${safeRole}_$safePerm';
  }

  bool? _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == 'true' || v == '1') return true;
      if (v == 'false' || v == '0') return false;
    }
    return null;
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
            return Exception('Role tidak ditemukan');
          case 409:
            return Exception('Role dengan ID ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
          default:
            return Exception(message);
        }
      case DioExceptionType.connectionError:
        return Exception('Tidak dapat terhubung ke server.');
      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
