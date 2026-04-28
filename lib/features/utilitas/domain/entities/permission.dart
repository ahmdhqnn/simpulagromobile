import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission.freezed.dart';

@freezed
class Permission with _$Permission {
  const Permission._();

  const factory Permission({
    required String permId,
    String? permName,
    String? permDesc,
    String? permPage,
    int? permSts,
    DateTime? permCreated,
    DateTime? permUpdate,
  }) = _Permission;

  /// Check if permission is active
  bool get isActive => permSts == 1;

  /// Get display name (fallback to code if name is null)
  String get displayName => permName ?? permId;

  /// Get resource from permission code (e.g., "user" from "user:create")
  String? get resource {
    if (permName == null) return null;
    final parts = permName!.split(':');
    return parts.isNotEmpty ? parts[0] : null;
  }

  /// Get action from permission code (e.g., "create" from "user:create")
  String? get action {
    if (permName == null) return null;
    final parts = permName!.split(':');
    return parts.length > 1 ? parts[1] : null;
  }
}
