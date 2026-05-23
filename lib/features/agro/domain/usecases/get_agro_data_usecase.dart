import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/agro_entity.dart';
import '../repositories/agro_repository.dart';

class GetAgroDataUseCase {
  final AgroRepository repository;

  GetAgroDataUseCase(this.repository);

  Future<Either<Failure, AgroEntity>> call(String siteId) async {
    return await repository.getAgroData(siteId);
  }
}
