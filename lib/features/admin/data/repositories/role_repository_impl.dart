import '../../domain/entities/role.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/role_remote_datasource.dart';
import '../models/role_model.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDatasource remoteDatasource;

  RoleRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Role>> getAllRoles() async {
    try {
      final models = await remoteDatasource.getAllRoles();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Role> getRoleById(String roleId) async {
    try {
      final model = await remoteDatasource.getRoleById(roleId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Role> createRole(Role role, List<String> permissionIds) async {
    try {
      final model = RoleModel.fromEntity(role);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'role_created' ||
            key == 'role_update' ||
            key == 'list_permission',
      );

      final createdModel = await remoteDatasource.createRole(data);
      if (permissionIds.isNotEmpty) {
        await remoteDatasource.assignPermissions(
          createdModel.roleId,
          permissionIds.toSet().toList(),
        );
      }
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Role> updateRole(
    String roleId,
    Role role,
    List<String>? permissionIds,
  ) async {
    try {
      final currentRole = await remoteDatasource.getRoleById(roleId);
      final model = RoleModel.fromEntity(role);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'role_id' ||
            key == 'role_created' ||
            key == 'role_update' ||
            key == 'list_permission',
      );

      final updatedModel = await remoteDatasource.updateRole(roleId, data);

      if (permissionIds != null) {
        final currentIds = currentRole.listPermission
            .map((rp) => rp.permId)
            .whereType<String>()
            .toSet();
        final targetIds = permissionIds.toSet();

        final toAdd = targetIds.difference(currentIds).toList();
        final toRemove = currentIds.difference(targetIds).toList();

        if (toAdd.isNotEmpty) {
          await remoteDatasource.assignPermissions(roleId, toAdd);
        }

        for (final permId in toRemove) {
          await remoteDatasource.removePermission(permId, roleId);
        }
      }

      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRole(String roleId) async {
    try {
      await remoteDatasource.deleteRole(roleId);
    } catch (e) {
      rethrow;
    }
  }
}
