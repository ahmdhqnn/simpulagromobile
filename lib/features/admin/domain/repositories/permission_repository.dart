import '../entities/permission.dart';
import '../entities/role_permission_row.dart';
import '../entities/role_with_permissions.dart';

abstract class PermissionRepository {
  Future<List<Permission>> getAllPermissions();
  Future<List<Permission>> getPermissionsByRole(String roleId);
  Future<List<RoleWithPermissions>> getRolePermissions();
  Future<List<RolePermissionRow>> getRolePermissionRows(String roleId);
  Future<Permission> getPermissionById(String permissionId);
  Future<Permission> createPermission(Permission permission);
  Future<Permission> updatePermission(
    String permissionId,
    Permission permission,
  );
  Future<void> createRolePermission(RolePermissionRow row);
  Future<void> updateRolePermission(RolePermissionRow row);
  Future<void> deleteRolePermission(String permId, String roleId);
}
