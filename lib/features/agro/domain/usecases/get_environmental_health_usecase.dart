import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/agro_entity.dart';
import '../repositories/agro_repository.dart';

class GetAgroEnvironmentalHealthUseCase {
  const GetAgroEnvironmentalHealthUseCase(this.repository);

  final AgroRepository repository;

  Future<Either<Failure, AgroEnvironmentalHealthEntity>> call(String siteId) {
    return repository.getEnvironmentalHealth(siteId);
  }
}
