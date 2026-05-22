import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/agro_model.dart';

abstract class AgroRepository {
  Future<Either<Failure, AgroModel>> getAgroData(String siteId);
}
