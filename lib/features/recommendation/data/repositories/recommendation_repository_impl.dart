import 'package:dartz/dartz.dart' hide Task;
import 'package:dio/dio.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/recommendation_request.dart';
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
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsBySite(
    String siteId, {
    bool refresh = false,
  }) async {
    try {
      final models = await _remoteDatasource.getRecommendationsBySite(
        siteId,
        refresh: refresh,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getLatestRecommendationsForSite(
    String siteId,
  ) async {
    try {
      final models = await _remoteDatasource.getLatestRecommendationsForSite(
        siteId,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsByPlant(
    String siteId,
    String plantId,
  ) async {
    try {
      final models = await _remoteDatasource.getRecommendationsByPlant(
        siteId,
        plantId,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> generateRecommendations(
    String siteId,
  ) async {
    try {
      final models = await _remoteDatasource.generateRecommendations(siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationHistory(
    String siteId,
  ) async {
    try {
      final models = await _remoteDatasource.getRecommendationHistory(siteId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendationsByPhase(
    String siteId,
    String phaseId,
  ) async {
    try {
      final models = await _remoteDatasource.getRecommendationsByPhase(
        siteId,
        phaseId,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> createPlantRecommendation(
    String siteId,
    PlantRecommendationInput input,
  ) async {
    try {
      final models = await _remoteDatasource.postPlantRecommendation(siteId, {
        'soil_nitro': input.soilNitro,
        'soil_phos': input.soilPhos,
        'soil_pot': input.soilPot,
        'env_temp': input.envTemp,
        'env_hum': input.envHum,
        'soil_ph': input.soilPh,
      });
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecommendationPreviewResult>> previewLabRecommendation(
    String siteId,
    RecommendationLabInput input,
  ) async {
    try {
      final data = await _remoteDatasource.previewDummyRecommendation(
        siteId,
        _labPayload(input, includeSiteId: false),
      );
      return Right(RecommendationPreviewResult(data));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecommendationPreviewResult>> saveLabRecommendation(
    String siteId,
    RecommendationLabInput input,
  ) async {
    try {
      final data = await _remoteDatasource.saveDummyRecommendation(
        siteId,
        _labPayload(input, siteId: siteId),
      );
      return Right(RecommendationPreviewResult(data));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Map<String, dynamic> _labPayload(
    RecommendationLabInput input, {
    String? siteId,
    bool includeSiteId = true,
  }) {
    return {
      'phase': input.phase,
      'sensorData': {
        'soil_nitro': input.soilNitro,
        'soil_phos': input.soilPhos,
        'soil_pot': input.soilPot,
        'env_temp': input.envTemp,
        'env_hum': input.envHum,
        'soil_temp': input.soilTemp,
        'soil_hum': input.soilHum,
        'soil_ph': input.soilPh,
      },
      if (includeSiteId && siteId != null) 'siteId': siteId,
    };
  }
}
