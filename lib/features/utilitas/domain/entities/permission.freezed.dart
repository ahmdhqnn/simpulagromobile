// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Permission {
  String get permId => throw _privateConstructorUsedError;
  String? get permName => throw _privateConstructorUsedError;
  String? get permDesc => throw _privateConstructorUsedError;
  String? get permPage => throw _privateConstructorUsedError;
  int? get permSts => throw _privateConstructorUsedError;
  DateTime? get permCreated => throw _privateConstructorUsedError;
  DateTime? get permUpdate => throw _privateConstructorUsedError;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionCopyWith<Permission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionCopyWith<$Res> {
  factory $PermissionCopyWith(
    Permission value,
    $Res Function(Permission) then,
  ) = _$PermissionCopyWithImpl<$Res, Permission>;
  @useResult
  $Res call({
    String permId,
    String? permName,
    String? permDesc,
    String? permPage,
    int? permSts,
    DateTime? permCreated,
    DateTime? permUpdate,
  });
}

/// @nodoc
class _$PermissionCopyWithImpl<$Res, $Val extends Permission>
    implements $PermissionCopyWith<$Res> {
  _$PermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permId = null,
    Object? permName = freezed,
    Object? permDesc = freezed,
    Object? permPage = freezed,
    Object? permSts = freezed,
    Object? permCreated = freezed,
    Object? permUpdate = freezed,
  }) {
    return _then(
      _value.copyWith(
            permId: null == permId
                ? _value.permId
                : permId // ignore: cast_nullable_to_non_nullable
                      as String,
            permName: freezed == permName
                ? _value.permName
                : permName // ignore: cast_nullable_to_non_nullable
                      as String?,
            permDesc: freezed == permDesc
                ? _value.permDesc
                : permDesc // ignore: cast_nullable_to_non_nullable
                      as String?,
            permPage: freezed == permPage
                ? _value.permPage
                : permPage // ignore: cast_nullable_to_non_nullable
                      as String?,
            permSts: freezed == permSts
                ? _value.permSts
                : permSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            permCreated: freezed == permCreated
                ? _value.permCreated
                : permCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            permUpdate: freezed == permUpdate
                ? _value.permUpdate
                : permUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PermissionImplCopyWith<$Res>
    implements $PermissionCopyWith<$Res> {
  factory _$$PermissionImplCopyWith(
    _$PermissionImpl value,
    $Res Function(_$PermissionImpl) then,
  ) = __$$PermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String permId,
    String? permName,
    String? permDesc,
    String? permPage,
    int? permSts,
    DateTime? permCreated,
    DateTime? permUpdate,
  });
}

/// @nodoc
class __$$PermissionImplCopyWithImpl<$Res>
    extends _$PermissionCopyWithImpl<$Res, _$PermissionImpl>
    implements _$$PermissionImplCopyWith<$Res> {
  __$$PermissionImplCopyWithImpl(
    _$PermissionImpl _value,
    $Res Function(_$PermissionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permId = null,
    Object? permName = freezed,
    Object? permDesc = freezed,
    Object? permPage = freezed,
    Object? permSts = freezed,
    Object? permCreated = freezed,
    Object? permUpdate = freezed,
  }) {
    return _then(
      _$PermissionImpl(
        permId: null == permId
            ? _value.permId
            : permId // ignore: cast_nullable_to_non_nullable
                  as String,
        permName: freezed == permName
            ? _value.permName
            : permName // ignore: cast_nullable_to_non_nullable
                  as String?,
        permDesc: freezed == permDesc
            ? _value.permDesc
            : permDesc // ignore: cast_nullable_to_non_nullable
                  as String?,
        permPage: freezed == permPage
            ? _value.permPage
            : permPage // ignore: cast_nullable_to_non_nullable
                  as String?,
        permSts: freezed == permSts
            ? _value.permSts
            : permSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        permCreated: freezed == permCreated
            ? _value.permCreated
            : permCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        permUpdate: freezed == permUpdate
            ? _value.permUpdate
            : permUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$PermissionImpl extends _Permission {
  const _$PermissionImpl({
    required this.permId,
    this.permName,
    this.permDesc,
    this.permPage,
    this.permSts,
    this.permCreated,
    this.permUpdate,
  }) : super._();

  @override
  final String permId;
  @override
  final String? permName;
  @override
  final String? permDesc;
  @override
  final String? permPage;
  @override
  final int? permSts;
  @override
  final DateTime? permCreated;
  @override
  final DateTime? permUpdate;

  @override
  String toString() {
    return 'Permission(permId: $permId, permName: $permName, permDesc: $permDesc, permPage: $permPage, permSts: $permSts, permCreated: $permCreated, permUpdate: $permUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionImpl &&
            (identical(other.permId, permId) || other.permId == permId) &&
            (identical(other.permName, permName) ||
                other.permName == permName) &&
            (identical(other.permDesc, permDesc) ||
                other.permDesc == permDesc) &&
            (identical(other.permPage, permPage) ||
                other.permPage == permPage) &&
            (identical(other.permSts, permSts) || other.permSts == permSts) &&
            (identical(other.permCreated, permCreated) ||
                other.permCreated == permCreated) &&
            (identical(other.permUpdate, permUpdate) ||
                other.permUpdate == permUpdate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    permId,
    permName,
    permDesc,
    permPage,
    permSts,
    permCreated,
    permUpdate,
  );

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      __$$PermissionImplCopyWithImpl<_$PermissionImpl>(this, _$identity);
}

abstract class _Permission extends Permission {
  const factory _Permission({
    required final String permId,
    final String? permName,
    final String? permDesc,
    final String? permPage,
    final int? permSts,
    final DateTime? permCreated,
    final DateTime? permUpdate,
  }) = _$PermissionImpl;
  const _Permission._() : super._();

  @override
  String get permId;
  @override
  String? get permName;
  @override
  String? get permDesc;
  @override
  String? get permPage;
  @override
  int? get permSts;
  @override
  DateTime? get permCreated;
  @override
  DateTime? get permUpdate;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
