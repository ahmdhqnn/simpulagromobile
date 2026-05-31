import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/plant.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_remote_datasource.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDatasource remoteDatasource;

  PlantRepositoryImpl(this.remoteDatasource);

  String? _formatPlantDate(DateTime? value) {
    if (value == null) return null;

    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String? _cropTypeToApi(CropType? value) {
    return switch (value) {
      CropType.padi => 'PADI',
      CropType.jagung => 'JAGUNG',
      CropType.kedelai => 'KEDELAI',
      null => null,
    };
  }

  Map<String, dynamic> _toMutationData(Plant plant) {
    final data = <String, dynamic>{
      'plant_name': plant.plantName?.trim(),
      'varietas_id': plant.varietasId?.trim(),
      'plant_type': _cropTypeToApi(plant.plantType),
      'plant_date': _formatPlantDate(plant.plantDate),
    };

    data.removeWhere(
      (_, value) => value == null || (value is String && value.trim().isEmpty),
    );
    return data;
  }

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
      case 401:
        return AuthFailure(message);
      case 403:
        return PermissionFailure(message);
      case 404:
        return NotFoundFailure(message);
      case 409:
        return ValidationFailure(message);
      default:
        return ServerFailure(message, statusCode: statusCode);
    }
  }

  @override
  Future<Either<Failure, List<Plant>>> getPlantsBySite(String siteId) async {
    try {
      final models = await remoteDatasource.getPlantsBySite(siteId);
      return Right(models.map((model) => model.toEntity()).toList());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> getPlantById(
    String siteId,
    String plantId,
  ) async {
    try {
      final model = await remoteDatasource.getPlantById(siteId, plantId);
      return Right(model.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> createPlant(String siteId, Plant plant) async {
    try {
      final data = _toMutationData(plant);
      final createdModel = await remoteDatasource.createPlant(siteId, data);
      return Right(createdModel.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> updatePlant(
    String siteId,
    String plantId,
    Plant plant,
  ) async {
    try {
      final data = _toMutationData(plant);
      final updatedModel = await remoteDatasource.updatePlant(
        siteId,
        plantId,
        data,
      );
      return Right(updatedModel.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> harvestPlant(
    String siteId,
    String plantId,
  ) async {
    try {
      final harvestedModel = await remoteDatasource.harvestPlant(
        siteId,
        plantId,
      );
      return Right(harvestedModel.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlant(
    String siteId,
    String plantId,
  ) async {
    try {
      await remoteDatasource.deletePlant(siteId, plantId);
      return const Right(null);
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
