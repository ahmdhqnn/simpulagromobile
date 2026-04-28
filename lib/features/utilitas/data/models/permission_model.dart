// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/permission.dart';

part 'permission_model.freezed.dart';
part 'permission_model.g.dart';

@freezed
class PermissionModel with _$PermissionModel {
  const PermissionModel._();

  const factory PermissionModel({
    @JsonKey(name: 'perm_id') required String permId,
    @JsonKey(name: 'perm_name') String? permName,
    @JsonKey(name: 'perm_desc') String? permDesc,
    @JsonKey(name: 'perm_page') String? permPage,
    @JsonKey(name: 'perm_sts') int? permSts,
    @JsonKey(name: 'perm_created') DateTime? permCreated,
    @JsonKey(name: 'perm_update') DateTime? permUpdate,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);

  /// Convert Model to Entity
  Permission toEntity() => Permission(
    permId: permId,
    permName: permName,
    permDesc: permDesc,
    permPage: permPage,
    permSts: permSts,
    permCreated: permCreated,
    permUpdate: permUpdate,
  );

  /// Convert Entity to Model
  factory PermissionModel.fromEntity(Permission entity) => PermissionModel(
    permId: entity.permId,
    permName: entity.permName,
    permDesc: entity.permDesc,
    permPage: entity.permPage,
    permSts: entity.permSts,
    permCreated: entity.permCreated,
    permUpdate: entity.permUpdate,
  );
}
