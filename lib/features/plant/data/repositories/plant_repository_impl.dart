import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/plant.dart';
import '../../domain/entities/varietas.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_remote_datasource.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDataSource remoteDataSource;

  PlantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Plant>>> getPlants(String siteId) async {
    try {
      final models = await remoteDataSource.getPlants(siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Plant>> getPlantById(
    String siteId,
    String plantId,
  ) async {
    try {
      final model = await remoteDataSource.getPlantById(siteId, plantId);
      return Right(model.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Plant>> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await remoteDataSource.createPlant(siteId, data);
      return Right(model.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Plant>> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await remoteDataSource.updatePlant(siteId, plantId, data);
      return Right(model.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> harvestPlant(
    String siteId,
    String plantId,
  ) async {
    try {
      await remoteDataSource.harvestPlant(siteId, plantId);
      return const Right(null);
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlant(
    String siteId,
    String plantId,
  ) async {
    try {
      await remoteDataSource.deletePlant(siteId, plantId);
      return const Right(null);
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Varietas>>> getVarietas() async {
    try {
      final models = await remoteDataSource.getVarietas();
      return Right(models.map((m) => m.toEntity()).toList());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Varietas>> getVarietasById(String varietasId) async {
    try {
      final model = await remoteDataSource.getVarietasById(varietasId);
      return Right(model.toEntity());
    } on UnsupportedBackendEndpointException catch (e) {
      return Left(UnsupportedBackendEndpointFailure(e.message));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
