import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_datasource.dart';

/// Recommendation repository implementation
class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDatasource _remoteDatasource;

  RecommendationRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendations() async {
    try {
      final models = await _remoteDatasource.getRecommendations();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsBySite(
    String siteId,
  ) async {
    try {
      final models = await _remoteDatasource.getRecommendationsBySite(siteId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsByPlant(
    String plantId,
  ) async {
    try {
      final models = await _remoteDatasource.getRecommendationsByPlant(plantId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsByType(
    RecommendationType type,
  ) async {
    try {
      final models = await _remoteDatasource.getRecommendationsByType(
        type.name,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recommendation>> getRecommendationById(
    String recommendationId,
  ) async {
    try {
      final model = await _remoteDatasource.getRecommendationById(
        recommendationId,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recommendation>> applyRecommendation(
    String recommendationId,
  ) async {
    try {
      final model = await _remoteDatasource.applyRecommendation(
        recommendationId,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recommendation>> dismissRecommendation(
    String recommendationId,
  ) async {
    try {
      final model = await _remoteDatasource.dismissRecommendation(
        recommendationId,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> generateRecommendations(
    String siteId,
  ) async {
    try {
      final models = await _remoteDatasource.generateRecommendations(siteId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
