/// Task entity representing a farming task.
///
/// Mirrors the backend contract documented at `/sites/{siteId}/tasks`.
/// Enum values map 1:1 with the API wire values (UPPERCASE).
class Task {
  final String taskId;
  final String? siteId;
  final String taskName;
  final String? taskDescription;
  final TaskType taskType;
  final TaskStatus taskStatus;
  final TaskPriority taskPriority;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const Task({
    required this.taskId,
    this.siteId,
    required this.taskName,
    this.taskDescription,
    required this.taskType,
    required this.taskStatus,
    required this.taskPriority,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  Task copyWith({
    String? taskId,
    String? siteId,
    String? taskName,
    String? taskDescription,
    TaskType? taskType,
    TaskStatus? taskStatus,
    TaskPriority? taskPriority,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      siteId: siteId ?? this.siteId,
      taskName: taskName ?? this.taskName,
      taskDescription: taskDescription ?? this.taskDescription,
      taskType: taskType ?? this.taskType,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: taskPriority ?? this.taskPriority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.taskId == taskId &&
        other.siteId == siteId &&
        other.taskName == taskName &&
        other.taskDescription == taskDescription &&
        other.taskType == taskType &&
        other.taskStatus == taskStatus &&
        other.taskPriority == taskPriority &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    siteId,
    taskName,
    taskDescription,
    taskType,
    taskStatus,
    taskPriority,
    createdAt,
    updatedAt,
    completedAt,
  );
}

/// Task type — must match API enum (UPPERCASE on the wire).
enum TaskType {
  planting('PLANTING', 'Penanaman'),
  fertilizing('FERTILIZING', 'Pemupukan'),
  harvesting('HARVESTING', 'Panen'),
  watering('WATERING', 'Penyiraman'),
  pestControl('PESTCONTROL', 'Pengendalian Hama'),
  monitoring('MONITORING', 'Monitoring'),
  maintenance('MAINTENANCE', 'Perawatan'),
  other('OTHER', 'Lainnya');

  final String apiValue;
  final String label;

  const TaskType(this.apiValue, this.label);

  static TaskType fromApi(String? value) {
    if (value == null) return TaskType.other;
    final upper = value.toUpperCase();
    for (final type in TaskType.values) {
      if (type.apiValue == upper) return type;
    }
    return TaskType.other;
  }
}

/// Task status — must match API enum (UPPERCASE on the wire).
/// Note: backend spelling is intentional: "COMPLITE" and "PROGRESS".
enum TaskStatus {
  pending('PENDING', 'Menunggu'),
  progress('PROGRESS', 'Dikerjakan'),
  complite('COMPLITE', 'Selesai'),
  failed('FAILED', 'Gagal');

  final String apiValue;
  final String label;

  const TaskStatus(this.apiValue, this.label);

  static TaskStatus fromApi(String? value) {
    if (value == null) return TaskStatus.pending;
    final upper = value.toUpperCase();
    for (final s in TaskStatus.values) {
      if (s.apiValue == upper) return s;
    }
    return TaskStatus.pending;
  }
}

enum TaskPriority {
  low('LOW', 'Rendah'),
  medium('MEDIUM', 'Sedang'),
  high('HIGH', 'Tinggi');

  final String apiValue;
  final String label;

  const TaskPriority(this.apiValue, this.label);

  static TaskPriority fromApi(String? value) {
    if (value == null) return TaskPriority.medium;
    final upper = value.toUpperCase();
    for (final p in TaskPriority.values) {
      if (p.apiValue == upper) return p;
    }
    return TaskPriority.medium;
  }
}
