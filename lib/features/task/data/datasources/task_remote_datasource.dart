import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDatasource {
  Future<List<TaskModel>> getTasks(
    String siteId, {
    String? taskType,
    String? taskStatus,
    String? taskPriority,
  });

  Future<TaskModel> getTaskById(String siteId, String taskId);

  Future<TaskModel> createTask(String siteId, TaskModel task);

  Future<TaskModel> updateTask(
    String siteId,
    String taskId,
    Map<String, dynamic> changes,
  );

  Future<void> deleteTask(String siteId, String taskId);
}

class TaskRemoteDatasourceImpl implements TaskRemoteDatasource {
  final Dio _dio;

  TaskRemoteDatasourceImpl(this._dio);

  @override
  Future<List<TaskModel>> getTasks(
    String siteId, {
    String? taskType,
    String? taskStatus,
    String? taskPriority,
  }) async {
    try {
      final endpoint = ApiEndpoints.tasksBySite(siteId);
      final query = <String, dynamic>{
        if (taskType != null) 'task_type': taskType,
        if (taskStatus != null) 'task_sts': taskStatus,
        if (taskPriority != null) 'task_priority': taskPriority,
      };

      final response = await _dio.get(
        endpoint,
        queryParameters: query.isEmpty ? null : query,
      );

      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map(TaskModel.fromJson)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e, 'Gagal memuat task'));
    }
  }

  @override
  Future<TaskModel> getTaskById(String siteId, String taskId) async {
    try {
      final endpoint = ApiEndpoints.taskBySiteAndId(siteId, taskId);
      final response = await _dio.get(endpoint);

      final data = response.data;
      if (data is Map && data['data'] is Map<String, dynamic>) {
        return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ServerException('Task tidak ditemukan');
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e, 'Gagal memuat detail task'));
    }
  }

  @override
  Future<TaskModel> createTask(String siteId, TaskModel task) async {
    try {
      final endpoint = ApiEndpoints.tasksBySite(siteId);
      final body = task.toCreateRequestBody();

      final response = await _dio.post(endpoint, data: body);

      final data = response.data;
      if (data is Map && data['data'] is Map<String, dynamic>) {
        return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ServerException('Gagal membuat task: respons tidak valid');
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e, 'Gagal membuat task'));
    }
  }

  @override
  Future<TaskModel> updateTask(
    String siteId,
    String taskId,
    Map<String, dynamic> changes,
  ) async {
    try {
      final endpoint = ApiEndpoints.taskBySiteAndId(siteId, taskId);
      final body = _toApiBody(changes);

      final response = await _dio.put(endpoint, data: body);

      final data = response.data;
      if (data is Map && data['data'] is Map<String, dynamic>) {
        return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ServerException(
        'Gagal memperbarui task: respons tidak valid',
      );
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e, 'Gagal memperbarui task'));
    }
  }

  @override
  Future<void> deleteTask(String siteId, String taskId) async {
    try {
      final endpoint = ApiEndpoints.taskBySiteAndId(siteId, taskId);
      await _dio.delete(endpoint);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e, 'Gagal menghapus task'));
    }
  }

  Map<String, dynamic> _toApiBody(Map<String, dynamic> changes) {
    final body = <String, dynamic>{};
    for (final entry in changes.entries) {
      final key = entry.key;
      final value = entry.value;
      switch (key) {
        case 'task_status':
          body['task_sts'] = value;
          break;
        case 'task_completed_date':
          body['task_complited_date'] = value;
          break;
        default:
          body[key] = value;
      }
    }
    return body;
  }

  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return e.message ?? fallback;
  }
}
