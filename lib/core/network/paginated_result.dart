class PaginationMeta {
  final int page;
  final int limit;
  final int? total;
  final int? totalPages;
  final bool? hasMore;

  const PaginationMeta({
    required this.page,
    required this.limit,
    this.total,
    this.totalPages,
    this.hasMore,
  });

  factory PaginationMeta.fromJson(
    Map<String, dynamic>? json, {
    required int fallbackPage,
    required int fallbackLimit,
    required int itemCount,
  }) {
    final page = _toInt(
      json?['page'] ?? json?['current_page'] ?? json?['currentPage'],
    );
    final limit = _toInt(
      json?['limit'] ?? json?['per_page'] ?? json?['perPage'],
    );
    return PaginationMeta(
      page: page ?? fallbackPage,
      limit: limit ?? fallbackLimit,
      total: _toInt(
        json?['total'] ?? json?['total_items'] ?? json?['totalItems'],
      ),
      totalPages: _toInt(
        json?['total_pages'] ?? json?['totalPages'] ?? json?['last_page'],
      ),
      hasMore: _toBool(
        json?['has_more'] ?? json?['hasMore'] ?? json?['has_next_page'],
      ),
    );
  }

  bool get hasNextPage {
    if (hasMore != null) return hasMore!;
    if (totalPages != null) return page < totalPages!;
    if (total != null) return page * limit < total!;
    return false;
  }

  bool get hasExplicitPageBoundary =>
      hasMore != null || totalPages != null || total != null;

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final text = value.trim().toLowerCase();
      if (text == 'true' || text == '1') return true;
      if (text == 'false' || text == '0') return false;
    }
    return null;
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginatedResult({required this.items, required this.meta});

  bool get hasNextPage => meta.hasNextPage;

  factory PaginatedResult.fromItems(
    List<T> items, {
    required int page,
    required int limit,
    Map<String, dynamic>? meta,
  }) {
    return PaginatedResult(
      items: items,
      meta: PaginationMeta.fromJson(
        meta,
        fallbackPage: page,
        fallbackLimit: limit,
        itemCount: items.length,
      ),
    );
  }
}
