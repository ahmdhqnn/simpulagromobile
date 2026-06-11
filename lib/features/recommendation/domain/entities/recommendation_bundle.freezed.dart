// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecommendationSensorData {
  num? get nitrogen => throw _privateConstructorUsedError;
  num? get phosphorus => throw _privateConstructorUsedError;
  num? get potassium => throw _privateConstructorUsedError;
  num? get ph => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationSensorData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationSensorDataCopyWith<RecommendationSensorData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationSensorDataCopyWith<$Res> {
  factory $RecommendationSensorDataCopyWith(
    RecommendationSensorData value,
    $Res Function(RecommendationSensorData) then,
  ) = _$RecommendationSensorDataCopyWithImpl<$Res, RecommendationSensorData>;
  @useResult
  $Res call({num? nitrogen, num? phosphorus, num? potassium, num? ph});
}

/// @nodoc
class _$RecommendationSensorDataCopyWithImpl<
  $Res,
  $Val extends RecommendationSensorData
>
    implements $RecommendationSensorDataCopyWith<$Res> {
  _$RecommendationSensorDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationSensorData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nitrogen = freezed,
    Object? phosphorus = freezed,
    Object? potassium = freezed,
    Object? ph = freezed,
  }) {
    return _then(
      _value.copyWith(
            nitrogen: freezed == nitrogen
                ? _value.nitrogen
                : nitrogen // ignore: cast_nullable_to_non_nullable
                      as num?,
            phosphorus: freezed == phosphorus
                ? _value.phosphorus
                : phosphorus // ignore: cast_nullable_to_non_nullable
                      as num?,
            potassium: freezed == potassium
                ? _value.potassium
                : potassium // ignore: cast_nullable_to_non_nullable
                      as num?,
            ph: freezed == ph
                ? _value.ph
                : ph // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationSensorDataImplCopyWith<$Res>
    implements $RecommendationSensorDataCopyWith<$Res> {
  factory _$$RecommendationSensorDataImplCopyWith(
    _$RecommendationSensorDataImpl value,
    $Res Function(_$RecommendationSensorDataImpl) then,
  ) = __$$RecommendationSensorDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num? nitrogen, num? phosphorus, num? potassium, num? ph});
}

/// @nodoc
class __$$RecommendationSensorDataImplCopyWithImpl<$Res>
    extends
        _$RecommendationSensorDataCopyWithImpl<
          $Res,
          _$RecommendationSensorDataImpl
        >
    implements _$$RecommendationSensorDataImplCopyWith<$Res> {
  __$$RecommendationSensorDataImplCopyWithImpl(
    _$RecommendationSensorDataImpl _value,
    $Res Function(_$RecommendationSensorDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationSensorData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nitrogen = freezed,
    Object? phosphorus = freezed,
    Object? potassium = freezed,
    Object? ph = freezed,
  }) {
    return _then(
      _$RecommendationSensorDataImpl(
        nitrogen: freezed == nitrogen
            ? _value.nitrogen
            : nitrogen // ignore: cast_nullable_to_non_nullable
                  as num?,
        phosphorus: freezed == phosphorus
            ? _value.phosphorus
            : phosphorus // ignore: cast_nullable_to_non_nullable
                  as num?,
        potassium: freezed == potassium
            ? _value.potassium
            : potassium // ignore: cast_nullable_to_non_nullable
                  as num?,
        ph: freezed == ph
            ? _value.ph
            : ph // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc

class _$RecommendationSensorDataImpl extends _RecommendationSensorData {
  const _$RecommendationSensorDataImpl({
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    this.ph,
  }) : super._();

  @override
  final num? nitrogen;
  @override
  final num? phosphorus;
  @override
  final num? potassium;
  @override
  final num? ph;

  @override
  String toString() {
    return 'RecommendationSensorData(nitrogen: $nitrogen, phosphorus: $phosphorus, potassium: $potassium, ph: $ph)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationSensorDataImpl &&
            (identical(other.nitrogen, nitrogen) ||
                other.nitrogen == nitrogen) &&
            (identical(other.phosphorus, phosphorus) ||
                other.phosphorus == phosphorus) &&
            (identical(other.potassium, potassium) ||
                other.potassium == potassium) &&
            (identical(other.ph, ph) || other.ph == ph));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nitrogen, phosphorus, potassium, ph);

  /// Create a copy of RecommendationSensorData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationSensorDataImplCopyWith<_$RecommendationSensorDataImpl>
  get copyWith =>
      __$$RecommendationSensorDataImplCopyWithImpl<
        _$RecommendationSensorDataImpl
      >(this, _$identity);
}

abstract class _RecommendationSensorData extends RecommendationSensorData {
  const factory _RecommendationSensorData({
    final num? nitrogen,
    final num? phosphorus,
    final num? potassium,
    final num? ph,
  }) = _$RecommendationSensorDataImpl;
  const _RecommendationSensorData._() : super._();

  @override
  num? get nitrogen;
  @override
  num? get phosphorus;
  @override
  num? get potassium;
  @override
  num? get ph;

  /// Create a copy of RecommendationSensorData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationSensorDataImplCopyWith<_$RecommendationSensorDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecommendationActionResult {
  String get status => throw _privateConstructorUsedError;
  String get pesan => throw _privateConstructorUsedError;
  num get dosisKgHa => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationActionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationActionResultCopyWith<RecommendationActionResult>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationActionResultCopyWith<$Res> {
  factory $RecommendationActionResultCopyWith(
    RecommendationActionResult value,
    $Res Function(RecommendationActionResult) then,
  ) =
      _$RecommendationActionResultCopyWithImpl<
        $Res,
        RecommendationActionResult
      >;
  @useResult
  $Res call({String status, String pesan, num dosisKgHa});
}

/// @nodoc
class _$RecommendationActionResultCopyWithImpl<
  $Res,
  $Val extends RecommendationActionResult
>
    implements $RecommendationActionResultCopyWith<$Res> {
  _$RecommendationActionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationActionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pesan = null,
    Object? dosisKgHa = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            pesan: null == pesan
                ? _value.pesan
                : pesan // ignore: cast_nullable_to_non_nullable
                      as String,
            dosisKgHa: null == dosisKgHa
                ? _value.dosisKgHa
                : dosisKgHa // ignore: cast_nullable_to_non_nullable
                      as num,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationActionResultImplCopyWith<$Res>
    implements $RecommendationActionResultCopyWith<$Res> {
  factory _$$RecommendationActionResultImplCopyWith(
    _$RecommendationActionResultImpl value,
    $Res Function(_$RecommendationActionResultImpl) then,
  ) = __$$RecommendationActionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String pesan, num dosisKgHa});
}

/// @nodoc
class __$$RecommendationActionResultImplCopyWithImpl<$Res>
    extends
        _$RecommendationActionResultCopyWithImpl<
          $Res,
          _$RecommendationActionResultImpl
        >
    implements _$$RecommendationActionResultImplCopyWith<$Res> {
  __$$RecommendationActionResultImplCopyWithImpl(
    _$RecommendationActionResultImpl _value,
    $Res Function(_$RecommendationActionResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationActionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pesan = null,
    Object? dosisKgHa = null,
  }) {
    return _then(
      _$RecommendationActionResultImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        pesan: null == pesan
            ? _value.pesan
            : pesan // ignore: cast_nullable_to_non_nullable
                  as String,
        dosisKgHa: null == dosisKgHa
            ? _value.dosisKgHa
            : dosisKgHa // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// @nodoc

class _$RecommendationActionResultImpl extends _RecommendationActionResult {
  const _$RecommendationActionResultImpl({
    required this.status,
    required this.pesan,
    required this.dosisKgHa,
  }) : super._();

  @override
  final String status;
  @override
  final String pesan;
  @override
  final num dosisKgHa;

  @override
  String toString() {
    return 'RecommendationActionResult(status: $status, pesan: $pesan, dosisKgHa: $dosisKgHa)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationActionResultImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pesan, pesan) || other.pesan == pesan) &&
            (identical(other.dosisKgHa, dosisKgHa) ||
                other.dosisKgHa == dosisKgHa));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, pesan, dosisKgHa);

  /// Create a copy of RecommendationActionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationActionResultImplCopyWith<_$RecommendationActionResultImpl>
  get copyWith =>
      __$$RecommendationActionResultImplCopyWithImpl<
        _$RecommendationActionResultImpl
      >(this, _$identity);
}

abstract class _RecommendationActionResult extends RecommendationActionResult {
  const factory _RecommendationActionResult({
    required final String status,
    required final String pesan,
    required final num dosisKgHa,
  }) = _$RecommendationActionResultImpl;
  const _RecommendationActionResult._() : super._();

  @override
  String get status;
  @override
  String get pesan;
  @override
  num get dosisKgHa;

  /// Create a copy of RecommendationActionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationActionResultImplCopyWith<_$RecommendationActionResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecommendationBundle {
  RecommendationActionResult? get npk => throw _privateConstructorUsedError;
  RecommendationActionResult? get ph => throw _privateConstructorUsedError;
  RecommendationSensorData? get sensorData =>
      throw _privateConstructorUsedError;

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationBundleCopyWith<RecommendationBundle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationBundleCopyWith<$Res> {
  factory $RecommendationBundleCopyWith(
    RecommendationBundle value,
    $Res Function(RecommendationBundle) then,
  ) = _$RecommendationBundleCopyWithImpl<$Res, RecommendationBundle>;
  @useResult
  $Res call({
    RecommendationActionResult? npk,
    RecommendationActionResult? ph,
    RecommendationSensorData? sensorData,
  });

  $RecommendationActionResultCopyWith<$Res>? get npk;
  $RecommendationActionResultCopyWith<$Res>? get ph;
  $RecommendationSensorDataCopyWith<$Res>? get sensorData;
}

/// @nodoc
class _$RecommendationBundleCopyWithImpl<
  $Res,
  $Val extends RecommendationBundle
>
    implements $RecommendationBundleCopyWith<$Res> {
  _$RecommendationBundleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? npk = freezed,
    Object? ph = freezed,
    Object? sensorData = freezed,
  }) {
    return _then(
      _value.copyWith(
            npk: freezed == npk
                ? _value.npk
                : npk // ignore: cast_nullable_to_non_nullable
                      as RecommendationActionResult?,
            ph: freezed == ph
                ? _value.ph
                : ph // ignore: cast_nullable_to_non_nullable
                      as RecommendationActionResult?,
            sensorData: freezed == sensorData
                ? _value.sensorData
                : sensorData // ignore: cast_nullable_to_non_nullable
                      as RecommendationSensorData?,
          )
          as $Val,
    );
  }

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationActionResultCopyWith<$Res>? get npk {
    if (_value.npk == null) {
      return null;
    }

    return $RecommendationActionResultCopyWith<$Res>(_value.npk!, (value) {
      return _then(_value.copyWith(npk: value) as $Val);
    });
  }

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationActionResultCopyWith<$Res>? get ph {
    if (_value.ph == null) {
      return null;
    }

    return $RecommendationActionResultCopyWith<$Res>(_value.ph!, (value) {
      return _then(_value.copyWith(ph: value) as $Val);
    });
  }

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationSensorDataCopyWith<$Res>? get sensorData {
    if (_value.sensorData == null) {
      return null;
    }

    return $RecommendationSensorDataCopyWith<$Res>(_value.sensorData!, (value) {
      return _then(_value.copyWith(sensorData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendationBundleImplCopyWith<$Res>
    implements $RecommendationBundleCopyWith<$Res> {
  factory _$$RecommendationBundleImplCopyWith(
    _$RecommendationBundleImpl value,
    $Res Function(_$RecommendationBundleImpl) then,
  ) = __$$RecommendationBundleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RecommendationActionResult? npk,
    RecommendationActionResult? ph,
    RecommendationSensorData? sensorData,
  });

  @override
  $RecommendationActionResultCopyWith<$Res>? get npk;
  @override
  $RecommendationActionResultCopyWith<$Res>? get ph;
  @override
  $RecommendationSensorDataCopyWith<$Res>? get sensorData;
}

/// @nodoc
class __$$RecommendationBundleImplCopyWithImpl<$Res>
    extends _$RecommendationBundleCopyWithImpl<$Res, _$RecommendationBundleImpl>
    implements _$$RecommendationBundleImplCopyWith<$Res> {
  __$$RecommendationBundleImplCopyWithImpl(
    _$RecommendationBundleImpl _value,
    $Res Function(_$RecommendationBundleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? npk = freezed,
    Object? ph = freezed,
    Object? sensorData = freezed,
  }) {
    return _then(
      _$RecommendationBundleImpl(
        npk: freezed == npk
            ? _value.npk
            : npk // ignore: cast_nullable_to_non_nullable
                  as RecommendationActionResult?,
        ph: freezed == ph
            ? _value.ph
            : ph // ignore: cast_nullable_to_non_nullable
                  as RecommendationActionResult?,
        sensorData: freezed == sensorData
            ? _value.sensorData
            : sensorData // ignore: cast_nullable_to_non_nullable
                  as RecommendationSensorData?,
      ),
    );
  }
}

/// @nodoc

class _$RecommendationBundleImpl extends _RecommendationBundle {
  const _$RecommendationBundleImpl({this.npk, this.ph, this.sensorData})
    : super._();

  @override
  final RecommendationActionResult? npk;
  @override
  final RecommendationActionResult? ph;
  @override
  final RecommendationSensorData? sensorData;

  @override
  String toString() {
    return 'RecommendationBundle(npk: $npk, ph: $ph, sensorData: $sensorData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationBundleImpl &&
            (identical(other.npk, npk) || other.npk == npk) &&
            (identical(other.ph, ph) || other.ph == ph) &&
            (identical(other.sensorData, sensorData) ||
                other.sensorData == sensorData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, npk, ph, sensorData);

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationBundleImplCopyWith<_$RecommendationBundleImpl>
  get copyWith =>
      __$$RecommendationBundleImplCopyWithImpl<_$RecommendationBundleImpl>(
        this,
        _$identity,
      );
}

abstract class _RecommendationBundle extends RecommendationBundle {
  const factory _RecommendationBundle({
    final RecommendationActionResult? npk,
    final RecommendationActionResult? ph,
    final RecommendationSensorData? sensorData,
  }) = _$RecommendationBundleImpl;
  const _RecommendationBundle._() : super._();

  @override
  RecommendationActionResult? get npk;
  @override
  RecommendationActionResult? get ph;
  @override
  RecommendationSensorData? get sensorData;

  /// Create a copy of RecommendationBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationBundleImplCopyWith<_$RecommendationBundleImpl>
  get copyWith => throw _privateConstructorUsedError;
}
