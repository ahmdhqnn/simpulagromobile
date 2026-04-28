// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/role.dart';
import 'permission_model.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
class RoleModel with _$RoleModel {
  const RoleModel._();

  const factory RoleModel({
    @JsonKey(name: 'role_id') required String roleId,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'role_desc') String? roleDesc,
    @JsonKey(name: 'role_sts') int? roleSts,
    @JsonKey(name: 'role_created') DateTime? roleCreated,
    @JsonKey(name: 'role_update') DateTime? roleUpdate,
    @JsonKey(name: 'list_permission')
    @Default([])
    List<RolePermissionModel> listPermission,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  /// Convert Model to Entity
  Role toEntity() => Role(
    roleId: roleId,
    roleName: roleName,
    roleDesc: roleDesc,
    roleSts: roleSts,
    roleCreated: roleCreated,
    roleUpdate: roleUpdate,
    permissions: listPermission
        .where((rp) => rp.permission != null)
        .map((rp) => rp.permission!.toEntity())
        .toList(),
  );

  /// Convert Entity to Model
  factory RoleModel.fromEntity(Role entity) => RoleModel(
    roleId: entity.roleId,
    roleName: entity.roleName,
    roleDesc: entity.roleDesc,
    roleSts: entity.roleSts,
    roleCreated: entity.roleCreated,
    roleUpdate: entity.roleUpdate,
    listPermission: entity.permissions
        .map(
          (p) => RolePermissionModel(
            rpId: '',
            roleId: entity.roleId,
            permId: p.permId,
            rpSts: 1,
            permission: PermissionModel.fromEntity(p),
          ),
        )
        .toList(),
  );
}

@freezed
class RolePermissionModel with _$RolePermissionModel {
  const factory RolePermissionModel({
    @JsonKey(name: 'rp_id') required String rpId,
    @JsonKey(name: 'role_id') required String roleId,
    @JsonKey(name: 'perm_id') required String permId,
    @JsonKey(name: 'rp_sts') required int rpSts,
    @JsonKey(name: 'permission') PermissionModel? permission,
  }) = _RolePermissionModel;

  factory RolePermissionModel.fromJson(Map<String, dynamic> json) =>
      _$RolePermissionModelFromJson(json);
}
