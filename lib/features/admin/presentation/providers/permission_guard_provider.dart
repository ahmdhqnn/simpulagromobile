import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Admin permission names for the current authenticated user.
///
/// Reads from AuthState to avoid duplicate profile permission API calls.
final adminUserPermissionsProvider = Provider<List<String>>((ref) {
  final authState = ref.watch(authProvider);
  return authState.permissions;
});

/// Provider untuk check apakah user punya permission tertentu
final hasPermissionProvider = Provider.family<bool, String>((ref, permission) {
  final permissions = ref.watch(adminUserPermissionsProvider);
  return permissions.contains(permission);
});

/// Provider untuk check apakah user adalah Admin
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.roleId == 'ROLE001'; // ROLE001 = Admin
});
