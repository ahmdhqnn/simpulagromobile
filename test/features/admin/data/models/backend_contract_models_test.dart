import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/admin/data/models/backend_contract_models.dart';
import 'package:simpulagromobile/features/admin/data/models/permission_model.dart';

void main() {
  group('Admin backend contract model parsing', () {
    test('PermissionModel parses Swagger permission payload', () {
      final model = PermissionModel.fromJson({
        'perm_id': 'PM001',
        'perm_name': 'User Management',
        'perm_slug': 'user-management',
        'perm_desc': 'Permission to manage users',
        'perm_page': '/sites/[siteId]/users',
        'perm_sts': 1,
      });

      expect(model.permId, 'PM001');
      expect(model.permName, 'User Management');
      expect(model.permSlug, 'user-management');
      expect(model.permSts, 1);
    });

    test('RolePermissionRowModel parses CRUD flags and nested permission', () {
      final row = RolePermissionRowModel.fromJson({
        'rp_id': 'RP001',
        'rp_sts': '1',
        'can_view': 'true',
        'can_create': 1,
        'can_edit': false,
        'can_delete': 0,
        'permission': {
          'perm_id': 'PM001',
          'perm_name': 'User Management',
          'perm_sts': 1,
        },
      });

      expect(row.rpId, 'RP001');
      expect(row.rpSts, 1);
      expect(row.canView, isTrue);
      expect(row.canCreate, isTrue);
      expect(row.canEdit, isFalse);
      expect(row.canDelete, isFalse);
      expect(row.permission?.permId, 'PM001');
    });

    test('RoleWithPermissionsModel parses role + list_permission payload', () {
      final model = RoleWithPermissionsModel.fromJson({
        'role_id': 'ROLE001',
        'role_name': 'Admin',
        'list_permission': [
          {
            'rp_id': 'RP001',
            'rp_sts': 1,
            'permission': {'perm_id': 'PM001'},
          },
        ],
      });

      expect(model.roleId, 'ROLE001');
      expect(model.roleName, 'Admin');
      expect(model.listPermission, hasLength(1));
      expect(model.listPermission.first.permission?.permId, 'PM001');
    });

    test('VarietasItemModel parses varietas payload', () {
      final model = VarietasItemModel.fromJson({
        'varietas_id': 'VAR_001',
        'varietas_name': 'IR64',
        'varietas_desc': 'Padi sawah unggulan',
        'varietas_sts': '1',
        'varietas_update': '2026-05-28T10:00:00.000Z',
      });

      expect(model.varietasId, 'VAR_001');
      expect(model.varietasName, 'IR64');
      expect(model.varietasSts, 1);
      expect(model.varietasUpdate, DateTime.parse('2026-05-28T10:00:00.000Z'));
    });

    test('DeviceSensorRangeModel parses threshold range payload', () {
      final model = DeviceSensorRangeModel.fromJson({
        'dev_id': 'DEV_001',
        'ds_id': 'DS_001',
        'ds_max_norm_value': '30',
        'ds_min_norm_value': 20,
        'ds_max_val_warn': '38.5',
        'ds_min_val_warn': '12',
        'ds_max_value': 40,
        'ds_min_value': '10',
      });

      expect(model.devId, 'DEV_001');
      expect(model.dsId, 'DS_001');
      expect(model.dsMaxNormValue, 30);
      expect(model.dsMinNormValue, 20);
      expect(model.dsMaxValWarn, 38.5);
      expect(model.dsMinValWarn, 12);
      expect(model.dsMaxValue, 40);
      expect(model.dsMinValue, 10);
    });
  });
}
