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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

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
