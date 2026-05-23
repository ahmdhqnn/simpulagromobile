import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendation_repository.dart';

class ApplyRecommendationUseCase {
  final RecommendationRepository repository;
  ApplyRecommendationUseCase(this.repository);

  Future<Either<Failure, Recommendation>> call(String id) async {
    return await repository.applyRecommendation(id);
  }
}

class DismissRecommendationUseCase {
  final RecommendationRepository repository;
  DismissRecommendationUseCase(this.repository);

  Future<Either<Failure, Recommendation>> call(String id) async {
    return await repository.dismissRecommendation(id);
  }
}
