import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/permission_model.dart';

abstract class PermissionRemoteDatasource {
  Future<List<PermissionModel>> getAllPermissions();
  Future<List<PermissionModel>> getPermissionsByRole(String roleId);
}

class PermissionRemoteDatasourceImpl implements PermissionRemoteDatasource {
  final Dio dio;

  PermissionRemoteDatasourceImpl(this.dio);

  @override
  Future<List<PermissionModel>> getAllPermissions() async {
    throw const UnsupportedBackendEndpointException(
      'CRUD permission tidak tersedia. Gunakan GET /profile/permissions.',
    );
  }

  @override
  Future<List<PermissionModel>> getPermissionsByRole(String roleId) async {
    throw const UnsupportedBackendEndpointException(
      'Permission per role tidak tersedia di backend live.',
    );
  }

}
