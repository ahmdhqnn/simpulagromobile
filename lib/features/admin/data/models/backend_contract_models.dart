import 'permission_model.dart';
import '../../domain/entities/role_permission_row.dart';
import '../../domain/entities/role_with_permissions.dart';

class RolePermissionRowModel {
  RolePermissionRowModel({
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
  final PermissionModel? permission;

  factory RolePermissionRowModel.fromJson(Map<String, dynamic> json) {
    final nested = json['permission'];
    return RolePermissionRowModel(
      rpId: json['rp_id']?.toString(),
      roleId: json['role_id']?.toString(),
      permId: json['perm_id']?.toString(),
      rpSts: _toInt(json['rp_sts']),
      canView: _toBool(json['can_view']),
      canCreate: _toBool(json['can_create']),
      canEdit: _toBool(json['can_edit']),
      canDelete: _toBool(json['can_delete']),
      permission: nested is Map<String, dynamic>
          ? PermissionModel.fromJson(_normalizePermission(nested))
          : null,
    );
  }

  RolePermissionRow toEntity() => RolePermissionRow(
    rpId: rpId,
    roleId: roleId,
    permId: permId ?? permission?.permId,
    rpSts: rpSts,
    canView: canView,
    canCreate: canCreate,
    canEdit: canEdit,
    canDelete: canDelete,
    permission: permission?.toEntity(),
  );
}

class RoleWithPermissionsModel {
  RoleWithPermissionsModel({
    this.roleId,
    this.roleName,
    this.listPermission = const [],
  });

  final String? roleId;
  final String? roleName;
  final List<RolePermissionRowModel> listPermission;

  factory RoleWithPermissionsModel.fromJson(Map<String, dynamic> json) {
    final list = json['list_permission'];
    return RoleWithPermissionsModel(
      roleId: json['role_id']?.toString(),
      roleName: json['role_name']?.toString(),
      listPermission: list is List
          ? list
                .whereType<Map<String, dynamic>>()
                .map(RolePermissionRowModel.fromJson)
                .toList()
          : const [],
    );
  }

  RoleWithPermissions toEntity() => RoleWithPermissions(
    roleId: roleId,
    roleName: roleName,
    listPermission: listPermission.map((row) => row.toEntity()).toList(),
  );
}

class VarietasItemModel {
  VarietasItemModel({
    this.varietasId,
    this.varietasName,
    this.varietasDesc,
    this.varietasSts,
    this.varietasUpdate,
  });

  final String? varietasId;
  final String? varietasName;
  final String? varietasDesc;
  final int? varietasSts;
  final DateTime? varietasUpdate;

  factory VarietasItemModel.fromJson(Map<String, dynamic> json) {
    return VarietasItemModel(
      varietasId: json['varietas_id']?.toString(),
      varietasName: json['varietas_name']?.toString(),
      varietasDesc: json['varietas_desc']?.toString(),
      varietasSts: _toInt(json['varietas_sts']),
      varietasUpdate: _toDateTime(json['varietas_update']),
    );
  }
}

class DeviceSensorRangeModel {
  DeviceSensorRangeModel({
    this.devId,
    this.dsId,
    this.dsMaxNormValue,
    this.dsMinNormValue,
    this.dsMaxValWarn,
    this.dsMinValWarn,
    this.dsMaxValue,
    this.dsMinValue,
  });

  final String? devId;
  final String? dsId;
  final double? dsMaxNormValue;
  final double? dsMinNormValue;
  final double? dsMaxValWarn;
  final double? dsMinValWarn;
  final double? dsMaxValue;
  final double? dsMinValue;

  factory DeviceSensorRangeModel.fromJson(Map<String, dynamic> json) {
    return DeviceSensorRangeModel(
      devId: json['dev_id']?.toString(),
      dsId: json['ds_id']?.toString(),
      dsMaxNormValue: _toDouble(json['ds_max_norm_value']),
      dsMinNormValue: _toDouble(json['ds_min_norm_value']),
      dsMaxValWarn: _toDouble(json['ds_max_val_warn']),
      dsMinValWarn: _toDouble(json['ds_min_val_warn']),
      dsMaxValue: _toDouble(json['ds_max_value']),
      dsMinValue: _toDouble(json['ds_min_value']),
    );
  }
}

Map<String, dynamic> _normalizePermission(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  normalized['perm_sts'] = _toInt(normalized['perm_sts']);
  return normalized;
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

double? _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
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

DateTime? _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value.trim());
  }
  return null;
}
