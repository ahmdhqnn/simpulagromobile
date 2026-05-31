import '../entities/role.dart';

abstract class RoleRepository {
  Future<List<Role>> getAllRoles();
  Future<Role> getRoleById(String roleId);
  Future<Role> createRole(Role role, List<String> permissionIds);
  Future<Role> updateRole(
    String roleId,
    Role role,
    List<String>? permissionIds,
  );
  Future<void> deleteRole(String roleId);
}
