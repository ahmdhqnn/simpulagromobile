// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) {
  return _RoleModel.fromJson(json);
}

/// @nodoc
mixin _$RoleModel {
  @JsonKey(name: 'role_id')
  String get roleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_name')
  String? get roleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_desc')
  String? get roleDesc => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_sts')
  int? get roleSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_created')
  DateTime? get roleCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_update')
  DateTime? get roleUpdate => throw _privateConstructorUsedError;
  @JsonKey(name: 'list_permission')
  List<RolePermissionModel> get listPermission =>
      throw _privateConstructorUsedError;

  /// Serializes this RoleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleModelCopyWith<RoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleModelCopyWith<$Res> {
  factory $RoleModelCopyWith(RoleModel value, $Res Function(RoleModel) then) =
      _$RoleModelCopyWithImpl<$Res, RoleModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'role_id') String roleId,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'role_desc') String? roleDesc,
    @JsonKey(name: 'role_sts') int? roleSts,
    @JsonKey(name: 'role_created') DateTime? roleCreated,
    @JsonKey(name: 'role_update') DateTime? roleUpdate,
    @JsonKey(name: 'list_permission') List<RolePermissionModel> listPermission,
  });
}

/// @nodoc
class _$RoleModelCopyWithImpl<$Res, $Val extends RoleModel>
    implements $RoleModelCopyWith<$Res> {
  _$RoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? roleName = freezed,
    Object? roleDesc = freezed,
    Object? roleSts = freezed,
    Object? roleCreated = freezed,
    Object? roleUpdate = freezed,
    Object? listPermission = null,
  }) {
    return _then(
      _value.copyWith(
            roleId: null == roleId
                ? _value.roleId
                : roleId // ignore: cast_nullable_to_non_nullable
                      as String,
            roleName: freezed == roleName
                ? _value.roleName
                : roleName // ignore: cast_nullable_to_non_nullable
                      as String?,
            roleDesc: freezed == roleDesc
                ? _value.roleDesc
                : roleDesc // ignore: cast_nullable_to_non_nullable
                      as String?,
            roleSts: freezed == roleSts
                ? _value.roleSts
                : roleSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            roleCreated: freezed == roleCreated
                ? _value.roleCreated
                : roleCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            roleUpdate: freezed == roleUpdate
                ? _value.roleUpdate
                : roleUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            listPermission: null == listPermission
                ? _value.listPermission
                : listPermission // ignore: cast_nullable_to_non_nullable
                      as List<RolePermissionModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoleModelImplCopyWith<$Res>
    implements $RoleModelCopyWith<$Res> {
  factory _$$RoleModelImplCopyWith(
    _$RoleModelImpl value,
    $Res Function(_$RoleModelImpl) then,
  ) = __$$RoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'role_id') String roleId,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'role_desc') String? roleDesc,
    @JsonKey(name: 'role_sts') int? roleSts,
    @JsonKey(name: 'role_created') DateTime? roleCreated,
    @JsonKey(name: 'role_update') DateTime? roleUpdate,
    @JsonKey(name: 'list_permission') List<RolePermissionModel> listPermission,
  });
}

/// @nodoc
class __$$RoleModelImplCopyWithImpl<$Res>
    extends _$RoleModelCopyWithImpl<$Res, _$RoleModelImpl>
    implements _$$RoleModelImplCopyWith<$Res> {
  __$$RoleModelImplCopyWithImpl(
    _$RoleModelImpl _value,
    $Res Function(_$RoleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? roleName = freezed,
    Object? roleDesc = freezed,
    Object? roleSts = freezed,
    Object? roleCreated = freezed,
    Object? roleUpdate = freezed,
    Object? listPermission = null,
  }) {
    return _then(
      _$RoleModelImpl(
        roleId: null == roleId
            ? _value.roleId
            : roleId // ignore: cast_nullable_to_non_nullable
                  as String,
        roleName: freezed == roleName
            ? _value.roleName
            : roleName // ignore: cast_nullable_to_non_nullable
                  as String?,
        roleDesc: freezed == roleDesc
            ? _value.roleDesc
            : roleDesc // ignore: cast_nullable_to_non_nullable
                  as String?,
        roleSts: freezed == roleSts
            ? _value.roleSts
            : roleSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        roleCreated: freezed == roleCreated
            ? _value.roleCreated
            : roleCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        roleUpdate: freezed == roleUpdate
            ? _value.roleUpdate
            : roleUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        listPermission: null == listPermission
            ? _value._listPermission
            : listPermission // ignore: cast_nullable_to_non_nullable
                  as List<RolePermissionModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoleModelImpl extends _RoleModel {
  const _$RoleModelImpl({
    @JsonKey(name: 'role_id') required this.roleId,
    @JsonKey(name: 'role_name') this.roleName,
    @JsonKey(name: 'role_desc') this.roleDesc,
    @JsonKey(name: 'role_sts') this.roleSts,
    @JsonKey(name: 'role_created') this.roleCreated,
    @JsonKey(name: 'role_update') this.roleUpdate,
    @JsonKey(name: 'list_permission')
    final List<RolePermissionModel> listPermission = const [],
  }) : _listPermission = listPermission,
       super._();

  factory _$RoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleModelImplFromJson(json);

  @override
  @JsonKey(name: 'role_id')
  final String roleId;
  @override
  @JsonKey(name: 'role_name')
  final String? roleName;
  @override
  @JsonKey(name: 'role_desc')
  final String? roleDesc;
  @override
  @JsonKey(name: 'role_sts')
  final int? roleSts;
  @override
  @JsonKey(name: 'role_created')
  final DateTime? roleCreated;
  @override
  @JsonKey(name: 'role_update')
  final DateTime? roleUpdate;
  final List<RolePermissionModel> _listPermission;
  @override
  @JsonKey(name: 'list_permission')
  List<RolePermissionModel> get listPermission {
    if (_listPermission is EqualUnmodifiableListView) return _listPermission;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listPermission);
  }

  @override
  String toString() {
    return 'RoleModel(roleId: $roleId, roleName: $roleName, roleDesc: $roleDesc, roleSts: $roleSts, roleCreated: $roleCreated, roleUpdate: $roleUpdate, listPermission: $listPermission)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleModelImpl &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.roleDesc, roleDesc) ||
                other.roleDesc == roleDesc) &&
            (identical(other.roleSts, roleSts) || other.roleSts == roleSts) &&
            (identical(other.roleCreated, roleCreated) ||
                other.roleCreated == roleCreated) &&
            (identical(other.roleUpdate, roleUpdate) ||
                other.roleUpdate == roleUpdate) &&
            const DeepCollectionEquality().equals(
              other._listPermission,
              _listPermission,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    roleId,
    roleName,
    roleDesc,
    roleSts,
    roleCreated,
    roleUpdate,
    const DeepCollectionEquality().hash(_listPermission),
  );

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      __$$RoleModelImplCopyWithImpl<_$RoleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleModelImplToJson(this);
  }
}

abstract class _RoleModel extends RoleModel {
  const factory _RoleModel({
    @JsonKey(name: 'role_id') required final String roleId,
    @JsonKey(name: 'role_name') final String? roleName,
    @JsonKey(name: 'role_desc') final String? roleDesc,
    @JsonKey(name: 'role_sts') final int? roleSts,
    @JsonKey(name: 'role_created') final DateTime? roleCreated,
    @JsonKey(name: 'role_update') final DateTime? roleUpdate,
    @JsonKey(name: 'list_permission')
    final List<RolePermissionModel> listPermission,
  }) = _$RoleModelImpl;
  const _RoleModel._() : super._();

  factory _RoleModel.fromJson(Map<String, dynamic> json) =
      _$RoleModelImpl.fromJson;

  @override
  @JsonKey(name: 'role_id')
  String get roleId;
  @override
  @JsonKey(name: 'role_name')
  String? get roleName;
  @override
  @JsonKey(name: 'role_desc')
  String? get roleDesc;
  @override
  @JsonKey(name: 'role_sts')
  int? get roleSts;
  @override
  @JsonKey(name: 'role_created')
  DateTime? get roleCreated;
  @override
  @JsonKey(name: 'role_update')
  DateTime? get roleUpdate;
  @override
  @JsonKey(name: 'list_permission')
  List<RolePermissionModel> get listPermission;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RolePermissionModel _$RolePermissionModelFromJson(Map<String, dynamic> json) {
  return _RolePermissionModel.fromJson(json);
}

/// @nodoc
mixin _$RolePermissionModel {
  @JsonKey(name: 'rp_id')
  String? get rpId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_id')
  String? get roleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'perm_id')
  String? get permId => throw _privateConstructorUsedError;
  @JsonKey(name: 'rp_sts')
  int? get rpSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_view')
  bool? get canView => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_create')
  bool? get canCreate => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_edit')
  bool? get canEdit => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_delete')
  bool? get canDelete => throw _privateConstructorUsedError;
  @JsonKey(name: 'permission')
  PermissionModel? get permission => throw _privateConstructorUsedError;

  /// Serializes this RolePermissionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RolePermissionModelCopyWith<RolePermissionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RolePermissionModelCopyWith<$Res> {
  factory $RolePermissionModelCopyWith(
    RolePermissionModel value,
    $Res Function(RolePermissionModel) then,
  ) = _$RolePermissionModelCopyWithImpl<$Res, RolePermissionModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'rp_id') String? rpId,
    @JsonKey(name: 'role_id') String? roleId,
    @JsonKey(name: 'perm_id') String? permId,
    @JsonKey(name: 'rp_sts') int? rpSts,
    @JsonKey(name: 'can_view') bool? canView,
    @JsonKey(name: 'can_create') bool? canCreate,
    @JsonKey(name: 'can_edit') bool? canEdit,
    @JsonKey(name: 'can_delete') bool? canDelete,
    @JsonKey(name: 'permission') PermissionModel? permission,
  });

  $PermissionModelCopyWith<$Res>? get permission;
}

/// @nodoc
class _$RolePermissionModelCopyWithImpl<$Res, $Val extends RolePermissionModel>
    implements $RolePermissionModelCopyWith<$Res> {
  _$RolePermissionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rpId = freezed,
    Object? roleId = freezed,
    Object? permId = freezed,
    Object? rpSts = freezed,
    Object? canView = freezed,
    Object? canCreate = freezed,
    Object? canEdit = freezed,
    Object? canDelete = freezed,
    Object? permission = freezed,
  }) {
    return _then(
      _value.copyWith(
            rpId: freezed == rpId
                ? _value.rpId
                : rpId // ignore: cast_nullable_to_non_nullable
                      as String?,
            roleId: freezed == roleId
                ? _value.roleId
                : roleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            permId: freezed == permId
                ? _value.permId
                : permId // ignore: cast_nullable_to_non_nullable
                      as String?,
            rpSts: freezed == rpSts
                ? _value.rpSts
                : rpSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            canView: freezed == canView
                ? _value.canView
                : canView // ignore: cast_nullable_to_non_nullable
                      as bool?,
            canCreate: freezed == canCreate
                ? _value.canCreate
                : canCreate // ignore: cast_nullable_to_non_nullable
                      as bool?,
            canEdit: freezed == canEdit
                ? _value.canEdit
                : canEdit // ignore: cast_nullable_to_non_nullable
                      as bool?,
            canDelete: freezed == canDelete
                ? _value.canDelete
                : canDelete // ignore: cast_nullable_to_non_nullable
                      as bool?,
            permission: freezed == permission
                ? _value.permission
                : permission // ignore: cast_nullable_to_non_nullable
                      as PermissionModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PermissionModelCopyWith<$Res>? get permission {
    if (_value.permission == null) {
      return null;
    }

    return $PermissionModelCopyWith<$Res>(_value.permission!, (value) {
      return _then(_value.copyWith(permission: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RolePermissionModelImplCopyWith<$Res>
    implements $RolePermissionModelCopyWith<$Res> {
  factory _$$RolePermissionModelImplCopyWith(
    _$RolePermissionModelImpl value,
    $Res Function(_$RolePermissionModelImpl) then,
  ) = __$$RolePermissionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'rp_id') String? rpId,
    @JsonKey(name: 'role_id') String? roleId,
    @JsonKey(name: 'perm_id') String? permId,
    @JsonKey(name: 'rp_sts') int? rpSts,
    @JsonKey(name: 'can_view') bool? canView,
    @JsonKey(name: 'can_create') bool? canCreate,
    @JsonKey(name: 'can_edit') bool? canEdit,
    @JsonKey(name: 'can_delete') bool? canDelete,
    @JsonKey(name: 'permission') PermissionModel? permission,
  });

  @override
  $PermissionModelCopyWith<$Res>? get permission;
}

/// @nodoc
class __$$RolePermissionModelImplCopyWithImpl<$Res>
    extends _$RolePermissionModelCopyWithImpl<$Res, _$RolePermissionModelImpl>
    implements _$$RolePermissionModelImplCopyWith<$Res> {
  __$$RolePermissionModelImplCopyWithImpl(
    _$RolePermissionModelImpl _value,
    $Res Function(_$RolePermissionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rpId = freezed,
    Object? roleId = freezed,
    Object? permId = freezed,
    Object? rpSts = freezed,
    Object? canView = freezed,
    Object? canCreate = freezed,
    Object? canEdit = freezed,
    Object? canDelete = freezed,
    Object? permission = freezed,
  }) {
    return _then(
      _$RolePermissionModelImpl(
        rpId: freezed == rpId
            ? _value.rpId
            : rpId // ignore: cast_nullable_to_non_nullable
                  as String?,
        roleId: freezed == roleId
            ? _value.roleId
            : roleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        permId: freezed == permId
            ? _value.permId
            : permId // ignore: cast_nullable_to_non_nullable
                  as String?,
        rpSts: freezed == rpSts
            ? _value.rpSts
            : rpSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        canView: freezed == canView
            ? _value.canView
            : canView // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canCreate: freezed == canCreate
            ? _value.canCreate
            : canCreate // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canEdit: freezed == canEdit
            ? _value.canEdit
            : canEdit // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canDelete: freezed == canDelete
            ? _value.canDelete
            : canDelete // ignore: cast_nullable_to_non_nullable
                  as bool?,
        permission: freezed == permission
            ? _value.permission
            : permission // ignore: cast_nullable_to_non_nullable
                  as PermissionModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RolePermissionModelImpl implements _RolePermissionModel {
  const _$RolePermissionModelImpl({
    @JsonKey(name: 'rp_id') this.rpId,
    @JsonKey(name: 'role_id') this.roleId,
    @JsonKey(name: 'perm_id') this.permId,
    @JsonKey(name: 'rp_sts') this.rpSts,
    @JsonKey(name: 'can_view') this.canView,
    @JsonKey(name: 'can_create') this.canCreate,
    @JsonKey(name: 'can_edit') this.canEdit,
    @JsonKey(name: 'can_delete') this.canDelete,
    @JsonKey(name: 'permission') this.permission,
  });

  factory _$RolePermissionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RolePermissionModelImplFromJson(json);

  @override
  @JsonKey(name: 'rp_id')
  final String? rpId;
  @override
  @JsonKey(name: 'role_id')
  final String? roleId;
  @override
  @JsonKey(name: 'perm_id')
  final String? permId;
  @override
  @JsonKey(name: 'rp_sts')
  final int? rpSts;
  @override
  @JsonKey(name: 'can_view')
  final bool? canView;
  @override
  @JsonKey(name: 'can_create')
  final bool? canCreate;
  @override
  @JsonKey(name: 'can_edit')
  final bool? canEdit;
  @override
  @JsonKey(name: 'can_delete')
  final bool? canDelete;
  @override
  @JsonKey(name: 'permission')
  final PermissionModel? permission;

  @override
  String toString() {
    return 'RolePermissionModel(rpId: $rpId, roleId: $roleId, permId: $permId, rpSts: $rpSts, canView: $canView, canCreate: $canCreate, canEdit: $canEdit, canDelete: $canDelete, permission: $permission)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RolePermissionModelImpl &&
            (identical(other.rpId, rpId) || other.rpId == rpId) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.permId, permId) || other.permId == permId) &&
            (identical(other.rpSts, rpSts) || other.rpSts == rpSts) &&
            (identical(other.canView, canView) || other.canView == canView) &&
            (identical(other.canCreate, canCreate) ||
                other.canCreate == canCreate) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.canDelete, canDelete) ||
                other.canDelete == canDelete) &&
            (identical(other.permission, permission) ||
                other.permission == permission));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rpId,
    roleId,
    permId,
    rpSts,
    canView,
    canCreate,
    canEdit,
    canDelete,
    permission,
  );

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RolePermissionModelImplCopyWith<_$RolePermissionModelImpl> get copyWith =>
      __$$RolePermissionModelImplCopyWithImpl<_$RolePermissionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RolePermissionModelImplToJson(this);
  }
}

abstract class _RolePermissionModel implements RolePermissionModel {
  const factory _RolePermissionModel({
    @JsonKey(name: 'rp_id') final String? rpId,
    @JsonKey(name: 'role_id') final String? roleId,
    @JsonKey(name: 'perm_id') final String? permId,
    @JsonKey(name: 'rp_sts') final int? rpSts,
    @JsonKey(name: 'can_view') final bool? canView,
    @JsonKey(name: 'can_create') final bool? canCreate,
    @JsonKey(name: 'can_edit') final bool? canEdit,
    @JsonKey(name: 'can_delete') final bool? canDelete,
    @JsonKey(name: 'permission') final PermissionModel? permission,
  }) = _$RolePermissionModelImpl;

  factory _RolePermissionModel.fromJson(Map<String, dynamic> json) =
      _$RolePermissionModelImpl.fromJson;

  @override
  @JsonKey(name: 'rp_id')
  String? get rpId;
  @override
  @JsonKey(name: 'role_id')
  String? get roleId;
  @override
  @JsonKey(name: 'perm_id')
  String? get permId;
  @override
  @JsonKey(name: 'rp_sts')
  int? get rpSts;
  @override
  @JsonKey(name: 'can_view')
  bool? get canView;
  @override
  @JsonKey(name: 'can_create')
  bool? get canCreate;
  @override
  @JsonKey(name: 'can_edit')
  bool? get canEdit;
  @override
  @JsonKey(name: 'can_delete')
  bool? get canDelete;
  @override
  @JsonKey(name: 'permission')
  PermissionModel? get permission;

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RolePermissionModelImplCopyWith<_$RolePermissionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
