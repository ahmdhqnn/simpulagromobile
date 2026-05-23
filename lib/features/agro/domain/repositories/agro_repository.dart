import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/agro_model.dart';

abstract class AgroRepository {
  /// Retrieve complete agro data (VDP, GDD, ETC)
  Future<Either<Failure, AgroModel>> getAgroData(String siteId);

  /// Retrieve VDP data only
  Future<Either<Failure, VdpModel>> getVdpData(String siteId);

  /// Retrieve GDD data only
  Future<Either<Failure, GddModel>> getGddData(String siteId);

  /// Retrieve ETC data only
  Future<Either<Failure, List<EtcDailyModel>>> getEtcData(String siteId);
}
