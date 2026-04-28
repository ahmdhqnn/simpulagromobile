import '../../domain/entities/permission.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/permission_remote_datasource.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionRemoteDatasource remoteDatasource;

  PermissionRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Permission>> getAllPermissions() async {
    try {
      final models = await remoteDatasource.getAllPermissions();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Permission>> getPermissionsByRole(String roleId) async {
    try {
      final models = await remoteDatasource.getPermissionsByRole(roleId);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Stubs — not used in read-only permission screen
  @override
  Future<Permission> getPermissionById(String permissionId) {
    throw UnimplementedError();
  }

  @override
  Future<Permission> createPermission(Permission permission) {
    throw UnimplementedError();
  }

  @override
  Future<Permission> updatePermission(
    String permissionId,
    Permission permission,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePermission(String permissionId) {
    throw UnimplementedError();
  }
}
