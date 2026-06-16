import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
import '../models/backend_contract_models.dart';
import '../models/permission_model.dart';

abstract class PermissionRemoteDatasource {
  Future<List<PermissionModel>> getAllPermissions();
  Future<List<PermissionModel>> getPermissionsByRole(String roleId);
  Future<List<RoleWithPermissionsModel>> getRolePermissions();
  Future<PermissionModel> createPermission(Map<String, dynamic> payload);
  Future<PermissionModel> updatePermission(Map<String, dynamic> payload);
  Future<void> createRolePermission(Map<String, dynamic> payload);
  Future<void> updateRolePermission(Map<String, dynamic> payload);
  Future<void> deleteRolePermission(String permId, String roleId);
}

class PermissionRemoteDatasourceImpl implements PermissionRemoteDatasource {
  final Dio dio;

  PermissionRemoteDatasourceImpl(this.dio);

  @override
  Future<List<PermissionModel>> getAllPermissions() async {
    try {
      final response = await dio.get(ApiEndpoints.permissionsAll);
      final rows = ResponseParser.extractDataList(response.data);
      return rows
          .whereType<Map>()
          .map((json) => _toPermissionModel(Map<String, dynamic>.from(json)))
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
      final rows = ResponseParser.extractDataList(response.data);
      return rows
          .whereType<Map>()
          .map((json) => _toPermissionModel(Map<String, dynamic>.from(json)))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get role permissions: $e');
    }
  }

  @override
  Future<List<RoleWithPermissionsModel>> getRolePermissions() async {
    try {
      final response = await dio.get(ApiEndpoints.permissionsRolePermissions);
      final rows = ResponseParser.extractDataList(response.data);
      return rows
          .whereType<Map>()
          .map(
            (json) => RoleWithPermissionsModel.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get role permissions: $e');
    }
  }

  @override
  Future<PermissionModel> createPermission(Map<String, dynamic> payload) async {
    try {
      final response = await dio.post(
        ApiEndpoints.permissionsNewPermission,
        data: payload,
      );
      final data = ResponseParser.extractDataMap(response.data);
      return PermissionModel.fromJson(_normalizePermission(data));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create permission: $e');
    }
  }

  @override
  Future<PermissionModel> updatePermission(Map<String, dynamic> payload) async {
    try {
      final response = await dio.put(
        ApiEndpoints.permissionsUpdatePermission,
        data: payload,
      );
      final data = ResponseParser.extractDataMap(response.data);
      return PermissionModel.fromJson(_normalizePermission(data));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update permission: $e');
    }
  }

  @override
  Future<void> createRolePermission(Map<String, dynamic> payload) async {
    try {
      await dio.post(ApiEndpoints.permissionsNewRolePermission, data: payload);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create role permission: $e');
    }
  }

  @override
  Future<void> updateRolePermission(Map<String, dynamic> payload) async {
    try {
      await dio.put(
        ApiEndpoints.permissionsUpdateRolePermission,
        data: payload,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update role permission: $e');
    }
  }

  @override
  Future<void> deleteRolePermission(String permId, String roleId) async {
    try {
      await dio.delete(
        ApiEndpoints.permissionsDeleteRolePermission(permId, roleId),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete role permission: $e');
    }
  }

  PermissionModel _toPermissionModel(Map<String, dynamic> json) {
    final nested = json['permission'];
    final source = nested is Map ? Map<String, dynamic>.from(nested) : json;
    return PermissionModel.fromJson(_normalizePermission(source));
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
    final sts = normalized['perm_sts'];
    if (sts is String) {
      normalized['perm_sts'] = int.tryParse(sts);
    }
    return normalized;
  }

  Exception _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = ResponseParser.extractMessage(
      error.response?.data,
      'Permission request failed: $statusCode',
    );
    if (statusCode == 401) {
      return Exception(message);
    }
    if (statusCode == 403) {
      return Exception(message);
    }
    if (statusCode == 404) {
      return Exception(message);
    }
    return Exception(message);
  }
}
