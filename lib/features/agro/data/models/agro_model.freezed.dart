// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agro_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VdpModel {
  double? get vdp => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  double? get humidity => throw _privateConstructorUsedError;
  double? get es => throw _privateConstructorUsedError;
  double? get ea => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of VdpModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VdpModelCopyWith<VdpModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VdpModelCopyWith<$Res> {
  factory $VdpModelCopyWith(VdpModel value, $Res Function(VdpModel) then) =
      _$VdpModelCopyWithImpl<$Res, VdpModel>;
  @useResult
  $Res call({
    double? vdp,
    String? status,
    double? temperature,
    double? humidity,
    double? es,
    double? ea,
    String? description,
  });
}

/// @nodoc
class _$VdpModelCopyWithImpl<$Res, $Val extends VdpModel>
    implements $VdpModelCopyWith<$Res> {
  _$VdpModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VdpModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdp = freezed,
    Object? status = freezed,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? es = freezed,
    Object? ea = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            vdp: freezed == vdp
                ? _value.vdp
                : vdp // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            temperature: freezed == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            humidity: freezed == humidity
                ? _value.humidity
                : humidity // ignore: cast_nullable_to_non_nullable
                      as double?,
            es: freezed == es
                ? _value.es
                : es // ignore: cast_nullable_to_non_nullable
                      as double?,
            ea: freezed == ea
                ? _value.ea
                : ea // ignore: cast_nullable_to_non_nullable
                      as double?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VdpModelImplCopyWith<$Res>
    implements $VdpModelCopyWith<$Res> {
  factory _$$VdpModelImplCopyWith(
    _$VdpModelImpl value,
    $Res Function(_$VdpModelImpl) then,
  ) = __$$VdpModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double? vdp,
    String? status,
    double? temperature,
    double? humidity,
    double? es,
    double? ea,
    String? description,
  });
}

/// @nodoc
class __$$VdpModelImplCopyWithImpl<$Res>
    extends _$VdpModelCopyWithImpl<$Res, _$VdpModelImpl>
    implements _$$VdpModelImplCopyWith<$Res> {
  __$$VdpModelImplCopyWithImpl(
    _$VdpModelImpl _value,
    $Res Function(_$VdpModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VdpModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdp = freezed,
    Object? status = freezed,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? es = freezed,
    Object? ea = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$VdpModelImpl(
        vdp: freezed == vdp
            ? _value.vdp
            : vdp // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        temperature: freezed == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        humidity: freezed == humidity
            ? _value.humidity
            : humidity // ignore: cast_nullable_to_non_nullable
                  as double?,
        es: freezed == es
            ? _value.es
            : es // ignore: cast_nullable_to_non_nullable
                  as double?,
        ea: freezed == ea
            ? _value.ea
            : ea // ignore: cast_nullable_to_non_nullable
                  as double?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$VdpModelImpl extends _VdpModel {
  const _$VdpModelImpl({
    this.vdp,
    this.status,
    this.temperature,
    this.humidity,
    this.es,
    this.ea,
    this.description,
  }) : super._();

  @override
  final double? vdp;
  @override
  final String? status;
  @override
  final double? temperature;
  @override
  final double? humidity;
  @override
  final double? es;
  @override
  final double? ea;
  @override
  final String? description;

  @override
  String toString() {
    return 'VdpModel(vdp: $vdp, status: $status, temperature: $temperature, humidity: $humidity, es: $es, ea: $ea, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VdpModelImpl &&
            (identical(other.vdp, vdp) || other.vdp == vdp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.es, es) || other.es == es) &&
            (identical(other.ea, ea) || other.ea == ea) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    vdp,
    status,
    temperature,
    humidity,
    es,
    ea,
    description,
  );

  /// Create a copy of VdpModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VdpModelImplCopyWith<_$VdpModelImpl> get copyWith =>
      __$$VdpModelImplCopyWithImpl<_$VdpModelImpl>(this, _$identity);
}

abstract class _VdpModel extends VdpModel {
  const factory _VdpModel({
    final double? vdp,
    final String? status,
    final double? temperature,
    final double? humidity,
    final double? es,
    final double? ea,
    final String? description,
  }) = _$VdpModelImpl;
  const _VdpModel._() : super._();

  @override
  double? get vdp;
  @override
  String? get status;
  @override
  double? get temperature;
  @override
  double? get humidity;
  @override
  double? get es;
  @override
  double? get ea;
  @override
  String? get description;

  /// Create a copy of VdpModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VdpModelImplCopyWith<_$VdpModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GddDailyModel {
  String? get day => throw _privateConstructorUsedError;
  double? get tempMin => throw _privateConstructorUsedError;
  double? get tempMax => throw _privateConstructorUsedError;
  double? get gdd => throw _privateConstructorUsedError;

  /// Create a copy of GddDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GddDailyModelCopyWith<GddDailyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GddDailyModelCopyWith<$Res> {
  factory $GddDailyModelCopyWith(
    GddDailyModel value,
    $Res Function(GddDailyModel) then,
  ) = _$GddDailyModelCopyWithImpl<$Res, GddDailyModel>;
  @useResult
  $Res call({String? day, double? tempMin, double? tempMax, double? gdd});
}

/// @nodoc
class _$GddDailyModelCopyWithImpl<$Res, $Val extends GddDailyModel>
    implements $GddDailyModelCopyWith<$Res> {
  _$GddDailyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GddDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = freezed,
    Object? tempMin = freezed,
    Object? tempMax = freezed,
    Object? gdd = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: freezed == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String?,
            tempMin: freezed == tempMin
                ? _value.tempMin
                : tempMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            tempMax: freezed == tempMax
                ? _value.tempMax
                : tempMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            gdd: freezed == gdd
                ? _value.gdd
                : gdd // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GddDailyModelImplCopyWith<$Res>
    implements $GddDailyModelCopyWith<$Res> {
  factory _$$GddDailyModelImplCopyWith(
    _$GddDailyModelImpl value,
    $Res Function(_$GddDailyModelImpl) then,
  ) = __$$GddDailyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? day, double? tempMin, double? tempMax, double? gdd});
}

/// @nodoc
class __$$GddDailyModelImplCopyWithImpl<$Res>
    extends _$GddDailyModelCopyWithImpl<$Res, _$GddDailyModelImpl>
    implements _$$GddDailyModelImplCopyWith<$Res> {
  __$$GddDailyModelImplCopyWithImpl(
    _$GddDailyModelImpl _value,
    $Res Function(_$GddDailyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GddDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = freezed,
    Object? tempMin = freezed,
    Object? tempMax = freezed,
    Object? gdd = freezed,
  }) {
    return _then(
      _$GddDailyModelImpl(
        day: freezed == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String?,
        tempMin: freezed == tempMin
            ? _value.tempMin
            : tempMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        tempMax: freezed == tempMax
            ? _value.tempMax
            : tempMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        gdd: freezed == gdd
            ? _value.gdd
            : gdd // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$GddDailyModelImpl extends _GddDailyModel {
  const _$GddDailyModelImpl({this.day, this.tempMin, this.tempMax, this.gdd})
    : super._();

  @override
  final String? day;
  @override
  final double? tempMin;
  @override
  final double? tempMax;
  @override
  final double? gdd;

  @override
  String toString() {
    return 'GddDailyModel(day: $day, tempMin: $tempMin, tempMax: $tempMax, gdd: $gdd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GddDailyModelImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.tempMin, tempMin) || other.tempMin == tempMin) &&
            (identical(other.tempMax, tempMax) || other.tempMax == tempMax) &&
            (identical(other.gdd, gdd) || other.gdd == gdd));
  }

  @override
  int get hashCode => Object.hash(runtimeType, day, tempMin, tempMax, gdd);

  /// Create a copy of GddDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GddDailyModelImplCopyWith<_$GddDailyModelImpl> get copyWith =>
      __$$GddDailyModelImplCopyWithImpl<_$GddDailyModelImpl>(this, _$identity);
}

abstract class _GddDailyModel extends GddDailyModel {
  const factory _GddDailyModel({
    final String? day,
    final double? tempMin,
    final double? tempMax,
    final double? gdd,
  }) = _$GddDailyModelImpl;
  const _GddDailyModel._() : super._();

  @override
  String? get day;
  @override
  double? get tempMin;
  @override
  double? get tempMax;
  @override
  double? get gdd;

  /// Create a copy of GddDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GddDailyModelImplCopyWith<_$GddDailyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GddModel {
  double? get totalGDD => throw _privateConstructorUsedError;
  List<GddDailyModel> get daily => throw _privateConstructorUsedError;

  /// Create a copy of GddModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GddModelCopyWith<GddModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GddModelCopyWith<$Res> {
  factory $GddModelCopyWith(GddModel value, $Res Function(GddModel) then) =
      _$GddModelCopyWithImpl<$Res, GddModel>;
  @useResult
  $Res call({double? totalGDD, List<GddDailyModel> daily});
}

/// @nodoc
class _$GddModelCopyWithImpl<$Res, $Val extends GddModel>
    implements $GddModelCopyWith<$Res> {
  _$GddModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GddModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalGDD = freezed, Object? daily = null}) {
    return _then(
      _value.copyWith(
            totalGDD: freezed == totalGDD
                ? _value.totalGDD
                : totalGDD // ignore: cast_nullable_to_non_nullable
                      as double?,
            daily: null == daily
                ? _value.daily
                : daily // ignore: cast_nullable_to_non_nullable
                      as List<GddDailyModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GddModelImplCopyWith<$Res>
    implements $GddModelCopyWith<$Res> {
  factory _$$GddModelImplCopyWith(
    _$GddModelImpl value,
    $Res Function(_$GddModelImpl) then,
  ) = __$$GddModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? totalGDD, List<GddDailyModel> daily});
}

/// @nodoc
class __$$GddModelImplCopyWithImpl<$Res>
    extends _$GddModelCopyWithImpl<$Res, _$GddModelImpl>
    implements _$$GddModelImplCopyWith<$Res> {
  __$$GddModelImplCopyWithImpl(
    _$GddModelImpl _value,
    $Res Function(_$GddModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GddModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalGDD = freezed, Object? daily = null}) {
    return _then(
      _$GddModelImpl(
        totalGDD: freezed == totalGDD
            ? _value.totalGDD
            : totalGDD // ignore: cast_nullable_to_non_nullable
                  as double?,
        daily: null == daily
            ? _value._daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<GddDailyModel>,
      ),
    );
  }
}

/// @nodoc

class _$GddModelImpl extends _GddModel {
  const _$GddModelImpl({
    this.totalGDD,
    final List<GddDailyModel> daily = const [],
  }) : _daily = daily,
       super._();

  @override
  final double? totalGDD;
  final List<GddDailyModel> _daily;
  @override
  @JsonKey()
  List<GddDailyModel> get daily {
    if (_daily is EqualUnmodifiableListView) return _daily;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daily);
  }

  @override
  String toString() {
    return 'GddModel(totalGDD: $totalGDD, daily: $daily)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GddModelImpl &&
            (identical(other.totalGDD, totalGDD) ||
                other.totalGDD == totalGDD) &&
            const DeepCollectionEquality().equals(other._daily, _daily));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalGDD,
    const DeepCollectionEquality().hash(_daily),
  );

  /// Create a copy of GddModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GddModelImplCopyWith<_$GddModelImpl> get copyWith =>
      __$$GddModelImplCopyWithImpl<_$GddModelImpl>(this, _$identity);
}

abstract class _GddModel extends GddModel {
  const factory _GddModel({
    final double? totalGDD,
    final List<GddDailyModel> daily,
  }) = _$GddModelImpl;
  const _GddModel._() : super._();

  @override
  double? get totalGDD;
  @override
  List<GddDailyModel> get daily;

  /// Create a copy of GddModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GddModelImplCopyWith<_$GddModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EtcDailyModel {
  int? get hst => throw _privateConstructorUsedError;
  String? get phase => throw _privateConstructorUsedError;
  double? get et0 => throw _privateConstructorUsedError;
  String? get day => throw _privateConstructorUsedError;
  double? get tempMin => throw _privateConstructorUsedError;
  double? get tempMax => throw _privateConstructorUsedError;
  double? get rhMin => throw _privateConstructorUsedError;
  double? get rhMax => throw _privateConstructorUsedError;
  double? get etc => throw _privateConstructorUsedError;
  double? get kc => throw _privateConstructorUsedError;
  double? get waterNeeds => throw _privateConstructorUsedError;
  String? get waterStatus => throw _privateConstructorUsedError;
  String? get recommendation => throw _privateConstructorUsedError;
  String? get riceType => throw _privateConstructorUsedError;

  /// Create a copy of EtcDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EtcDailyModelCopyWith<EtcDailyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EtcDailyModelCopyWith<$Res> {
  factory $EtcDailyModelCopyWith(
    EtcDailyModel value,
    $Res Function(EtcDailyModel) then,
  ) = _$EtcDailyModelCopyWithImpl<$Res, EtcDailyModel>;
  @useResult
  $Res call({
    int? hst,
    String? phase,
    double? et0,
    String? day,
    double? tempMin,
    double? tempMax,
    double? rhMin,
    double? rhMax,
    double? etc,
    double? kc,
    double? waterNeeds,
    String? waterStatus,
    String? recommendation,
    String? riceType,
  });
}

/// @nodoc
class _$EtcDailyModelCopyWithImpl<$Res, $Val extends EtcDailyModel>
    implements $EtcDailyModelCopyWith<$Res> {
  _$EtcDailyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EtcDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hst = freezed,
    Object? phase = freezed,
    Object? et0 = freezed,
    Object? day = freezed,
    Object? tempMin = freezed,
    Object? tempMax = freezed,
    Object? rhMin = freezed,
    Object? rhMax = freezed,
    Object? etc = freezed,
    Object? kc = freezed,
    Object? waterNeeds = freezed,
    Object? waterStatus = freezed,
    Object? recommendation = freezed,
    Object? riceType = freezed,
  }) {
    return _then(
      _value.copyWith(
            hst: freezed == hst
                ? _value.hst
                : hst // ignore: cast_nullable_to_non_nullable
                      as int?,
            phase: freezed == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as String?,
            et0: freezed == et0
                ? _value.et0
                : et0 // ignore: cast_nullable_to_non_nullable
                      as double?,
            day: freezed == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String?,
            tempMin: freezed == tempMin
                ? _value.tempMin
                : tempMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            tempMax: freezed == tempMax
                ? _value.tempMax
                : tempMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            rhMin: freezed == rhMin
                ? _value.rhMin
                : rhMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            rhMax: freezed == rhMax
                ? _value.rhMax
                : rhMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            etc: freezed == etc
                ? _value.etc
                : etc // ignore: cast_nullable_to_non_nullable
                      as double?,
            kc: freezed == kc
                ? _value.kc
                : kc // ignore: cast_nullable_to_non_nullable
                      as double?,
            waterNeeds: freezed == waterNeeds
                ? _value.waterNeeds
                : waterNeeds // ignore: cast_nullable_to_non_nullable
                      as double?,
            waterStatus: freezed == waterStatus
                ? _value.waterStatus
                : waterStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            recommendation: freezed == recommendation
                ? _value.recommendation
                : recommendation // ignore: cast_nullable_to_non_nullable
                      as String?,
            riceType: freezed == riceType
                ? _value.riceType
                : riceType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EtcDailyModelImplCopyWith<$Res>
    implements $EtcDailyModelCopyWith<$Res> {
  factory _$$EtcDailyModelImplCopyWith(
    _$EtcDailyModelImpl value,
    $Res Function(_$EtcDailyModelImpl) then,
  ) = __$$EtcDailyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? hst,
    String? phase,
    double? et0,
    String? day,
    double? tempMin,
    double? tempMax,
    double? rhMin,
    double? rhMax,
    double? etc,
    double? kc,
    double? waterNeeds,
    String? waterStatus,
    String? recommendation,
    String? riceType,
  });
}

/// @nodoc
class __$$EtcDailyModelImplCopyWithImpl<$Res>
    extends _$EtcDailyModelCopyWithImpl<$Res, _$EtcDailyModelImpl>
    implements _$$EtcDailyModelImplCopyWith<$Res> {
  __$$EtcDailyModelImplCopyWithImpl(
    _$EtcDailyModelImpl _value,
    $Res Function(_$EtcDailyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EtcDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hst = freezed,
    Object? phase = freezed,
    Object? et0 = freezed,
    Object? day = freezed,
    Object? tempMin = freezed,
    Object? tempMax = freezed,
    Object? rhMin = freezed,
    Object? rhMax = freezed,
    Object? etc = freezed,
    Object? kc = freezed,
    Object? waterNeeds = freezed,
    Object? waterStatus = freezed,
    Object? recommendation = freezed,
    Object? riceType = freezed,
  }) {
    return _then(
      _$EtcDailyModelImpl(
        hst: freezed == hst
            ? _value.hst
            : hst // ignore: cast_nullable_to_non_nullable
                  as int?,
        phase: freezed == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as String?,
        et0: freezed == et0
            ? _value.et0
            : et0 // ignore: cast_nullable_to_non_nullable
                  as double?,
        day: freezed == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String?,
        tempMin: freezed == tempMin
            ? _value.tempMin
            : tempMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        tempMax: freezed == tempMax
            ? _value.tempMax
            : tempMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        rhMin: freezed == rhMin
            ? _value.rhMin
            : rhMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        rhMax: freezed == rhMax
            ? _value.rhMax
            : rhMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        etc: freezed == etc
            ? _value.etc
            : etc // ignore: cast_nullable_to_non_nullable
                  as double?,
        kc: freezed == kc
            ? _value.kc
            : kc // ignore: cast_nullable_to_non_nullable
                  as double?,
        waterNeeds: freezed == waterNeeds
            ? _value.waterNeeds
            : waterNeeds // ignore: cast_nullable_to_non_nullable
                  as double?,
        waterStatus: freezed == waterStatus
            ? _value.waterStatus
            : waterStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        recommendation: freezed == recommendation
            ? _value.recommendation
            : recommendation // ignore: cast_nullable_to_non_nullable
                  as String?,
        riceType: freezed == riceType
            ? _value.riceType
            : riceType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$EtcDailyModelImpl extends _EtcDailyModel {
  const _$EtcDailyModelImpl({
    this.hst,
    this.phase,
    this.et0,
    this.day,
    this.tempMin,
    this.tempMax,
    this.rhMin,
    this.rhMax,
    this.etc,
    this.kc,
    this.waterNeeds,
    this.waterStatus,
    this.recommendation,
    this.riceType,
  }) : super._();

  @override
  final int? hst;
  @override
  final String? phase;
  @override
  final double? et0;
  @override
  final String? day;
  @override
  final double? tempMin;
  @override
  final double? tempMax;
  @override
  final double? rhMin;
  @override
  final double? rhMax;
  @override
  final double? etc;
  @override
  final double? kc;
  @override
  final double? waterNeeds;
  @override
  final String? waterStatus;
  @override
  final String? recommendation;
  @override
  final String? riceType;

  @override
  String toString() {
    return 'EtcDailyModel(hst: $hst, phase: $phase, et0: $et0, day: $day, tempMin: $tempMin, tempMax: $tempMax, rhMin: $rhMin, rhMax: $rhMax, etc: $etc, kc: $kc, waterNeeds: $waterNeeds, waterStatus: $waterStatus, recommendation: $recommendation, riceType: $riceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EtcDailyModelImpl &&
            (identical(other.hst, hst) || other.hst == hst) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.et0, et0) || other.et0 == et0) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.tempMin, tempMin) || other.tempMin == tempMin) &&
            (identical(other.tempMax, tempMax) || other.tempMax == tempMax) &&
            (identical(other.rhMin, rhMin) || other.rhMin == rhMin) &&
            (identical(other.rhMax, rhMax) || other.rhMax == rhMax) &&
            (identical(other.etc, etc) || other.etc == etc) &&
            (identical(other.kc, kc) || other.kc == kc) &&
            (identical(other.waterNeeds, waterNeeds) ||
                other.waterNeeds == waterNeeds) &&
            (identical(other.waterStatus, waterStatus) ||
                other.waterStatus == waterStatus) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            (identical(other.riceType, riceType) ||
                other.riceType == riceType));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    hst,
    phase,
    et0,
    day,
    tempMin,
    tempMax,
    rhMin,
    rhMax,
    etc,
    kc,
    waterNeeds,
    waterStatus,
    recommendation,
    riceType,
  );

  /// Create a copy of EtcDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EtcDailyModelImplCopyWith<_$EtcDailyModelImpl> get copyWith =>
      __$$EtcDailyModelImplCopyWithImpl<_$EtcDailyModelImpl>(this, _$identity);
}

abstract class _EtcDailyModel extends EtcDailyModel {
  const factory _EtcDailyModel({
    final int? hst,
    final String? phase,
    final double? et0,
    final String? day,
    final double? tempMin,
    final double? tempMax,
    final double? rhMin,
    final double? rhMax,
    final double? etc,
    final double? kc,
    final double? waterNeeds,
    final String? waterStatus,
    final String? recommendation,
    final String? riceType,
  }) = _$EtcDailyModelImpl;
  const _EtcDailyModel._() : super._();

  @override
  int? get hst;
  @override
  String? get phase;
  @override
  double? get et0;
  @override
  String? get day;
  @override
  double? get tempMin;
  @override
  double? get tempMax;
  @override
  double? get rhMin;
  @override
  double? get rhMax;
  @override
  double? get etc;
  @override
  double? get kc;
  @override
  double? get waterNeeds;
  @override
  String? get waterStatus;
  @override
  String? get recommendation;
  @override
  String? get riceType;

  /// Create a copy of EtcDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EtcDailyModelImplCopyWith<_$EtcDailyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AgroModel {
  VdpModel? get vdp => throw _privateConstructorUsedError;
  GddModel? get gdd => throw _privateConstructorUsedError;
  List<EtcDailyModel> get etc => throw _privateConstructorUsedError;

  /// Create a copy of AgroModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgroModelCopyWith<AgroModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgroModelCopyWith<$Res> {
  factory $AgroModelCopyWith(AgroModel value, $Res Function(AgroModel) then) =
      _$AgroModelCopyWithImpl<$Res, AgroModel>;
  @useResult
  $Res call({VdpModel? vdp, GddModel? gdd, List<EtcDailyModel> etc});

  $VdpModelCopyWith<$Res>? get vdp;
  $GddModelCopyWith<$Res>? get gdd;
}

/// @nodoc
class _$AgroModelCopyWithImpl<$Res, $Val extends AgroModel>
    implements $AgroModelCopyWith<$Res> {
  _$AgroModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgroModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdp = freezed,
    Object? gdd = freezed,
    Object? etc = null,
  }) {
    return _then(
      _value.copyWith(
            vdp: freezed == vdp
                ? _value.vdp
                : vdp // ignore: cast_nullable_to_non_nullable
                      as VdpModel?,
            gdd: freezed == gdd
                ? _value.gdd
                : gdd // ignore: cast_nullable_to_non_nullable
                      as GddModel?,
            etc: null == etc
                ? _value.etc
                : etc // ignore: cast_nullable_to_non_nullable
                      as List<EtcDailyModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of AgroModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VdpModelCopyWith<$Res>? get vdp {
    if (_value.vdp == null) {
      return null;
    }

    return $VdpModelCopyWith<$Res>(_value.vdp!, (value) {
      return _then(_value.copyWith(vdp: value) as $Val);
    });
  }

  /// Create a copy of AgroModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GddModelCopyWith<$Res>? get gdd {
    if (_value.gdd == null) {
      return null;
    }

    return $GddModelCopyWith<$Res>(_value.gdd!, (value) {
      return _then(_value.copyWith(gdd: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AgroModelImplCopyWith<$Res>
    implements $AgroModelCopyWith<$Res> {
  factory _$$AgroModelImplCopyWith(
    _$AgroModelImpl value,
    $Res Function(_$AgroModelImpl) then,
  ) = __$$AgroModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({VdpModel? vdp, GddModel? gdd, List<EtcDailyModel> etc});

  @override
  $VdpModelCopyWith<$Res>? get vdp;
  @override
  $GddModelCopyWith<$Res>? get gdd;
}

/// @nodoc
class __$$AgroModelImplCopyWithImpl<$Res>
    extends _$AgroModelCopyWithImpl<$Res, _$AgroModelImpl>
    implements _$$AgroModelImplCopyWith<$Res> {
  __$$AgroModelImplCopyWithImpl(
    _$AgroModelImpl _value,
    $Res Function(_$AgroModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AgroModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdp = freezed,
    Object? gdd = freezed,
    Object? etc = null,
  }) {
    return _then(
      _$AgroModelImpl(
        vdp: freezed == vdp
            ? _value.vdp
            : vdp // ignore: cast_nullable_to_non_nullable
                  as VdpModel?,
        gdd: freezed == gdd
            ? _value.gdd
            : gdd // ignore: cast_nullable_to_non_nullable
                  as GddModel?,
        etc: null == etc
            ? _value._etc
            : etc // ignore: cast_nullable_to_non_nullable
                  as List<EtcDailyModel>,
      ),
    );
  }
}

/// @nodoc

class _$AgroModelImpl extends _AgroModel {
  const _$AgroModelImpl({
    this.vdp,
    this.gdd,
    final List<EtcDailyModel> etc = const [],
  }) : _etc = etc,
       super._();

  @override
  final VdpModel? vdp;
  @override
  final GddModel? gdd;
  final List<EtcDailyModel> _etc;
  @override
  @JsonKey()
  List<EtcDailyModel> get etc {
    if (_etc is EqualUnmodifiableListView) return _etc;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_etc);
  }

  @override
  String toString() {
    return 'AgroModel(vdp: $vdp, gdd: $gdd, etc: $etc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgroModelImpl &&
            (identical(other.vdp, vdp) || other.vdp == vdp) &&
            (identical(other.gdd, gdd) || other.gdd == gdd) &&
            const DeepCollectionEquality().equals(other._etc, _etc));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    vdp,
    gdd,
    const DeepCollectionEquality().hash(_etc),
  );

  /// Create a copy of AgroModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgroModelImplCopyWith<_$AgroModelImpl> get copyWith =>
      __$$AgroModelImplCopyWithImpl<_$AgroModelImpl>(this, _$identity);
}

abstract class _AgroModel extends AgroModel {
  const factory _AgroModel({
    final VdpModel? vdp,
    final GddModel? gdd,
    final List<EtcDailyModel> etc,
  }) = _$AgroModelImpl;
  const _AgroModel._() : super._();

  @override
  VdpModel? get vdp;
  @override
  GddModel? get gdd;
  @override
  List<EtcDailyModel> get etc;

  /// Create a copy of AgroModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgroModelImplCopyWith<_$AgroModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
