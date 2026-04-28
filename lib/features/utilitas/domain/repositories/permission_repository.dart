import '../entities/permission.dart';

abstract class PermissionRepository {
  Future<List<Permission>> getAllPermissions();
  Future<List<Permission>> getPermissionsByRole(String roleId);
  Future<Permission> getPermissionById(String permissionId);
  Future<Permission> createPermission(Permission permission);
  Future<Permission> updatePermission(
    String permissionId,
    Permission permission,
  );
  Future<void> deletePermission(String permissionId);
}
