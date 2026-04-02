import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

/// Task repository implementation
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDatasource remoteDatasource;

  TaskRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await remoteDatasource.getTasks();
      return Right(tasks.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksBySite(String siteId) async {
    try {
      final tasks = await remoteDatasource.getTasksBySite(siteId);
      return Right(tasks.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(String taskId) async {
    try {
      final task = await remoteDatasource.getTaskById(taskId);
      return Right(task.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final created = await remoteDatasource.createTask(model);
      return Right(created.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final updated = await remoteDatasource.updateTask(model);
      return Right(updated.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await remoteDatasource.deleteTask(taskId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTaskStatus(
    String taskId,
    TaskStatus status,
  ) async {
    try {
      final updated = await remoteDatasource.updateTaskStatus(
        taskId,
        status.name,
      );
      return Right(updated.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> completeTask(String taskId) async {
    return updateTaskStatus(taskId, TaskStatus.completed);
  }
}
