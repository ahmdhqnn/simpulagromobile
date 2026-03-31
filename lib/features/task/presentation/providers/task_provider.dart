import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/models/task_model.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TaskRemoteDataSource(dioClient.dio);
});

/// All tasks
final tasksProvider = FutureProvider.autoDispose<List<TaskModel>>((ref) async {
  final ds = ref.watch(taskRemoteDataSourceProvider);
  return ds.getTasks();
});

/// Search/filter query
final taskSearchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered tasks based on search query
final filteredTasksProvider = Provider.autoDispose<AsyncValue<List<TaskModel>>>(
  (ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final query = ref.watch(taskSearchQueryProvider).toLowerCase().trim();

    return tasksAsync.whenData((tasks) {
      if (query.isEmpty) return tasks;
      return tasks
          .where(
            (t) =>
                (t.taskName?.toLowerCase().contains(query) ?? false) ||
                (t.taskDesc?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    });
  },
);

// ─── Mutation State ─────────────────────────────────────
class TaskMutationState {
  final bool isLoading;
  final String? error;

  const TaskMutationState({this.isLoading = false, this.error});

  TaskMutationState copyWith({bool? isLoading, String? error}) =>
      TaskMutationState(isLoading: isLoading ?? this.isLoading, error: error);
}

class TaskMutationNotifier extends StateNotifier<TaskMutationState> {
  final TaskRemoteDataSource _ds;
  final Ref _ref;

  TaskMutationNotifier(this._ds, this._ref) : super(const TaskMutationState());

  Future<bool> createTask({required String taskName, String? taskDesc}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _ds.createTask(taskName: taskName, taskDesc: taskDesc);
      _ref.invalidate(tasksProvider);
      state = const TaskMutationState();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateTask({
    required String taskId,
    required String taskName,
    String? taskDesc,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _ds.updateTask(
        taskId: taskId,
        taskName: taskName,
        taskDesc: taskDesc,
      );
      _ref.invalidate(tasksProvider);
      state = const TaskMutationState();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _ds.deleteTask(taskId);
      _ref.invalidate(tasksProvider);
      state = const TaskMutationState();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() => state = const TaskMutationState();
}

final taskMutationProvider =
    StateNotifierProvider<TaskMutationNotifier, TaskMutationState>((ref) {
      final ds = ref.watch(taskRemoteDataSourceProvider);
      return TaskMutationNotifier(ds, ref);
    });
