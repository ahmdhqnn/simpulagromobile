import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/permission_remote_datasource.dart';
import '../../data/repositories/permission_repository_impl.dart';
import '../../domain/entities/permission.dart';
import '../../domain/entities/role_permission_row.dart';
import '../../domain/entities/role_with_permissions.dart';
import '../../domain/repositories/permission_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE & REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════
final adminPermissionRemoteDatasourceProvider =
    Provider<PermissionRemoteDatasource>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return PermissionRemoteDatasourceImpl(dioClient.dio);
    });

final adminPermissionRepositoryProvider = Provider<PermissionRepository>((ref) {
  final datasource = ref.watch(adminPermissionRemoteDatasourceProvider);
  return PermissionRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// ALL PERMISSIONS PROVIDER (for list screen & role form)
// ═══════════════════════════════════════════════════════════
final allPermissionsProvider = FutureProvider<List<Permission>>((ref) async {
  final repository = ref.watch(adminPermissionRepositoryProvider);
  return repository.getAllPermissions();
});

// ═══════════════════════════════════════════════════════════
// PERMISSIONS BY ROLE PROVIDER
// ═══════════════════════════════════════════════════════════
final permissionsByRoleProvider =
    FutureProvider.family<List<Permission>, String>((ref, roleId) async {
      final repository = ref.watch(adminPermissionRepositoryProvider);
      return repository.getPermissionsByRole(roleId);
    });

final rolePermissionsProvider = FutureProvider<List<RoleWithPermissions>>((
  ref,
) async {
  final repository = ref.watch(adminPermissionRepositoryProvider);
  return repository.getRolePermissions();
});

final rolePermissionRowsProvider =
    FutureProvider.family<List<RolePermissionRow>, String>((ref, roleId) async {
      final repository = ref.watch(adminPermissionRepositoryProvider);
      return repository.getRolePermissionRows(roleId);
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

class RolePermissionMutationState {
  const RolePermissionMutationState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  RolePermissionMutationState copyWith({bool? isLoading, String? error}) {
    return RolePermissionMutationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RolePermissionMutationNotifier
    extends StateNotifier<RolePermissionMutationState> {
  RolePermissionMutationNotifier(this._repository, this._ref)
    : super(const RolePermissionMutationState());

  final PermissionRepository _repository;
  final Ref _ref;

  Future<bool> updateRolePermission(RolePermissionRow row) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateRolePermission(row);
      if (row.roleId != null) {
        _ref.invalidate(rolePermissionRowsProvider(row.roleId!));
        _ref.invalidate(permissionsByRoleProvider(row.roleId!));
      }
      _ref.invalidate(rolePermissionsProvider);
      state = const RolePermissionMutationState();
      return true;
    } catch (e) {
      state = RolePermissionMutationState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteRolePermission({
    required String roleId,
    required String permId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteRolePermission(permId, roleId);
      _ref.invalidate(rolePermissionRowsProvider(roleId));
      _ref.invalidate(permissionsByRoleProvider(roleId));
      _ref.invalidate(rolePermissionsProvider);
      state = const RolePermissionMutationState();
      return true;
    } catch (e) {
      state = RolePermissionMutationState(error: e.toString());
      return false;
    }
  }
}

final rolePermissionMutationProvider =
    StateNotifierProvider<
      RolePermissionMutationNotifier,
      RolePermissionMutationState
    >((ref) {
      final repository = ref.watch(adminPermissionRepositoryProvider);
      return RolePermissionMutationNotifier(repository, ref);
    });
