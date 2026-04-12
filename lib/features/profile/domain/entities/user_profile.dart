import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    required String userName,
    String? userEmail,
    String? userPhone,
    String? userSts,
    String? roleId,
    String? roleName,
    @Default([]) List<String> permissions,
    DateTime? userCreated,
    DateTime? userUpdate,
  }) = _UserProfile;
}
