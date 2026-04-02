// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'phone') required String phone,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'permissions') required List<String> permissions,
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  UserProfile toEntity() => UserProfile(
    id: id,
    name: name,
    email: email,
    phone: phone,
    role: role,
    permissions: permissions,
    avatar: avatar,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
