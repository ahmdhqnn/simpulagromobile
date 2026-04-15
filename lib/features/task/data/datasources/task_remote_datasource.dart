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
      // Note: Backend API endpoint for creating tasks is not yet implemented
      // According to API documentation, only GET /api/tasks is available
      // This will return 404 error until backend adds POST /api/tasks endpoint

      final response = await _dio.post(
        '/tasks',
        data: {
          'task_name': task.taskName,
          'task_desc': task.taskDescription,
          'user_id': task.userId,
          // Extended fields (if backend supports them)
          if (task.siteId != null) 'site_id': task.siteId,
          if (task.plantId != null) 'plant_id': task.plantId,
          if (task.taskType != null) 'task_type': task.taskType,
          if (task.taskStatus != null) 'task_status': task.taskStatus,
          if (task.taskPriority != null) 'task_priority': task.taskPriority,
          if (task.taskDueDate != null)
            'task_due_date': task.taskDueDate!.toIso8601String(),
          if (task.assignedTo != null) 'assigned_to': task.assignedTo,
          if (task.notes != null) 'notes': task.notes,
        },
      );

      if (response.data['status'] == 201 && response.data['data'] != null) {
        return TaskModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to create task');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception(
          'Endpoint untuk membuat task belum tersedia di backend. '
          'Silakan hubungi backend developer untuk menambahkan endpoint POST /api/tasks',
        );
      }
      throw Exception('Failed to create task: ${e.message}');
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
