import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../entities/recommendation_request.dart';
import '../repositories/recommendation_repository.dart';

class GenerateRecommendationUseCase {
  final RecommendationRepository repository;
  GenerateRecommendationUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(String siteId) async {
    return await repository.generateRecommendations(siteId);
  }
}

class GetRecommendationHistoryUseCase {
  final RecommendationRepository repository;
  GetRecommendationHistoryUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(String siteId) {
    return repository.getRecommendationHistory(siteId);
  }
}

class GetRecommendationsByPhaseUseCase {
  final RecommendationRepository repository;
  GetRecommendationsByPhaseUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(
    String siteId,
    String phaseId,
  ) {
    return repository.getRecommendationsByPhase(siteId, phaseId);
  }
}

class CreatePlantRecommendationUseCase {
  final RecommendationRepository repository;
  CreatePlantRecommendationUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(
    String siteId,
    PlantRecommendationInput input,
  ) {
    return repository.createPlantRecommendation(siteId, input);
  }
}

class PreviewLabRecommendationUseCase {
  final RecommendationRepository repository;
  PreviewLabRecommendationUseCase(this.repository);

  Future<Either<Failure, RecommendationPreviewResult>> call(
    String siteId,
    RecommendationLabInput input,
  ) {
    return repository.previewLabRecommendation(siteId, input);
  }
}

class SaveLabRecommendationUseCase {
  final RecommendationRepository repository;
  SaveLabRecommendationUseCase(this.repository);

  Future<Either<Failure, RecommendationPreviewResult>> call(
    String siteId,
    RecommendationLabInput input,
  ) {
    return repository.saveLabRecommendation(siteId, input);
  }
}
