// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  @JsonKey(name: 'task_id')
  String get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  String? get siteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_name')
  String? get siteName => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_id')
  String? get plantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_name')
  String? get plantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_name')
  String get taskName => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_description')
  String? get taskDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_type')
  String get taskType => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_status')
  String get taskStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_priority')
  String get taskPriority => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_due_date')
  DateTime? get taskDueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_completed_date')
  DateTime? get taskCompletedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  String? get assignedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to_name')
  String? get assignedToName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'task_id') String taskId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'plant_id') String? plantId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'task_name') String taskName,
    @JsonKey(name: 'task_description') String? taskDescription,
    @JsonKey(name: 'task_type') String taskType,
    @JsonKey(name: 'task_status') String taskStatus,
    @JsonKey(name: 'task_priority') String taskPriority,
    @JsonKey(name: 'task_due_date') DateTime? taskDueDate,
    @JsonKey(name: 'task_completed_date') DateTime? taskCompletedDate,
    @JsonKey(name: 'assigned_to') String? assignedTo,
    @JsonKey(name: 'assigned_to_name') String? assignedToName,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'notes') String? notes,
  });
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? siteId = freezed,
    Object? siteName = freezed,
    Object? plantId = freezed,
    Object? plantName = freezed,
    Object? taskName = null,
    Object? taskDescription = freezed,
    Object? taskType = null,
    Object? taskStatus = null,
    Object? taskPriority = null,
    Object? taskDueDate = freezed,
    Object? taskCompletedDate = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as String,
            siteId: freezed == siteId
                ? _value.siteId
                : siteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            siteName: freezed == siteName
                ? _value.siteName
                : siteName // ignore: cast_nullable_to_non_nullable
                      as String?,
            plantId: freezed == plantId
                ? _value.plantId
                : plantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            plantName: freezed == plantName
                ? _value.plantName
                : plantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            taskName: null == taskName
                ? _value.taskName
                : taskName // ignore: cast_nullable_to_non_nullable
                      as String,
            taskDescription: freezed == taskDescription
                ? _value.taskDescription
                : taskDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            taskType: null == taskType
                ? _value.taskType
                : taskType // ignore: cast_nullable_to_non_nullable
                      as String,
            taskStatus: null == taskStatus
                ? _value.taskStatus
                : taskStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            taskPriority: null == taskPriority
                ? _value.taskPriority
                : taskPriority // ignore: cast_nullable_to_non_nullable
                      as String,
            taskDueDate: freezed == taskDueDate
                ? _value.taskDueDate
                : taskDueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            taskCompletedDate: freezed == taskCompletedDate
                ? _value.taskCompletedDate
                : taskCompletedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedToName: freezed == assignedToName
                ? _value.assignedToName
                : assignedToName // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
    _$TaskModelImpl value,
    $Res Function(_$TaskModelImpl) then,
  ) = __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'task_id') String taskId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'plant_id') String? plantId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'task_name') String taskName,
    @JsonKey(name: 'task_description') String? taskDescription,
    @JsonKey(name: 'task_type') String taskType,
    @JsonKey(name: 'task_status') String taskStatus,
    @JsonKey(name: 'task_priority') String taskPriority,
    @JsonKey(name: 'task_due_date') DateTime? taskDueDate,
    @JsonKey(name: 'task_completed_date') DateTime? taskCompletedDate,
    @JsonKey(name: 'assigned_to') String? assignedTo,
    @JsonKey(name: 'assigned_to_name') String? assignedToName,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'notes') String? notes,
  });
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
    _$TaskModelImpl _value,
    $Res Function(_$TaskModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? siteId = freezed,
    Object? siteName = freezed,
    Object? plantId = freezed,
    Object? plantName = freezed,
    Object? taskName = null,
    Object? taskDescription = freezed,
    Object? taskType = null,
    Object? taskStatus = null,
    Object? taskPriority = null,
    Object? taskDueDate = freezed,
    Object? taskCompletedDate = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$TaskModelImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
        siteId: freezed == siteId
            ? _value.siteId
            : siteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        siteName: freezed == siteName
            ? _value.siteName
            : siteName // ignore: cast_nullable_to_non_nullable
                  as String?,
        plantId: freezed == plantId
            ? _value.plantId
            : plantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        plantName: freezed == plantName
            ? _value.plantName
            : plantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        taskName: null == taskName
            ? _value.taskName
            : taskName // ignore: cast_nullable_to_non_nullable
                  as String,
        taskDescription: freezed == taskDescription
            ? _value.taskDescription
            : taskDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        taskType: null == taskType
            ? _value.taskType
            : taskType // ignore: cast_nullable_to_non_nullable
                  as String,
        taskStatus: null == taskStatus
            ? _value.taskStatus
            : taskStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        taskPriority: null == taskPriority
            ? _value.taskPriority
            : taskPriority // ignore: cast_nullable_to_non_nullable
                  as String,
        taskDueDate: freezed == taskDueDate
            ? _value.taskDueDate
            : taskDueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        taskCompletedDate: freezed == taskCompletedDate
            ? _value.taskCompletedDate
            : taskCompletedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedToName: freezed == assignedToName
            ? _value.assignedToName
            : assignedToName // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl extends _TaskModel {
  const _$TaskModelImpl({
    @JsonKey(name: 'task_id') required this.taskId,
    @JsonKey(name: 'site_id') this.siteId,
    @JsonKey(name: 'site_name') this.siteName,
    @JsonKey(name: 'plant_id') this.plantId,
    @JsonKey(name: 'plant_name') this.plantName,
    @JsonKey(name: 'task_name') required this.taskName,
    @JsonKey(name: 'task_description') this.taskDescription,
    @JsonKey(name: 'task_type') required this.taskType,
    @JsonKey(name: 'task_status') required this.taskStatus,
    @JsonKey(name: 'task_priority') required this.taskPriority,
    @JsonKey(name: 'task_due_date') this.taskDueDate,
    @JsonKey(name: 'task_completed_date') this.taskCompletedDate,
    @JsonKey(name: 'assigned_to') this.assignedTo,
    @JsonKey(name: 'assigned_to_name') this.assignedToName,
    @JsonKey(name: 'created_by') this.createdBy,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'notes') this.notes,
  }) : super._();

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  @JsonKey(name: 'task_id')
  final String taskId;
  @override
  @JsonKey(name: 'site_id')
  final String? siteId;
  @override
  @JsonKey(name: 'site_name')
  final String? siteName;
  @override
  @JsonKey(name: 'plant_id')
  final String? plantId;
  @override
  @JsonKey(name: 'plant_name')
  final String? plantName;
  @override
  @JsonKey(name: 'task_name')
  final String taskName;
  @override
  @JsonKey(name: 'task_description')
  final String? taskDescription;
  @override
  @JsonKey(name: 'task_type')
  final String taskType;
  @override
  @JsonKey(name: 'task_status')
  final String taskStatus;
  @override
  @JsonKey(name: 'task_priority')
  final String taskPriority;
  @override
  @JsonKey(name: 'task_due_date')
  final DateTime? taskDueDate;
  @override
  @JsonKey(name: 'task_completed_date')
  final DateTime? taskCompletedDate;
  @override
  @JsonKey(name: 'assigned_to')
  final String? assignedTo;
  @override
  @JsonKey(name: 'assigned_to_name')
  final String? assignedToName;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'notes')
  final String? notes;

  @override
  String toString() {
    return 'TaskModel(taskId: $taskId, siteId: $siteId, siteName: $siteName, plantId: $plantId, plantName: $plantName, taskName: $taskName, taskDescription: $taskDescription, taskType: $taskType, taskStatus: $taskStatus, taskPriority: $taskPriority, taskDueDate: $taskDueDate, taskCompletedDate: $taskCompletedDate, assignedTo: $assignedTo, assignedToName: $assignedToName, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.siteName, siteName) ||
                other.siteName == siteName) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.taskName, taskName) ||
                other.taskName == taskName) &&
            (identical(other.taskDescription, taskDescription) ||
                other.taskDescription == taskDescription) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.taskStatus, taskStatus) ||
                other.taskStatus == taskStatus) &&
            (identical(other.taskPriority, taskPriority) ||
                other.taskPriority == taskPriority) &&
            (identical(other.taskDueDate, taskDueDate) ||
                other.taskDueDate == taskDueDate) &&
            (identical(other.taskCompletedDate, taskCompletedDate) ||
                other.taskCompletedDate == taskCompletedDate) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    taskId,
    siteId,
    siteName,
    plantId,
    plantName,
    taskName,
    taskDescription,
    taskType,
    taskStatus,
    taskPriority,
    taskDueDate,
    taskCompletedDate,
    assignedTo,
    assignedToName,
    createdBy,
    createdAt,
    updatedAt,
    notes,
  );

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(this);
  }
}

abstract class _TaskModel extends TaskModel {
  const factory _TaskModel({
    @JsonKey(name: 'task_id') required final String taskId,
    @JsonKey(name: 'site_id') final String? siteId,
    @JsonKey(name: 'site_name') final String? siteName,
    @JsonKey(name: 'plant_id') final String? plantId,
    @JsonKey(name: 'plant_name') final String? plantName,
    @JsonKey(name: 'task_name') required final String taskName,
    @JsonKey(name: 'task_description') final String? taskDescription,
    @JsonKey(name: 'task_type') required final String taskType,
    @JsonKey(name: 'task_status') required final String taskStatus,
    @JsonKey(name: 'task_priority') required final String taskPriority,
    @JsonKey(name: 'task_due_date') final DateTime? taskDueDate,
    @JsonKey(name: 'task_completed_date') final DateTime? taskCompletedDate,
    @JsonKey(name: 'assigned_to') final String? assignedTo,
    @JsonKey(name: 'assigned_to_name') final String? assignedToName,
    @JsonKey(name: 'created_by') final String? createdBy,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'notes') final String? notes,
  }) = _$TaskModelImpl;
  const _TaskModel._() : super._();

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  @JsonKey(name: 'task_id')
  String get taskId;
  @override
  @JsonKey(name: 'site_id')
  String? get siteId;
  @override
  @JsonKey(name: 'site_name')
  String? get siteName;
  @override
  @JsonKey(name: 'plant_id')
  String? get plantId;
  @override
  @JsonKey(name: 'plant_name')
  String? get plantName;
  @override
  @JsonKey(name: 'task_name')
  String get taskName;
  @override
  @JsonKey(name: 'task_description')
  String? get taskDescription;
  @override
  @JsonKey(name: 'task_type')
  String get taskType;
  @override
  @JsonKey(name: 'task_status')
  String get taskStatus;
  @override
  @JsonKey(name: 'task_priority')
  String get taskPriority;
  @override
  @JsonKey(name: 'task_due_date')
  DateTime? get taskDueDate;
  @override
  @JsonKey(name: 'task_completed_date')
  DateTime? get taskCompletedDate;
  @override
  @JsonKey(name: 'assigned_to')
  String? get assignedTo;
  @override
  @JsonKey(name: 'assigned_to_name')
  String? get assignedToName;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'notes')
  String? get notes;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
