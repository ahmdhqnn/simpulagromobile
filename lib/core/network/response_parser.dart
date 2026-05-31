import '../error/exceptions.dart';

/// Centralized helper for parsing backend response bodies.
/// Handles single-nested and double-nested response formats gracefully.
class ResponseParser {
  /// Extracts a Map from the response data.
  static Map<String, dynamic> extractDataMap(dynamic responseData) {
    if (responseData == null) {
      throw const ServerException('Response data is null');
    }
    if (responseData is Map<String, dynamic>) {
      final first = responseData['data'];
      if (first == null) {
        return responseData;
      }
      if (first is Map<String, dynamic>) {
        if (first.containsKey('data') &&
            first['data'] is Map<String, dynamic>) {
          return first['data'] as Map<String, dynamic>;
        }
        if (first.containsKey('data') &&
            first['data'] is List &&
            (first['data'] as List).isEmpty) {
          return <String, dynamic>{};
        }
        return first;
      }
      if (first is List && first.isEmpty) {
        return <String, dynamic>{};
      }
    }
    if (responseData is List && responseData.isEmpty) {
      return <String, dynamic>{};
    }
    throw const ServerException('Invalid response structure: expected Map');
  }

  /// Extracts a List from the response data.
  static List<dynamic> extractDataList(dynamic responseData) {
    if (responseData == null) {
      return [];
    }
    if (responseData is Map<String, dynamic>) {
      final first = responseData['data'];
      if (first == null) {
        return [];
      }
      if (first is Map && first.containsKey('data')) {
        final second = first['data'];
        if (second is List) return second;
        if (second is Map) {
          final wrapped = _extractWrappedList(second);
          if (wrapped != null) return wrapped;
          return [second];
        }
        return [];
      }
      if (first is Map) {
        final wrapped = _extractWrappedList(first);
        if (wrapped != null) return wrapped;
      }
      if (first is List) return first;
      if (first is Map) return [first];
      return [];
    }
    if (responseData is List) {
      return responseData;
    }
    return [];
  }

  static List<dynamic>? _extractWrappedList(Map<dynamic, dynamic> data) {
    const keys = [
      'items',
      'rows',
      'records',
      'results',
      'plants',
      'devices',
      'sensors',
      'sensor',
      'reads',
      'notes',
      'tasks',
      'users',
      'units',
      'roles',
      'permissions',
      'varietas',
      'phases',
    ];

    for (final key in keys) {
      final value = data[key];
      if (value is List) return value;
    }
    return null;
  }

  /// Extracts messages from response body.
  static String extractMessage(
    dynamic responseData, [
    String defaultMessage = 'Success',
  ]) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ?? responseData['msg'] ?? defaultMessage;
    }
    return defaultMessage;
  }

  /// Extracts pagination metadata from response body.
  static Map<String, dynamic>? extractPaginationMeta(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final meta = responseData['meta'];
      if (meta is Map<String, dynamic>) {
        return meta;
      }
      final pagination = responseData['pagination'];
      if (pagination is Map<String, dynamic>) {
        return pagination;
      }
      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        final nestedMeta = data['meta'];
        if (nestedMeta is Map<String, dynamic>) return nestedMeta;
        final nestedPagination = data['pagination'];
        if (nestedPagination is Map<String, dynamic>) return nestedPagination;
        if (_containsPaginationKey(data)) {
          return _flatPaginationMap(data);
        }
      }
      if (responseData.containsKey('total') ||
          responseData.containsKey('page')) {
        return _flatPaginationMap(responseData);
      }
    }
    return null;
  }

  static bool _containsPaginationKey(Map<String, dynamic> data) {
    return data.containsKey('total') ||
        data.containsKey('page') ||
        data.containsKey('current_page') ||
        data.containsKey('total_pages') ||
        data.containsKey('has_more') ||
        data.containsKey('has_next_page');
  }

  static Map<String, dynamic> _flatPaginationMap(Map<String, dynamic> data) {
    final map = {
      'page': data['page'] ?? data['current_page'] ?? data['currentPage'],
      'limit': data['limit'] ?? data['per_page'] ?? data['perPage'],
      'total': data['total'] ?? data['total_items'] ?? data['totalItems'],
      'total_pages':
          data['total_pages'] ?? data['totalPages'] ?? data['last_page'],
      'has_more': data['has_more'] ?? data['hasMore'] ?? data['has_next_page'],
    };
    map.removeWhere((_, value) => value == null);
    return map;
  }
}
