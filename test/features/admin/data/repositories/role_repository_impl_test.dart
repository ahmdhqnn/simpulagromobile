import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/features/admin/data/datasources/role_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/models/role_model.dart';
import 'package:simpulagromobile/features/admin/data/repositories/role_repository_impl.dart';
import 'package:simpulagromobile/features/admin/domain/entities/role.dart';

class MockRoleRemoteDatasource extends Mock implements RoleRemoteDatasource {}

void main() {
  late MockRoleRemoteDatasource mockDatasource;
  late RoleRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(<String, dynamic>{});
  });

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

    test(
      'createRole calls role endpoint then assigns selected permissions',
      () async {
        when(
          () => mockDatasource.createRole(any()),
        ).thenAnswer((_) async => dummyRoleModel);
        when(
          () => mockDatasource.assignPermissions(any(), any()),
        ).thenAnswer((_) async {});

        final result = await repository.createRole(dummyRole, [
          'perm_1',
          'perm_2',
        ]);

        expect(result.roleId, equals('ROLE002'));
        expect(result.roleName, equals('Staff'));

        verify(
          () => mockDatasource.createRole({
            'role_id': 'ROLE002',
            'role_name': 'Staff',
            'role_desc': 'Staff member',
            'role_sts': 1,
          }),
        ).called(1);
        verify(
          () =>
              mockDatasource.assignPermissions('ROLE002', ['perm_1', 'perm_2']),
        ).called(1);
      },
    );

    test(
      'updateRole diffs permissions and calls assign/remove accordingly',
      () async {
        final currentRoleModel = RoleModel(
          roleId: 'ROLE002',
          roleName: 'Staff',
          roleDesc: 'Staff member',
          roleSts: 1,
          listPermission: const [
            RolePermissionModel(permId: 'perm_1'),
            RolePermissionModel(permId: 'perm_2'),
          ],
        );

        when(
          () => mockDatasource.getRoleById('ROLE002'),
        ).thenAnswer((_) async => currentRoleModel);
        when(
          () => mockDatasource.updateRole(any(), any()),
        ).thenAnswer((_) async => dummyRoleModel);
        when(
          () => mockDatasource.assignPermissions(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => mockDatasource.removePermission(any(), any()),
        ).thenAnswer((_) async {});

        final result = await repository.updateRole('ROLE002', dummyRole, [
          'perm_2',
          'perm_3',
        ]);

        expect(result.roleId, equals('ROLE002'));

        verify(() => mockDatasource.getRoleById('ROLE002')).called(1);
        verify(
          () => mockDatasource.updateRole('ROLE002', {
            'role_name': 'Staff',
            'role_desc': 'Staff member',
            'role_sts': 1,
          }),
        ).called(1);
        verify(
          () => mockDatasource.assignPermissions('ROLE002', ['perm_3']),
        ).called(1);
        verify(
          () => mockDatasource.removePermission('perm_1', 'ROLE002'),
        ).called(1);
      },
    );
  });
}
