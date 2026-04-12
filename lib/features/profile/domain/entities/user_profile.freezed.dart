// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserProfile {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userEmail => throw _privateConstructorUsedError;
  String? get userPhone => throw _privateConstructorUsedError;
  String? get userSts => throw _privateConstructorUsedError;
  String? get roleId => throw _privateConstructorUsedError;
  String? get roleName => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  DateTime? get userCreated => throw _privateConstructorUsedError;
  DateTime? get userUpdate => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String userId,
    String userName,
    String? userEmail,
    String? userPhone,
    String? userSts,
    String? roleId,
    String? roleName,
    List<String> permissions,
    DateTime? userCreated,
    DateTime? userUpdate,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
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
    Object? permissions = null,
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
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String userName,
    String? userEmail,
    String? userPhone,
    String? userSts,
    String? roleId,
    String? roleName,
    List<String> permissions,
    DateTime? userCreated,
    DateTime? userUpdate,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
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
    Object? permissions = null,
    Object? userCreated = freezed,
    Object? userUpdate = freezed,
  }) {
    return _then(
      _$UserProfileImpl(
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
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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

class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl({
    required this.userId,
    required this.userName,
    this.userEmail,
    this.userPhone,
    this.userSts,
    this.roleId,
    this.roleName,
    final List<String> permissions = const [],
    this.userCreated,
    this.userUpdate,
  }) : _permissions = permissions;

  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userEmail;
  @override
  final String? userPhone;
  @override
  final String? userSts;
  @override
  final String? roleId;
  @override
  final String? roleName;
  final List<String> _permissions;
  @override
  @JsonKey()
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final DateTime? userCreated;
  @override
  final DateTime? userUpdate;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, userSts: $userSts, roleId: $roleId, roleName: $roleName, permissions: $permissions, userCreated: $userCreated, userUpdate: $userUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
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

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile({
    required final String userId,
    required final String userName,
    final String? userEmail,
    final String? userPhone,
    final String? userSts,
    final String? roleId,
    final String? roleName,
    final List<String> permissions,
    final DateTime? userCreated,
    final DateTime? userUpdate,
  }) = _$UserProfileImpl;

  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userEmail;
  @override
  String? get userPhone;
  @override
  String? get userSts;
  @override
  String? get roleId;
  @override
  String? get roleName;
  @override
  List<String> get permissions;
  @override
  DateTime? get userCreated;
  @override
  DateTime? get userUpdate;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
