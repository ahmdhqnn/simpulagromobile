// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PermissionModel _$PermissionModelFromJson(Map<String, dynamic> json) {
  return _PermissionModel.fromJson(json);
}

/// @nodoc
mixin _$PermissionModel {
  @JsonKey(name: 'perm_id')
  String get permId => throw _privateConstructorUsedError;
  @JsonKey(name: 'perm_name')
  String? get permName => throw _privateConstructorUsedError;
  @JsonKey(name: 'perm_desc')
  String? get permDesc => throw _privateConstructorUsedError;
  @JsonKey(name: 'perm_page')
  String? get permPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'perm_sts')
  int? get permSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'perm_created')
  DateTime? get permCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'perm_update')
  DateTime? get permUpdate => throw _privateConstructorUsedError;

  /// Serializes this PermissionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionModelCopyWith<PermissionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionModelCopyWith<$Res> {
  factory $PermissionModelCopyWith(
    PermissionModel value,
    $Res Function(PermissionModel) then,
  ) = _$PermissionModelCopyWithImpl<$Res, PermissionModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'perm_id') String permId,
    @JsonKey(name: 'perm_name') String? permName,
    @JsonKey(name: 'perm_desc') String? permDesc,
    @JsonKey(name: 'perm_page') String? permPage,
    @JsonKey(name: 'perm_sts') int? permSts,
    @JsonKey(name: 'perm_created') DateTime? permCreated,
    @JsonKey(name: 'perm_update') DateTime? permUpdate,
  });
}

/// @nodoc
class _$PermissionModelCopyWithImpl<$Res, $Val extends PermissionModel>
    implements $PermissionModelCopyWith<$Res> {
  _$PermissionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionModel
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
abstract class _$$PermissionModelImplCopyWith<$Res>
    implements $PermissionModelCopyWith<$Res> {
  factory _$$PermissionModelImplCopyWith(
    _$PermissionModelImpl value,
    $Res Function(_$PermissionModelImpl) then,
  ) = __$$PermissionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'perm_id') String permId,
    @JsonKey(name: 'perm_name') String? permName,
    @JsonKey(name: 'perm_desc') String? permDesc,
    @JsonKey(name: 'perm_page') String? permPage,
    @JsonKey(name: 'perm_sts') int? permSts,
    @JsonKey(name: 'perm_created') DateTime? permCreated,
    @JsonKey(name: 'perm_update') DateTime? permUpdate,
  });
}

/// @nodoc
class __$$PermissionModelImplCopyWithImpl<$Res>
    extends _$PermissionModelCopyWithImpl<$Res, _$PermissionModelImpl>
    implements _$$PermissionModelImplCopyWith<$Res> {
  __$$PermissionModelImplCopyWithImpl(
    _$PermissionModelImpl _value,
    $Res Function(_$PermissionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PermissionModel
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
      _$PermissionModelImpl(
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
@JsonSerializable()
class _$PermissionModelImpl extends _PermissionModel {
  const _$PermissionModelImpl({
    @JsonKey(name: 'perm_id') required this.permId,
    @JsonKey(name: 'perm_name') this.permName,
    @JsonKey(name: 'perm_desc') this.permDesc,
    @JsonKey(name: 'perm_page') this.permPage,
    @JsonKey(name: 'perm_sts') this.permSts,
    @JsonKey(name: 'perm_created') this.permCreated,
    @JsonKey(name: 'perm_update') this.permUpdate,
  }) : super._();

  factory _$PermissionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionModelImplFromJson(json);

  @override
  @JsonKey(name: 'perm_id')
  final String permId;
  @override
  @JsonKey(name: 'perm_name')
  final String? permName;
  @override
  @JsonKey(name: 'perm_desc')
  final String? permDesc;
  @override
  @JsonKey(name: 'perm_page')
  final String? permPage;
  @override
  @JsonKey(name: 'perm_sts')
  final int? permSts;
  @override
  @JsonKey(name: 'perm_created')
  final DateTime? permCreated;
  @override
  @JsonKey(name: 'perm_update')
  final DateTime? permUpdate;

  @override
  String toString() {
    return 'PermissionModel(permId: $permId, permName: $permName, permDesc: $permDesc, permPage: $permPage, permSts: $permSts, permCreated: $permCreated, permUpdate: $permUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionModelImplCopyWith<_$PermissionModelImpl> get copyWith =>
      __$$PermissionModelImplCopyWithImpl<_$PermissionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionModelImplToJson(this);
  }
}

abstract class _PermissionModel extends PermissionModel {
  const factory _PermissionModel({
    @JsonKey(name: 'perm_id') required final String permId,
    @JsonKey(name: 'perm_name') final String? permName,
    @JsonKey(name: 'perm_desc') final String? permDesc,
    @JsonKey(name: 'perm_page') final String? permPage,
    @JsonKey(name: 'perm_sts') final int? permSts,
    @JsonKey(name: 'perm_created') final DateTime? permCreated,
    @JsonKey(name: 'perm_update') final DateTime? permUpdate,
  }) = _$PermissionModelImpl;
  const _PermissionModel._() : super._();

  factory _PermissionModel.fromJson(Map<String, dynamic> json) =
      _$PermissionModelImpl.fromJson;

  @override
  @JsonKey(name: 'perm_id')
  String get permId;
  @override
  @JsonKey(name: 'perm_name')
  String? get permName;
  @override
  @JsonKey(name: 'perm_desc')
  String? get permDesc;
  @override
  @JsonKey(name: 'perm_page')
  String? get permPage;
  @override
  @JsonKey(name: 'perm_sts')
  int? get permSts;
  @override
  @JsonKey(name: 'perm_created')
  DateTime? get permCreated;
  @override
  @JsonKey(name: 'perm_update')
  DateTime? get permUpdate;

  /// Create a copy of PermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionModelImplCopyWith<_$PermissionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
