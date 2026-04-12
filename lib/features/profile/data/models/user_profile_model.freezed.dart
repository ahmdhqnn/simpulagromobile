// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_email')
  String? get userEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_phone')
  String? get userPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_sts')
  String? get userSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_id')
  String? get roleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_name')
  String? get roleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'permissions')
  List<String>? get permissions => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_created')
  DateTime? get userCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_update')
  DateTime? get userUpdate => throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
    UserProfileModel value,
    $Res Function(UserProfileModel) then,
  ) = _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'user_name') String userName,
    @JsonKey(name: 'user_email') String? userEmail,
    @JsonKey(name: 'user_phone') String? userPhone,
    @JsonKey(name: 'user_sts') String? userSts,
    @JsonKey(name: 'role_id') String? roleId,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'permissions') List<String>? permissions,
    @JsonKey(name: 'user_created') DateTime? userCreated,
    @JsonKey(name: 'user_update') DateTime? userUpdate,
  });
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? userSts = freezed,
    Object? roleId = freezed,
    Object? roleName = freezed,
    Object? permissions = freezed,
    Object? userCreated = freezed,
    Object? userUpdate = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            userEmail: freezed == userEmail
                ? _value.userEmail
                : userEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            userPhone: freezed == userPhone
                ? _value.userPhone
                : userPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            userSts: freezed == userSts
                ? _value.userSts
                : userSts // ignore: cast_nullable_to_non_nullable
                      as String?,
            roleId: freezed == roleId
                ? _value.roleId
                : roleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            roleName: freezed == roleName
                ? _value.roleName
                : roleName // ignore: cast_nullable_to_non_nullable
                      as String?,
            permissions: freezed == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            userCreated: freezed == userCreated
                ? _value.userCreated
                : userCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            userUpdate: freezed == userUpdate
                ? _value.userUpdate
                : userUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(
    _$UserProfileModelImpl value,
    $Res Function(_$UserProfileModelImpl) then,
  ) = __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'user_name') String userName,
    @JsonKey(name: 'user_email') String? userEmail,
    @JsonKey(name: 'user_phone') String? userPhone,
    @JsonKey(name: 'user_sts') String? userSts,
    @JsonKey(name: 'role_id') String? roleId,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'permissions') List<String>? permissions,
    @JsonKey(name: 'user_created') DateTime? userCreated,
    @JsonKey(name: 'user_update') DateTime? userUpdate,
  });
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(
    _$UserProfileModelImpl _value,
    $Res Function(_$UserProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? userSts = freezed,
    Object? roleId = freezed,
    Object? roleName = freezed,
    Object? permissions = freezed,
    Object? userCreated = freezed,
    Object? userUpdate = freezed,
  }) {
    return _then(
      _$UserProfileModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        userEmail: freezed == userEmail
            ? _value.userEmail
            : userEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        userPhone: freezed == userPhone
            ? _value.userPhone
            : userPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        userSts: freezed == userSts
            ? _value.userSts
            : userSts // ignore: cast_nullable_to_non_nullable
                  as String?,
        roleId: freezed == roleId
            ? _value.roleId
            : roleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        roleName: freezed == roleName
            ? _value.roleName
            : roleName // ignore: cast_nullable_to_non_nullable
                  as String?,
        permissions: freezed == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        userCreated: freezed == userCreated
            ? _value.userCreated
            : userCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        userUpdate: freezed == userUpdate
            ? _value.userUpdate
            : userUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl extends _UserProfileModel {
  const _$UserProfileModelImpl({
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'user_name') required this.userName,
    @JsonKey(name: 'user_email') this.userEmail,
    @JsonKey(name: 'user_phone') this.userPhone,
    @JsonKey(name: 'user_sts') this.userSts,
    @JsonKey(name: 'role_id') this.roleId,
    @JsonKey(name: 'role_name') this.roleName,
    @JsonKey(name: 'permissions') final List<String>? permissions,
    @JsonKey(name: 'user_created') this.userCreated,
    @JsonKey(name: 'user_update') this.userUpdate,
  }) : _permissions = permissions,
       super._();

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  @JsonKey(name: 'user_email')
  final String? userEmail;
  @override
  @JsonKey(name: 'user_phone')
  final String? userPhone;
  @override
  @JsonKey(name: 'user_sts')
  final String? userSts;
  @override
  @JsonKey(name: 'role_id')
  final String? roleId;
  @override
  @JsonKey(name: 'role_name')
  final String? roleName;
  final List<String>? _permissions;
  @override
  @JsonKey(name: 'permissions')
  List<String>? get permissions {
    final value = _permissions;
    if (value == null) return null;
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'user_created')
  final DateTime? userCreated;
  @override
  @JsonKey(name: 'user_update')
  final DateTime? userUpdate;

  @override
  String toString() {
    return 'UserProfileModel(userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, userSts: $userSts, roleId: $roleId, roleName: $roleName, permissions: $permissions, userCreated: $userCreated, userUpdate: $userUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.userSts, userSts) || other.userSts == userSts) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.userCreated, userCreated) ||
                other.userCreated == userCreated) &&
            (identical(other.userUpdate, userUpdate) ||
                other.userUpdate == userUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    userName,
    userEmail,
    userPhone,
    userSts,
    roleId,
    roleName,
    const DeepCollectionEquality().hash(_permissions),
    userCreated,
    userUpdate,
  );

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(this);
  }
}

abstract class _UserProfileModel extends UserProfileModel {
  const factory _UserProfileModel({
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'user_name') required final String userName,
    @JsonKey(name: 'user_email') final String? userEmail,
    @JsonKey(name: 'user_phone') final String? userPhone,
    @JsonKey(name: 'user_sts') final String? userSts,
    @JsonKey(name: 'role_id') final String? roleId,
    @JsonKey(name: 'role_name') final String? roleName,
    @JsonKey(name: 'permissions') final List<String>? permissions,
    @JsonKey(name: 'user_created') final DateTime? userCreated,
    @JsonKey(name: 'user_update') final DateTime? userUpdate,
  }) = _$UserProfileModelImpl;
  const _UserProfileModel._() : super._();

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'user_email')
  String? get userEmail;
  @override
  @JsonKey(name: 'user_phone')
  String? get userPhone;
  @override
  @JsonKey(name: 'user_sts')
  String? get userSts;
  @override
  @JsonKey(name: 'role_id')
  String? get roleId;
  @override
  @JsonKey(name: 'role_name')
  String? get roleName;
  @override
  @JsonKey(name: 'permissions')
  List<String>? get permissions;
  @override
  @JsonKey(name: 'user_created')
  DateTime? get userCreated;
  @override
  @JsonKey(name: 'user_update')
  DateTime? get userUpdate;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
