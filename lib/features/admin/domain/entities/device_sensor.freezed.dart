// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_sensor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DeviceSensor {
  String get dsId => throw _privateConstructorUsedError;
  String get devId => throw _privateConstructorUsedError;
  String? get unitId => throw _privateConstructorUsedError;
  String? get sensId => throw _privateConstructorUsedError;
  double? get dcNormalValue => throw _privateConstructorUsedError;
  double? get dsMinNormValue => throw _privateConstructorUsedError;
  double? get dsMaxNormValue => throw _privateConstructorUsedError;
  double? get dsMinValue => throw _privateConstructorUsedError;
  double? get dsMaxValue => throw _privateConstructorUsedError;
  double? get dsMinValWarn => throw _privateConstructorUsedError;
  double? get dsMaxValWarn => throw _privateConstructorUsedError;
  String? get dsName => throw _privateConstructorUsedError;
  String? get dsAddress => throw _privateConstructorUsedError;
  int? get dsSeq => throw _privateConstructorUsedError;
  int? get dsSts => throw _privateConstructorUsedError;
  DateTime? get dsCreated => throw _privateConstructorUsedError;
  DateTime? get dsUpdate => throw _privateConstructorUsedError;

  /// Create a copy of DeviceSensor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceSensorCopyWith<DeviceSensor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceSensorCopyWith<$Res> {
  factory $DeviceSensorCopyWith(
    DeviceSensor value,
    $Res Function(DeviceSensor) then,
  ) = _$DeviceSensorCopyWithImpl<$Res, DeviceSensor>;
  @useResult
  $Res call({
    String dsId,
    String devId,
    String? unitId,
    String? sensId,
    double? dcNormalValue,
    double? dsMinNormValue,
    double? dsMaxNormValue,
    double? dsMinValue,
    double? dsMaxValue,
    double? dsMinValWarn,
    double? dsMaxValWarn,
    String? dsName,
    String? dsAddress,
    int? dsSeq,
    int? dsSts,
    DateTime? dsCreated,
    DateTime? dsUpdate,
  });
}

/// @nodoc
class _$DeviceSensorCopyWithImpl<$Res, $Val extends DeviceSensor>
    implements $DeviceSensorCopyWith<$Res> {
  _$DeviceSensorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceSensor
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
    Object? dsCreated = freezed,
    Object? dsUpdate = freezed,
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
            dsCreated: freezed == dsCreated
                ? _value.dsCreated
                : dsCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dsUpdate: freezed == dsUpdate
                ? _value.dsUpdate
                : dsUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceSensorImplCopyWith<$Res>
    implements $DeviceSensorCopyWith<$Res> {
  factory _$$DeviceSensorImplCopyWith(
    _$DeviceSensorImpl value,
    $Res Function(_$DeviceSensorImpl) then,
  ) = __$$DeviceSensorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String dsId,
    String devId,
    String? unitId,
    String? sensId,
    double? dcNormalValue,
    double? dsMinNormValue,
    double? dsMaxNormValue,
    double? dsMinValue,
    double? dsMaxValue,
    double? dsMinValWarn,
    double? dsMaxValWarn,
    String? dsName,
    String? dsAddress,
    int? dsSeq,
    int? dsSts,
    DateTime? dsCreated,
    DateTime? dsUpdate,
  });
}

/// @nodoc
class __$$DeviceSensorImplCopyWithImpl<$Res>
    extends _$DeviceSensorCopyWithImpl<$Res, _$DeviceSensorImpl>
    implements _$$DeviceSensorImplCopyWith<$Res> {
  __$$DeviceSensorImplCopyWithImpl(
    _$DeviceSensorImpl _value,
    $Res Function(_$DeviceSensorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceSensor
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
    Object? dsCreated = freezed,
    Object? dsUpdate = freezed,
  }) {
    return _then(
      _$DeviceSensorImpl(
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
        dsCreated: freezed == dsCreated
            ? _value.dsCreated
            : dsCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dsUpdate: freezed == dsUpdate
            ? _value.dsUpdate
            : dsUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$DeviceSensorImpl extends _DeviceSensor {
  const _$DeviceSensorImpl({
    required this.dsId,
    required this.devId,
    this.unitId,
    this.sensId,
    this.dcNormalValue,
    this.dsMinNormValue,
    this.dsMaxNormValue,
    this.dsMinValue,
    this.dsMaxValue,
    this.dsMinValWarn,
    this.dsMaxValWarn,
    this.dsName,
    this.dsAddress,
    this.dsSeq,
    this.dsSts,
    this.dsCreated,
    this.dsUpdate,
  }) : super._();

  @override
  final String dsId;
  @override
  final String devId;
  @override
  final String? unitId;
  @override
  final String? sensId;
  @override
  final double? dcNormalValue;
  @override
  final double? dsMinNormValue;
  @override
  final double? dsMaxNormValue;
  @override
  final double? dsMinValue;
  @override
  final double? dsMaxValue;
  @override
  final double? dsMinValWarn;
  @override
  final double? dsMaxValWarn;
  @override
  final String? dsName;
  @override
  final String? dsAddress;
  @override
  final int? dsSeq;
  @override
  final int? dsSts;
  @override
  final DateTime? dsCreated;
  @override
  final DateTime? dsUpdate;

  @override
  String toString() {
    return 'DeviceSensor(dsId: $dsId, devId: $devId, unitId: $unitId, sensId: $sensId, dcNormalValue: $dcNormalValue, dsMinNormValue: $dsMinNormValue, dsMaxNormValue: $dsMaxNormValue, dsMinValue: $dsMinValue, dsMaxValue: $dsMaxValue, dsMinValWarn: $dsMinValWarn, dsMaxValWarn: $dsMaxValWarn, dsName: $dsName, dsAddress: $dsAddress, dsSeq: $dsSeq, dsSts: $dsSts, dsCreated: $dsCreated, dsUpdate: $dsUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceSensorImpl &&
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
            (identical(other.dsSts, dsSts) || other.dsSts == dsSts) &&
            (identical(other.dsCreated, dsCreated) ||
                other.dsCreated == dsCreated) &&
            (identical(other.dsUpdate, dsUpdate) ||
                other.dsUpdate == dsUpdate));
  }

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
    dsCreated,
    dsUpdate,
  );

  /// Create a copy of DeviceSensor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceSensorImplCopyWith<_$DeviceSensorImpl> get copyWith =>
      __$$DeviceSensorImplCopyWithImpl<_$DeviceSensorImpl>(this, _$identity);
}

abstract class _DeviceSensor extends DeviceSensor {
  const factory _DeviceSensor({
    required final String dsId,
    required final String devId,
    final String? unitId,
    final String? sensId,
    final double? dcNormalValue,
    final double? dsMinNormValue,
    final double? dsMaxNormValue,
    final double? dsMinValue,
    final double? dsMaxValue,
    final double? dsMinValWarn,
    final double? dsMaxValWarn,
    final String? dsName,
    final String? dsAddress,
    final int? dsSeq,
    final int? dsSts,
    final DateTime? dsCreated,
    final DateTime? dsUpdate,
  }) = _$DeviceSensorImpl;
  const _DeviceSensor._() : super._();

  @override
  String get dsId;
  @override
  String get devId;
  @override
  String? get unitId;
  @override
  String? get sensId;
  @override
  double? get dcNormalValue;
  @override
  double? get dsMinNormValue;
  @override
  double? get dsMaxNormValue;
  @override
  double? get dsMinValue;
  @override
  double? get dsMaxValue;
  @override
  double? get dsMinValWarn;
  @override
  double? get dsMaxValWarn;
  @override
  String? get dsName;
  @override
  String? get dsAddress;
  @override
  int? get dsSeq;
  @override
  int? get dsSts;
  @override
  DateTime? get dsCreated;
  @override
  DateTime? get dsUpdate;

  /// Create a copy of DeviceSensor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceSensorImplCopyWith<_$DeviceSensorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
