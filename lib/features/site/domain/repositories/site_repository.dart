import '../entities/site.dart';

abstract class SiteRepository {
  Future<List<Site>> getSites();
  Future<Site> getSiteById(String siteId);
  Future<Site> createSite(Site site);
  Future<Site> updateSite(String siteId, Site site);
}
