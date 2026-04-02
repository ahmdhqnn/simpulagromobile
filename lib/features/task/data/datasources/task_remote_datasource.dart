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
    // TODO: Replace with real API call
    // final response = await _dio.get(ApiEndpoints.tasks);
    // return (response.data['data'] as List)
    //     .map((json) => TaskModel.fromJson(json))
    //     .toList();

    // Mock data for now
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTasks;
  }

  @override
  Future<List<TaskModel>> getTasksBySite(String siteId) async {
    // TODO: Replace with real API call
    // final response = await _dio.get('${ApiEndpoints.tasks}?site_id=$siteId');

    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTasks.where((t) => t.siteId == siteId).toList();
  }

  @override
  Future<TaskModel> getTaskById(String taskId) async {
    // TODO: Replace with real API call
    // final response = await _dio.get('${ApiEndpoints.tasks}/$taskId');
    // return TaskModel.fromJson(response.data['data']);

    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTasks.firstWhere((t) => t.taskId == taskId);
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    // TODO: Replace with real API call
    // final response = await _dio.post(
    //   ApiEndpoints.tasks,
    //   data: task.toJson(),
    // );
    // return TaskModel.fromJson(response.data['data']);

    await Future.delayed(const Duration(milliseconds: 500));
    final newTask = task.copyWith(
      taskId: 'task_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _mockTasks.add(newTask);
    return newTask;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    // TODO: Replace with real API call
    // final response = await _dio.put(
    //   '${ApiEndpoints.tasks}/${task.taskId}',
    //   data: task.toJson(),
    // );
    // return TaskModel.fromJson(response.data['data']);

    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockTasks.indexWhere((t) => t.taskId == task.taskId);
    if (index != -1) {
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      _mockTasks[index] = updatedTask;
      return updatedTask;
    }
    throw Exception('Task not found');
  }

  @override
  Future<void> deleteTask(String taskId) async {
    // TODO: Replace with real API call
    // await _dio.delete('${ApiEndpoints.tasks}/$taskId');

    await Future.delayed(const Duration(milliseconds: 300));
    _mockTasks.removeWhere((t) => t.taskId == taskId);
  }

  @override
  Future<TaskModel> updateTaskStatus(String taskId, String status) async {
    // TODO: Replace with real API call
    // final response = await _dio.patch(
    //   '${ApiEndpoints.tasks}/$taskId/status',
    //   data: {'status': status},
    // );
    // return TaskModel.fromJson(response.data['data']);

    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockTasks.indexWhere((t) => t.taskId == taskId);
    if (index != -1) {
      final updatedTask = _mockTasks[index].copyWith(
        taskStatus: status,
        taskCompletedDate: status == 'completed' ? DateTime.now() : null,
        updatedAt: DateTime.now(),
      );
      _mockTasks[index] = updatedTask;
      return updatedTask;
    }
    throw Exception('Task not found');
  }
}

// Mock data
final List<TaskModel> _mockTasks = [
  TaskModel(
    taskId: 'task_001',
    siteId: 'site_001',
    siteName: 'Lahan Sawah A',
    plantId: 'plant_001',
    plantName: 'Padi IR64',
    taskName: 'Pemupukan NPK Tahap 1',
    taskDescription: 'Pemupukan NPK dengan dosis 200kg/ha',
    taskType: 'fertilizing',
    taskStatus: 'pending',
    taskPriority: 'high',
    taskDueDate: DateTime.now().add(const Duration(days: 2)),
    assignedTo: 'user_001',
    assignedToName: 'Budi Santoso',
    createdBy: 'admin',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    notes: 'Gunakan pupuk NPK 15-15-15',
  ),
  TaskModel(
    taskId: 'task_002',
    siteId: 'site_001',
    siteName: 'Lahan Sawah A',
    plantId: 'plant_001',
    plantName: 'Padi IR64',
    taskName: 'Penyiraman Pagi',
    taskDescription: 'Penyiraman rutin pagi hari',
    taskType: 'watering',
    taskStatus: 'inProgress',
    taskPriority: 'medium',
    taskDueDate: DateTime.now(),
    assignedTo: 'user_002',
    assignedToName: 'Siti Aminah',
    createdBy: 'admin',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  TaskModel(
    taskId: 'task_003',
    siteId: 'site_001',
    siteName: 'Lahan Sawah A',
    plantId: 'plant_001',
    plantName: 'Padi IR64',
    taskName: 'Monitoring Hama',
    taskDescription: 'Cek kondisi tanaman dan keberadaan hama',
    taskType: 'monitoring',
    taskStatus: 'completed',
    taskPriority: 'medium',
    taskDueDate: DateTime.now().subtract(const Duration(days: 1)),
    taskCompletedDate: DateTime.now().subtract(const Duration(hours: 3)),
    assignedTo: 'user_001',
    assignedToName: 'Budi Santoso',
    createdBy: 'admin',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    notes: 'Tidak ditemukan hama yang signifikan',
  ),
  TaskModel(
    taskId: 'task_004',
    siteId: 'site_002',
    siteName: 'Lahan Jagung B',
    plantId: 'plant_002',
    plantName: 'Jagung Hibrida',
    taskName: 'Penyemprotan Pestisida',
    taskDescription: 'Penyemprotan pestisida untuk pengendalian hama',
    taskType: 'pestControl',
    taskStatus: 'pending',
    taskPriority: 'urgent',
    taskDueDate: DateTime.now().add(const Duration(hours: 6)),
    assignedTo: 'user_003',
    assignedToName: 'Ahmad Yani',
    createdBy: 'admin',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    notes: 'Gunakan pestisida organik',
  ),
  TaskModel(
    taskId: 'task_005',
    siteId: 'site_002',
    siteName: 'Lahan Jagung B',
    plantId: 'plant_002',
    plantName: 'Jagung Hibrida',
    taskName: 'Perawatan Drainase',
    taskDescription: 'Membersihkan dan memperbaiki sistem drainase',
    taskType: 'maintenance',
    taskStatus: 'pending',
    taskPriority: 'low',
    taskDueDate: DateTime.now().add(const Duration(days: 5)),
    assignedTo: 'user_002',
    assignedToName: 'Siti Aminah',
    createdBy: 'admin',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
