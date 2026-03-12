class Site {
  final String siteId;
  final String? siteName;
  final String? siteAddress;
  final double? siteLon;
  final double? siteLat;
  final double? siteAlt;
  final int? siteSts;

  const Site({
    required this.siteId,
    this.siteName,
    this.siteAddress,
    this.siteLon,
    this.siteLat,
    this.siteAlt,
    this.siteSts,
  });

  bool get isActive => siteSts == 1;
}
