import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String role,
    required List<String> permissions,
    String? avatar,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;
}
