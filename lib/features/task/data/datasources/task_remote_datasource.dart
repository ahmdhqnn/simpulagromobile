import 'package:dio/dio.dart';
import '../models/task_model.dart';

/// Task remote datasource
abstract class TaskRemoteDatasource {
  Future<List<TaskModel>> getTasks();
  Future<List<TaskModel>> getTasksBySite(String siteId);
  Future<TaskModel> getTaskById(String taskId);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<TaskModel> updateTaskStatus(String taskId, String status);
}

/// Task remote datasource implementation
class TaskRemoteDatasourceImpl implements TaskRemoteDatasource {
  // ignore: unused_field
  final Dio _dio;

  TaskRemoteDatasourceImpl(this._dio);

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');

      if (response.data['status'] == 200 && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'] as List;
        return data
            .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<List<TaskModel>> getTasksBySite(String siteId) async {
    try {
      final response = await _dio.get(
        '/tasks',
        queryParameters: {'site_id': siteId},
      );

      if (response.data['status'] == 200 && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'] as List;
        return data
            .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch tasks by site: $e');
    }
  }

  @override
  Future<TaskModel> getTaskById(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId');

      if (response.data['status'] == 200 && response.data['data'] != null) {
        return TaskModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }

      throw Exception('Task not found');
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _dio.post('/tasks', data: task.toJson());

      if (response.data['status'] == 201 && response.data['data'] != null) {
        return TaskModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to create task');
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _dio.put(
        '/tasks/${task.taskId}',
        data: task.toJson(),
      );

      if (response.data['status'] == 200 && response.data['data'] != null) {
        return TaskModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to update task');
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _dio.delete('/tasks/$taskId');
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<TaskModel> updateTaskStatus(String taskId, String status) async {
    try {
      final response = await _dio.patch(
        '/tasks/$taskId/status',
        data: {'status': status},
      );

      if (response.data['status'] == 200 && response.data['data'] != null) {
        return TaskModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to update task status');
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }
}
