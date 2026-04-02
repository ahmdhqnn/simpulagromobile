// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Task {
  String get taskId => throw _privateConstructorUsedError;
  String? get siteId => throw _privateConstructorUsedError;
  String? get siteName => throw _privateConstructorUsedError;
  String? get plantId => throw _privateConstructorUsedError;
  String? get plantName => throw _privateConstructorUsedError;
  String get taskName => throw _privateConstructorUsedError;
  String? get taskDescription => throw _privateConstructorUsedError;
  TaskType get taskType => throw _privateConstructorUsedError;
  TaskStatus get taskStatus => throw _privateConstructorUsedError;
  TaskPriority get taskPriority => throw _privateConstructorUsedError;
  DateTime? get taskDueDate => throw _privateConstructorUsedError;
  DateTime? get taskCompletedDate => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get assignedToName => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call({
    String taskId,
    String? siteId,
    String? siteName,
    String? plantId,
    String? plantName,
    String taskName,
    String? taskDescription,
    TaskType taskType,
    TaskStatus taskStatus,
    TaskPriority taskPriority,
    DateTime? taskDueDate,
    DateTime? taskCompletedDate,
    String? assignedTo,
    String? assignedToName,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  });
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
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
                      as TaskType,
            taskStatus: null == taskStatus
                ? _value.taskStatus
                : taskStatus // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            taskPriority: null == taskPriority
                ? _value.taskPriority
                : taskPriority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
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
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
    _$TaskImpl value,
    $Res Function(_$TaskImpl) then,
  ) = __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String taskId,
    String? siteId,
    String? siteName,
    String? plantId,
    String? plantName,
    String taskName,
    String? taskDescription,
    TaskType taskType,
    TaskStatus taskStatus,
    TaskPriority taskPriority,
    DateTime? taskDueDate,
    DateTime? taskCompletedDate,
    String? assignedTo,
    String? assignedToName,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  });
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
    : super(_value, _then);

  /// Create a copy of Task
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
      _$TaskImpl(
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
                  as TaskType,
        taskStatus: null == taskStatus
            ? _value.taskStatus
            : taskStatus // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        taskPriority: null == taskPriority
            ? _value.taskPriority
            : taskPriority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
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

class _$TaskImpl extends _Task {
  const _$TaskImpl({
    required this.taskId,
    this.siteId,
    this.siteName,
    this.plantId,
    this.plantName,
    required this.taskName,
    this.taskDescription,
    required this.taskType,
    required this.taskStatus,
    required this.taskPriority,
    this.taskDueDate,
    this.taskCompletedDate,
    this.assignedTo,
    this.assignedToName,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.notes,
  }) : super._();

  @override
  final String taskId;
  @override
  final String? siteId;
  @override
  final String? siteName;
  @override
  final String? plantId;
  @override
  final String? plantName;
  @override
  final String taskName;
  @override
  final String? taskDescription;
  @override
  final TaskType taskType;
  @override
  final TaskStatus taskStatus;
  @override
  final TaskPriority taskPriority;
  @override
  final DateTime? taskDueDate;
  @override
  final DateTime? taskCompletedDate;
  @override
  final String? assignedTo;
  @override
  final String? assignedToName;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Task(taskId: $taskId, siteId: $siteId, siteName: $siteName, plantId: $plantId, plantName: $plantName, taskName: $taskName, taskDescription: $taskDescription, taskType: $taskType, taskStatus: $taskStatus, taskPriority: $taskPriority, taskDueDate: $taskDueDate, taskCompletedDate: $taskCompletedDate, assignedTo: $assignedTo, assignedToName: $assignedToName, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
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

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);
}

abstract class _Task extends Task {
  const factory _Task({
    required final String taskId,
    final String? siteId,
    final String? siteName,
    final String? plantId,
    final String? plantName,
    required final String taskName,
    final String? taskDescription,
    required final TaskType taskType,
    required final TaskStatus taskStatus,
    required final TaskPriority taskPriority,
    final DateTime? taskDueDate,
    final DateTime? taskCompletedDate,
    final String? assignedTo,
    final String? assignedToName,
    final String? createdBy,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? notes,
  }) = _$TaskImpl;
  const _Task._() : super._();

  @override
  String get taskId;
  @override
  String? get siteId;
  @override
  String? get siteName;
  @override
  String? get plantId;
  @override
  String? get plantName;
  @override
  String get taskName;
  @override
  String? get taskDescription;
  @override
  TaskType get taskType;
  @override
  TaskStatus get taskStatus;
  @override
  TaskPriority get taskPriority;
  @override
  DateTime? get taskDueDate;
  @override
  DateTime? get taskCompletedDate;
  @override
  String? get assignedTo;
  @override
  String? get assignedToName;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get notes;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
