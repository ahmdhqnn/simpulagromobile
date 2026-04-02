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
  String toString() {
    return 'SensorModel(sensId: $sensId, devId: $devId, sensName: $sensName, sensAddress: $sensAddress, sensLocation: $sensLocation, sensLat: $sensLat, sensLon: $sensLon, sensAlt: $sensAlt)';
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
            (identical(other.sensAlt, sensAlt) || other.sensAlt == sensAlt));
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

  /// Create a copy of SensorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorModelImplCopyWith<_$SensorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceSensorModel _$DeviceSensorModelFromJson(Map<String, dynamic> json) {
  return _DeviceSensorModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceSensorModel {
  @JsonKey(name: 'ds_id')
  String get dsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_id')
  String get devId => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String? get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sens_id')
  String? get sensId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dc_normal_value')
  double? get dcNormalValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_min_norm_value')
  double? get dsMinNormValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_max_norm_value')
  double? get dsMaxNormValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_min_value')
  double? get dsMinValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_max_value')
  double? get dsMaxValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_min_val_warn')
  double? get dsMinValWarn => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_max_val_warn')
  double? get dsMaxValWarn => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_name')
  String? get dsName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_address')
  String? get dsAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_seq')
  int? get dsSeq => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_sts')
  int? get dsSts => throw _privateConstructorUsedError;

  /// Serializes this DeviceSensorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceSensorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceSensorModelCopyWith<DeviceSensorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceSensorModelCopyWith<$Res> {
  factory $DeviceSensorModelCopyWith(
    DeviceSensorModel value,
    $Res Function(DeviceSensorModel) then,
  ) = _$DeviceSensorModelCopyWithImpl<$Res, DeviceSensorModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ds_id') String dsId,
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'sens_id') String? sensId,
    @JsonKey(name: 'dc_normal_value') double? dcNormalValue,
    @JsonKey(name: 'ds_min_norm_value') double? dsMinNormValue,
    @JsonKey(name: 'ds_max_norm_value') double? dsMaxNormValue,
    @JsonKey(name: 'ds_min_value') double? dsMinValue,
    @JsonKey(name: 'ds_max_value') double? dsMaxValue,
    @JsonKey(name: 'ds_min_val_warn') double? dsMinValWarn,
    @JsonKey(name: 'ds_max_val_warn') double? dsMaxValWarn,
    @JsonKey(name: 'ds_name') String? dsName,
    @JsonKey(name: 'ds_address') String? dsAddress,
    @JsonKey(name: 'ds_seq') int? dsSeq,
    @JsonKey(name: 'ds_sts') int? dsSts,
  });
}

/// @nodoc
class _$DeviceSensorModelCopyWithImpl<$Res, $Val extends DeviceSensorModel>
    implements $DeviceSensorModelCopyWith<$Res> {
  _$DeviceSensorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceSensorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dsId = null,
    Object? devId = null,
    Object? unitId = freezed,
    Object? sensId = freezed,
    Object? dcNormalValue = freezed,
    Object? dsMinNormValue = freezed,
    Object? dsMaxNormValue = freezed,
    Object? dsMinValue = freezed,
    Object? dsMaxValue = freezed,
    Object? dsMinValWarn = freezed,
    Object? dsMaxValWarn = freezed,
    Object? dsName = freezed,
    Object? dsAddress = freezed,
    Object? dsSeq = freezed,
    Object? dsSts = freezed,
  }) {
    return _then(
      _value.copyWith(
            dsId: null == dsId
                ? _value.dsId
                : dsId // ignore: cast_nullable_to_non_nullable
                      as String,
            devId: null == devId
                ? _value.devId
                : devId // ignore: cast_nullable_to_non_nullable
                      as String,
            unitId: freezed == unitId
                ? _value.unitId
                : unitId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sensId: freezed == sensId
                ? _value.sensId
                : sensId // ignore: cast_nullable_to_non_nullable
                      as String?,
            dcNormalValue: freezed == dcNormalValue
                ? _value.dcNormalValue
                : dcNormalValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            dsMinNormValue: freezed == dsMinNormValue
                ? _value.dsMinNormValue
                : dsMinNormValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            dsMaxNormValue: freezed == dsMaxNormValue
                ? _value.dsMaxNormValue
                : dsMaxNormValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            dsMinValue: freezed == dsMinValue
                ? _value.dsMinValue
                : dsMinValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            dsMaxValue: freezed == dsMaxValue
                ? _value.dsMaxValue
                : dsMaxValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            dsMinValWarn: freezed == dsMinValWarn
                ? _value.dsMinValWarn
                : dsMinValWarn // ignore: cast_nullable_to_non_nullable
                      as double?,
            dsMaxValWarn: freezed == dsMaxValWarn
                ? _value.dsMaxValWarn
                : dsMaxValWarn // ignore: cast_nullable_to_non_nullable
                      as double?,
            dsName: freezed == dsName
                ? _value.dsName
                : dsName // ignore: cast_nullable_to_non_nullable
                      as String?,
            dsAddress: freezed == dsAddress
                ? _value.dsAddress
                : dsAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            dsSeq: freezed == dsSeq
                ? _value.dsSeq
                : dsSeq // ignore: cast_nullable_to_non_nullable
                      as int?,
            dsSts: freezed == dsSts
                ? _value.dsSts
                : dsSts // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceSensorModelImplCopyWith<$Res>
    implements $DeviceSensorModelCopyWith<$Res> {
  factory _$$DeviceSensorModelImplCopyWith(
    _$DeviceSensorModelImpl value,
    $Res Function(_$DeviceSensorModelImpl) then,
  ) = __$$DeviceSensorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ds_id') String dsId,
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'sens_id') String? sensId,
    @JsonKey(name: 'dc_normal_value') double? dcNormalValue,
    @JsonKey(name: 'ds_min_norm_value') double? dsMinNormValue,
    @JsonKey(name: 'ds_max_norm_value') double? dsMaxNormValue,
    @JsonKey(name: 'ds_min_value') double? dsMinValue,
    @JsonKey(name: 'ds_max_value') double? dsMaxValue,
    @JsonKey(name: 'ds_min_val_warn') double? dsMinValWarn,
    @JsonKey(name: 'ds_max_val_warn') double? dsMaxValWarn,
    @JsonKey(name: 'ds_name') String? dsName,
    @JsonKey(name: 'ds_address') String? dsAddress,
    @JsonKey(name: 'ds_seq') int? dsSeq,
    @JsonKey(name: 'ds_sts') int? dsSts,
  });
}

/// @nodoc
class __$$DeviceSensorModelImplCopyWithImpl<$Res>
    extends _$DeviceSensorModelCopyWithImpl<$Res, _$DeviceSensorModelImpl>
    implements _$$DeviceSensorModelImplCopyWith<$Res> {
  __$$DeviceSensorModelImplCopyWithImpl(
    _$DeviceSensorModelImpl _value,
    $Res Function(_$DeviceSensorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceSensorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dsId = null,
    Object? devId = null,
    Object? unitId = freezed,
    Object? sensId = freezed,
    Object? dcNormalValue = freezed,
    Object? dsMinNormValue = freezed,
    Object? dsMaxNormValue = freezed,
    Object? dsMinValue = freezed,
    Object? dsMaxValue = freezed,
    Object? dsMinValWarn = freezed,
    Object? dsMaxValWarn = freezed,
    Object? dsName = freezed,
    Object? dsAddress = freezed,
    Object? dsSeq = freezed,
    Object? dsSts = freezed,
  }) {
    return _then(
      _$DeviceSensorModelImpl(
        dsId: null == dsId
            ? _value.dsId
            : dsId // ignore: cast_nullable_to_non_nullable
                  as String,
        devId: null == devId
            ? _value.devId
            : devId // ignore: cast_nullable_to_non_nullable
                  as String,
        unitId: freezed == unitId
            ? _value.unitId
            : unitId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sensId: freezed == sensId
            ? _value.sensId
            : sensId // ignore: cast_nullable_to_non_nullable
                  as String?,
        dcNormalValue: freezed == dcNormalValue
            ? _value.dcNormalValue
            : dcNormalValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        dsMinNormValue: freezed == dsMinNormValue
            ? _value.dsMinNormValue
            : dsMinNormValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        dsMaxNormValue: freezed == dsMaxNormValue
            ? _value.dsMaxNormValue
            : dsMaxNormValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        dsMinValue: freezed == dsMinValue
            ? _value.dsMinValue
            : dsMinValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        dsMaxValue: freezed == dsMaxValue
            ? _value.dsMaxValue
            : dsMaxValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        dsMinValWarn: freezed == dsMinValWarn
            ? _value.dsMinValWarn
            : dsMinValWarn // ignore: cast_nullable_to_non_nullable
                  as double?,
        dsMaxValWarn: freezed == dsMaxValWarn
            ? _value.dsMaxValWarn
            : dsMaxValWarn // ignore: cast_nullable_to_non_nullable
                  as double?,
        dsName: freezed == dsName
            ? _value.dsName
            : dsName // ignore: cast_nullable_to_non_nullable
                  as String?,
        dsAddress: freezed == dsAddress
            ? _value.dsAddress
            : dsAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        dsSeq: freezed == dsSeq
            ? _value.dsSeq
            : dsSeq // ignore: cast_nullable_to_non_nullable
                  as int?,
        dsSts: freezed == dsSts
            ? _value.dsSts
            : dsSts // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceSensorModelImpl extends _DeviceSensorModel {
  const _$DeviceSensorModelImpl({
    @JsonKey(name: 'ds_id') required this.dsId,
    @JsonKey(name: 'dev_id') required this.devId,
    @JsonKey(name: 'unit_id') this.unitId,
    @JsonKey(name: 'sens_id') this.sensId,
    @JsonKey(name: 'dc_normal_value') this.dcNormalValue,
    @JsonKey(name: 'ds_min_norm_value') this.dsMinNormValue,
    @JsonKey(name: 'ds_max_norm_value') this.dsMaxNormValue,
    @JsonKey(name: 'ds_min_value') this.dsMinValue,
    @JsonKey(name: 'ds_max_value') this.dsMaxValue,
    @JsonKey(name: 'ds_min_val_warn') this.dsMinValWarn,
    @JsonKey(name: 'ds_max_val_warn') this.dsMaxValWarn,
    @JsonKey(name: 'ds_name') this.dsName,
    @JsonKey(name: 'ds_address') this.dsAddress,
    @JsonKey(name: 'ds_seq') this.dsSeq,
    @JsonKey(name: 'ds_sts') this.dsSts,
  }) : super._();

  factory _$DeviceSensorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceSensorModelImplFromJson(json);

  @override
  @JsonKey(name: 'ds_id')
  final String dsId;
  @override
  @JsonKey(name: 'dev_id')
  final String devId;
  @override
  @JsonKey(name: 'unit_id')
  final String? unitId;
  @override
  @JsonKey(name: 'sens_id')
  final String? sensId;
  @override
  @JsonKey(name: 'dc_normal_value')
  final double? dcNormalValue;
  @override
  @JsonKey(name: 'ds_min_norm_value')
  final double? dsMinNormValue;
  @override
  @JsonKey(name: 'ds_max_norm_value')
  final double? dsMaxNormValue;
  @override
  @JsonKey(name: 'ds_min_value')
  final double? dsMinValue;
  @override
  @JsonKey(name: 'ds_max_value')
  final double? dsMaxValue;
  @override
  @JsonKey(name: 'ds_min_val_warn')
  final double? dsMinValWarn;
  @override
  @JsonKey(name: 'ds_max_val_warn')
  final double? dsMaxValWarn;
  @override
  @JsonKey(name: 'ds_name')
  final String? dsName;
  @override
  @JsonKey(name: 'ds_address')
  final String? dsAddress;
  @override
  @JsonKey(name: 'ds_seq')
  final int? dsSeq;
  @override
  @JsonKey(name: 'ds_sts')
  final int? dsSts;

  @override
  String toString() {
    return 'DeviceSensorModel(dsId: $dsId, devId: $devId, unitId: $unitId, sensId: $sensId, dcNormalValue: $dcNormalValue, dsMinNormValue: $dsMinNormValue, dsMaxNormValue: $dsMaxNormValue, dsMinValue: $dsMinValue, dsMaxValue: $dsMaxValue, dsMinValWarn: $dsMinValWarn, dsMaxValWarn: $dsMaxValWarn, dsName: $dsName, dsAddress: $dsAddress, dsSeq: $dsSeq, dsSts: $dsSts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceSensorModelImpl &&
            (identical(other.dsId, dsId) || other.dsId == dsId) &&
            (identical(other.devId, devId) || other.devId == devId) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.sensId, sensId) || other.sensId == sensId) &&
            (identical(other.dcNormalValue, dcNormalValue) ||
                other.dcNormalValue == dcNormalValue) &&
            (identical(other.dsMinNormValue, dsMinNormValue) ||
                other.dsMinNormValue == dsMinNormValue) &&
            (identical(other.dsMaxNormValue, dsMaxNormValue) ||
                other.dsMaxNormValue == dsMaxNormValue) &&
            (identical(other.dsMinValue, dsMinValue) ||
                other.dsMinValue == dsMinValue) &&
            (identical(other.dsMaxValue, dsMaxValue) ||
                other.dsMaxValue == dsMaxValue) &&
            (identical(other.dsMinValWarn, dsMinValWarn) ||
                other.dsMinValWarn == dsMinValWarn) &&
            (identical(other.dsMaxValWarn, dsMaxValWarn) ||
                other.dsMaxValWarn == dsMaxValWarn) &&
            (identical(other.dsName, dsName) || other.dsName == dsName) &&
            (identical(other.dsAddress, dsAddress) ||
                other.dsAddress == dsAddress) &&
            (identical(other.dsSeq, dsSeq) || other.dsSeq == dsSeq) &&
            (identical(other.dsSts, dsSts) || other.dsSts == dsSts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dsId,
    devId,
    unitId,
    sensId,
    dcNormalValue,
    dsMinNormValue,
    dsMaxNormValue,
    dsMinValue,
    dsMaxValue,
    dsMinValWarn,
    dsMaxValWarn,
    dsName,
    dsAddress,
    dsSeq,
    dsSts,
  );

  /// Create a copy of DeviceSensorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceSensorModelImplCopyWith<_$DeviceSensorModelImpl> get copyWith =>
      __$$DeviceSensorModelImplCopyWithImpl<_$DeviceSensorModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceSensorModelImplToJson(this);
  }
}

abstract class _DeviceSensorModel extends DeviceSensorModel {
  const factory _DeviceSensorModel({
    @JsonKey(name: 'ds_id') required final String dsId,
    @JsonKey(name: 'dev_id') required final String devId,
    @JsonKey(name: 'unit_id') final String? unitId,
    @JsonKey(name: 'sens_id') final String? sensId,
    @JsonKey(name: 'dc_normal_value') final double? dcNormalValue,
    @JsonKey(name: 'ds_min_norm_value') final double? dsMinNormValue,
    @JsonKey(name: 'ds_max_norm_value') final double? dsMaxNormValue,
    @JsonKey(name: 'ds_min_value') final double? dsMinValue,
    @JsonKey(name: 'ds_max_value') final double? dsMaxValue,
    @JsonKey(name: 'ds_min_val_warn') final double? dsMinValWarn,
    @JsonKey(name: 'ds_max_val_warn') final double? dsMaxValWarn,
    @JsonKey(name: 'ds_name') final String? dsName,
    @JsonKey(name: 'ds_address') final String? dsAddress,
    @JsonKey(name: 'ds_seq') final int? dsSeq,
    @JsonKey(name: 'ds_sts') final int? dsSts,
  }) = _$DeviceSensorModelImpl;
  const _DeviceSensorModel._() : super._();

  factory _DeviceSensorModel.fromJson(Map<String, dynamic> json) =
      _$DeviceSensorModelImpl.fromJson;

  @override
  @JsonKey(name: 'ds_id')
  String get dsId;
  @override
  @JsonKey(name: 'dev_id')
  String get devId;
  @override
  @JsonKey(name: 'unit_id')
  String? get unitId;
  @override
  @JsonKey(name: 'sens_id')
  String? get sensId;
  @override
  @JsonKey(name: 'dc_normal_value')
  double? get dcNormalValue;
  @override
  @JsonKey(name: 'ds_min_norm_value')
  double? get dsMinNormValue;
  @override
  @JsonKey(name: 'ds_max_norm_value')
  double? get dsMaxNormValue;
  @override
  @JsonKey(name: 'ds_min_value')
  double? get dsMinValue;
  @override
  @JsonKey(name: 'ds_max_value')
  double? get dsMaxValue;
  @override
  @JsonKey(name: 'ds_min_val_warn')
  double? get dsMinValWarn;
  @override
  @JsonKey(name: 'ds_max_val_warn')
  double? get dsMaxValWarn;
  @override
  @JsonKey(name: 'ds_name')
  String? get dsName;
  @override
  @JsonKey(name: 'ds_address')
  String? get dsAddress;
  @override
  @JsonKey(name: 'ds_seq')
  int? get dsSeq;
  @override
  @JsonKey(name: 'ds_sts')
  int? get dsSts;

  /// Create a copy of DeviceSensorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceSensorModelImplCopyWith<_$DeviceSensorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
