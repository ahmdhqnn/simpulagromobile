import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/site.dart';

abstract class SiteRepository {
  Future<Either<Failure, List<Site>>> getSites();
  Future<Either<Failure, Site>> getSiteById(String siteId);
  Future<Either<Failure, Site>> createSite(Site site);
  Future<Either<Failure, Site>> updateSite(String siteId, Site site);
  Future<Either<Failure, void>> inviteMember(String siteId, String userId);
}
