import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

// ─── DataSource & Repository ────────────────────────────────────────────────
final taskDatasourceProvider = Provider<TaskRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TaskRemoteDatasourceImpl(dioClient.dio);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final datasource = ref.watch(taskDatasourceProvider);
  return TaskRepositoryImpl(datasource);
});

// ─── Task List ──────────────────────────────────────────────────────────────
/// Tasks for the currently selected site.
/// API: GET /sites/{siteId}/tasks
final taskListProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final siteId = ref.watch(selectedSiteIdProvider);

  if (siteId == null) {
    throw Exception('Pilih site terlebih dahulu');
  }

  return await ref.retryOnError(() async {
    final result = await repository.getTasks(siteId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (tasks) => tasks,
    );
  });
});

/// Tasks scoped to a specific siteId — for callers that already know the site.
final tasksBySiteProvider = FutureProvider.family<List<Task>, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getTasks(siteId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (tasks) => tasks,
    );
  });
});

// ─── Task Detail ────────────────────────────────────────────────────────────
/// Get task detail for a specific site + task id.
/// API: GET /sites/{siteId}/tasks/{id}
final taskDetailProvider = FutureProvider.family<Task, (String, String)>((
  ref,
  params,
) async {
  final repository = ref.watch(taskRepositoryProvider);
  final (siteId, taskId) = params;

  return await ref.retryOnError(() async {
    final result = await repository.getTaskById(siteId, taskId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (task) => task,
    );
  });
});

/// Backward-compat helper: resolves siteId from the selected site.
final taskDetailByIdProvider = FutureProvider.family<Task, String>((
  ref,
  taskId,
) async {
  final repository = ref.watch(taskRepositoryProvider);
  final siteId = ref.watch(selectedSiteIdProvider);

  if (siteId == null) {
    throw Exception('Pilih site terlebih dahulu');
  }

  return await ref.retryOnError(() async {
    final result = await repository.getTaskById(siteId, taskId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (task) => task,
    );
  });
});

// ─── Filter ─────────────────────────────────────────────────────────────────
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

/// Filtered list applied client-side over [taskListProvider].
final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasksAsync.whenData((tasks) {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.pending:
        return tasks.where((t) => t.taskStatus == TaskStatus.pending).toList();
      case TaskFilter.progress:
        return tasks.where((t) => t.taskStatus == TaskStatus.progress).toList();
      case TaskFilter.complite:
        return tasks.where((t) => t.taskStatus == TaskStatus.complite).toList();
      case TaskFilter.failed:
        return tasks.where((t) => t.taskStatus == TaskStatus.failed).toList();
    }
  });
});

// ─── Stats ──────────────────────────────────────────────────────────────────
final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.when(
    data: (tasks) {
      final total = tasks.length;
      final pending = tasks
          .where((t) => t.taskStatus == TaskStatus.pending)
          .length;
      final progress = tasks
          .where((t) => t.taskStatus == TaskStatus.progress)
          .length;
      final complite = tasks
          .where((t) => t.taskStatus == TaskStatus.complite)
          .length;
      final failed = tasks
          .where((t) => t.taskStatus == TaskStatus.failed)
          .length;

      return TaskStats(
        total: total,
        pending: pending,
        progress: progress,
        complite: complite,
        failed: failed,
      );
    },
    loading: () => const TaskStats(),
    error: (_, __) => const TaskStats(),
  );
});

// ─── Form Notifier ──────────────────────────────────────────────────────────
class TaskFormState {
  final bool isLoading;
  final String? error;
  final Task? savedTask;

  const TaskFormState({this.isLoading = false, this.error, this.savedTask});

  TaskFormState copyWith({bool? isLoading, String? error, Task? savedTask}) {
    return TaskFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedTask: savedTask ?? this.savedTask,
    );
  }
}

class TaskFormNotifier extends StateNotifier<TaskFormState> {
  final TaskRepository _repository;
  final Ref _ref;

  TaskFormNotifier(this._repository, this._ref) : super(const TaskFormState());

  Future<bool> createTask(String siteId, Task task) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.createTask(siteId, task);
    return result.fold(
      (failure) {
        state = TaskFormState(error: failure.message);
        return false;
      },
      (saved) async {
        await refreshTaskCache(_ref, siteId: siteId);
        state = TaskFormState(savedTask: saved);
        return true;
      },
    );
  }

  Future<bool> updateTask(
    String siteId,
    String taskId,
    Map<String, dynamic> changes,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.updateTask(siteId, taskId, changes);
    return result.fold(
      (failure) {
        state = TaskFormState(error: failure.message);
        return false;
      },
      (saved) async {
        await refreshTaskCache(_ref, siteId: siteId, taskId: taskId);
        state = TaskFormState(savedTask: saved);
        return true;
      },
    );
  }

  void reset() => state = const TaskFormState();
}

final taskFormProvider = StateNotifierProvider<TaskFormNotifier, TaskFormState>(
  (ref) {
    final repository = ref.watch(taskRepositoryProvider);
    return TaskFormNotifier(repository, ref);
  },
);

// ─── Filter & Stats models ──────────────────────────────────────────────────
enum TaskFilter {
  all('Semua'),
  pending('Menunggu'),
  progress('Dikerjakan'),
  complite('Selesai'),
  failed('Gagal');

  final String label;
  const TaskFilter(this.label);
}

class TaskStats {
  final int total;
  final int pending;
  final int progress;
  final int complite;
  final int failed;

  const TaskStats({
    this.total = 0,
    this.pending = 0,
    this.progress = 0,
    this.complite = 0,
    this.failed = 0,
  });

  /// Convenience aliases — keep the dashboard widgets simple.
  int get inProgress => progress;
  int get completed => complite;
  int get cancelled => failed;

  double get completionRate {
    if (total == 0) return 0;
    return (complite / total) * 100;
  }
}

// ─── Cache refresh helper ───────────────────────────────────────────────────
/// Invalidate every provider that holds task data for a given site/task and
/// wait for the new fetches to complete.
///
/// Call this after any successful mutation (create/update/delete/status) so
/// every dependent screen (list, detail, dashboard stats) is up-to-date
/// before navigation transitions complete. This prevents the stale-data
/// flicker users would otherwise see when popping back to the detail/list
/// screen.
Future<void> refreshTaskCache(
  dynamic ref, {
  required String siteId,
  String? taskId,
}) async {
  if (ref is Ref) {
    ref.invalidate(taskListProvider);
    ref.invalidate(tasksBySiteProvider(siteId));
    if (taskId != null) {
      ref.invalidate(taskDetailProvider((siteId, taskId)));
      ref.invalidate(taskDetailByIdProvider(taskId));
    }
  } else if (ref is WidgetRef) {
    ref.invalidate(taskListProvider);
    ref.invalidate(tasksBySiteProvider(siteId));
    if (taskId != null) {
      ref.invalidate(taskDetailProvider((siteId, taskId)));
      ref.invalidate(taskDetailByIdProvider(taskId));
    }
  } else {
    throw ArgumentError('ref must be either Ref or WidgetRef');
  }

  // Await the new fetches so callers see fresh data on the next build.
  // Errors are intentionally swallowed here — they surface through the
  // provider's normal error state on the watching widget.
  final futures = <Future<Object?>>[
    _safe(ref.read(taskListProvider.future)),
    if (taskId != null)
      _safe(ref.read(taskDetailProvider((siteId, taskId)).future)),
  ];
  await Future.wait(futures);
}

Future<Object?> _safe(Future<Object?> future) async {
  try {
    return await future;
  } catch (_) {
    return null;
  }
}
