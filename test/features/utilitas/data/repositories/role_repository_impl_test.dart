import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/features/utilitas/data/datasources/role_remote_datasource.dart';
import 'package:simpulagromobile/features/utilitas/data/repositories/role_repository_impl.dart';
import 'package:simpulagromobile/features/utilitas/data/models/role_model.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/role.dart';

class MockRoleRemoteDatasource extends Mock implements RoleRemoteDatasource {}

void main() {
  late MockRoleRemoteDatasource mockDatasource;
  late RoleRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockRoleRemoteDatasource();
    repository = RoleRepositoryImpl(mockDatasource);
  });

  group('RoleRepositoryImpl Tests', () {
    const dummyRole = Role(
      roleId: 'ROLE002',
      roleName: 'Staff',
      roleDesc: 'Staff member',
      roleSts: 1,
    );

    final dummyRoleModel = RoleModel.fromEntity(dummyRole);

    test('createRole calls remote datasource createRole and does not assign permissions', () async {
      when(() => mockDatasource.createRole(any())).thenAnswer((_) async => dummyRoleModel);

      final result = await repository.createRole(dummyRole, ['perm_1', 'perm_2']);

      expect(result.roleId, equals('ROLE002'));
      expect(result.roleName, equals('Staff'));

      verify(() => mockDatasource.createRole({
            'role_id': 'ROLE002',
            'role_name': 'Staff',
            'role_desc': 'Staff member',
            'role_sts': 1,
          })).called(1);

      // Verify that no assignPermissions or removePermission was called
      verifyNever(() => mockDatasource.assignPermissions(any(), any()));
      verifyNever(() => mockDatasource.removePermission(any(), any()));
    });

    test('updateRole calls remote datasource updateRole and does not modify permissions', () async {
      when(() => mockDatasource.updateRole(any(), any())).thenAnswer((_) async => dummyRoleModel);

      final result = await repository.updateRole('ROLE002', dummyRole, ['perm_3']);

      expect(result.roleId, equals('ROLE002'));

      verify(() => mockDatasource.updateRole('ROLE002', {
            'role_name': 'Staff',
            'role_desc': 'Staff member',
            'role_sts': 1,
          })).called(1);

      // Verify that no assignPermissions or removePermission was called
      verifyNever(() => mockDatasource.assignPermissions(any(), any()));
      verifyNever(() => mockDatasource.removePermission(any(), any()));
    });
  });
}
