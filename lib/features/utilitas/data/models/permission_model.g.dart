// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionModelImpl _$$PermissionModelImplFromJson(
  Map<String, dynamic> json,
) => _$PermissionModelImpl(
  permId: json['perm_id'] as String,
  permName: json['perm_name'] as String?,
  permDesc: json['perm_desc'] as String?,
  permPage: json['perm_page'] as String?,
  permSts: (json['perm_sts'] as num?)?.toInt(),
  permCreated: json['perm_created'] == null
      ? null
      : DateTime.parse(json['perm_created'] as String),
  permUpdate: json['perm_update'] == null
      ? null
      : DateTime.parse(json['perm_update'] as String),
);

Map<String, dynamic> _$$PermissionModelImplToJson(
  _$PermissionModelImpl instance,
) => <String, dynamic>{
  'perm_id': instance.permId,
  'perm_name': instance.permName,
  'perm_desc': instance.permDesc,
  'perm_page': instance.permPage,
  'perm_sts': instance.permSts,
  'perm_created': instance.permCreated?.toIso8601String(),
  'perm_update': instance.permUpdate?.toIso8601String(),
};
