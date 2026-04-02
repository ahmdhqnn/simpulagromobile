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
  String get plantId => throw _privateConstructorUsedError;
  String get plantName => throw _privateConstructorUsedError;
  String get phaseName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get startHst => throw _privateConstructorUsedError;
  int get endHst => throw _privateConstructorUsedError;
  int get currentHst => throw _privateConstructorUsedError;
  double get requiredGdd => throw _privateConstructorUsedError;
  double get currentGdd => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // active, completed, upcoming
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

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
    String plantId,
    String plantName,
    String phaseName,
    String description,
    int startHst,
    int endHst,
    int currentHst,
    double requiredGdd,
    double currentGdd,
    double progress,
    String status,
    DateTime startDate,
    DateTime? endDate,
    DateTime createdAt,
    DateTime updatedAt,
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
    Object? plantId = null,
    Object? plantName = null,
    Object? phaseName = null,
    Object? description = null,
    Object? startHst = null,
    Object? endHst = null,
    Object? currentHst = null,
    Object? requiredGdd = null,
    Object? currentGdd = null,
    Object? progress = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            plantId: null == plantId
                ? _value.plantId
                : plantId // ignore: cast_nullable_to_non_nullable
                      as String,
            plantName: null == plantName
                ? _value.plantName
                : plantName // ignore: cast_nullable_to_non_nullable
                      as String,
            phaseName: null == phaseName
                ? _value.phaseName
                : phaseName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            startHst: null == startHst
                ? _value.startHst
                : startHst // ignore: cast_nullable_to_non_nullable
                      as int,
            endHst: null == endHst
                ? _value.endHst
                : endHst // ignore: cast_nullable_to_non_nullable
                      as int,
            currentHst: null == currentHst
                ? _value.currentHst
                : currentHst // ignore: cast_nullable_to_non_nullable
                      as int,
            requiredGdd: null == requiredGdd
                ? _value.requiredGdd
                : requiredGdd // ignore: cast_nullable_to_non_nullable
                      as double,
            currentGdd: null == currentGdd
                ? _value.currentGdd
                : currentGdd // ignore: cast_nullable_to_non_nullable
                      as double,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
    String plantId,
    String plantName,
    String phaseName,
    String description,
    int startHst,
    int endHst,
    int currentHst,
    double requiredGdd,
    double currentGdd,
    double progress,
    String status,
    DateTime startDate,
    DateTime? endDate,
    DateTime createdAt,
    DateTime updatedAt,
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
    Object? plantId = null,
    Object? plantName = null,
    Object? phaseName = null,
    Object? description = null,
    Object? startHst = null,
    Object? endHst = null,
    Object? currentHst = null,
    Object? requiredGdd = null,
    Object? currentGdd = null,
    Object? progress = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$PhaseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        plantId: null == plantId
            ? _value.plantId
            : plantId // ignore: cast_nullable_to_non_nullable
                  as String,
        plantName: null == plantName
            ? _value.plantName
            : plantName // ignore: cast_nullable_to_non_nullable
                  as String,
        phaseName: null == phaseName
            ? _value.phaseName
            : phaseName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        startHst: null == startHst
            ? _value.startHst
            : startHst // ignore: cast_nullable_to_non_nullable
                  as int,
        endHst: null == endHst
            ? _value.endHst
            : endHst // ignore: cast_nullable_to_non_nullable
                  as int,
        currentHst: null == currentHst
            ? _value.currentHst
            : currentHst // ignore: cast_nullable_to_non_nullable
                  as int,
        requiredGdd: null == requiredGdd
            ? _value.requiredGdd
            : requiredGdd // ignore: cast_nullable_to_non_nullable
                  as double,
        currentGdd: null == currentGdd
            ? _value.currentGdd
            : currentGdd // ignore: cast_nullable_to_non_nullable
                  as double,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$PhaseImpl extends _Phase {
  const _$PhaseImpl({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.phaseName,
    required this.description,
    required this.startHst,
    required this.endHst,
    required this.currentHst,
    required this.requiredGdd,
    required this.currentGdd,
    required this.progress,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  @override
  final String id;
  @override
  final String plantId;
  @override
  final String plantName;
  @override
  final String phaseName;
  @override
  final String description;
  @override
  final int startHst;
  @override
  final int endHst;
  @override
  final int currentHst;
  @override
  final double requiredGdd;
  @override
  final double currentGdd;
  @override
  final double progress;
  @override
  final String status;
  // active, completed, upcoming
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Phase(id: $id, plantId: $plantId, plantName: $plantName, phaseName: $phaseName, description: $description, startHst: $startHst, endHst: $endHst, currentHst: $currentHst, requiredGdd: $requiredGdd, currentGdd: $currentGdd, progress: $progress, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.phaseName, phaseName) ||
                other.phaseName == phaseName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startHst, startHst) ||
                other.startHst == startHst) &&
            (identical(other.endHst, endHst) || other.endHst == endHst) &&
            (identical(other.currentHst, currentHst) ||
                other.currentHst == currentHst) &&
            (identical(other.requiredGdd, requiredGdd) ||
                other.requiredGdd == requiredGdd) &&
            (identical(other.currentGdd, currentGdd) ||
                other.currentGdd == currentGdd) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    plantId,
    plantName,
    phaseName,
    description,
    startHst,
    endHst,
    currentHst,
    requiredGdd,
    currentGdd,
    progress,
    status,
    startDate,
    endDate,
    createdAt,
    updatedAt,
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
    required final String plantId,
    required final String plantName,
    required final String phaseName,
    required final String description,
    required final int startHst,
    required final int endHst,
    required final int currentHst,
    required final double requiredGdd,
    required final double currentGdd,
    required final double progress,
    required final String status,
    required final DateTime startDate,
    final DateTime? endDate,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$PhaseImpl;
  const _Phase._() : super._();

  @override
  String get id;
  @override
  String get plantId;
  @override
  String get plantName;
  @override
  String get phaseName;
  @override
  String get description;
  @override
  int get startHst;
  @override
  int get endHst;
  @override
  int get currentHst;
  @override
  double get requiredGdd;
  @override
  double get currentGdd;
  @override
  double get progress;
  @override
  String get status; // active, completed, upcoming
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhaseImplCopyWith<_$PhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
