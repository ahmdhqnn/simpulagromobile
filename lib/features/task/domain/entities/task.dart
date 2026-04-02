import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

/// Task entity representing a farming task
@freezed
class Task with _$Task {
  const Task._();

  const factory Task({
    required String taskId,
    String? siteId,
    String? siteName,
    String? plantId,
    String? plantName,
    required String taskName,
    String? taskDescription,
    required TaskType taskType,
    required TaskStatus taskStatus,
    required TaskPriority taskPriority,
    DateTime? taskDueDate,
    DateTime? taskCompletedDate,
    String? assignedTo,
    String? assignedToName,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) = _Task;

  /// Check if task is overdue
  bool get isOverdue {
    if (taskStatus == TaskStatus.completed) return false;
    if (taskDueDate == null) return false;
    return DateTime.now().isAfter(taskDueDate!);
  }

  /// Check if task is due soon (within 24 hours)
  bool get isDueSoon {
    if (taskStatus == TaskStatus.completed) return false;
    if (taskDueDate == null) return false;
    final now = DateTime.now();
    final diff = taskDueDate!.difference(now);
    return diff.inHours <= 24 && diff.inHours > 0;
  }

  /// Get status color
  String get statusColor {
    switch (taskStatus) {
      case TaskStatus.pending:
        return '#FFA726'; // Orange
      case TaskStatus.inProgress:
        return '#42A5F5'; // Blue
      case TaskStatus.completed:
        return '#66BB6A'; // Green
      case TaskStatus.cancelled:
        return '#EF5350'; // Red
    }
  }

  /// Get priority color
  String get priorityColor {
    switch (taskPriority) {
      case TaskPriority.low:
        return '#66BB6A'; // Green
      case TaskPriority.medium:
        return '#FFA726'; // Orange
      case TaskPriority.high:
        return '#EF5350'; // Red
      case TaskPriority.urgent:
        return '#D32F2F'; // Dark Red
    }
  }
}

/// Task type enum
enum TaskType {
  planting,
  watering,
  fertilizing,
  pestControl,
  harvesting,
  monitoring,
  maintenance,
  other;

  String get label {
    switch (this) {
      case TaskType.planting:
        return 'Penanaman';
      case TaskType.watering:
        return 'Penyiraman';
      case TaskType.fertilizing:
        return 'Pemupukan';
      case TaskType.pestControl:
        return 'Pengendalian Hama';
      case TaskType.harvesting:
        return 'Panen';
      case TaskType.monitoring:
        return 'Monitoring';
      case TaskType.maintenance:
        return 'Perawatan';
      case TaskType.other:
        return 'Lainnya';
    }
  }
}

/// Task status enum
enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Menunggu';
      case TaskStatus.inProgress:
        return 'Sedang Dikerjakan';
      case TaskStatus.completed:
        return 'Selesai';
      case TaskStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}

/// Task priority enum
enum TaskPriority {
  low,
  medium,
  high,
  urgent;

  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Rendah';
      case TaskPriority.medium:
        return 'Sedang';
      case TaskPriority.high:
        return 'Tinggi';
      case TaskPriority.urgent:
        return 'Mendesak';
    }
  }
}
