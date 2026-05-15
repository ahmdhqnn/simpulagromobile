import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userId,
    required super.userName,
    super.userEmail,
    super.userPhone,
    super.userSts,
    super.roleId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'],
      userPhone: json['user_phone'],
      userSts: json['user_sts'],
      roleId: json['role_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'user_sts': userSts,
      'role_id': roleId,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString));
  }
}

/// Response model for login endpoint.
/// Backend returns: { access_token, refresh_token, expires_in, token_type, user }
class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final UserModel user;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'] ?? json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresIn: json['expires_in'] ?? 3600,
      tokenType: json['token_type'] ?? 'Bearer',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
