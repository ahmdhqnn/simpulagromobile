class Task {
  final String taskId;
  final String? userId;
  final String? taskName;
  final String? taskDesc;
  final DateTime? taskCreated;
  final DateTime? taskUpdate;

  const Task({
    required this.taskId,
    this.userId,
    this.taskName,
    this.taskDesc,
    this.taskCreated,
    this.taskUpdate,
  });
}
