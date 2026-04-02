// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_read_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SensorReadModel _$SensorReadModelFromJson(Map<String, dynamic> json) {
  return _SensorReadModel.fromJson(json);
}

/// @nodoc
mixin _$SensorReadModel {
  @JsonKey(name: 'read_id')
  String get readId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_id')
  String? get dsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_id')
  String? get devId => throw _privateConstructorUsedError;
  @JsonKey(name: 'log_rx_id')
  String? get logRxId => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_date')
  DateTime? get readDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_value')
  String? get readValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_sts')
  int? get readSts => throw _privateConstructorUsedError;

  /// Serializes this SensorReadModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SensorReadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorReadModelCopyWith<SensorReadModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorReadModelCopyWith<$Res> {
  factory $SensorReadModelCopyWith(
    SensorReadModel value,
    $Res Function(SensorReadModel) then,
  ) = _$SensorReadModelCopyWithImpl<$Res, SensorReadModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'read_id') String readId,
    @JsonKey(name: 'ds_id') String? dsId,
    @JsonKey(name: 'dev_id') String? devId,
    @JsonKey(name: 'log_rx_id') String? logRxId,
    @JsonKey(name: 'read_date') DateTime? readDate,
    @JsonKey(name: 'read_value') String? readValue,
    @JsonKey(name: 'read_sts') int? readSts,
  });
}

/// @nodoc
class _$SensorReadModelCopyWithImpl<$Res, $Val extends SensorReadModel>
    implements $SensorReadModelCopyWith<$Res> {
  _$SensorReadModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SensorReadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readId = null,
    Object? dsId = freezed,
    Object? devId = freezed,
    Object? logRxId = freezed,
    Object? readDate = freezed,
    Object? readValue = freezed,
    Object? readSts = freezed,
  }) {
    return _then(
      _value.copyWith(
            readId: null == readId
                ? _value.readId
                : readId // ignore: cast_nullable_to_non_nullable
                      as String,
            dsId: freezed == dsId
                ? _value.dsId
                : dsId // ignore: cast_nullable_to_non_nullable
                      as String?,
            devId: freezed == devId
                ? _value.devId
                : devId // ignore: cast_nullable_to_non_nullable
                      as String?,
            logRxId: freezed == logRxId
                ? _value.logRxId
                : logRxId // ignore: cast_nullable_to_non_nullable
                      as String?,
            readDate: freezed == readDate
                ? _value.readDate
                : readDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readValue: freezed == readValue
                ? _value.readValue
                : readValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            readSts: freezed == readSts
                ? _value.readSts
                : readSts // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SensorReadModelImplCopyWith<$Res>
    implements $SensorReadModelCopyWith<$Res> {
  factory _$$SensorReadModelImplCopyWith(
    _$SensorReadModelImpl value,
    $Res Function(_$SensorReadModelImpl) then,
  ) = __$$SensorReadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'read_id') String readId,
    @JsonKey(name: 'ds_id') String? dsId,
    @JsonKey(name: 'dev_id') String? devId,
    @JsonKey(name: 'log_rx_id') String? logRxId,
    @JsonKey(name: 'read_date') DateTime? readDate,
    @JsonKey(name: 'read_value') String? readValue,
    @JsonKey(name: 'read_sts') int? readSts,
  });
}

/// @nodoc
class __$$SensorReadModelImplCopyWithImpl<$Res>
    extends _$SensorReadModelCopyWithImpl<$Res, _$SensorReadModelImpl>
    implements _$$SensorReadModelImplCopyWith<$Res> {
  __$$SensorReadModelImplCopyWithImpl(
    _$SensorReadModelImpl _value,
    $Res Function(_$SensorReadModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SensorReadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readId = null,
    Object? dsId = freezed,
    Object? devId = freezed,
    Object? logRxId = freezed,
    Object? readDate = freezed,
    Object? readValue = freezed,
    Object? readSts = freezed,
  }) {
    return _then(
      _$SensorReadModelImpl(
        readId: null == readId
            ? _value.readId
            : readId // ignore: cast_nullable_to_non_nullable
                  as String,
        dsId: freezed == dsId
            ? _value.dsId
            : dsId // ignore: cast_nullable_to_non_nullable
                  as String?,
        devId: freezed == devId
            ? _value.devId
            : devId // ignore: cast_nullable_to_non_nullable
                  as String?,
        logRxId: freezed == logRxId
            ? _value.logRxId
            : logRxId // ignore: cast_nullable_to_non_nullable
                  as String?,
        readDate: freezed == readDate
            ? _value.readDate
            : readDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readValue: freezed == readValue
            ? _value.readValue
            : readValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        readSts: freezed == readSts
            ? _value.readSts
            : readSts // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorReadModelImpl extends _SensorReadModel {
  const _$SensorReadModelImpl({
    @JsonKey(name: 'read_id') required this.readId,
    @JsonKey(name: 'ds_id') this.dsId,
    @JsonKey(name: 'dev_id') this.devId,
    @JsonKey(name: 'log_rx_id') this.logRxId,
    @JsonKey(name: 'read_date') this.readDate,
    @JsonKey(name: 'read_value') this.readValue,
    @JsonKey(name: 'read_sts') this.readSts,
  }) : super._();

  factory _$SensorReadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorReadModelImplFromJson(json);

  @override
  @JsonKey(name: 'read_id')
  final String readId;
  @override
  @JsonKey(name: 'ds_id')
  final String? dsId;
  @override
  @JsonKey(name: 'dev_id')
  final String? devId;
  @override
  @JsonKey(name: 'log_rx_id')
  final String? logRxId;
  @override
  @JsonKey(name: 'read_date')
  final DateTime? readDate;
  @override
  @JsonKey(name: 'read_value')
  final String? readValue;
  @override
  @JsonKey(name: 'read_sts')
  final int? readSts;

  @override
  String toString() {
    return 'SensorReadModel(readId: $readId, dsId: $dsId, devId: $devId, logRxId: $logRxId, readDate: $readDate, readValue: $readValue, readSts: $readSts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorReadModelImpl &&
            (identical(other.readId, readId) || other.readId == readId) &&
            (identical(other.dsId, dsId) || other.dsId == dsId) &&
            (identical(other.devId, devId) || other.devId == devId) &&
            (identical(other.logRxId, logRxId) || other.logRxId == logRxId) &&
            (identical(other.readDate, readDate) ||
                other.readDate == readDate) &&
            (identical(other.readValue, readValue) ||
                other.readValue == readValue) &&
            (identical(other.readSts, readSts) || other.readSts == readSts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    readId,
    dsId,
    devId,
    logRxId,
    readDate,
    readValue,
    readSts,
  );

  /// Create a copy of SensorReadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorReadModelImplCopyWith<_$SensorReadModelImpl> get copyWith =>
      __$$SensorReadModelImplCopyWithImpl<_$SensorReadModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorReadModelImplToJson(this);
  }
}

abstract class _SensorReadModel extends SensorReadModel {
  const factory _SensorReadModel({
    @JsonKey(name: 'read_id') required final String readId,
    @JsonKey(name: 'ds_id') final String? dsId,
    @JsonKey(name: 'dev_id') final String? devId,
    @JsonKey(name: 'log_rx_id') final String? logRxId,
    @JsonKey(name: 'read_date') final DateTime? readDate,
    @JsonKey(name: 'read_value') final String? readValue,
    @JsonKey(name: 'read_sts') final int? readSts,
  }) = _$SensorReadModelImpl;
  const _SensorReadModel._() : super._();

  factory _SensorReadModel.fromJson(Map<String, dynamic> json) =
      _$SensorReadModelImpl.fromJson;

  @override
  @JsonKey(name: 'read_id')
  String get readId;
  @override
  @JsonKey(name: 'ds_id')
  String? get dsId;
  @override
  @JsonKey(name: 'dev_id')
  String? get devId;
  @override
  @JsonKey(name: 'log_rx_id')
  String? get logRxId;
  @override
  @JsonKey(name: 'read_date')
  DateTime? get readDate;
  @override
  @JsonKey(name: 'read_value')
  String? get readValue;
  @override
  @JsonKey(name: 'read_sts')
  int? get readSts;

  /// Create a copy of SensorReadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorReadModelImplCopyWith<_$SensorReadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SensorReadUpdateModel _$SensorReadUpdateModelFromJson(
  Map<String, dynamic> json,
) {
  return _SensorReadUpdateModel.fromJson(json);
}

/// @nodoc
mixin _$SensorReadUpdateModel {
  @JsonKey(name: 'read_update_id')
  String get readUpdateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_id')
  String get dsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_id')
  String get devId => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_update_date')
  DateTime? get readUpdateDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_update_value')
  String? get readUpdateValue => throw _privateConstructorUsedError;

  /// Serializes this SensorReadUpdateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SensorReadUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorReadUpdateModelCopyWith<SensorReadUpdateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorReadUpdateModelCopyWith<$Res> {
  factory $SensorReadUpdateModelCopyWith(
    SensorReadUpdateModel value,
    $Res Function(SensorReadUpdateModel) then,
  ) = _$SensorReadUpdateModelCopyWithImpl<$Res, SensorReadUpdateModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'read_update_id') String readUpdateId,
    @JsonKey(name: 'ds_id') String dsId,
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'read_update_date') DateTime? readUpdateDate,
    @JsonKey(name: 'read_update_value') String? readUpdateValue,
  });
}

/// @nodoc
class _$SensorReadUpdateModelCopyWithImpl<
  $Res,
  $Val extends SensorReadUpdateModel
>
    implements $SensorReadUpdateModelCopyWith<$Res> {
  _$SensorReadUpdateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SensorReadUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readUpdateId = null,
    Object? dsId = null,
    Object? devId = null,
    Object? readUpdateDate = freezed,
    Object? readUpdateValue = freezed,
  }) {
    return _then(
      _value.copyWith(
            readUpdateId: null == readUpdateId
                ? _value.readUpdateId
                : readUpdateId // ignore: cast_nullable_to_non_nullable
                      as String,
            dsId: null == dsId
                ? _value.dsId
                : dsId // ignore: cast_nullable_to_non_nullable
                      as String,
            devId: null == devId
                ? _value.devId
                : devId // ignore: cast_nullable_to_non_nullable
                      as String,
            readUpdateDate: freezed == readUpdateDate
                ? _value.readUpdateDate
                : readUpdateDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readUpdateValue: freezed == readUpdateValue
                ? _value.readUpdateValue
                : readUpdateValue // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SensorReadUpdateModelImplCopyWith<$Res>
    implements $SensorReadUpdateModelCopyWith<$Res> {
  factory _$$SensorReadUpdateModelImplCopyWith(
    _$SensorReadUpdateModelImpl value,
    $Res Function(_$SensorReadUpdateModelImpl) then,
  ) = __$$SensorReadUpdateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'read_update_id') String readUpdateId,
    @JsonKey(name: 'ds_id') String dsId,
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'read_update_date') DateTime? readUpdateDate,
    @JsonKey(name: 'read_update_value') String? readUpdateValue,
  });
}

/// @nodoc
class __$$SensorReadUpdateModelImplCopyWithImpl<$Res>
    extends
        _$SensorReadUpdateModelCopyWithImpl<$Res, _$SensorReadUpdateModelImpl>
    implements _$$SensorReadUpdateModelImplCopyWith<$Res> {
  __$$SensorReadUpdateModelImplCopyWithImpl(
    _$SensorReadUpdateModelImpl _value,
    $Res Function(_$SensorReadUpdateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SensorReadUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readUpdateId = null,
    Object? dsId = null,
    Object? devId = null,
    Object? readUpdateDate = freezed,
    Object? readUpdateValue = freezed,
  }) {
    return _then(
      _$SensorReadUpdateModelImpl(
        readUpdateId: null == readUpdateId
            ? _value.readUpdateId
            : readUpdateId // ignore: cast_nullable_to_non_nullable
                  as String,
        dsId: null == dsId
            ? _value.dsId
            : dsId // ignore: cast_nullable_to_non_nullable
                  as String,
        devId: null == devId
            ? _value.devId
            : devId // ignore: cast_nullable_to_non_nullable
                  as String,
        readUpdateDate: freezed == readUpdateDate
            ? _value.readUpdateDate
            : readUpdateDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readUpdateValue: freezed == readUpdateValue
            ? _value.readUpdateValue
            : readUpdateValue // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorReadUpdateModelImpl extends _SensorReadUpdateModel {
  const _$SensorReadUpdateModelImpl({
    @JsonKey(name: 'read_update_id') required this.readUpdateId,
    @JsonKey(name: 'ds_id') required this.dsId,
    @JsonKey(name: 'dev_id') required this.devId,
    @JsonKey(name: 'read_update_date') this.readUpdateDate,
    @JsonKey(name: 'read_update_value') this.readUpdateValue,
  }) : super._();

  factory _$SensorReadUpdateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorReadUpdateModelImplFromJson(json);

  @override
  @JsonKey(name: 'read_update_id')
  final String readUpdateId;
  @override
  @JsonKey(name: 'ds_id')
  final String dsId;
  @override
  @JsonKey(name: 'dev_id')
  final String devId;
  @override
  @JsonKey(name: 'read_update_date')
  final DateTime? readUpdateDate;
  @override
  @JsonKey(name: 'read_update_value')
  final String? readUpdateValue;

  @override
  String toString() {
    return 'SensorReadUpdateModel(readUpdateId: $readUpdateId, dsId: $dsId, devId: $devId, readUpdateDate: $readUpdateDate, readUpdateValue: $readUpdateValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorReadUpdateModelImpl &&
            (identical(other.readUpdateId, readUpdateId) ||
                other.readUpdateId == readUpdateId) &&
            (identical(other.dsId, dsId) || other.dsId == dsId) &&
            (identical(other.devId, devId) || other.devId == devId) &&
            (identical(other.readUpdateDate, readUpdateDate) ||
                other.readUpdateDate == readUpdateDate) &&
            (identical(other.readUpdateValue, readUpdateValue) ||
                other.readUpdateValue == readUpdateValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    readUpdateId,
    dsId,
    devId,
    readUpdateDate,
    readUpdateValue,
  );

  /// Create a copy of SensorReadUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorReadUpdateModelImplCopyWith<_$SensorReadUpdateModelImpl>
  get copyWith =>
      __$$SensorReadUpdateModelImplCopyWithImpl<_$SensorReadUpdateModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorReadUpdateModelImplToJson(this);
  }
}

abstract class _SensorReadUpdateModel extends SensorReadUpdateModel {
  const factory _SensorReadUpdateModel({
    @JsonKey(name: 'read_update_id') required final String readUpdateId,
    @JsonKey(name: 'ds_id') required final String dsId,
    @JsonKey(name: 'dev_id') required final String devId,
    @JsonKey(name: 'read_update_date') final DateTime? readUpdateDate,
    @JsonKey(name: 'read_update_value') final String? readUpdateValue,
  }) = _$SensorReadUpdateModelImpl;
  const _SensorReadUpdateModel._() : super._();

  factory _SensorReadUpdateModel.fromJson(Map<String, dynamic> json) =
      _$SensorReadUpdateModelImpl.fromJson;

  @override
  @JsonKey(name: 'read_update_id')
  String get readUpdateId;
  @override
  @JsonKey(name: 'ds_id')
  String get dsId;
  @override
  @JsonKey(name: 'dev_id')
  String get devId;
  @override
  @JsonKey(name: 'read_update_date')
  DateTime? get readUpdateDate;
  @override
  @JsonKey(name: 'read_update_value')
  String? get readUpdateValue;

  /// Create a copy of SensorReadUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorReadUpdateModelImplCopyWith<_$SensorReadUpdateModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SensorDailyModel _$SensorDailyModelFromJson(Map<String, dynamic> json) {
  return _SensorDailyModel.fromJson(json);
}

/// @nodoc
mixin _$SensorDailyModel {
  @JsonKey(name: 'day')
  DateTime get day => throw _privateConstructorUsedError;
  @JsonKey(name: 'dev_id')
  String get devId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ds_id')
  String get dsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_val')
  double? get avgVal => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_val')
  double? get minVal => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_val')
  double? get maxVal => throw _privateConstructorUsedError;

  /// Serializes this SensorDailyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SensorDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorDailyModelCopyWith<SensorDailyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorDailyModelCopyWith<$Res> {
  factory $SensorDailyModelCopyWith(
    SensorDailyModel value,
    $Res Function(SensorDailyModel) then,
  ) = _$SensorDailyModelCopyWithImpl<$Res, SensorDailyModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'day') DateTime day,
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'ds_id') String dsId,
    @JsonKey(name: 'avg_val') double? avgVal,
    @JsonKey(name: 'min_val') double? minVal,
    @JsonKey(name: 'max_val') double? maxVal,
  });
}

/// @nodoc
class _$SensorDailyModelCopyWithImpl<$Res, $Val extends SensorDailyModel>
    implements $SensorDailyModelCopyWith<$Res> {
  _$SensorDailyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SensorDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? devId = null,
    Object? dsId = null,
    Object? avgVal = freezed,
    Object? minVal = freezed,
    Object? maxVal = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            devId: null == devId
                ? _value.devId
                : devId // ignore: cast_nullable_to_non_nullable
                      as String,
            dsId: null == dsId
                ? _value.dsId
                : dsId // ignore: cast_nullable_to_non_nullable
                      as String,
            avgVal: freezed == avgVal
                ? _value.avgVal
                : avgVal // ignore: cast_nullable_to_non_nullable
                      as double?,
            minVal: freezed == minVal
                ? _value.minVal
                : minVal // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxVal: freezed == maxVal
                ? _value.maxVal
                : maxVal // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SensorDailyModelImplCopyWith<$Res>
    implements $SensorDailyModelCopyWith<$Res> {
  factory _$$SensorDailyModelImplCopyWith(
    _$SensorDailyModelImpl value,
    $Res Function(_$SensorDailyModelImpl) then,
  ) = __$$SensorDailyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'day') DateTime day,
    @JsonKey(name: 'dev_id') String devId,
    @JsonKey(name: 'ds_id') String dsId,
    @JsonKey(name: 'avg_val') double? avgVal,
    @JsonKey(name: 'min_val') double? minVal,
    @JsonKey(name: 'max_val') double? maxVal,
  });
}

/// @nodoc
class __$$SensorDailyModelImplCopyWithImpl<$Res>
    extends _$SensorDailyModelCopyWithImpl<$Res, _$SensorDailyModelImpl>
    implements _$$SensorDailyModelImplCopyWith<$Res> {
  __$$SensorDailyModelImplCopyWithImpl(
    _$SensorDailyModelImpl _value,
    $Res Function(_$SensorDailyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SensorDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? devId = null,
    Object? dsId = null,
    Object? avgVal = freezed,
    Object? minVal = freezed,
    Object? maxVal = freezed,
  }) {
    return _then(
      _$SensorDailyModelImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        devId: null == devId
            ? _value.devId
            : devId // ignore: cast_nullable_to_non_nullable
                  as String,
        dsId: null == dsId
            ? _value.dsId
            : dsId // ignore: cast_nullable_to_non_nullable
                  as String,
        avgVal: freezed == avgVal
            ? _value.avgVal
            : avgVal // ignore: cast_nullable_to_non_nullable
                  as double?,
        minVal: freezed == minVal
            ? _value.minVal
            : minVal // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxVal: freezed == maxVal
            ? _value.maxVal
            : maxVal // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorDailyModelImpl implements _SensorDailyModel {
  const _$SensorDailyModelImpl({
    @JsonKey(name: 'day') required this.day,
    @JsonKey(name: 'dev_id') required this.devId,
    @JsonKey(name: 'ds_id') required this.dsId,
    @JsonKey(name: 'avg_val') this.avgVal,
    @JsonKey(name: 'min_val') this.minVal,
    @JsonKey(name: 'max_val') this.maxVal,
  });

  factory _$SensorDailyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorDailyModelImplFromJson(json);

  @override
  @JsonKey(name: 'day')
  final DateTime day;
  @override
  @JsonKey(name: 'dev_id')
  final String devId;
  @override
  @JsonKey(name: 'ds_id')
  final String dsId;
  @override
  @JsonKey(name: 'avg_val')
  final double? avgVal;
  @override
  @JsonKey(name: 'min_val')
  final double? minVal;
  @override
  @JsonKey(name: 'max_val')
  final double? maxVal;

  @override
  String toString() {
    return 'SensorDailyModel(day: $day, devId: $devId, dsId: $dsId, avgVal: $avgVal, minVal: $minVal, maxVal: $maxVal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorDailyModelImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.devId, devId) || other.devId == devId) &&
            (identical(other.dsId, dsId) || other.dsId == dsId) &&
            (identical(other.avgVal, avgVal) || other.avgVal == avgVal) &&
            (identical(other.minVal, minVal) || other.minVal == minVal) &&
            (identical(other.maxVal, maxVal) || other.maxVal == maxVal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, day, devId, dsId, avgVal, minVal, maxVal);

  /// Create a copy of SensorDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorDailyModelImplCopyWith<_$SensorDailyModelImpl> get copyWith =>
      __$$SensorDailyModelImplCopyWithImpl<_$SensorDailyModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorDailyModelImplToJson(this);
  }
}

abstract class _SensorDailyModel implements SensorDailyModel {
  const factory _SensorDailyModel({
    @JsonKey(name: 'day') required final DateTime day,
    @JsonKey(name: 'dev_id') required final String devId,
    @JsonKey(name: 'ds_id') required final String dsId,
    @JsonKey(name: 'avg_val') final double? avgVal,
    @JsonKey(name: 'min_val') final double? minVal,
    @JsonKey(name: 'max_val') final double? maxVal,
  }) = _$SensorDailyModelImpl;

  factory _SensorDailyModel.fromJson(Map<String, dynamic> json) =
      _$SensorDailyModelImpl.fromJson;

  @override
  @JsonKey(name: 'day')
  DateTime get day;
  @override
  @JsonKey(name: 'dev_id')
  String get devId;
  @override
  @JsonKey(name: 'ds_id')
  String get dsId;
  @override
  @JsonKey(name: 'avg_val')
  double? get avgVal;
  @override
  @JsonKey(name: 'min_val')
  double? get minVal;
  @override
  @JsonKey(name: 'max_val')
  double? get maxVal;

  /// Create a copy of SensorDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorDailyModelImplCopyWith<_$SensorDailyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
