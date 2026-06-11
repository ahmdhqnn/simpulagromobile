import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/recommendation_request.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_datasource.dart';
import '../models/recommendation_model.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  RecommendationRepositoryImpl(this._remoteDatasource);

  final RecommendationRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsBySite(
    String siteId, {
    bool refresh = false,
  }) {
    return _mapList(
      () =>
          _remoteDatasource.getRecommendationsBySite(siteId, refresh: refresh),
    );
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getLatestRecommendationsForSite(
    String siteId,
  ) {
    return _mapList(
      () => _remoteDatasource.getLatestRecommendationsForSite(siteId),
    );
  }

  @override
  Future<Either<Failure, List<Recommendation>>> generateRecommendations(
    String siteId,
  ) {
    return _mapList(
      () => _remoteDatasource.getRecommendationsBySite(siteId, refresh: true),
    );
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationHistory(
    String siteId,
  ) {
    return _mapList(() => _remoteDatasource.getRecommendationHistory(siteId));
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsByPhase(
    String siteId,
    String phaseId,
  ) {
    return _mapList(
      () => _remoteDatasource.getRecommendationsByPhase(siteId, phaseId),
    );
  }

  @override
  Future<Either<Failure, List<Recommendation>>> createPlantRecommendation(
    String siteId,
    PlantRecommendationInput input,
  ) {
    return _mapList(
      () => _remoteDatasource.postPlantRecommendation(siteId, {
        'soil_nitro': input.soilNitro,
        'soil_phos': input.soilPhos,
        'soil_pot': input.soilPot,
        'env_temp': input.envTemp,
        'env_hum': input.envHum,
        'soil_ph': input.soilPh,
      }),
    );
  }

  Future<Either<Failure, List<Recommendation>>> _mapList(
    Future<List<RecommendationModel>> Function() request,
  ) async {
    try {
      final models = await request();
      return Right(models.map((model) => model.toEntity()).toList());
    } on DioException catch (error) {
      return Left(error.toFailure());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }
}
