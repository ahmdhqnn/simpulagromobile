import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../domain/entities/site.dart';
import '../models/site_model.dart';

class SiteRemoteDataSource {
  final Dio _dio;

  SiteRemoteDataSource(this._dio);

  /// GET /api/sites
  /// Fetch all sites
  Future<List<SiteModel>> getSites() async {
    final response = await _dio.get(ApiEndpoints.sites);
    final data = response.data['data'] as List;
    return data.map((json) => SiteModel.fromJson(json)).toList();
  }

  /// GET /api/sites/:siteId
  /// Fetch site by ID
  Future<SiteModel> getSiteById(String siteId) async {
    final response = await _dio.get(ApiEndpoints.siteById(siteId));
    return SiteModel.fromJson(response.data['data']);
  }

  /// POST /api/sites
  /// Create new site (requires permission: site:create)
  Future<SiteModel> createSite(Site site) async {
    final response = await _dio.post(
      ApiEndpoints.sites,
      data: {
        'site_id': site.siteId,
        'site_name': site.siteName,
        'site_address': site.siteAddress,
        'site_lat': site.siteLat,
        'site_lon': site.siteLon,
        'site_alt': site.siteAlt,
        'site_sts': site.siteSts ?? 1,
      },
    );
    return SiteModel.fromJson(response.data['data']);
  }

  /// PUT /api/sites/:siteId
  /// Update existing site (requires permission: site:update)
  Future<SiteModel> updateSite(String siteId, Site site) async {
    final response = await _dio.put(
      ApiEndpoints.siteById(siteId),
      data: {
        if (site.siteName != null) 'site_name': site.siteName,
        if (site.siteAddress != null) 'site_address': site.siteAddress,
        if (site.siteLat != null) 'site_lat': site.siteLat,
        if (site.siteLon != null) 'site_lon': site.siteLon,
        if (site.siteAlt != null) 'site_alt': site.siteAlt,
        if (site.siteSts != null) 'site_sts': site.siteSts,
      },
    );
    return SiteModel.fromJson(response.data['data']);
  }
}
