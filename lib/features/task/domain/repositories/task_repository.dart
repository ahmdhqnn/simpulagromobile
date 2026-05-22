import 'package:dartz/dartz.dart' hide Task;
import '../../domain/entities/task.dart';
import '../../../../core/error/failures.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks(
    String siteId, {
    TaskType? type,
    TaskStatus? status,
    TaskPriority? priority,
  });

  Future<Either<Failure, Task>> getTaskById(String siteId, String taskId);

  Future<Either<Failure, Task>> createTask(String siteId, Task task);

  Future<Either<Failure, Task>> updateTask(
    String siteId,
    String taskId,
    Map<String, dynamic> changes,
  );

  Future<Either<Failure, Task>> updateTaskStatus(
    String siteId,
    String taskId,
    TaskStatus status,
  );

  Future<Either<Failure, Task>> completeTask(String siteId, String taskId);

  Future<Either<Failure, Unit>> deleteTask(String siteId, String taskId);
}
