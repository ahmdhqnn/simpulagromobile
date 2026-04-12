// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserProfileModelImpl(
  userId: json['user_id'] as String,
  userName: json['user_name'] as String,
  userEmail: json['user_email'] as String?,
  userPhone: json['user_phone'] as String?,
  userSts: json['user_sts'] as String?,
  roleId: json['role_id'] as String?,
  roleName: json['role_name'] as String?,
  permissions: (json['permissions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  userCreated: json['user_created'] == null
      ? null
      : DateTime.parse(json['user_created'] as String),
  userUpdate: json['user_update'] == null
      ? null
      : DateTime.parse(json['user_update'] as String),
);

Map<String, dynamic> _$$UserProfileModelImplToJson(
  _$UserProfileModelImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'user_name': instance.userName,
  'user_email': instance.userEmail,
  'user_phone': instance.userPhone,
  'user_sts': instance.userSts,
  'role_id': instance.roleId,
  'role_name': instance.roleName,
  'permissions': instance.permissions,
  'user_created': instance.userCreated?.toIso8601String(),
  'user_update': instance.userUpdate?.toIso8601String(),
};
