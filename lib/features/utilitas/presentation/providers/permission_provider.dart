import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/permission_remote_datasource.dart';
import '../../data/repositories/permission_repository_impl.dart';
import '../../domain/entities/permission.dart';
import '../../domain/repositories/permission_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE & REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════
final permissionRemoteDatasourceProvider = Provider<PermissionRemoteDatasource>(
  (ref) {
    final dioClient = ref.watch(dioClientProvider);
    return PermissionRemoteDatasourceImpl(dioClient.dio);
  },
);

final permissionRepositoryProvider = Provider<PermissionRepository>((ref) {
  final datasource = ref.watch(permissionRemoteDatasourceProvider);
  return PermissionRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// ALL PERMISSIONS PROVIDER (for list screen & role form)
// ═══════════════════════════════════════════════════════════
final allPermissionsProvider = FutureProvider<List<Permission>>((ref) async {
  final repository = ref.watch(permissionRepositoryProvider);
  return repository.getAllPermissions();
});

// ═══════════════════════════════════════════════════════════
// PERMISSIONS BY ROLE PROVIDER
// ═══════════════════════════════════════════════════════════
final permissionsByRoleProvider =
    FutureProvider.family<List<Permission>, String>((ref, roleId) async {
      final repository = ref.watch(permissionRepositoryProvider);
      return repository.getPermissionsByRole(roleId);
    });

// ═══════════════════════════════════════════════════════════
// GROUPED PERMISSIONS PROVIDER (by resource for display)
// ═══════════════════════════════════════════════════════════
final groupedPermissionsProvider =
    FutureProvider<Map<String, List<Permission>>>((ref) async {
      final permissions = await ref.watch(allPermissionsProvider.future);

      final grouped = <String, List<Permission>>{};
      for (final perm in permissions) {
        final resource = perm.resource ?? 'other';
        grouped.putIfAbsent(resource, () => []).add(perm);
      }

      // Sort keys alphabetically
      return Map.fromEntries(
        grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
    });
