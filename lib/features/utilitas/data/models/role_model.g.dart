// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleModelImpl _$$RoleModelImplFromJson(Map<String, dynamic> json) =>
    _$RoleModelImpl(
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String?,
      roleDesc: json['role_desc'] as String?,
      roleSts: (json['role_sts'] as num?)?.toInt(),
      roleCreated: json['role_created'] == null
          ? null
          : DateTime.parse(json['role_created'] as String),
      roleUpdate: json['role_update'] == null
          ? null
          : DateTime.parse(json['role_update'] as String),
      listPermission:
          (json['list_permission'] as List<dynamic>?)
              ?.map(
                (e) => RolePermissionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RoleModelImplToJson(_$RoleModelImpl instance) =>
    <String, dynamic>{
      'role_id': instance.roleId,
      'role_name': instance.roleName,
      'role_desc': instance.roleDesc,
      'role_sts': instance.roleSts,
      'role_created': instance.roleCreated?.toIso8601String(),
      'role_update': instance.roleUpdate?.toIso8601String(),
      'list_permission': instance.listPermission,
    };

_$RolePermissionModelImpl _$$RolePermissionModelImplFromJson(
  Map<String, dynamic> json,
) => _$RolePermissionModelImpl(
  rpId: json['rp_id'] as String,
  roleId: json['role_id'] as String,
  permId: json['perm_id'] as String,
  rpSts: (json['rp_sts'] as num).toInt(),
  permission: json['permission'] == null
      ? null
      : PermissionModel.fromJson(json['permission'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$RolePermissionModelImplToJson(
  _$RolePermissionModelImpl instance,
) => <String, dynamic>{
  'rp_id': instance.rpId,
  'role_id': instance.roleId,
  'perm_id': instance.permId,
  'rp_sts': instance.rpSts,
  'permission': instance.permission,
};
