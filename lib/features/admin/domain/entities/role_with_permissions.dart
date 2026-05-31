import 'role_permission_row.dart';

class RoleWithPermissions {
  const RoleWithPermissions({
    this.roleId,
    this.roleName,
    this.listPermission = const [],
  });

  final String? roleId;
  final String? roleName;
  final List<RolePermissionRow> listPermission;
}
