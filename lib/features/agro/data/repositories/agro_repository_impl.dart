import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/agro_repository.dart';
import '../datasources/agro_remote_datasource.dart';
import '../models/agro_model.dart';

class AgroRepositoryImpl implements AgroRepository {
  final AgroRemoteDataSource remoteDataSource;

  AgroRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AgroModel>> getAgroData(String siteId) async {
    try {
      final data = await remoteDataSource.getAgroData(siteId);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
