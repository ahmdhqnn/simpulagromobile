// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) {
  return _DeviceModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceModel {
  @JsonKey(name: 'dev_id')
  String get devId => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  String? get siteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_name')
  String? get devName => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_token')
  String? get devToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_location')
  String? get devLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_lon')
  double? get devLon => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_lat')
  double? get devLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_alt')
  double? get devAlt => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_number_id')
  String? get devNumberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_ip')
  String? get devIp => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_port')
  String? get devPort => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_img')
  String? get devImg => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_sts')
  int? get devSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_created')
  DateTime? get devCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_update')
  DateTime? get devUpdate => throw _privateConstructorUsedError;

  /// Serializes this DeviceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceModelCopyWith<DeviceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceModelCopyWith<$Res> {
  factory $DeviceModelCopyWith(
    DeviceModel value,
    $Res Function(DeviceModel) then,
  ) = _$DeviceModelCopyWithImpl<$Res, DeviceModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'dev_name') String? devName,
    @JsonKey(name: 'dev_token') String? devToken,
    @JsonKey(name: 'dev_location') String? devLocation,
    @JsonKey(name: 'dev_lon') double? devLon,
    @JsonKey(name: 'dev_lat') double? devLat,
    @JsonKey(name: 'dev_alt') double? devAlt,
    @JsonKey(name: 'dev_number_id') String? devNumberId,
    @JsonKey(name: 'dev_ip') String? devIp,
    @JsonKey(name: 'dev_port') String? devPort,
    @JsonKey(name: 'dev_img') String? devImg,
    @JsonKey(name: 'dev_sts') int? devSts,
    @JsonKey(name: 'dev_created') DateTime? devCreated,
    @JsonKey(name: 'dev_update') DateTime? devUpdate,
  });
}

/// @nodoc
class _$DeviceModelCopyWithImpl<$Res, $Val extends DeviceModel>
    implements $DeviceModelCopyWith<$Res> {
  _$DeviceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devId = null,
    Object? siteId = freezed,
    Object? userId = freezed,
    Object? devName = freezed,
    Object? devToken = freezed,
    Object? devLocation = freezed,
    Object? devLon = freezed,
    Object? devLat = freezed,
    Object? devAlt = freezed,
    Object? devNumberId = freezed,
    Object? devIp = freezed,
    Object? devPort = freezed,
    Object? devImg = freezed,
    Object? devSts = freezed,
    Object? devCreated = freezed,
    Object? devUpdate = freezed,
  }) {
    return _then(
      _value.copyWith(
            devId: null == devId
                ? _value.devId
                : devId // ignore: cast_nullable_to_non_nullable
                      as String,
            siteId: freezed == siteId
                ? _value.siteId
                : siteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            devName: freezed == devName
                ? _value.devName
                : devName // ignore: cast_nullable_to_non_nullable
                      as String?,
            devToken: freezed == devToken
                ? _value.devToken
                : devToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            devLocation: freezed == devLocation
                ? _value.devLocation
                : devLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            devLon: freezed == devLon
                ? _value.devLon
                : devLon // ignore: cast_nullable_to_non_nullable
                      as double?,
            devLat: freezed == devLat
                ? _value.devLat
                : devLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            devAlt: freezed == devAlt
                ? _value.devAlt
                : devAlt // ignore: cast_nullable_to_non_nullable
                      as double?,
            devNumberId: freezed == devNumberId
                ? _value.devNumberId
                : devNumberId // ignore: cast_nullable_to_non_nullable
                      as String?,
            devIp: freezed == devIp
                ? _value.devIp
                : devIp // ignore: cast_nullable_to_non_nullable
                      as String?,
            devPort: freezed == devPort
                ? _value.devPort
                : devPort // ignore: cast_nullable_to_non_nullable
                      as String?,
            devImg: freezed == devImg
                ? _value.devImg
                : devImg // ignore: cast_nullable_to_non_nullable
                      as String?,
            devSts: freezed == devSts
                ? _value.devSts
                : devSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            devCreated: freezed == devCreated
                ? _value.devCreated
                : devCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            devUpdate: freezed == devUpdate
                ? _value.devUpdate
                : devUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceModelImplCopyWith<$Res>
    implements $DeviceModelCopyWith<$Res> {
  factory _$$DeviceModelImplCopyWith(
    _$DeviceModelImpl value,
    $Res Function(_$DeviceModelImpl) then,
  ) = __$$DeviceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'dev_name') String? devName,
    @JsonKey(name: 'dev_token') String? devToken,
    @JsonKey(name: 'dev_location') String? devLocation,
    @JsonKey(name: 'dev_lon') double? devLon,
    @JsonKey(name: 'dev_lat') double? devLat,
    @JsonKey(name: 'dev_alt') double? devAlt,
    @JsonKey(name: 'dev_number_id') String? devNumberId,
    @JsonKey(name: 'dev_ip') String? devIp,
    @JsonKey(name: 'dev_port') String? devPort,
    @JsonKey(name: 'dev_img') String? devImg,
    @JsonKey(name: 'dev_sts') int? devSts,
    @JsonKey(name: 'dev_created') DateTime? devCreated,
    @JsonKey(name: 'dev_update') DateTime? devUpdate,
  });
}

/// @nodoc
class __$$DeviceModelImplCopyWithImpl<$Res>
    extends _$DeviceModelCopyWithImpl<$Res, _$DeviceModelImpl>
    implements _$$DeviceModelImplCopyWith<$Res> {
  __$$DeviceModelImplCopyWithImpl(
    _$DeviceModelImpl _value,
    $Res Function(_$DeviceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devId = null,
    Object? siteId = freezed,
    Object? userId = freezed,
    Object? devName = freezed,
    Object? devToken = freezed,
    Object? devLocation = freezed,
    Object? devLon = freezed,
    Object? devLat = freezed,
    Object? devAlt = freezed,
    Object? devNumberId = freezed,
    Object? devIp = freezed,
    Object? devPort = freezed,
    Object? devImg = freezed,
    Object? devSts = freezed,
    Object? devCreated = freezed,
    Object? devUpdate = freezed,
  }) {
    return _then(
      _$DeviceModelImpl(
        devId: null == devId
            ? _value.devId
            : devId // ignore: cast_nullable_to_non_nullable
                  as String,
        siteId: freezed == siteId
            ? _value.siteId
            : siteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        devName: freezed == devName
            ? _value.devName
            : devName // ignore: cast_nullable_to_non_nullable
                  as String?,
        devToken: freezed == devToken
            ? _value.devToken
            : devToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        devLocation: freezed == devLocation
            ? _value.devLocation
            : devLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        devLon: freezed == devLon
            ? _value.devLon
            : devLon // ignore: cast_nullable_to_non_nullable
                  as double?,
        devLat: freezed == devLat
            ? _value.devLat
            : devLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        devAlt: freezed == devAlt
            ? _value.devAlt
            : devAlt // ignore: cast_nullable_to_non_nullable
                  as double?,
        devNumberId: freezed == devNumberId
            ? _value.devNumberId
            : devNumberId // ignore: cast_nullable_to_non_nullable
                  as String?,
        devIp: freezed == devIp
            ? _value.devIp
            : devIp // ignore: cast_nullable_to_non_nullable
                  as String?,
        devPort: freezed == devPort
            ? _value.devPort
            : devPort // ignore: cast_nullable_to_non_nullable
                  as String?,
        devImg: freezed == devImg
            ? _value.devImg
            : devImg // ignore: cast_nullable_to_non_nullable
                  as String?,
        devSts: freezed == devSts
            ? _value.devSts
            : devSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        devCreated: freezed == devCreated
            ? _value.devCreated
            : devCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        devUpdate: freezed == devUpdate
            ? _value.devUpdate
            : devUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceModelImpl extends _DeviceModel {
  const _$DeviceModelImpl({
    @JsonKey(name: 'dev_id') required this.devId,
    @JsonKey(name: 'site_id') this.siteId,
    @JsonKey(name: 'user_id') this.userId,
    @JsonKey(name: 'dev_name') this.devName,
    @JsonKey(name: 'dev_token') this.devToken,
    @JsonKey(name: 'dev_location') this.devLocation,
    @JsonKey(name: 'dev_lon') this.devLon,
    @JsonKey(name: 'dev_lat') this.devLat,
    @JsonKey(name: 'dev_alt') this.devAlt,
    @JsonKey(name: 'dev_number_id') this.devNumberId,
    @JsonKey(name: 'dev_ip') this.devIp,
    @JsonKey(name: 'dev_port') this.devPort,
    @JsonKey(name: 'dev_img') this.devImg,
    @JsonKey(name: 'dev_sts') this.devSts,
    @JsonKey(name: 'dev_created') this.devCreated,
    @JsonKey(name: 'dev_update') this.devUpdate,
  }) : super._();

  factory _$DeviceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceModelImplFromJson(json);

  @override
  @JsonKey(name: 'dev_id')
  final String devId;
  @override
  @JsonKey(name: 'site_id')
  final String? siteId;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'dev_name')
  final String? devName;
  @override
  @JsonKey(name: 'dev_token')
  final String? devToken;
  @override
  @JsonKey(name: 'dev_location')
  final String? devLocation;
  @override
  @JsonKey(name: 'dev_lon')
  final double? devLon;
  @override
  @JsonKey(name: 'dev_lat')
  final double? devLat;
  @override
  @JsonKey(name: 'dev_alt')
  final double? devAlt;
  @override
  @JsonKey(name: 'dev_number_id')
  final String? devNumberId;
  @override
  @JsonKey(name: 'dev_ip')
  final String? devIp;
  @override
  @JsonKey(name: 'dev_port')
  final String? devPort;
  @override
  @JsonKey(name: 'dev_img')
  final String? devImg;
  @override
  @JsonKey(name: 'dev_sts')
  final int? devSts;
  @override
  @JsonKey(name: 'dev_created')
  final DateTime? devCreated;
  @override
  @JsonKey(name: 'dev_update')
  final DateTime? devUpdate;

  @override
  String toString() {
    return 'DeviceModel(devId: $devId, siteId: $siteId, userId: $userId, devName: $devName, devToken: $devToken, devLocation: $devLocation, devLon: $devLon, devLat: $devLat, devAlt: $devAlt, devNumberId: $devNumberId, devIp: $devIp, devPort: $devPort, devImg: $devImg, devSts: $devSts, devCreated: $devCreated, devUpdate: $devUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceModelImpl &&
            (identical(other.devId, devId) || other.devId == devId) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.devName, devName) || other.devName == devName) &&
            (identical(other.devToken, devToken) ||
                other.devToken == devToken) &&
            (identical(other.devLocation, devLocation) ||
                other.devLocation == devLocation) &&
            (identical(other.devLon, devLon) || other.devLon == devLon) &&
            (identical(other.devLat, devLat) || other.devLat == devLat) &&
            (identical(other.devAlt, devAlt) || other.devAlt == devAlt) &&
            (identical(other.devNumberId, devNumberId) ||
                other.devNumberId == devNumberId) &&
            (identical(other.devIp, devIp) || other.devIp == devIp) &&
            (identical(other.devPort, devPort) || other.devPort == devPort) &&
            (identical(other.devImg, devImg) || other.devImg == devImg) &&
            (identical(other.devSts, devSts) || other.devSts == devSts) &&
            (identical(other.devCreated, devCreated) ||
                other.devCreated == devCreated) &&
            (identical(other.devUpdate, devUpdate) ||
                other.devUpdate == devUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    devId,
    siteId,
    userId,
    devName,
    devToken,
    devLocation,
    devLon,
    devLat,
    devAlt,
    devNumberId,
    devIp,
    devPort,
    devImg,
    devSts,
    devCreated,
    devUpdate,
  );

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      __$$DeviceModelImplCopyWithImpl<_$DeviceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceModelImplToJson(this);
  }
}

abstract class _DeviceModel extends DeviceModel {
  const factory _DeviceModel({
    @JsonKey(name: 'dev_id') required final String devId,
    @JsonKey(name: 'site_id') final String? siteId,
    @JsonKey(name: 'user_id') final String? userId,
    @JsonKey(name: 'dev_name') final String? devName,
    @JsonKey(name: 'dev_token') final String? devToken,
    @JsonKey(name: 'dev_location') final String? devLocation,
    @JsonKey(name: 'dev_lon') final double? devLon,
    @JsonKey(name: 'dev_lat') final double? devLat,
    @JsonKey(name: 'dev_alt') final double? devAlt,
    @JsonKey(name: 'dev_number_id') final String? devNumberId,
    @JsonKey(name: 'dev_ip') final String? devIp,
    @JsonKey(name: 'dev_port') final String? devPort,
    @JsonKey(name: 'dev_img') final String? devImg,
    @JsonKey(name: 'dev_sts') final int? devSts,
    @JsonKey(name: 'dev_created') final DateTime? devCreated,
    @JsonKey(name: 'dev_update') final DateTime? devUpdate,
  }) = _$DeviceModelImpl;
  const _DeviceModel._() : super._();

  factory _DeviceModel.fromJson(Map<String, dynamic> json) =
      _$DeviceModelImpl.fromJson;

  @override
  @JsonKey(name: 'dev_id')
  String get devId;
  @override
  @JsonKey(name: 'site_id')
  String? get siteId;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'dev_name')
  String? get devName;
  @override
  @JsonKey(name: 'dev_token')
  String? get devToken;
  @override
  @JsonKey(name: 'dev_location')
  String? get devLocation;
  @override
  @JsonKey(name: 'dev_lon')
  double? get devLon;
  @override
  @JsonKey(name: 'dev_lat')
  double? get devLat;
  @override
  @JsonKey(name: 'dev_alt')
  double? get devAlt;
  @override
  @JsonKey(name: 'dev_number_id')
  String? get devNumberId;
  @override
  @JsonKey(name: 'dev_ip')
  String? get devIp;
  @override
  @JsonKey(name: 'dev_port')
  String? get devPort;
  @override
  @JsonKey(name: 'dev_img')
  String? get devImg;
  @override
  @JsonKey(name: 'dev_sts')
  int? get devSts;
  @override
  @JsonKey(name: 'dev_created')
  DateTime? get devCreated;
  @override
  @JsonKey(name: 'dev_update')
  DateTime? get devUpdate;

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
