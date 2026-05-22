import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDatasource remoteDatasource;

  TaskRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Task>>> getTasks(
    String siteId, {
    TaskType? type,
    TaskStatus? status,
    TaskPriority? priority,
  }) async {
    try {
      final tasks = await remoteDatasource.getTasks(
        siteId,
        taskType: type?.apiValue,
        taskStatus: status?.apiValue,
        taskPriority: priority?.apiValue,
      );
      return Right(tasks.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(
    String siteId,
    String taskId,
  ) async {
    try {
      final task = await remoteDatasource.getTaskById(siteId, taskId);
      return Right(task.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(String siteId, Task task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final created = await remoteDatasource.createTask(siteId, model);
      return Right(created.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(
    String siteId,
    String taskId,
    Map<String, dynamic> changes,
  ) async {
    try {
      final updated = await remoteDatasource.updateTask(
        siteId,
        taskId,
        changes,
      );
      return Right(updated.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTaskStatus(
    String siteId,
    String taskId,
    TaskStatus status,
  ) {
    return updateTask(siteId, taskId, {'task_sts': status.apiValue});
  }

  @override
  Future<Either<Failure, Task>> completeTask(String siteId, String taskId) {
    return updateTaskStatus(siteId, taskId, TaskStatus.complite);
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String siteId, String taskId) async {
    try {
      await remoteDatasource.deleteTask(siteId, taskId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
