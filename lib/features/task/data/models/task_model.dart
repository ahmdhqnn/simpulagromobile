// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Task model for data layer
@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    @JsonKey(name: 'task_id') required String taskId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'plant_id') String? plantId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'task_name') required String taskName,
    @JsonKey(name: 'task_description') String? taskDescription,
    @JsonKey(name: 'task_type') required String taskType,
    @JsonKey(name: 'task_status') required String taskStatus,
    @JsonKey(name: 'task_priority') required String taskPriority,
    @JsonKey(name: 'task_due_date') DateTime? taskDueDate,
    @JsonKey(name: 'task_completed_date') DateTime? taskCompletedDate,
    @JsonKey(name: 'assigned_to') String? assignedTo,
    @JsonKey(name: 'assigned_to_name') String? assignedToName,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'notes') String? notes,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  /// Convert model to entity
  Task toEntity() {
    return Task(
      taskId: taskId,
      siteId: siteId,
      siteName: siteName,
      plantId: plantId,
      plantName: plantName,
      taskName: taskName,
      taskDescription: taskDescription,
      taskType: _parseTaskType(taskType),
      taskStatus: _parseTaskStatus(taskStatus),
      taskPriority: _parseTaskPriority(taskPriority),
      taskDueDate: taskDueDate,
      taskCompletedDate: taskCompletedDate,
      assignedTo: assignedTo,
      assignedToName: assignedToName,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      notes: notes,
    );
  }

  /// Create model from entity
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      taskId: task.taskId,
      siteId: task.siteId,
      siteName: task.siteName,
      plantId: task.plantId,
      plantName: task.plantName,
      taskName: task.taskName,
      taskDescription: task.taskDescription,
      taskType: task.taskType.name,
      taskStatus: task.taskStatus.name,
      taskPriority: task.taskPriority.name,
      taskDueDate: task.taskDueDate,
      taskCompletedDate: task.taskCompletedDate,
      assignedTo: task.assignedTo,
      assignedToName: task.assignedToName,
      createdBy: task.createdBy,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      notes: task.notes,
    );
  }

  static TaskType _parseTaskType(String type) {
    return TaskType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => TaskType.other,
    );
  }

  static TaskStatus _parseTaskStatus(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TaskStatus.pending,
    );
  }

  static TaskPriority _parseTaskPriority(String priority) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == priority,
      orElse: () => TaskPriority.medium,
    );
  }
}
