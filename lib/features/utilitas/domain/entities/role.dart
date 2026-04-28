import 'package:freezed_annotation/freezed_annotation.dart';
import 'permission.dart';

part 'role.freezed.dart';

@freezed
class Role with _$Role {
  const Role._();

  const factory Role({
    required String roleId,
    String? roleName,
    String? roleDesc,
    int? roleSts,
    DateTime? roleCreated,
    DateTime? roleUpdate,
    @Default([]) List<Permission> permissions,
  }) = _Role;

  /// Check if role is active
  bool get isActive => roleSts == 1;

  /// Get display name (fallback to ID if name is null)
  String get displayName => roleName ?? roleId;

  /// Get permission count
  int get permissionCount => permissions.length;

  /// Check if role has specific permission
  bool hasPermission(String permissionCode) {
    return permissions.any((p) => p.permName == permissionCode);
  }
}
