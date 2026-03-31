import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.taskId,
    super.userId,
    super.taskName,
    super.taskDesc,
    super.taskCreated,
    super.taskUpdate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['task_id'] ?? '',
      userId: json['user_id'],
      taskName: json['task_name'],
      taskDesc: json['task_desc'],
      taskCreated: json['task_created'] != null
          ? DateTime.tryParse(json['task_created'])
          : null,
      taskUpdate: json['task_update'] != null
          ? DateTime.tryParse(json['task_update'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'task_name': taskName,
    'task_desc': taskDesc,
  };
}
