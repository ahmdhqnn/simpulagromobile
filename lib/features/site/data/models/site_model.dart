import '../../domain/entities/site.dart';

class SiteModel extends Site {
  const SiteModel({
    required super.siteId,
    super.siteName,
    super.siteAddress,
    super.siteLon,
    super.siteLat,
    super.siteAlt,
    super.siteSts,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      siteId: json['site_id'] ?? '',
      siteName: json['site_name'],
      siteAddress: json['site_address'],
      siteLon: (json['site_lon'] as num?)?.toDouble(),
      siteLat: (json['site_lat'] as num?)?.toDouble(),
      siteAlt: (json['site_alt'] as num?)?.toDouble(),
      siteSts: json['site_sts'] as int?,
    );
  }
}
