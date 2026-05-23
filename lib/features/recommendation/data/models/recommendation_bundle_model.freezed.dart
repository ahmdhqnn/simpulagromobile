// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_bundle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecommendationSensorDataModel _$RecommendationSensorDataModelFromJson(
  Map<String, dynamic> json,
) {
  return _RecommendationSensorDataModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendationSensorDataModel {
  @JsonKey(name: 'nitrogen')
  num? get nitrogen => throw _privateConstructorUsedError;
  @JsonKey(name: 'phosphorus')
  num? get phosphorus => throw _privateConstructorUsedError;
  @JsonKey(name: 'potassium')
  num? get potassium => throw _privateConstructorUsedError;
  @JsonKey(name: 'ph')
  num? get ph => throw _privateConstructorUsedError;

  /// Serializes this RecommendationSensorDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationSensorDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationSensorDataModelCopyWith<RecommendationSensorDataModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationSensorDataModelCopyWith<$Res> {
  factory $RecommendationSensorDataModelCopyWith(
    RecommendationSensorDataModel value,
    $Res Function(RecommendationSensorDataModel) then,
  ) =
      _$RecommendationSensorDataModelCopyWithImpl<
        $Res,
        RecommendationSensorDataModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'nitrogen') num? nitrogen,
    @JsonKey(name: 'phosphorus') num? phosphorus,
    @JsonKey(name: 'potassium') num? potassium,
    @JsonKey(name: 'ph') num? ph,
  });
}

/// @nodoc
class _$RecommendationSensorDataModelCopyWithImpl<
  $Res,
  $Val extends RecommendationSensorDataModel
>
    implements $RecommendationSensorDataModelCopyWith<$Res> {
  _$RecommendationSensorDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationSensorDataModel
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
abstract class _$$RecommendationSensorDataModelImplCopyWith<$Res>
    implements $RecommendationSensorDataModelCopyWith<$Res> {
  factory _$$RecommendationSensorDataModelImplCopyWith(
    _$RecommendationSensorDataModelImpl value,
    $Res Function(_$RecommendationSensorDataModelImpl) then,
  ) = __$$RecommendationSensorDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'nitrogen') num? nitrogen,
    @JsonKey(name: 'phosphorus') num? phosphorus,
    @JsonKey(name: 'potassium') num? potassium,
    @JsonKey(name: 'ph') num? ph,
  });
}

/// @nodoc
class __$$RecommendationSensorDataModelImplCopyWithImpl<$Res>
    extends
        _$RecommendationSensorDataModelCopyWithImpl<
          $Res,
          _$RecommendationSensorDataModelImpl
        >
    implements _$$RecommendationSensorDataModelImplCopyWith<$Res> {
  __$$RecommendationSensorDataModelImplCopyWithImpl(
    _$RecommendationSensorDataModelImpl _value,
    $Res Function(_$RecommendationSensorDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationSensorDataModel
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
      _$RecommendationSensorDataModelImpl(
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
@JsonSerializable()
class _$RecommendationSensorDataModelImpl
    extends _RecommendationSensorDataModel {
  const _$RecommendationSensorDataModelImpl({
    @JsonKey(name: 'nitrogen') this.nitrogen,
    @JsonKey(name: 'phosphorus') this.phosphorus,
    @JsonKey(name: 'potassium') this.potassium,
    @JsonKey(name: 'ph') this.ph,
  }) : super._();

  factory _$RecommendationSensorDataModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$RecommendationSensorDataModelImplFromJson(json);

  @override
  @JsonKey(name: 'nitrogen')
  final num? nitrogen;
  @override
  @JsonKey(name: 'phosphorus')
  final num? phosphorus;
  @override
  @JsonKey(name: 'potassium')
  final num? potassium;
  @override
  @JsonKey(name: 'ph')
  final num? ph;

  @override
  String toString() {
    return 'RecommendationSensorDataModel(nitrogen: $nitrogen, phosphorus: $phosphorus, potassium: $potassium, ph: $ph)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationSensorDataModelImpl &&
            (identical(other.nitrogen, nitrogen) ||
                other.nitrogen == nitrogen) &&
            (identical(other.phosphorus, phosphorus) ||
                other.phosphorus == phosphorus) &&
            (identical(other.potassium, potassium) ||
                other.potassium == potassium) &&
            (identical(other.ph, ph) || other.ph == ph));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, nitrogen, phosphorus, potassium, ph);

  /// Create a copy of RecommendationSensorDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationSensorDataModelImplCopyWith<
    _$RecommendationSensorDataModelImpl
  >
  get copyWith =>
      __$$RecommendationSensorDataModelImplCopyWithImpl<
        _$RecommendationSensorDataModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationSensorDataModelImplToJson(this);
  }
}

abstract class _RecommendationSensorDataModel
    extends RecommendationSensorDataModel {
  const factory _RecommendationSensorDataModel({
    @JsonKey(name: 'nitrogen') final num? nitrogen,
    @JsonKey(name: 'phosphorus') final num? phosphorus,
    @JsonKey(name: 'potassium') final num? potassium,
    @JsonKey(name: 'ph') final num? ph,
  }) = _$RecommendationSensorDataModelImpl;
  const _RecommendationSensorDataModel._() : super._();

  factory _RecommendationSensorDataModel.fromJson(Map<String, dynamic> json) =
      _$RecommendationSensorDataModelImpl.fromJson;

  @override
  @JsonKey(name: 'nitrogen')
  num? get nitrogen;
  @override
  @JsonKey(name: 'phosphorus')
  num? get phosphorus;
  @override
  @JsonKey(name: 'potassium')
  num? get potassium;
  @override
  @JsonKey(name: 'ph')
  num? get ph;

  /// Create a copy of RecommendationSensorDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationSensorDataModelImplCopyWith<
    _$RecommendationSensorDataModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

RecommendationActionResultModel _$RecommendationActionResultModelFromJson(
  Map<String, dynamic> json,
) {
  return _RecommendationActionResultModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendationActionResultModel {
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'pesan')
  String get pesan => throw _privateConstructorUsedError;
  @JsonKey(name: 'dosis_kg_ha')
  num get dosisKgHa => throw _privateConstructorUsedError;

  /// Serializes this RecommendationActionResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationActionResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationActionResultModelCopyWith<RecommendationActionResultModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationActionResultModelCopyWith<$Res> {
  factory $RecommendationActionResultModelCopyWith(
    RecommendationActionResultModel value,
    $Res Function(RecommendationActionResultModel) then,
  ) =
      _$RecommendationActionResultModelCopyWithImpl<
        $Res,
        RecommendationActionResultModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'pesan') String pesan,
    @JsonKey(name: 'dosis_kg_ha') num dosisKgHa,
  });
}

/// @nodoc
class _$RecommendationActionResultModelCopyWithImpl<
  $Res,
  $Val extends RecommendationActionResultModel
>
    implements $RecommendationActionResultModelCopyWith<$Res> {
  _$RecommendationActionResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationActionResultModel
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
abstract class _$$RecommendationActionResultModelImplCopyWith<$Res>
    implements $RecommendationActionResultModelCopyWith<$Res> {
  factory _$$RecommendationActionResultModelImplCopyWith(
    _$RecommendationActionResultModelImpl value,
    $Res Function(_$RecommendationActionResultModelImpl) then,
  ) = __$$RecommendationActionResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'pesan') String pesan,
    @JsonKey(name: 'dosis_kg_ha') num dosisKgHa,
  });
}

/// @nodoc
class __$$RecommendationActionResultModelImplCopyWithImpl<$Res>
    extends
        _$RecommendationActionResultModelCopyWithImpl<
          $Res,
          _$RecommendationActionResultModelImpl
        >
    implements _$$RecommendationActionResultModelImplCopyWith<$Res> {
  __$$RecommendationActionResultModelImplCopyWithImpl(
    _$RecommendationActionResultModelImpl _value,
    $Res Function(_$RecommendationActionResultModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationActionResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pesan = null,
    Object? dosisKgHa = null,
  }) {
    return _then(
      _$RecommendationActionResultModelImpl(
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
@JsonSerializable()
class _$RecommendationActionResultModelImpl
    extends _RecommendationActionResultModel {
  const _$RecommendationActionResultModelImpl({
    @JsonKey(name: 'status') required this.status,
    @JsonKey(name: 'pesan') required this.pesan,
    @JsonKey(name: 'dosis_kg_ha') required this.dosisKgHa,
  }) : super._();

  factory _$RecommendationActionResultModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$RecommendationActionResultModelImplFromJson(json);

  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'pesan')
  final String pesan;
  @override
  @JsonKey(name: 'dosis_kg_ha')
  final num dosisKgHa;

  @override
  String toString() {
    return 'RecommendationActionResultModel(status: $status, pesan: $pesan, dosisKgHa: $dosisKgHa)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationActionResultModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pesan, pesan) || other.pesan == pesan) &&
            (identical(other.dosisKgHa, dosisKgHa) ||
                other.dosisKgHa == dosisKgHa));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, pesan, dosisKgHa);

  /// Create a copy of RecommendationActionResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationActionResultModelImplCopyWith<
    _$RecommendationActionResultModelImpl
  >
  get copyWith =>
      __$$RecommendationActionResultModelImplCopyWithImpl<
        _$RecommendationActionResultModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationActionResultModelImplToJson(this);
  }
}

abstract class _RecommendationActionResultModel
    extends RecommendationActionResultModel {
  const factory _RecommendationActionResultModel({
    @JsonKey(name: 'status') required final String status,
    @JsonKey(name: 'pesan') required final String pesan,
    @JsonKey(name: 'dosis_kg_ha') required final num dosisKgHa,
  }) = _$RecommendationActionResultModelImpl;
  const _RecommendationActionResultModel._() : super._();

  factory _RecommendationActionResultModel.fromJson(Map<String, dynamic> json) =
      _$RecommendationActionResultModelImpl.fromJson;

  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'pesan')
  String get pesan;
  @override
  @JsonKey(name: 'dosis_kg_ha')
  num get dosisKgHa;

  /// Create a copy of RecommendationActionResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationActionResultModelImplCopyWith<
    _$RecommendationActionResultModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

RecommendationBundleModel _$RecommendationBundleModelFromJson(
  Map<String, dynamic> json,
) {
  return _RecommendationBundleModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendationBundleModel {
  @JsonKey(name: 'npk')
  RecommendationActionResultModel? get npk =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ph')
  RecommendationActionResultModel? get ph => throw _privateConstructorUsedError;

  /// Serializes this RecommendationBundleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationBundleModelCopyWith<RecommendationBundleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationBundleModelCopyWith<$Res> {
  factory $RecommendationBundleModelCopyWith(
    RecommendationBundleModel value,
    $Res Function(RecommendationBundleModel) then,
  ) = _$RecommendationBundleModelCopyWithImpl<$Res, RecommendationBundleModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'npk') RecommendationActionResultModel? npk,
    @JsonKey(name: 'ph') RecommendationActionResultModel? ph,
  });

  $RecommendationActionResultModelCopyWith<$Res>? get npk;
  $RecommendationActionResultModelCopyWith<$Res>? get ph;
}

/// @nodoc
class _$RecommendationBundleModelCopyWithImpl<
  $Res,
  $Val extends RecommendationBundleModel
>
    implements $RecommendationBundleModelCopyWith<$Res> {
  _$RecommendationBundleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? npk = freezed, Object? ph = freezed}) {
    return _then(
      _value.copyWith(
            npk: freezed == npk
                ? _value.npk
                : npk // ignore: cast_nullable_to_non_nullable
                      as RecommendationActionResultModel?,
            ph: freezed == ph
                ? _value.ph
                : ph // ignore: cast_nullable_to_non_nullable
                      as RecommendationActionResultModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of RecommendationBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationActionResultModelCopyWith<$Res>? get npk {
    if (_value.npk == null) {
      return null;
    }

    return $RecommendationActionResultModelCopyWith<$Res>(_value.npk!, (value) {
      return _then(_value.copyWith(npk: value) as $Val);
    });
  }

  /// Create a copy of RecommendationBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationActionResultModelCopyWith<$Res>? get ph {
    if (_value.ph == null) {
      return null;
    }

    return $RecommendationActionResultModelCopyWith<$Res>(_value.ph!, (value) {
      return _then(_value.copyWith(ph: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendationBundleModelImplCopyWith<$Res>
    implements $RecommendationBundleModelCopyWith<$Res> {
  factory _$$RecommendationBundleModelImplCopyWith(
    _$RecommendationBundleModelImpl value,
    $Res Function(_$RecommendationBundleModelImpl) then,
  ) = __$$RecommendationBundleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'npk') RecommendationActionResultModel? npk,
    @JsonKey(name: 'ph') RecommendationActionResultModel? ph,
  });

  @override
  $RecommendationActionResultModelCopyWith<$Res>? get npk;
  @override
  $RecommendationActionResultModelCopyWith<$Res>? get ph;
}

/// @nodoc
class __$$RecommendationBundleModelImplCopyWithImpl<$Res>
    extends
        _$RecommendationBundleModelCopyWithImpl<
          $Res,
          _$RecommendationBundleModelImpl
        >
    implements _$$RecommendationBundleModelImplCopyWith<$Res> {
  __$$RecommendationBundleModelImplCopyWithImpl(
    _$RecommendationBundleModelImpl _value,
    $Res Function(_$RecommendationBundleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? npk = freezed, Object? ph = freezed}) {
    return _then(
      _$RecommendationBundleModelImpl(
        npk: freezed == npk
            ? _value.npk
            : npk // ignore: cast_nullable_to_non_nullable
                  as RecommendationActionResultModel?,
        ph: freezed == ph
            ? _value.ph
            : ph // ignore: cast_nullable_to_non_nullable
                  as RecommendationActionResultModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationBundleModelImpl extends _RecommendationBundleModel {
  const _$RecommendationBundleModelImpl({
    @JsonKey(name: 'npk') this.npk,
    @JsonKey(name: 'ph') this.ph,
  }) : super._();

  factory _$RecommendationBundleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationBundleModelImplFromJson(json);

  @override
  @JsonKey(name: 'npk')
  final RecommendationActionResultModel? npk;
  @override
  @JsonKey(name: 'ph')
  final RecommendationActionResultModel? ph;

  @override
  String toString() {
    return 'RecommendationBundleModel(npk: $npk, ph: $ph)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationBundleModelImpl &&
            (identical(other.npk, npk) || other.npk == npk) &&
            (identical(other.ph, ph) || other.ph == ph));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, npk, ph);

  /// Create a copy of RecommendationBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationBundleModelImplCopyWith<_$RecommendationBundleModelImpl>
  get copyWith =>
      __$$RecommendationBundleModelImplCopyWithImpl<
        _$RecommendationBundleModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationBundleModelImplToJson(this);
  }
}

abstract class _RecommendationBundleModel extends RecommendationBundleModel {
  const factory _RecommendationBundleModel({
    @JsonKey(name: 'npk') final RecommendationActionResultModel? npk,
    @JsonKey(name: 'ph') final RecommendationActionResultModel? ph,
  }) = _$RecommendationBundleModelImpl;
  const _RecommendationBundleModel._() : super._();

  factory _RecommendationBundleModel.fromJson(Map<String, dynamic> json) =
      _$RecommendationBundleModelImpl.fromJson;

  @override
  @JsonKey(name: 'npk')
  RecommendationActionResultModel? get npk;
  @override
  @JsonKey(name: 'ph')
  RecommendationActionResultModel? get ph;

  /// Create a copy of RecommendationBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationBundleModelImplCopyWith<_$RecommendationBundleModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
