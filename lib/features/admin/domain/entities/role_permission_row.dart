import 'permission.dart';

class RolePermissionRow {
  const RolePermissionRow({
    this.rpId,
    this.roleId,
    this.permId,
    this.rpSts,
    this.canView,
    this.canCreate,
    this.canEdit,
    this.canDelete,
    this.permission,
  });

  final String? rpId;
  final String? roleId;
  final String? permId;
  final int? rpSts;
  final bool? canView;
  final bool? canCreate;
  final bool? canEdit;
  final bool? canDelete;
  final Permission? permission;
}
