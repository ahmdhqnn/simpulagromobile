import '../../domain/entities/task.dart';

/// Pure data-class model for the Task feature.
///
/// Maps directly to the JSON wire format used by `/sites/{siteId}/tasks`.
/// No code generation — fully manual to keep the integration explicit.
class TaskModel {
  final String taskId;
  final String? siteId;
  final String taskName;
  final String? taskDescription;
  final String? taskType;
  final String? taskStatus;
  final String? taskPriority;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const TaskModel({
    required this.taskId,
    this.siteId,
    required this.taskName,
    this.taskDescription,
    this.taskType,
    this.taskStatus,
    this.taskPriority,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: (json['task_id'] ?? '').toString(),
      siteId: json['site_id']?.toString(),
      taskName: (json['task_name'] ?? '').toString(),
      taskDescription: json['task_desc']?.toString(),
      taskType: json['task_type']?.toString(),
      taskStatus: json['task_sts']?.toString(),
      taskPriority: json['task_priority']?.toString(),
      createdAt: _parseDate(json['task_created']),
      updatedAt: _parseDate(json['task_update']),
      completedAt: _parseDate(json['task_complited_date']),
    );
  }

  /// Convert to entity (parses enum strings into typed values).
  Task toEntity() {
    return Task(
      taskId: taskId,
      siteId: siteId,
      taskName: taskName,
      taskDescription: taskDescription,
      taskType: TaskType.fromApi(taskType),
      taskStatus: TaskStatus.fromApi(taskStatus),
      taskPriority: TaskPriority.fromApi(taskPriority),
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      taskId: task.taskId,
      siteId: task.siteId,
      taskName: task.taskName,
      taskDescription: task.taskDescription,
      taskType: task.taskType.apiValue,
      taskStatus: task.taskStatus.apiValue,
      taskPriority: task.taskPriority.apiValue,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      completedAt: task.completedAt,
    );
  }

  Map<String, dynamic> toCreateRequestBody() {
    final body = <String, dynamic>{'task_name': taskName};
    if (taskDescription != null && taskDescription!.isNotEmpty) {
      body['task_desc'] = taskDescription;
    }
    if (taskType != null) body['task_type'] = taskType;
    if (taskStatus != null) body['task_sts'] = taskStatus;
    if (taskPriority != null) body['task_priority'] = taskPriority;
    return body;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final s = value.toString();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }
}
