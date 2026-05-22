import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/plant.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_remote_datasource.dart';
import '../models/plant_model.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDataSource remoteDataSource;

  PlantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Plant>>> getPlants(String siteId) async {
    try {
      final models = await remoteDataSource.getPlants(siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId) async {
    try {
      final model = await remoteDataSource.getPlantById(siteId, plantId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> createPlant(String siteId, Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.createPlant(siteId, data);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> updatePlant(String siteId, String plantId, Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.updatePlant(siteId, plantId, data);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Plant>> harvestPlant(String siteId, String plantId) async {
    try {
      final model = await remoteDataSource.harvestPlant(siteId, plantId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VarietasModel>>> getVarietas() async {
    try {
      final models = await remoteDataSource.getVarietas();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VarietasModel>> getVarietasById(String varietasId) async {
    try {
      final model = await remoteDataSource.getVarietasById(varietasId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
