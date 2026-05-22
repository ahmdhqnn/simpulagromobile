import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/plant.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_remote_datasource.dart';
import '../models/plant_model.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDatasource remoteDatasource;

  PlantRepositoryImpl(this.remoteDatasource);

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timeout');
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('No internet connection');
    }
    final statusCode = e.response?.statusCode;
    String message = 'Unknown error';
    if (e.response?.data is Map) {
      message = e.response?.data['message'] ?? e.message ?? 'Unknown error';
    } else {
      message = e.message ?? 'Unknown error';
    }

    switch (statusCode) {
      case 401: return AuthFailure(message);
      case 403: return PermissionFailure(message);
      case 404: return NotFoundFailure(message);
      case 409: return ValidationFailure(message);
      default: return ServerFailure(message, statusCode: statusCode);
    }
  }

  @override
  Future<Either<Failure, List<Plant>>> getPlantsBySite(String siteId) async {
    try {
      final models = await remoteDatasource.getPlantsBySite(siteId);
      return Right(models.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId) async {
    try {
      final model = await remoteDatasource.getPlantById(siteId, plantId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> createPlant(String siteId, Plant plant) async {
    try {
      final model = PlantModel.fromEntity(plant);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'plant_created' ||
            key == 'plant_update' ||
            key == 'plant_harvest',
      );

      final createdModel = await remoteDatasource.createPlant(siteId, data);
      return Right(createdModel.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> updatePlant(String siteId, String plantId, Plant plant) async {
    try {
      final model = PlantModel.fromEntity(plant);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'plant_id' ||
            key == 'plant_created' ||
            key == 'plant_update' ||
            key == 'plant_harvest',
      );

      final updatedModel = await remoteDatasource.updatePlant(
        siteId,
        plantId,
        data,
      );
      return Right(updatedModel.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> harvestPlant(String siteId, String plantId) async {
    try {
      final harvestedModel = await remoteDatasource.harvestPlant(
        siteId,
        plantId,
      );
      return Right(harvestedModel.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlant(String siteId, String plantId) async {
    try {
      await remoteDatasource.deletePlant(siteId, plantId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
