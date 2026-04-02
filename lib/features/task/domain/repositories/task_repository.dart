import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/task.dart';

/// Task repository interface
abstract class TaskRepository {
  /// Get all tasks
  Future<Either<Failure, List<Task>>> getTasks();

  /// Get tasks by site
  Future<Either<Failure, List<Task>>> getTasksBySite(String siteId);

  /// Get task by ID
  Future<Either<Failure, Task>> getTaskById(String taskId);

  /// Create new task
  Future<Either<Failure, Task>> createTask(Task task);

  /// Update existing task
  Future<Either<Failure, Task>> updateTask(Task task);

  /// Delete task
  Future<Either<Failure, void>> deleteTask(String taskId);

  /// Update task status
  Future<Either<Failure, Task>> updateTaskStatus(
    String taskId,
    TaskStatus status,
  );

  /// Complete task
  Future<Either<Failure, Task>> completeTask(String taskId);
}
