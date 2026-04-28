// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SensorModel _$SensorModelFromJson(Map<String, dynamic> json) {
  return _SensorModel.fromJson(json);
}

/// @nodoc
mixin _$SensorModel {
  @JsonKey(name: 'sens_id')
  String get sensId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_id')
  String? get devId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_name')
  String? get sensName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_address')
  String? get sensAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_location')
  String? get sensLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_lat')
  double? get sensLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_lon')
  double? get sensLon => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_alt')
  double? get sensAlt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_sts')
  int? get sensSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_created')
  DateTime? get sensCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_update')
  DateTime? get sensUpdate => throw _privateConstructorUsedError;

  /// Serializes this SensorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SensorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorModelCopyWith<SensorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorModelCopyWith<$Res> {
  factory $SensorModelCopyWith(
    SensorModel value,
    $Res Function(SensorModel) then,
  ) = _$SensorModelCopyWithImpl<$Res, SensorModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'sens_id') String sensId,
    @JsonKey(name: 'dev_id') String? devId,
    @JsonKey(name: 'sens_name') String? sensName,
    @JsonKey(name: 'sens_address') String? sensAddress,
    @JsonKey(name: 'sens_location') String? sensLocation,
    @JsonKey(name: 'sens_lat') double? sensLat,
    @JsonKey(name: 'sens_lon') double? sensLon,
    @JsonKey(name: 'sens_alt') double? sensAlt,
    @JsonKey(name: 'sens_sts') int? sensSts,
    @JsonKey(name: 'sens_created') DateTime? sensCreated,
    @JsonKey(name: 'sens_update') DateTime? sensUpdate,
  });
}

/// @nodoc
class _$SensorModelCopyWithImpl<$Res, $Val extends SensorModel>
    implements $SensorModelCopyWith<$Res> {
  _$SensorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SensorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sensId = null,
    Object? devId = freezed,
    Object? sensName = freezed,
    Object? sensAddress = freezed,
    Object? sensLocation = freezed,
    Object? sensLat = freezed,
    Object? sensLon = freezed,
    Object? sensAlt = freezed,
    Object? sensSts = freezed,
    Object? sensCreated = freezed,
    Object? sensUpdate = freezed,
  }) {
    return _then(
      _value.copyWith(
            sensId: null == sensId
                ? _value.sensId
                : sensId // ignore: cast_nullable_to_non_nullable
                      as String,
            devId: freezed == devId
                ? _value.devId
                : devId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sensName: freezed == sensName
                ? _value.sensName
                : sensName // ignore: cast_nullable_to_non_nullable
                      as String?,
            sensAddress: freezed == sensAddress
                ? _value.sensAddress
                : sensAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            sensLocation: freezed == sensLocation
                ? _value.sensLocation
                : sensLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            sensLat: freezed == sensLat
                ? _value.sensLat
                : sensLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            sensLon: freezed == sensLon
                ? _value.sensLon
                : sensLon // ignore: cast_nullable_to_non_nullable
                      as double?,
            sensAlt: freezed == sensAlt
                ? _value.sensAlt
                : sensAlt // ignore: cast_nullable_to_non_nullable
                      as double?,
            sensSts: freezed == sensSts
                ? _value.sensSts
                : sensSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            sensCreated: freezed == sensCreated
                ? _value.sensCreated
                : sensCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            sensUpdate: freezed == sensUpdate
                ? _value.sensUpdate
                : sensUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SensorModelImplCopyWith<$Res>
    implements $SensorModelCopyWith<$Res> {
  factory _$$SensorModelImplCopyWith(
    _$SensorModelImpl value,
    $Res Function(_$SensorModelImpl) then,
  ) = __$$SensorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'sens_id') String sensId,
    @JsonKey(name: 'dev_id') String? devId,
    @JsonKey(name: 'sens_name') String? sensName,
    @JsonKey(name: 'sens_address') String? sensAddress,
    @JsonKey(name: 'sens_location') String? sensLocation,
    @JsonKey(name: 'sens_lat') double? sensLat,
    @JsonKey(name: 'sens_lon') double? sensLon,
    @JsonKey(name: 'sens_alt') double? sensAlt,
    @JsonKey(name: 'sens_sts') int? sensSts,
    @JsonKey(name: 'sens_created') DateTime? sensCreated,
    @JsonKey(name: 'sens_update') DateTime? sensUpdate,
  });
}

/// @nodoc
class __$$SensorModelImplCopyWithImpl<$Res>
    extends _$SensorModelCopyWithImpl<$Res, _$SensorModelImpl>
    implements _$$SensorModelImplCopyWith<$Res> {
  __$$SensorModelImplCopyWithImpl(
    _$SensorModelImpl _value,
    $Res Function(_$SensorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SensorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sensId = null,
    Object? devId = freezed,
    Object? sensName = freezed,
    Object? sensAddress = freezed,
    Object? sensLocation = freezed,
    Object? sensLat = freezed,
    Object? sensLon = freezed,
    Object? sensAlt = freezed,
    Object? sensSts = freezed,
    Object? sensCreated = freezed,
    Object? sensUpdate = freezed,
  }) {
    return _then(
      _$SensorModelImpl(
        sensId: null == sensId
            ? _value.sensId
            : sensId // ignore: cast_nullable_to_non_nullable
                  as String,
        devId: freezed == devId
            ? _value.devId
            : devId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sensName: freezed == sensName
            ? _value.sensName
            : sensName // ignore: cast_nullable_to_non_nullable
                  as String?,
        sensAddress: freezed == sensAddress
            ? _value.sensAddress
            : sensAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        sensLocation: freezed == sensLocation
            ? _value.sensLocation
            : sensLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        sensLat: freezed == sensLat
            ? _value.sensLat
            : sensLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        sensLon: freezed == sensLon
            ? _value.sensLon
            : sensLon // ignore: cast_nullable_to_non_nullable
                  as double?,
        sensAlt: freezed == sensAlt
            ? _value.sensAlt
            : sensAlt // ignore: cast_nullable_to_non_nullable
                  as double?,
        sensSts: freezed == sensSts
            ? _value.sensSts
            : sensSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        sensCreated: freezed == sensCreated
            ? _value.sensCreated
            : sensCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sensUpdate: freezed == sensUpdate
            ? _value.sensUpdate
            : sensUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorModelImpl extends _SensorModel {
  const _$SensorModelImpl({
    @JsonKey(name: 'sens_id') required this.sensId,
    @JsonKey(name: 'dev_id') this.devId,
    @JsonKey(name: 'sens_name') this.sensName,
    @JsonKey(name: 'sens_address') this.sensAddress,
    @JsonKey(name: 'sens_location') this.sensLocation,
    @JsonKey(name: 'sens_lat') this.sensLat,
    @JsonKey(name: 'sens_lon') this.sensLon,
    @JsonKey(name: 'sens_alt') this.sensAlt,
    @JsonKey(name: 'sens_sts') this.sensSts,
    @JsonKey(name: 'sens_created') this.sensCreated,
    @JsonKey(name: 'sens_update') this.sensUpdate,
  }) : super._();

  factory _$SensorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorModelImplFromJson(json);

  @override
  @JsonKey(name: 'sens_id')
  final String sensId;
  @override
  @JsonKey(name: 'dev_id')
  final String? devId;
  @override
  @JsonKey(name: 'sens_name')
  final String? sensName;
  @override
  @JsonKey(name: 'sens_address')
  final String? sensAddress;
  @override
  @JsonKey(name: 'sens_location')
  final String? sensLocation;
  @override
  @JsonKey(name: 'sens_lat')
  final double? sensLat;
  @override
  @JsonKey(name: 'sens_lon')
  final double? sensLon;
  @override
  @JsonKey(name: 'sens_alt')
  final double? sensAlt;
  @override
  @JsonKey(name: 'sens_sts')
  final int? sensSts;
  @override
  @JsonKey(name: 'sens_created')
  final DateTime? sensCreated;
  @override
  @JsonKey(name: 'sens_update')
  final DateTime? sensUpdate;

  @override
  String toString() {
    return 'SensorModel(sensId: $sensId, devId: $devId, sensName: $sensName, sensAddress: $sensAddress, sensLocation: $sensLocation, sensLat: $sensLat, sensLon: $sensLon, sensAlt: $sensAlt, sensSts: $sensSts, sensCreated: $sensCreated, sensUpdate: $sensUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorModelImpl &&
            (identical(other.sensId, sensId) || other.sensId == sensId) &&
            (identical(other.devId, devId) || other.devId == devId) &&
            (identical(other.sensName, sensName) ||
                other.sensName == sensName) &&
            (identical(other.sensAddress, sensAddress) ||
                other.sensAddress == sensAddress) &&
            (identical(other.sensLocation, sensLocation) ||
                other.sensLocation == sensLocation) &&
            (identical(other.sensLat, sensLat) || other.sensLat == sensLat) &&
            (identical(other.sensLon, sensLon) || other.sensLon == sensLon) &&
            (identical(other.sensAlt, sensAlt) || other.sensAlt == sensAlt) &&
            (identical(other.sensSts, sensSts) || other.sensSts == sensSts) &&
            (identical(other.sensCreated, sensCreated) ||
                other.sensCreated == sensCreated) &&
            (identical(other.sensUpdate, sensUpdate) ||
                other.sensUpdate == sensUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sensId,
    devId,
    sensName,
    sensAddress,
    sensLocation,
    sensLat,
    sensLon,
    sensAlt,
    sensSts,
    sensCreated,
    sensUpdate,
  );

  /// Create a copy of SensorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorModelImplCopyWith<_$SensorModelImpl> get copyWith =>
      __$$SensorModelImplCopyWithImpl<_$SensorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorModelImplToJson(this);
  }
}

abstract class _SensorModel extends SensorModel {
  const factory _SensorModel({
    @JsonKey(name: 'sens_id') required final String sensId,
    @JsonKey(name: 'dev_id') final String? devId,
    @JsonKey(name: 'sens_name') final String? sensName,
    @JsonKey(name: 'sens_address') final String? sensAddress,
    @JsonKey(name: 'sens_location') final String? sensLocation,
    @JsonKey(name: 'sens_lat') final double? sensLat,
    @JsonKey(name: 'sens_lon') final double? sensLon,
    @JsonKey(name: 'sens_alt') final double? sensAlt,
    @JsonKey(name: 'sens_sts') final int? sensSts,
    @JsonKey(name: 'sens_created') final DateTime? sensCreated,
    @JsonKey(name: 'sens_update') final DateTime? sensUpdate,
  }) = _$SensorModelImpl;
  const _SensorModel._() : super._();

  factory _SensorModel.fromJson(Map<String, dynamic> json) =
      _$SensorModelImpl.fromJson;

  @override
  @JsonKey(name: 'sens_id')
  String get sensId;
  @override
  @JsonKey(name: 'dev_id')
  String? get devId;
  @override
  @JsonKey(name: 'sens_name')
  String? get sensName;
  @override
  @JsonKey(name: 'sens_address')
  String? get sensAddress;
  @override
  @JsonKey(name: 'sens_location')
  String? get sensLocation;
  @override
  @JsonKey(name: 'sens_lat')
  double? get sensLat;
  @override
  @JsonKey(name: 'sens_lon')
  double? get sensLon;
  @override
  @JsonKey(name: 'sens_alt')
  double? get sensAlt;
  @override
  @JsonKey(name: 'sens_sts')
  int? get sensSts;
  @override
  @JsonKey(name: 'sens_created')
  DateTime? get sensCreated;
  @override
  @JsonKey(name: 'sens_update')
  DateTime? get sensUpdate;

  /// Create a copy of SensorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorModelImplCopyWith<_$SensorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
