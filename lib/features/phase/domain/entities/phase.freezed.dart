// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Phase {
  String get id => throw _privateConstructorUsedError;

  /// Jenis tanaman: PADI, JAGUNG, KEDELAI
  String get cropType => throw _privateConstructorUsedError;

  /// Nama fase: Vegetatif, Generatif, dll.
  String get phaseName => throw _privateConstructorUsedError;

  /// Urutan fase (1, 2, 3, ...)
  int get phaseOrder => throw _privateConstructorUsedError;

  /// HST minimum fase ini dimulai
  int get hstMin => throw _privateConstructorUsedError;

  /// HST maksimum fase ini berakhir
  int get hstMax => throw _privateConstructorUsedError;

  /// HST saat ini (dari /fase/phases-by-hst)
  int get currentHst => throw _privateConstructorUsedError;

  /// Status: upcoming / active / completed
  String get status => throw _privateConstructorUsedError;

  /// Progress 0.0–1.0
  double get progress => throw _privateConstructorUsedError;

  /// Deskripsi fase (dibangun dari phaseName)
  String get description => throw _privateConstructorUsedError;

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhaseCopyWith<Phase> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhaseCopyWith<$Res> {
  factory $PhaseCopyWith(Phase value, $Res Function(Phase) then) =
      _$PhaseCopyWithImpl<$Res, Phase>;
  @useResult
  $Res call({
    String id,
    String cropType,
    String phaseName,
    int phaseOrder,
    int hstMin,
    int hstMax,
    int currentHst,
    String status,
    double progress,
    String description,
  });
}

/// @nodoc
class _$PhaseCopyWithImpl<$Res, $Val extends Phase>
    implements $PhaseCopyWith<$Res> {
  _$PhaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Phase
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
    Object? description = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhaseImplCopyWith<$Res> implements $PhaseCopyWith<$Res> {
  factory _$$PhaseImplCopyWith(
    _$PhaseImpl value,
    $Res Function(_$PhaseImpl) then,
  ) = __$$PhaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String cropType,
    String phaseName,
    int phaseOrder,
    int hstMin,
    int hstMax,
    int currentHst,
    String status,
    double progress,
    String description,
  });
}

/// @nodoc
class __$$PhaseImplCopyWithImpl<$Res>
    extends _$PhaseCopyWithImpl<$Res, _$PhaseImpl>
    implements _$$PhaseImplCopyWith<$Res> {
  __$$PhaseImplCopyWithImpl(
    _$PhaseImpl _value,
    $Res Function(_$PhaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Phase
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
    Object? description = null,
  }) {
    return _then(
      _$PhaseImpl(
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
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PhaseImpl extends _Phase {
  const _$PhaseImpl({
    required this.id,
    required this.cropType,
    required this.phaseName,
    required this.phaseOrder,
    required this.hstMin,
    required this.hstMax,
    this.currentHst = 0,
    this.status = 'upcoming',
    this.progress = 0.0,
    this.description = '',
  }) : super._();

  @override
  final String id;

  /// Jenis tanaman: PADI, JAGUNG, KEDELAI
  @override
  final String cropType;

  /// Nama fase: Vegetatif, Generatif, dll.
  @override
  final String phaseName;

  /// Urutan fase (1, 2, 3, ...)
  @override
  final int phaseOrder;

  /// HST minimum fase ini dimulai
  @override
  final int hstMin;

  /// HST maksimum fase ini berakhir
  @override
  final int hstMax;

  /// HST saat ini (dari /fase/phases-by-hst)
  @override
  @JsonKey()
  final int currentHst;

  /// Status: upcoming / active / completed
  @override
  @JsonKey()
  final String status;

  /// Progress 0.0–1.0
  @override
  @JsonKey()
  final double progress;

  /// Deskripsi fase (dibangun dari phaseName)
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'Phase(id: $id, cropType: $cropType, phaseName: $phaseName, phaseOrder: $phaseOrder, hstMin: $hstMin, hstMax: $hstMax, currentHst: $currentHst, status: $status, progress: $progress, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhaseImpl &&
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
                other.progress == progress) &&
            (identical(other.description, description) ||
                other.description == description));
  }

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
    description,
  );

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhaseImplCopyWith<_$PhaseImpl> get copyWith =>
      __$$PhaseImplCopyWithImpl<_$PhaseImpl>(this, _$identity);
}

abstract class _Phase extends Phase {
  const factory _Phase({
    required final String id,
    required final String cropType,
    required final String phaseName,
    required final int phaseOrder,
    required final int hstMin,
    required final int hstMax,
    final int currentHst,
    final String status,
    final double progress,
    final String description,
  }) = _$PhaseImpl;
  const _Phase._() : super._();

  @override
  String get id;

  /// Jenis tanaman: PADI, JAGUNG, KEDELAI
  @override
  String get cropType;

  /// Nama fase: Vegetatif, Generatif, dll.
  @override
  String get phaseName;

  /// Urutan fase (1, 2, 3, ...)
  @override
  int get phaseOrder;

  /// HST minimum fase ini dimulai
  @override
  int get hstMin;

  /// HST maksimum fase ini berakhir
  @override
  int get hstMax;

  /// HST saat ini (dari /fase/phases-by-hst)
  @override
  int get currentHst;

  /// Status: upcoming / active / completed
  @override
  String get status;

  /// Progress 0.0–1.0
  @override
  double get progress;

  /// Deskripsi fase (dibangun dari phaseName)
  @override
  String get description;

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhaseImplCopyWith<_$PhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
