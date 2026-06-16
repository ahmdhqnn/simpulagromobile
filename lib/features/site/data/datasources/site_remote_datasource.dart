import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
import '../../domain/entities/site.dart';
import '../models/site_model.dart';

class SiteRemoteDataSource {
  final Dio _dio;

  SiteRemoteDataSource(this._dio);

  /// GET /api/sites
  /// Fetch all sites
  Future<List<SiteModel>> getSites() async {
    final response = await _dio.get(ApiEndpoints.sites);
    final data = ResponseParser.extractDataList(response.data);
    return data
        .whereType<Map>()
        .map((json) => SiteModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  /// GET /api/sites?site_id=:siteId
  /// Fetch site by ID using the documented site_id query filter.
  Future<SiteModel> getSiteById(String siteId) async {
    final response = await _dio.get(
      ApiEndpoints.sites,
      queryParameters: {'site_id': siteId},
    );
    return _siteFromResponse(response.data, siteId);
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
    return SiteModel.fromJson(ResponseParser.extractDataMap(response.data));
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
    return SiteModel.fromJson(ResponseParser.extractDataMap(response.data));
  }

  /// POST /sites/{siteId}/members/invite
  Future<void> inviteMember(String siteId, String userId) async {
    await _dio.post(
      ApiEndpoints.siteMemberInvite(siteId),
      data: {'user_id': userId},
    );
  }

  SiteModel _siteFromResponse(dynamic body, String siteId) {
    try {
      final map = ResponseParser.extractDataMap(body);
      final site = SiteModel.fromJson(map);
      if (site.siteId.isNotEmpty) return site;
    } catch (_) {
      // Fallback to collection parsing below.
    }

    final rows = ResponseParser.extractDataList(body)
        .whereType<Map>()
        .map((json) => SiteModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();

    if (rows.isNotEmpty) {
      return rows.firstWhere(
        (site) => site.siteId == siteId,
        orElse: () => rows.first,
      );
    }

    return SiteModel.fromJson(ResponseParser.extractDataMap(body));
  }
}
