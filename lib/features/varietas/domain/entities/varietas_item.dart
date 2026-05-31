class VarietasItem {
  const VarietasItem({
    required this.varietasId,
    this.varietasName,
    this.varietasDesc,
    this.varietasSts,
    this.varietasUpdate,
  });

  final String varietasId;
  final String? varietasName;
  final String? varietasDesc;
  final int? varietasSts;
  final DateTime? varietasUpdate;

  bool get isActive => varietasSts == null || varietasSts == 1;

  String get displayName {
    final name = varietasName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return varietasId;
  }
}
