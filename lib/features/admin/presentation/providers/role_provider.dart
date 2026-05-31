import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/role_remote_datasource.dart';
import '../../data/repositories/role_repository_impl.dart';
import '../../domain/entities/role.dart';
import '../../domain/repositories/role_repository.dart';
import 'permission_provider.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE & REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════
final adminRoleRemoteDatasourceProvider = Provider<RoleRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RoleRemoteDatasourceImpl(dioClient.dio);
});

final adminRoleRepositoryProvider = Provider<RoleRepository>((ref) {
  final datasource = ref.watch(adminRoleRemoteDatasourceProvider);
  return RoleRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// ROLE LIST PROVIDER
// ═══════════════════════════════════════════════════════════
final adminRoleListProvider = FutureProvider<List<Role>>((ref) async {
  final repository = ref.watch(adminRoleRepositoryProvider);
  return repository.getAllRoles();
});

// ═══════════════════════════════════════════════════════════
// ROLE DETAIL PROVIDER
// ═══════════════════════════════════════════════════════════
final adminRoleDetailProvider = FutureProvider.family<Role, String>((
  ref,
  roleId,
) async {
  final repository = ref.watch(adminRoleRepositoryProvider);
  return repository.getRoleById(roleId);
});

// ═══════════════════════════════════════════════════════════
// SELECTED PERMISSIONS STATE (for form checkbox group)
// ═══════════════════════════════════════════════════════════
final selectedPermissionIdsProvider = StateProvider<Set<String>>((ref) => {});

// ═══════════════════════════════════════════════════════════
// ROLE FORM STATE
// ═══════════════════════════════════════════════════════════
class RoleFormState {
  final bool isLoading;
  final String? error;
  final Role? savedRole;

  const RoleFormState({this.isLoading = false, this.error, this.savedRole});

  RoleFormState copyWith({bool? isLoading, String? error, Role? savedRole}) {
    return RoleFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedRole: savedRole ?? this.savedRole,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ROLE FORM NOTIFIER
// ═══════════════════════════════════════════════════════════
class RoleFormNotifier extends StateNotifier<RoleFormState> {
  final RoleRepository _repository;
  final Ref _ref;

  RoleFormNotifier(this._repository, this._ref) : super(const RoleFormState());

  Future<bool> createRole(Role role, List<String> permissionIds) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedRole = await _repository.createRole(role, permissionIds);
      state = RoleFormState(savedRole: savedRole);
      _ref.invalidate(adminRoleListProvider);
      _ref.invalidate(permissionsByRoleProvider(savedRole.roleId));
      _ref.invalidate(rolePermissionsProvider);
      _ref.invalidate(allPermissionsProvider);
      return true;
    } catch (e) {
      state = RoleFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateRole(
    String roleId,
    Role role,
    List<String> permissionIds,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedRole = await _repository.updateRole(
        roleId,
        role,
        permissionIds,
      );
      state = RoleFormState(savedRole: savedRole);
      _ref.invalidate(adminRoleListProvider);
      _ref.invalidate(adminRoleDetailProvider(roleId));
      _ref.invalidate(permissionsByRoleProvider(roleId));
      _ref.invalidate(rolePermissionsProvider);
      _ref.invalidate(allPermissionsProvider);
      return true;
    } catch (e) {
      state = RoleFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteRole(String roleId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteRole(roleId);
      state = const RoleFormState();
      _ref.invalidate(adminRoleListProvider);
      return true;
    } catch (e) {
      state = RoleFormState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const RoleFormState();
  }
}

// ═══════════════════════════════════════════════════════════
// ROLE FORM PROVIDER
// ═══════════════════════════════════════════════════════════
final adminRoleFormProvider =
    StateNotifierProvider<RoleFormNotifier, RoleFormState>((ref) {
      final repository = ref.watch(adminRoleRepositoryProvider);
      return RoleFormNotifier(repository, ref);
    });
