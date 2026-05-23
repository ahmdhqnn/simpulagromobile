// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phase_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhaseModel _$PhaseModelFromJson(Map<String, dynamic> json) {
  return _PhaseModel.fromJson(json);
}

/// @nodoc
mixin _$PhaseModel {
  /// phase_id dari API
  @JsonKey(name: 'phase_id')
  String get id => throw _privateConstructorUsedError;

  /// Jenis tanaman: PADI, JAGUNG, KEDELAI (field 'chrop_type' di API)
  @JsonKey(name: 'chrop_type')
  String get cropType => throw _privateConstructorUsedError;

  /// Nama fase: Vegetatif, Generatif, dll.
  @JsonKey(name: 'phase_name')
  String get phaseName => throw _privateConstructorUsedError;

  /// Urutan fase (1, 2, 3, ...)
  @JsonKey(name: 'phase_order')
  int get phaseOrder => throw _privateConstructorUsedError;

  /// HST minimum fase ini dimulai
  @JsonKey(name: 'phase_hst_min')
  int get hstMin => throw _privateConstructorUsedError;

  /// HST maksimum fase ini berakhir
  @JsonKey(name: 'phase_hst_max')
  int get hstMax => throw _privateConstructorUsedError;

  /// HST saat ini — diisi via enrichWithHst(), default 0
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get currentHst => throw _privateConstructorUsedError;

  /// Status fase: upcoming / active / completed — diisi via enrichWithHst()
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get status => throw _privateConstructorUsedError;

  /// Progress 0.0–1.0 — dihitung via enrichWithHst()
  @JsonKey(includeFromJson: false, includeToJson: false)
  double get progress => throw _privateConstructorUsedError;

  /// Serializes this PhaseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhaseModelCopyWith<PhaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhaseModelCopyWith<$Res> {
  factory $PhaseModelCopyWith(
    PhaseModel value,
    $Res Function(PhaseModel) then,
  ) = _$PhaseModelCopyWithImpl<$Res, PhaseModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'phase_id') String id,
    @JsonKey(name: 'chrop_type') String cropType,
    @JsonKey(name: 'phase_name') String phaseName,
    @JsonKey(name: 'phase_order') int phaseOrder,
    @JsonKey(name: 'phase_hst_min') int hstMin,
    @JsonKey(name: 'phase_hst_max') int hstMax,
    @JsonKey(includeFromJson: false, includeToJson: false) int currentHst,
    @JsonKey(includeFromJson: false, includeToJson: false) String status,
    @JsonKey(includeFromJson: false, includeToJson: false) double progress,
  });
}

/// @nodoc
class _$PhaseModelCopyWithImpl<$Res, $Val extends PhaseModel>
    implements $PhaseModelCopyWith<$Res> {
  _$PhaseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cropType = null,
    Object? phaseName = null,
    Object? phaseOrder = null,
    Object? hstMin = null,
    Object? hstMax = null,
    Object? currentHst = null,
    Object? status = null,
    Object? progress = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            cropType: null == cropType
                ? _value.cropType
                : cropType // ignore: cast_nullable_to_non_nullable
                      as String,
            phaseName: null == phaseName
                ? _value.phaseName
                : phaseName // ignore: cast_nullable_to_non_nullable
                      as String,
            phaseOrder: null == phaseOrder
                ? _value.phaseOrder
                : phaseOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            hstMin: null == hstMin
                ? _value.hstMin
                : hstMin // ignore: cast_nullable_to_non_nullable
                      as int,
            hstMax: null == hstMax
                ? _value.hstMax
                : hstMax // ignore: cast_nullable_to_non_nullable
                      as int,
            currentHst: null == currentHst
                ? _value.currentHst
                : currentHst // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhaseModelImplCopyWith<$Res>
    implements $PhaseModelCopyWith<$Res> {
  factory _$$PhaseModelImplCopyWith(
    _$PhaseModelImpl value,
    $Res Function(_$PhaseModelImpl) then,
  ) = __$$PhaseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'phase_id') String id,
    @JsonKey(name: 'chrop_type') String cropType,
    @JsonKey(name: 'phase_name') String phaseName,
    @JsonKey(name: 'phase_order') int phaseOrder,
    @JsonKey(name: 'phase_hst_min') int hstMin,
    @JsonKey(name: 'phase_hst_max') int hstMax,
    @JsonKey(includeFromJson: false, includeToJson: false) int currentHst,
    @JsonKey(includeFromJson: false, includeToJson: false) String status,
    @JsonKey(includeFromJson: false, includeToJson: false) double progress,
  });
}

/// @nodoc
class __$$PhaseModelImplCopyWithImpl<$Res>
    extends _$PhaseModelCopyWithImpl<$Res, _$PhaseModelImpl>
    implements _$$PhaseModelImplCopyWith<$Res> {
  __$$PhaseModelImplCopyWithImpl(
    _$PhaseModelImpl _value,
    $Res Function(_$PhaseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cropType = null,
    Object? phaseName = null,
    Object? phaseOrder = null,
    Object? hstMin = null,
    Object? hstMax = null,
    Object? currentHst = null,
    Object? status = null,
    Object? progress = null,
  }) {
    return _then(
      _$PhaseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        cropType: null == cropType
            ? _value.cropType
            : cropType // ignore: cast_nullable_to_non_nullable
                  as String,
        phaseName: null == phaseName
            ? _value.phaseName
            : phaseName // ignore: cast_nullable_to_non_nullable
                  as String,
        phaseOrder: null == phaseOrder
            ? _value.phaseOrder
            : phaseOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        hstMin: null == hstMin
            ? _value.hstMin
            : hstMin // ignore: cast_nullable_to_non_nullable
                  as int,
        hstMax: null == hstMax
            ? _value.hstMax
            : hstMax // ignore: cast_nullable_to_non_nullable
                  as int,
        currentHst: null == currentHst
            ? _value.currentHst
            : currentHst // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhaseModelImpl extends _PhaseModel {
  const _$PhaseModelImpl({
    @JsonKey(name: 'phase_id') required this.id,
    @JsonKey(name: 'chrop_type') required this.cropType,
    @JsonKey(name: 'phase_name') required this.phaseName,
    @JsonKey(name: 'phase_order') required this.phaseOrder,
    @JsonKey(name: 'phase_hst_min') required this.hstMin,
    @JsonKey(name: 'phase_hst_max') required this.hstMax,
    @JsonKey(includeFromJson: false, includeToJson: false) this.currentHst = 0,
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.status = 'upcoming',
    @JsonKey(includeFromJson: false, includeToJson: false) this.progress = 0.0,
  }) : super._();

  factory _$PhaseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhaseModelImplFromJson(json);

  /// phase_id dari API
  @override
  @JsonKey(name: 'phase_id')
  final String id;

  /// Jenis tanaman: PADI, JAGUNG, KEDELAI (field 'chrop_type' di API)
  @override
  @JsonKey(name: 'chrop_type')
  final String cropType;

  /// Nama fase: Vegetatif, Generatif, dll.
  @override
  @JsonKey(name: 'phase_name')
  final String phaseName;

  /// Urutan fase (1, 2, 3, ...)
  @override
  @JsonKey(name: 'phase_order')
  final int phaseOrder;

  /// HST minimum fase ini dimulai
  @override
  @JsonKey(name: 'phase_hst_min')
  final int hstMin;

  /// HST maksimum fase ini berakhir
  @override
  @JsonKey(name: 'phase_hst_max')
  final int hstMax;

  /// HST saat ini — diisi via enrichWithHst(), default 0
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int currentHst;

  /// Status fase: upcoming / active / completed — diisi via enrichWithHst()
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String status;

  /// Progress 0.0–1.0 — dihitung via enrichWithHst()
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double progress;

  @override
  String toString() {
    return 'PhaseModel(id: $id, cropType: $cropType, phaseName: $phaseName, phaseOrder: $phaseOrder, hstMin: $hstMin, hstMax: $hstMax, currentHst: $currentHst, status: $status, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhaseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cropType, cropType) ||
                other.cropType == cropType) &&
            (identical(other.phaseName, phaseName) ||
                other.phaseName == phaseName) &&
            (identical(other.phaseOrder, phaseOrder) ||
                other.phaseOrder == phaseOrder) &&
            (identical(other.hstMin, hstMin) || other.hstMin == hstMin) &&
            (identical(other.hstMax, hstMax) || other.hstMax == hstMax) &&
            (identical(other.currentHst, currentHst) ||
                other.currentHst == currentHst) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    cropType,
    phaseName,
    phaseOrder,
    hstMin,
    hstMax,
    currentHst,
    status,
    progress,
  );

  /// Create a copy of PhaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhaseModelImplCopyWith<_$PhaseModelImpl> get copyWith =>
      __$$PhaseModelImplCopyWithImpl<_$PhaseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhaseModelImplToJson(this);
  }
}

abstract class _PhaseModel extends PhaseModel {
  const factory _PhaseModel({
    @JsonKey(name: 'phase_id') required final String id,
    @JsonKey(name: 'chrop_type') required final String cropType,
    @JsonKey(name: 'phase_name') required final String phaseName,
    @JsonKey(name: 'phase_order') required final int phaseOrder,
    @JsonKey(name: 'phase_hst_min') required final int hstMin,
    @JsonKey(name: 'phase_hst_max') required final int hstMax,
    @JsonKey(includeFromJson: false, includeToJson: false) final int currentHst,
    @JsonKey(includeFromJson: false, includeToJson: false) final String status,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final double progress,
  }) = _$PhaseModelImpl;
  const _PhaseModel._() : super._();

  factory _PhaseModel.fromJson(Map<String, dynamic> json) =
      _$PhaseModelImpl.fromJson;

  /// phase_id dari API
  @override
  @JsonKey(name: 'phase_id')
  String get id;

  /// Jenis tanaman: PADI, JAGUNG, KEDELAI (field 'chrop_type' di API)
  @override
  @JsonKey(name: 'chrop_type')
  String get cropType;

  /// Nama fase: Vegetatif, Generatif, dll.
  @override
  @JsonKey(name: 'phase_name')
  String get phaseName;

  /// Urutan fase (1, 2, 3, ...)
  @override
  @JsonKey(name: 'phase_order')
  int get phaseOrder;

  /// HST minimum fase ini dimulai
  @override
  @JsonKey(name: 'phase_hst_min')
  int get hstMin;

  /// HST maksimum fase ini berakhir
  @override
  @JsonKey(name: 'phase_hst_max')
  int get hstMax;

  /// HST saat ini — diisi via enrichWithHst(), default 0
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get currentHst;

  /// Status fase: upcoming / active / completed — diisi via enrichWithHst()
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get status;

  /// Progress 0.0–1.0 — dihitung via enrichWithHst()
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  double get progress;

  /// Create a copy of PhaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhaseModelImplCopyWith<_$PhaseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
