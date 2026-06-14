// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agro_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VdpEntity {
  double? get vdp => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  double? get humidity => throw _privateConstructorUsedError;
  double? get es => throw _privateConstructorUsedError;
  double? get ea => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of VdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VdpEntityCopyWith<VdpEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VdpEntityCopyWith<$Res> {
  factory $VdpEntityCopyWith(VdpEntity value, $Res Function(VdpEntity) then) =
      _$VdpEntityCopyWithImpl<$Res, VdpEntity>;
  @useResult
  $Res call({
    double? vdp,
    double? temperature,
    double? humidity,
    double? es,
    double? ea,
    String? status,
    String? description,
  });
}

/// @nodoc
class _$VdpEntityCopyWithImpl<$Res, $Val extends VdpEntity>
    implements $VdpEntityCopyWith<$Res> {
  _$VdpEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdp = freezed,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? es = freezed,
    Object? ea = freezed,
    Object? status = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            vdp: freezed == vdp
                ? _value.vdp
                : vdp // ignore: cast_nullable_to_non_nullable
                      as double?,
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
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$VdpEntityImplCopyWith<$Res>
    implements $VdpEntityCopyWith<$Res> {
  factory _$$VdpEntityImplCopyWith(
    _$VdpEntityImpl value,
    $Res Function(_$VdpEntityImpl) then,
  ) = __$$VdpEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double? vdp,
    double? temperature,
    double? humidity,
    double? es,
    double? ea,
    String? status,
    String? description,
  });
}

/// @nodoc
class __$$VdpEntityImplCopyWithImpl<$Res>
    extends _$VdpEntityCopyWithImpl<$Res, _$VdpEntityImpl>
    implements _$$VdpEntityImplCopyWith<$Res> {
  __$$VdpEntityImplCopyWithImpl(
    _$VdpEntityImpl _value,
    $Res Function(_$VdpEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdp = freezed,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? es = freezed,
    Object? ea = freezed,
    Object? status = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$VdpEntityImpl(
        vdp: freezed == vdp
            ? _value.vdp
            : vdp // ignore: cast_nullable_to_non_nullable
                  as double?,
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
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$VdpEntityImpl extends _VdpEntity {
  const _$VdpEntityImpl({
    this.vdp,
    this.temperature,
    this.humidity,
    this.es,
    this.ea,
    this.status,
    this.description,
  }) : super._();

  @override
  final double? vdp;
  @override
  final double? temperature;
  @override
  final double? humidity;
  @override
  final double? es;
  @override
  final double? ea;
  @override
  final String? status;
  @override
  final String? description;

  @override
  String toString() {
    return 'VdpEntity(vdp: $vdp, temperature: $temperature, humidity: $humidity, es: $es, ea: $ea, status: $status, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VdpEntityImpl &&
            (identical(other.vdp, vdp) || other.vdp == vdp) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.es, es) || other.es == es) &&
            (identical(other.ea, ea) || other.ea == ea) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    vdp,
    temperature,
    humidity,
    es,
    ea,
    status,
    description,
  );

  /// Create a copy of VdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VdpEntityImplCopyWith<_$VdpEntityImpl> get copyWith =>
      __$$VdpEntityImplCopyWithImpl<_$VdpEntityImpl>(this, _$identity);
}

abstract class _VdpEntity extends VdpEntity {
  const factory _VdpEntity({
    final double? vdp,
    final double? temperature,
    final double? humidity,
    final double? es,
    final double? ea,
    final String? status,
    final String? description,
  }) = _$VdpEntityImpl;
  const _VdpEntity._() : super._();

  @override
  double? get vdp;
  @override
  double? get temperature;
  @override
  double? get humidity;
  @override
  double? get es;
  @override
  double? get ea;
  @override
  String? get status;
  @override
  String? get description;

  /// Create a copy of VdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VdpEntityImplCopyWith<_$VdpEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GddDailyEntity {
  String? get day => throw _privateConstructorUsedError;
  double? get tempMin => throw _privateConstructorUsedError;
  double? get tempMax => throw _privateConstructorUsedError;
  double? get gdd => throw _privateConstructorUsedError;

  /// Create a copy of GddDailyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GddDailyEntityCopyWith<GddDailyEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GddDailyEntityCopyWith<$Res> {
  factory $GddDailyEntityCopyWith(
    GddDailyEntity value,
    $Res Function(GddDailyEntity) then,
  ) = _$GddDailyEntityCopyWithImpl<$Res, GddDailyEntity>;
  @useResult
  $Res call({String? day, double? tempMin, double? tempMax, double? gdd});
}

/// @nodoc
class _$GddDailyEntityCopyWithImpl<$Res, $Val extends GddDailyEntity>
    implements $GddDailyEntityCopyWith<$Res> {
  _$GddDailyEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GddDailyEntity
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
abstract class _$$GddDailyEntityImplCopyWith<$Res>
    implements $GddDailyEntityCopyWith<$Res> {
  factory _$$GddDailyEntityImplCopyWith(
    _$GddDailyEntityImpl value,
    $Res Function(_$GddDailyEntityImpl) then,
  ) = __$$GddDailyEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? day, double? tempMin, double? tempMax, double? gdd});
}

/// @nodoc
class __$$GddDailyEntityImplCopyWithImpl<$Res>
    extends _$GddDailyEntityCopyWithImpl<$Res, _$GddDailyEntityImpl>
    implements _$$GddDailyEntityImplCopyWith<$Res> {
  __$$GddDailyEntityImplCopyWithImpl(
    _$GddDailyEntityImpl _value,
    $Res Function(_$GddDailyEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GddDailyEntity
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
      _$GddDailyEntityImpl(
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

class _$GddDailyEntityImpl extends _GddDailyEntity {
  const _$GddDailyEntityImpl({this.day, this.tempMin, this.tempMax, this.gdd})
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
    return 'GddDailyEntity(day: $day, tempMin: $tempMin, tempMax: $tempMax, gdd: $gdd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GddDailyEntityImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.tempMin, tempMin) || other.tempMin == tempMin) &&
            (identical(other.tempMax, tempMax) || other.tempMax == tempMax) &&
            (identical(other.gdd, gdd) || other.gdd == gdd));
  }

  @override
  int get hashCode => Object.hash(runtimeType, day, tempMin, tempMax, gdd);

  /// Create a copy of GddDailyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GddDailyEntityImplCopyWith<_$GddDailyEntityImpl> get copyWith =>
      __$$GddDailyEntityImplCopyWithImpl<_$GddDailyEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _GddDailyEntity extends GddDailyEntity {
  const factory _GddDailyEntity({
    final String? day,
    final double? tempMin,
    final double? tempMax,
    final double? gdd,
  }) = _$GddDailyEntityImpl;
  const _GddDailyEntity._() : super._();

  @override
  String? get day;
  @override
  double? get tempMin;
  @override
  double? get tempMax;
  @override
  double? get gdd;

  /// Create a copy of GddDailyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GddDailyEntityImplCopyWith<_$GddDailyEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GddEntity {
  double? get totalGDD => throw _privateConstructorUsedError;
  List<GddDailyEntity> get daily => throw _privateConstructorUsedError;

  /// Create a copy of GddEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GddEntityCopyWith<GddEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GddEntityCopyWith<$Res> {
  factory $GddEntityCopyWith(GddEntity value, $Res Function(GddEntity) then) =
      _$GddEntityCopyWithImpl<$Res, GddEntity>;
  @useResult
  $Res call({double? totalGDD, List<GddDailyEntity> daily});
}

/// @nodoc
class _$GddEntityCopyWithImpl<$Res, $Val extends GddEntity>
    implements $GddEntityCopyWith<$Res> {
  _$GddEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GddEntity
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
                      as List<GddDailyEntity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GddEntityImplCopyWith<$Res>
    implements $GddEntityCopyWith<$Res> {
  factory _$$GddEntityImplCopyWith(
    _$GddEntityImpl value,
    $Res Function(_$GddEntityImpl) then,
  ) = __$$GddEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? totalGDD, List<GddDailyEntity> daily});
}

/// @nodoc
class __$$GddEntityImplCopyWithImpl<$Res>
    extends _$GddEntityCopyWithImpl<$Res, _$GddEntityImpl>
    implements _$$GddEntityImplCopyWith<$Res> {
  __$$GddEntityImplCopyWithImpl(
    _$GddEntityImpl _value,
    $Res Function(_$GddEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GddEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalGDD = freezed, Object? daily = null}) {
    return _then(
      _$GddEntityImpl(
        totalGDD: freezed == totalGDD
            ? _value.totalGDD
            : totalGDD // ignore: cast_nullable_to_non_nullable
                  as double?,
        daily: null == daily
            ? _value._daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<GddDailyEntity>,
      ),
    );
  }
}

/// @nodoc

class _$GddEntityImpl extends _GddEntity {
  const _$GddEntityImpl({
    this.totalGDD,
    final List<GddDailyEntity> daily = const [],
  }) : _daily = daily,
       super._();

  @override
  final double? totalGDD;
  final List<GddDailyEntity> _daily;
  @override
  @JsonKey()
  List<GddDailyEntity> get daily {
    if (_daily is EqualUnmodifiableListView) return _daily;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daily);
  }

  @override
  String toString() {
    return 'GddEntity(totalGDD: $totalGDD, daily: $daily)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GddEntityImpl &&
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

  /// Create a copy of GddEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GddEntityImplCopyWith<_$GddEntityImpl> get copyWith =>
      __$$GddEntityImplCopyWithImpl<_$GddEntityImpl>(this, _$identity);
}

abstract class _GddEntity extends GddEntity {
  const factory _GddEntity({
    final double? totalGDD,
    final List<GddDailyEntity> daily,
  }) = _$GddEntityImpl;
  const _GddEntity._() : super._();

  @override
  double? get totalGDD;
  @override
  List<GddDailyEntity> get daily;

  /// Create a copy of GddEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GddEntityImplCopyWith<_$GddEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EtcDailyEntity {
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
  double? get waterNeededMM => throw _privateConstructorUsedError;
  int? get waterNeededLiter => throw _privateConstructorUsedError;
  String? get waterManagement => throw _privateConstructorUsedError;
  int? get daysToHarvest => throw _privateConstructorUsedError;
  bool? get isCriticalPhase => throw _privateConstructorUsedError;
  DateTime? get harvestDate => throw _privateConstructorUsedError;

  /// Create a copy of EtcDailyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EtcDailyEntityCopyWith<EtcDailyEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EtcDailyEntityCopyWith<$Res> {
  factory $EtcDailyEntityCopyWith(
    EtcDailyEntity value,
    $Res Function(EtcDailyEntity) then,
  ) = _$EtcDailyEntityCopyWithImpl<$Res, EtcDailyEntity>;
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
    double? waterNeededMM,
    int? waterNeededLiter,
    String? waterManagement,
    int? daysToHarvest,
    bool? isCriticalPhase,
    DateTime? harvestDate,
  });
}

/// @nodoc
class _$EtcDailyEntityCopyWithImpl<$Res, $Val extends EtcDailyEntity>
    implements $EtcDailyEntityCopyWith<$Res> {
  _$EtcDailyEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EtcDailyEntity
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
    Object? waterNeededMM = freezed,
    Object? waterNeededLiter = freezed,
    Object? waterManagement = freezed,
    Object? daysToHarvest = freezed,
    Object? isCriticalPhase = freezed,
    Object? harvestDate = freezed,
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
            waterNeededMM: freezed == waterNeededMM
                ? _value.waterNeededMM
                : waterNeededMM // ignore: cast_nullable_to_non_nullable
                      as double?,
            waterNeededLiter: freezed == waterNeededLiter
                ? _value.waterNeededLiter
                : waterNeededLiter // ignore: cast_nullable_to_non_nullable
                      as int?,
            waterManagement: freezed == waterManagement
                ? _value.waterManagement
                : waterManagement // ignore: cast_nullable_to_non_nullable
                      as String?,
            daysToHarvest: freezed == daysToHarvest
                ? _value.daysToHarvest
                : daysToHarvest // ignore: cast_nullable_to_non_nullable
                      as int?,
            isCriticalPhase: freezed == isCriticalPhase
                ? _value.isCriticalPhase
                : isCriticalPhase // ignore: cast_nullable_to_non_nullable
                      as bool?,
            harvestDate: freezed == harvestDate
                ? _value.harvestDate
                : harvestDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EtcDailyEntityImplCopyWith<$Res>
    implements $EtcDailyEntityCopyWith<$Res> {
  factory _$$EtcDailyEntityImplCopyWith(
    _$EtcDailyEntityImpl value,
    $Res Function(_$EtcDailyEntityImpl) then,
  ) = __$$EtcDailyEntityImplCopyWithImpl<$Res>;
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
    double? waterNeededMM,
    int? waterNeededLiter,
    String? waterManagement,
    int? daysToHarvest,
    bool? isCriticalPhase,
    DateTime? harvestDate,
  });
}

/// @nodoc
class __$$EtcDailyEntityImplCopyWithImpl<$Res>
    extends _$EtcDailyEntityCopyWithImpl<$Res, _$EtcDailyEntityImpl>
    implements _$$EtcDailyEntityImplCopyWith<$Res> {
  __$$EtcDailyEntityImplCopyWithImpl(
    _$EtcDailyEntityImpl _value,
    $Res Function(_$EtcDailyEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EtcDailyEntity
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
    Object? waterNeededMM = freezed,
    Object? waterNeededLiter = freezed,
    Object? waterManagement = freezed,
    Object? daysToHarvest = freezed,
    Object? isCriticalPhase = freezed,
    Object? harvestDate = freezed,
  }) {
    return _then(
      _$EtcDailyEntityImpl(
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
        waterNeededMM: freezed == waterNeededMM
            ? _value.waterNeededMM
            : waterNeededMM // ignore: cast_nullable_to_non_nullable
                  as double?,
        waterNeededLiter: freezed == waterNeededLiter
            ? _value.waterNeededLiter
            : waterNeededLiter // ignore: cast_nullable_to_non_nullable
                  as int?,
        waterManagement: freezed == waterManagement
            ? _value.waterManagement
            : waterManagement // ignore: cast_nullable_to_non_nullable
                  as String?,
        daysToHarvest: freezed == daysToHarvest
            ? _value.daysToHarvest
            : daysToHarvest // ignore: cast_nullable_to_non_nullable
                  as int?,
        isCriticalPhase: freezed == isCriticalPhase
            ? _value.isCriticalPhase
            : isCriticalPhase // ignore: cast_nullable_to_non_nullable
                  as bool?,
        harvestDate: freezed == harvestDate
            ? _value.harvestDate
            : harvestDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$EtcDailyEntityImpl extends _EtcDailyEntity {
  const _$EtcDailyEntityImpl({
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
    this.waterNeededMM,
    this.waterNeededLiter,
    this.waterManagement,
    this.daysToHarvest,
    this.isCriticalPhase,
    this.harvestDate,
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
  final double? waterNeededMM;
  @override
  final int? waterNeededLiter;
  @override
  final String? waterManagement;
  @override
  final int? daysToHarvest;
  @override
  final bool? isCriticalPhase;
  @override
  final DateTime? harvestDate;

  @override
  String toString() {
    return 'EtcDailyEntity(hst: $hst, phase: $phase, et0: $et0, day: $day, tempMin: $tempMin, tempMax: $tempMax, rhMin: $rhMin, rhMax: $rhMax, etc: $etc, kc: $kc, waterNeeds: $waterNeeds, waterStatus: $waterStatus, recommendation: $recommendation, riceType: $riceType, waterNeededMM: $waterNeededMM, waterNeededLiter: $waterNeededLiter, waterManagement: $waterManagement, daysToHarvest: $daysToHarvest, isCriticalPhase: $isCriticalPhase, harvestDate: $harvestDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EtcDailyEntityImpl &&
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
                other.riceType == riceType) &&
            (identical(other.waterNeededMM, waterNeededMM) ||
                other.waterNeededMM == waterNeededMM) &&
            (identical(other.waterNeededLiter, waterNeededLiter) ||
                other.waterNeededLiter == waterNeededLiter) &&
            (identical(other.waterManagement, waterManagement) ||
                other.waterManagement == waterManagement) &&
            (identical(other.daysToHarvest, daysToHarvest) ||
                other.daysToHarvest == daysToHarvest) &&
            (identical(other.isCriticalPhase, isCriticalPhase) ||
                other.isCriticalPhase == isCriticalPhase) &&
            (identical(other.harvestDate, harvestDate) ||
                other.harvestDate == harvestDate));
  }

  @override
  int get hashCode => Object.hashAll([
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
    waterNeededMM,
    waterNeededLiter,
    waterManagement,
    daysToHarvest,
    isCriticalPhase,
    harvestDate,
  ]);

  /// Create a copy of EtcDailyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EtcDailyEntityImplCopyWith<_$EtcDailyEntityImpl> get copyWith =>
      __$$EtcDailyEntityImplCopyWithImpl<_$EtcDailyEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _EtcDailyEntity extends EtcDailyEntity {
  const factory _EtcDailyEntity({
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
    final double? waterNeededMM,
    final int? waterNeededLiter,
    final String? waterManagement,
    final int? daysToHarvest,
    final bool? isCriticalPhase,
    final DateTime? harvestDate,
  }) = _$EtcDailyEntityImpl;
  const _EtcDailyEntity._() : super._();

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
  @override
  double? get waterNeededMM;
  @override
  int? get waterNeededLiter;
  @override
  String? get waterManagement;
  @override
  int? get daysToHarvest;
  @override
  bool? get isCriticalPhase;
  @override
  DateTime? get harvestDate;

  /// Create a copy of EtcDailyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EtcDailyEntityImplCopyWith<_$EtcDailyEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AgroEntity {
  VdpEntity? get vdp => throw _privateConstructorUsedError;
  GddEntity? get gdd => throw _privateConstructorUsedError;
  List<EtcDailyEntity> get etc => throw _privateConstructorUsedError;

  /// Create a copy of AgroEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgroEntityCopyWith<AgroEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgroEntityCopyWith<$Res> {
  factory $AgroEntityCopyWith(
    AgroEntity value,
    $Res Function(AgroEntity) then,
  ) = _$AgroEntityCopyWithImpl<$Res, AgroEntity>;
  @useResult
  $Res call({VdpEntity? vdp, GddEntity? gdd, List<EtcDailyEntity> etc});

  $VdpEntityCopyWith<$Res>? get vdp;
  $GddEntityCopyWith<$Res>? get gdd;
}

/// @nodoc
class _$AgroEntityCopyWithImpl<$Res, $Val extends AgroEntity>
    implements $AgroEntityCopyWith<$Res> {
  _$AgroEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgroEntity
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
                      as VdpEntity?,
            gdd: freezed == gdd
                ? _value.gdd
                : gdd // ignore: cast_nullable_to_non_nullable
                      as GddEntity?,
            etc: null == etc
                ? _value.etc
                : etc // ignore: cast_nullable_to_non_nullable
                      as List<EtcDailyEntity>,
          )
          as $Val,
    );
  }

  /// Create a copy of AgroEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VdpEntityCopyWith<$Res>? get vdp {
    if (_value.vdp == null) {
      return null;
    }

    return $VdpEntityCopyWith<$Res>(_value.vdp!, (value) {
      return _then(_value.copyWith(vdp: value) as $Val);
    });
  }

  /// Create a copy of AgroEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GddEntityCopyWith<$Res>? get gdd {
    if (_value.gdd == null) {
      return null;
    }

    return $GddEntityCopyWith<$Res>(_value.gdd!, (value) {
      return _then(_value.copyWith(gdd: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AgroEntityImplCopyWith<$Res>
    implements $AgroEntityCopyWith<$Res> {
  factory _$$AgroEntityImplCopyWith(
    _$AgroEntityImpl value,
    $Res Function(_$AgroEntityImpl) then,
  ) = __$$AgroEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({VdpEntity? vdp, GddEntity? gdd, List<EtcDailyEntity> etc});

  @override
  $VdpEntityCopyWith<$Res>? get vdp;
  @override
  $GddEntityCopyWith<$Res>? get gdd;
}

/// @nodoc
class __$$AgroEntityImplCopyWithImpl<$Res>
    extends _$AgroEntityCopyWithImpl<$Res, _$AgroEntityImpl>
    implements _$$AgroEntityImplCopyWith<$Res> {
  __$$AgroEntityImplCopyWithImpl(
    _$AgroEntityImpl _value,
    $Res Function(_$AgroEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AgroEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdp = freezed,
    Object? gdd = freezed,
    Object? etc = null,
  }) {
    return _then(
      _$AgroEntityImpl(
        vdp: freezed == vdp
            ? _value.vdp
            : vdp // ignore: cast_nullable_to_non_nullable
                  as VdpEntity?,
        gdd: freezed == gdd
            ? _value.gdd
            : gdd // ignore: cast_nullable_to_non_nullable
                  as GddEntity?,
        etc: null == etc
            ? _value._etc
            : etc // ignore: cast_nullable_to_non_nullable
                  as List<EtcDailyEntity>,
      ),
    );
  }
}

/// @nodoc

class _$AgroEntityImpl extends _AgroEntity {
  const _$AgroEntityImpl({
    this.vdp,
    this.gdd,
    final List<EtcDailyEntity> etc = const [],
  }) : _etc = etc,
       super._();

  @override
  final VdpEntity? vdp;
  @override
  final GddEntity? gdd;
  final List<EtcDailyEntity> _etc;
  @override
  @JsonKey()
  List<EtcDailyEntity> get etc {
    if (_etc is EqualUnmodifiableListView) return _etc;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_etc);
  }

  @override
  String toString() {
    return 'AgroEntity(vdp: $vdp, gdd: $gdd, etc: $etc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgroEntityImpl &&
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

  /// Create a copy of AgroEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgroEntityImplCopyWith<_$AgroEntityImpl> get copyWith =>
      __$$AgroEntityImplCopyWithImpl<_$AgroEntityImpl>(this, _$identity);
}

abstract class _AgroEntity extends AgroEntity {
  const factory _AgroEntity({
    final VdpEntity? vdp,
    final GddEntity? gdd,
    final List<EtcDailyEntity> etc,
  }) = _$AgroEntityImpl;
  const _AgroEntity._() : super._();

  @override
  VdpEntity? get vdp;
  @override
  GddEntity? get gdd;
  @override
  List<EtcDailyEntity> get etc;

  /// Create a copy of AgroEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgroEntityImplCopyWith<_$AgroEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
