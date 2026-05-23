import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendation_repository.dart';

class GenerateRecommendationUseCase {
  final RecommendationRepository repository;
  GenerateRecommendationUseCase(this.repository);

  Future<Either<Failure, List<Recommendation>>> call(String siteId) async {
    return await repository.generateRecommendations(siteId);
  }
}
