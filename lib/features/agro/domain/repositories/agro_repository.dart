import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/agro_entity.dart';

/// Repository interface untuk fitur Agro
/// Domain layer — tidak boleh import dari data layer
abstract class AgroRepository {
  /// GET /sites/{siteId}/agro
  /// Mengambil data agro lengkap (VDP, GDD, ETC)
  Future<Either<Failure, AgroEntity>> getAgroData(String siteId);

  /// Mengambil hanya data VDP
  Future<Either<Failure, VdpEntity>> getVdpData(String siteId);

  /// Mengambil hanya data GDD
  Future<Either<Failure, GddEntity>> getGddData(String siteId);

  /// Mengambil hanya data ETC
  Future<Either<Failure, List<EtcDailyEntity>>> getEtcData(String siteId);

  Future<Either<Failure, AgroEnvironmentalHealthEntity>> getEnvironmentalHealth(
    String siteId,
  );
}
