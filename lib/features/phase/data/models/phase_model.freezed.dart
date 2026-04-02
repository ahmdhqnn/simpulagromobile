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
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_id')
  String get plantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_name')
  String get plantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'phase_name')
  String get phaseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_hst')
  int get startHst => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_hst')
  int get endHst => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_hst')
  int get currentHst => throw _privateConstructorUsedError;
  @JsonKey(name: 'required_gdd')
  double get requiredGdd => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_gdd')
  double get currentGdd => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress')
  double get progress => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'plant_id') String plantId,
    @JsonKey(name: 'plant_name') String plantName,
    @JsonKey(name: 'phase_name') String phaseName,
    @JsonKey(name: 'description') String description,
    @JsonKey(name: 'start_hst') int startHst,
    @JsonKey(name: 'end_hst') int endHst,
    @JsonKey(name: 'current_hst') int currentHst,
    @JsonKey(name: 'required_gdd') double requiredGdd,
    @JsonKey(name: 'current_gdd') double currentGdd,
    @JsonKey(name: 'progress') double progress,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
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
abstract class _$$PhaseModelImplCopyWith<$Res>
    implements $PhaseModelCopyWith<$Res> {
  factory _$$PhaseModelImplCopyWith(
    _$PhaseModelImpl value,
    $Res Function(_$PhaseModelImpl) then,
  ) = __$$PhaseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'plant_id') String plantId,
    @JsonKey(name: 'plant_name') String plantName,
    @JsonKey(name: 'phase_name') String phaseName,
    @JsonKey(name: 'description') String description,
    @JsonKey(name: 'start_hst') int startHst,
    @JsonKey(name: 'end_hst') int endHst,
    @JsonKey(name: 'current_hst') int currentHst,
    @JsonKey(name: 'required_gdd') double requiredGdd,
    @JsonKey(name: 'current_gdd') double currentGdd,
    @JsonKey(name: 'progress') double progress,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
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
      _$PhaseModelImpl(
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
@JsonSerializable()
class _$PhaseModelImpl extends _PhaseModel {
  const _$PhaseModelImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'plant_id') required this.plantId,
    @JsonKey(name: 'plant_name') required this.plantName,
    @JsonKey(name: 'phase_name') required this.phaseName,
    @JsonKey(name: 'description') required this.description,
    @JsonKey(name: 'start_hst') required this.startHst,
    @JsonKey(name: 'end_hst') required this.endHst,
    @JsonKey(name: 'current_hst') required this.currentHst,
    @JsonKey(name: 'required_gdd') required this.requiredGdd,
    @JsonKey(name: 'current_gdd') required this.currentGdd,
    @JsonKey(name: 'progress') required this.progress,
    @JsonKey(name: 'status') required this.status,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : super._();

  factory _$PhaseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhaseModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'plant_id')
  final String plantId;
  @override
  @JsonKey(name: 'plant_name')
  final String plantName;
  @override
  @JsonKey(name: 'phase_name')
  final String phaseName;
  @override
  @JsonKey(name: 'description')
  final String description;
  @override
  @JsonKey(name: 'start_hst')
  final int startHst;
  @override
  @JsonKey(name: 'end_hst')
  final int endHst;
  @override
  @JsonKey(name: 'current_hst')
  final int currentHst;
  @override
  @JsonKey(name: 'required_gdd')
  final double requiredGdd;
  @override
  @JsonKey(name: 'current_gdd')
  final double currentGdd;
  @override
  @JsonKey(name: 'progress')
  final double progress;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PhaseModel(id: $id, plantId: $plantId, plantName: $plantName, phaseName: $phaseName, description: $description, startHst: $startHst, endHst: $endHst, currentHst: $currentHst, requiredGdd: $requiredGdd, currentGdd: $currentGdd, progress: $progress, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhaseModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'plant_id') required final String plantId,
    @JsonKey(name: 'plant_name') required final String plantName,
    @JsonKey(name: 'phase_name') required final String phaseName,
    @JsonKey(name: 'description') required final String description,
    @JsonKey(name: 'start_hst') required final int startHst,
    @JsonKey(name: 'end_hst') required final int endHst,
    @JsonKey(name: 'current_hst') required final int currentHst,
    @JsonKey(name: 'required_gdd') required final double requiredGdd,
    @JsonKey(name: 'current_gdd') required final double currentGdd,
    @JsonKey(name: 'progress') required final double progress,
    @JsonKey(name: 'status') required final String status,
    @JsonKey(name: 'start_date') required final DateTime startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$PhaseModelImpl;
  const _PhaseModel._() : super._();

  factory _PhaseModel.fromJson(Map<String, dynamic> json) =
      _$PhaseModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'plant_id')
  String get plantId;
  @override
  @JsonKey(name: 'plant_name')
  String get plantName;
  @override
  @JsonKey(name: 'phase_name')
  String get phaseName;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'start_hst')
  int get startHst;
  @override
  @JsonKey(name: 'end_hst')
  int get endHst;
  @override
  @JsonKey(name: 'current_hst')
  int get currentHst;
  @override
  @JsonKey(name: 'required_gdd')
  double get requiredGdd;
  @override
  @JsonKey(name: 'current_gdd')
  double get currentGdd;
  @override
  @JsonKey(name: 'progress')
  double get progress;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of PhaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhaseModelImplCopyWith<_$PhaseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
