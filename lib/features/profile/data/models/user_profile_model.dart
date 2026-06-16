// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'user_email') String? userEmail,
    @JsonKey(name: 'user_phone') String? userPhone,
    @JsonKey(name: 'user_sts') String? userSts,
    @JsonKey(name: 'role_id') String? roleId,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'permissions') List<String>? permissions,
    @JsonKey(name: 'user_created') DateTime? userCreated,
    @JsonKey(name: 'user_update') DateTime? userUpdate,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'];
    final roleMap = role is Map ? role : null;
    return UserProfileModel(
      userId: _stringValue(json['user_id'] ?? json['userId'] ?? json['id']),
      userName: _stringValue(
        json['user_name'] ?? json['userName'] ?? json['name'],
      ),
      userEmail: _nullableString(json['user_email'] ?? json['userEmail']),
      userPhone: _nullableString(json['user_phone'] ?? json['userPhone']),
      userSts: _statusValue(json['user_sts'] ?? json['userSts']),
      roleId: _nullableString(
        json['role_id'] ?? json['roleId'] ?? roleMap?['role_id'],
      ),
      roleName: _nullableString(
        json['role_name'] ?? json['roleName'] ?? roleMap?['role_name'],
      ),
      permissions: _permissionStrings(json['permissions']),
      userCreated: _toDateTime(json['user_created'] ?? json['userCreated']),
      userUpdate: _toDateTime(json['user_update'] ?? json['userUpdate']),
    );
  }

  UserProfile toEntity() => UserProfile(
    userId: userId,
    userName: userName,
    userEmail: userEmail,
    userPhone: userPhone,
    userSts: userSts,
    roleId: roleId,
    roleName: roleName ?? (roleId == 'ROLE001' ? 'Admin' : 'User'),
    permissions: permissions ?? [],
    userCreated: userCreated,
    userUpdate: userUpdate,
  );
}

String _stringValue(dynamic value) => value?.toString().trim() ?? '';

String? _nullableString(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

String? _statusValue(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value ? 'active' : 'inactive';
  if (value is num) return value.toInt() == 1 ? 'active' : 'inactive';
  final text = value.toString().trim();
  if (text == '1') return 'active';
  if (text == '0') return 'inactive';
  return text.isEmpty ? null : text;
}

List<String>? _permissionStrings(dynamic value) {
  if (value is! List) return null;
  return value
      .map((item) {
        if (item is Map) {
          final permission = item['permission'];
          return item['perm_name'] ??
              item['perm_slug'] ??
              (permission is Map ? permission['perm_name'] : null) ??
              (permission is Map ? permission['perm_slug'] : null);
        }
        return item;
      })
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString().trim());
}
