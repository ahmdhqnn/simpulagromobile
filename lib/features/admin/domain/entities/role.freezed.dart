// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Role {
  String get roleId => throw _privateConstructorUsedError;
  String? get roleName => throw _privateConstructorUsedError;
  String? get roleDesc => throw _privateConstructorUsedError;
  int? get roleSts => throw _privateConstructorUsedError;
  DateTime? get roleCreated => throw _privateConstructorUsedError;
  DateTime? get roleUpdate => throw _privateConstructorUsedError;
  List<Permission> get permissions => throw _privateConstructorUsedError;

  /// Create a copy of Role
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleCopyWith<Role> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleCopyWith<$Res> {
  factory $RoleCopyWith(Role value, $Res Function(Role) then) =
      _$RoleCopyWithImpl<$Res, Role>;
  @useResult
  $Res call({
    String roleId,
    String? roleName,
    String? roleDesc,
    int? roleSts,
    DateTime? roleCreated,
    DateTime? roleUpdate,
    List<Permission> permissions,
  });
}

/// @nodoc
class _$RoleCopyWithImpl<$Res, $Val extends Role>
    implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Role
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
    Object? permissions = null,
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
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<Permission>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoleImplCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory _$$RoleImplCopyWith(
    _$RoleImpl value,
    $Res Function(_$RoleImpl) then,
  ) = __$$RoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roleId,
    String? roleName,
    String? roleDesc,
    int? roleSts,
    DateTime? roleCreated,
    DateTime? roleUpdate,
    List<Permission> permissions,
  });
}

/// @nodoc
class __$$RoleImplCopyWithImpl<$Res>
    extends _$RoleCopyWithImpl<$Res, _$RoleImpl>
    implements _$$RoleImplCopyWith<$Res> {
  __$$RoleImplCopyWithImpl(_$RoleImpl _value, $Res Function(_$RoleImpl) _then)
    : super(_value, _then);

  /// Create a copy of Role
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
    Object? permissions = null,
  }) {
    return _then(
      _$RoleImpl(
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
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<Permission>,
      ),
    );
  }
}

/// @nodoc

class _$RoleImpl extends _Role {
  const _$RoleImpl({
    required this.roleId,
    this.roleName,
    this.roleDesc,
    this.roleSts,
    this.roleCreated,
    this.roleUpdate,
    final List<Permission> permissions = const [],
  }) : _permissions = permissions,
       super._();

  @override
  final String roleId;
  @override
  final String? roleName;
  @override
  final String? roleDesc;
  @override
  final int? roleSts;
  @override
  final DateTime? roleCreated;
  @override
  final DateTime? roleUpdate;
  final List<Permission> _permissions;
  @override
  @JsonKey()
  List<Permission> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  String toString() {
    return 'Role(roleId: $roleId, roleName: $roleName, roleDesc: $roleDesc, roleSts: $roleSts, roleCreated: $roleCreated, roleUpdate: $roleUpdate, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleImpl &&
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
              other._permissions,
              _permissions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roleId,
    roleName,
    roleDesc,
    roleSts,
    roleCreated,
    roleUpdate,
    const DeepCollectionEquality().hash(_permissions),
  );

  /// Create a copy of Role
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleImplCopyWith<_$RoleImpl> get copyWith =>
      __$$RoleImplCopyWithImpl<_$RoleImpl>(this, _$identity);
}

abstract class _Role extends Role {
  const factory _Role({
    required final String roleId,
    final String? roleName,
    final String? roleDesc,
    final int? roleSts,
    final DateTime? roleCreated,
    final DateTime? roleUpdate,
    final List<Permission> permissions,
  }) = _$RoleImpl;
  const _Role._() : super._();

  @override
  String get roleId;
  @override
  String? get roleName;
  @override
  String? get roleDesc;
  @override
  int? get roleSts;
  @override
  DateTime? get roleCreated;
  @override
  DateTime? get roleUpdate;
  @override
  List<Permission> get permissions;

  /// Create a copy of Role
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleImplCopyWith<_$RoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
