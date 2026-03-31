import 'package:dio/dio.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final Dio _dio;

  TaskRemoteDataSource(this._dio);

  /// GET /api/tasks
  Future<List<TaskModel>> getTasks() async {
    final response = await _dio.get('/tasks');
    final data = response.data['data'] as List? ?? [];
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  /// POST /api/tasks
  Future<TaskModel> createTask({
    required String taskName,
    String? taskDesc,
  }) async {
    final response = await _dio.post(
      '/tasks',
      data: {
        'task_name': taskName,
        if (taskDesc != null && taskDesc.isNotEmpty) 'task_desc': taskDesc,
      },
    );
    return TaskModel.fromJson(response.data['data'] ?? {});
  }

  /// PUT /api/tasks/:id
  Future<TaskModel> updateTask({
    required String taskId,
    required String taskName,
    String? taskDesc,
  }) async {
    final response = await _dio.put(
      '/tasks/$taskId',
      data: {
        'task_name': taskName,
        if (taskDesc != null && taskDesc.isNotEmpty) 'task_desc': taskDesc,
      },
    );
    return TaskModel.fromJson(response.data['data'] ?? {});
  }

  /// DELETE /api/tasks/:id
  Future<void> deleteTask(String taskId) async {
    await _dio.delete('/tasks/$taskId');
  }
}
