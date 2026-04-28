import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Provider untuk mendapatkan semua permissions user yang sedang login
/// Reuse permissions from AuthState to avoid duplicate API calls
final userPermissionsProvider = Provider<List<String>>((ref) {
  final authState = ref.watch(authProvider);
  return authState.permissions;
});

/// Provider untuk check apakah user punya permission tertentu
final hasPermissionProvider = Provider.family<bool, String>((ref, permission) {
  final permissions = ref.watch(userPermissionsProvider);
  return permissions.contains(permission);
});

/// Provider untuk check apakah user adalah Admin
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.roleId == 'ROLE001'; // ROLE001 = Admin
});
