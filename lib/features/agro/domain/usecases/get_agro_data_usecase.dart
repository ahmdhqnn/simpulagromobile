import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/agro_model.dart';
import '../repositories/agro_repository.dart';

class GetAgroDataUseCase {
  final AgroRepository repository;

  GetAgroDataUseCase(this.repository);

  Future<Either<Failure, AgroModel>> call(String siteId) async {
    return await repository.getAgroData(siteId);
  }
}
