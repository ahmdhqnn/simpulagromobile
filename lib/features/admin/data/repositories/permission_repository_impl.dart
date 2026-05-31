import '../../domain/entities/permission.dart';
import '../../domain/entities/role_permission_row.dart';
import '../../domain/entities/role_with_permissions.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/permission_remote_datasource.dart';
import '../models/permission_model.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionRemoteDatasource remoteDatasource;

  PermissionRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Permission>> getAllPermissions() async {
    final models = await remoteDatasource.getAllPermissions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Permission>> getPermissionsByRole(String roleId) async {
    final models = await remoteDatasource.getPermissionsByRole(roleId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<RoleWithPermissions>> getRolePermissions() async {
    final models = await remoteDatasource.getRolePermissions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<RolePermissionRow>> getRolePermissionRows(String roleId) async {
    final models = await remoteDatasource.getPermissionsByRole(roleId);
    return models
        .map(
          (permission) => RolePermissionRow(
            roleId: roleId,
            permId: permission.permId,
            permission: permission.toEntity(),
            rpSts: 1,
          ),
        )
        .toList();
  }

  @override
  Future<Permission> getPermissionById(String permissionId) async {
    final permissions = await getAllPermissions();
    return permissions.firstWhere(
      (permission) => permission.permId == permissionId,
    );
  }

  @override
  Future<Permission> createPermission(Permission permission) async {
    final payload = _toPermissionPayload(permission);
    final model = await remoteDatasource.createPermission(payload);
    return model.toEntity();
  }

  @override
  Future<Permission> updatePermission(
    String permissionId,
    Permission permission,
  ) async {
    final payload = _toPermissionPayload(
      permission.copyWith(permId: permissionId),
    );
    final model = await remoteDatasource.updatePermission(payload);
    return model.toEntity();
  }

  @override
  Future<void> createRolePermission(RolePermissionRow row) {
    return remoteDatasource.createRolePermission(
      _toRolePermissionCreatePayload(row),
    );
  }

  @override
  Future<void> updateRolePermission(RolePermissionRow row) {
    return remoteDatasource.updateRolePermission(
      _toRolePermissionUpdatePayload(row),
    );
  }

  @override
  Future<void> deleteRolePermission(String permId, String roleId) {
    return remoteDatasource.deleteRolePermission(permId, roleId);
  }

  Map<String, dynamic> _toPermissionPayload(Permission permission) {
    final payload = PermissionModel.fromEntity(permission).toJson();
    payload.removeWhere((key, value) => value == null);
    return payload;
  }

  Map<String, dynamic> _toRolePermissionCreatePayload(RolePermissionRow row) {
    final roleId = row.roleId;
    final permId = row.permId;
    if (roleId == null || roleId.isEmpty || permId == null || permId.isEmpty) {
      throw Exception('role_id dan perm_id wajib diisi');
    }
    return {
      'rp_id': row.rpId ?? _buildRolePermissionId(roleId, permId),
      'role_id': roleId,
      'perm_id': permId,
      'rp_sts': row.rpSts ?? 1,
      'can_view': row.canView ?? true,
      'can_create': row.canCreate ?? true,
      'can_edit': row.canEdit ?? true,
      'can_delete': row.canDelete ?? true,
    };
  }

  Map<String, dynamic> _toRolePermissionUpdatePayload(RolePermissionRow row) {
    final roleId = row.roleId;
    final permId = row.permId;
    if (roleId == null || roleId.isEmpty || permId == null || permId.isEmpty) {
      throw Exception('role_id dan perm_id wajib diisi');
    }
    final payload = <String, dynamic>{'role_id': roleId, 'perm_id': permId};
    if (row.rpSts != null) payload['rp_sts'] = row.rpSts;
    if (row.canView != null) payload['can_view'] = row.canView;
    if (row.canCreate != null) payload['can_create'] = row.canCreate;
    if (row.canEdit != null) payload['can_edit'] = row.canEdit;
    if (row.canDelete != null) payload['can_delete'] = row.canDelete;
    return payload;
  }

  String _buildRolePermissionId(String roleId, String permId) {
    final safeRole = roleId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final safePerm = permId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    return 'RP_${safeRole}_$safePerm';
  }
}
