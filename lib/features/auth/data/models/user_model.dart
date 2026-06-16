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
      userId: _stringValue(json['user_id'] ?? json['userId'] ?? json['id']),
      userName: _stringValue(
        json['user_name'] ?? json['userName'] ?? json['name'],
      ),
      userEmail: _nullableString(json['user_email'] ?? json['userEmail']),
      userPhone: _nullableString(json['user_phone'] ?? json['userPhone']),
      userSts: _statusValue(json['user_sts'] ?? json['userSts']),
      roleId: _nullableString(json['role_id'] ?? json['roleId']),
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
    final source = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    final userData = source['user'] ?? {};
    return LoginResponseModel(
      accessToken: _stringValue(
        source['access_token'] ?? source['accessToken'] ?? source['token'],
      ),
      refreshToken: _stringValue(
        source['refresh_token'] ?? source['refreshToken'],
      ),
      expiresIn: _intValue(source['expires_in'] ?? source['expiresIn']) ?? 3600,
      tokenType:
          _stringValue(source['token_type'] ?? source['tokenType']).isEmpty
          ? 'Bearer'
          : _stringValue(source['token_type'] ?? source['tokenType']),
      user: UserModel.fromJson(
        userData is Map ? Map<String, dynamic>.from(userData) : {},
      ),
    );
  }
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

int? _intValue(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}
