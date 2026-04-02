import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

/// Task datasource provider
final taskDatasourceProvider = Provider<TaskRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TaskRemoteDatasourceImpl(dioClient.dio);
});

/// Task repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final datasource = ref.watch(taskDatasourceProvider);
  return TaskRepositoryImpl(datasource);
});

/// Task list provider
final taskListProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final result = await repository.getTasks();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (tasks) => List<Task>.from(tasks),
  );
});

/// Tasks by site provider
final tasksBySiteProvider = FutureProvider.family<List<Task>, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(taskRepositoryProvider);
  final result = await repository.getTasksBySite(siteId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (tasks) => List<Task>.from(tasks),
  );
});

/// Task detail provider
final taskDetailProvider = FutureProvider.family<Task, String>((
  ref,
  taskId,
) async {
  final repository = ref.watch(taskRepositoryProvider);
  final result = await repository.getTaskById(taskId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (task) => task,
  );
});

/// Task filter provider
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

/// Filtered tasks provider
final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasksAsync.whenData((tasks) {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.pending:
        return tasks.where((t) => t.taskStatus == TaskStatus.pending).toList();
      case TaskFilter.inProgress:
        return tasks
            .where((t) => t.taskStatus == TaskStatus.inProgress)
            .toList();
      case TaskFilter.completed:
        return tasks
            .where((t) => t.taskStatus == TaskStatus.completed)
            .toList();
      case TaskFilter.overdue:
        return tasks.where((t) => t.isOverdue).toList();
      case TaskFilter.dueSoon:
        return tasks.where((t) => t.isDueSoon).toList();
    }
  });
});

/// Task statistics provider
final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.when(
    data: (tasks) {
      final total = tasks.length;
      final pending = tasks
          .where((t) => t.taskStatus == TaskStatus.pending)
          .length;
      final inProgress = tasks
          .where((t) => t.taskStatus == TaskStatus.inProgress)
          .length;
      final completed = tasks
          .where((t) => t.taskStatus == TaskStatus.completed)
          .length;
      final overdue = tasks.where((t) => t.isOverdue).length;
      final dueSoon = tasks.where((t) => t.isDueSoon).length;

      return TaskStats(
        total: total,
        pending: pending,
        inProgress: inProgress,
        completed: completed,
        overdue: overdue,
        dueSoon: dueSoon,
      );
    },
    loading: () => const TaskStats(),
    error: (_, __) => const TaskStats(),
  );
});

/// Task filter enum
enum TaskFilter {
  all,
  pending,
  inProgress,
  completed,
  overdue,
  dueSoon;

  String get label {
    switch (this) {
      case TaskFilter.all:
        return 'Semua';
      case TaskFilter.pending:
        return 'Menunggu';
      case TaskFilter.inProgress:
        return 'Dikerjakan';
      case TaskFilter.completed:
        return 'Selesai';
      case TaskFilter.overdue:
        return 'Terlambat';
      case TaskFilter.dueSoon:
        return 'Segera';
    }
  }
}

/// Task statistics model
class TaskStats {
  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final int overdue;
  final int dueSoon;

  const TaskStats({
    this.total = 0,
    this.pending = 0,
    this.inProgress = 0,
    this.completed = 0,
    this.overdue = 0,
    this.dueSoon = 0,
  });

  double get completionRate {
    if (total == 0) return 0;
    return (completed / total) * 100;
  }
}
