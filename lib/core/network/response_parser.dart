import '../error/exceptions.dart';

/// Centralized helper for parsing backend response bodies.
/// Handles single-nested and double-nested response formats gracefully.
class ResponseParser {
  /// Extracts a Map from the response data.
  static Map<String, dynamic> extractDataMap(dynamic responseData) {
    if (responseData == null) {
      throw const ServerException('Response data is null');
    }
    if (responseData is Map) {
      final responseMap = Map<dynamic, dynamic>.from(responseData);
      final first = responseData['data'];
      if (first == null) {
        final wrapped = _extractWrappedMap(responseMap);
        if (wrapped != null) return wrapped;
        return Map<String, dynamic>.from(responseMap);
      }
      if (first is Map) {
        final firstMap = Map<dynamic, dynamic>.from(first);
        if (first.containsKey('data') && first['data'] is Map) {
          final secondMap = Map<dynamic, dynamic>.from(first['data'] as Map);
          final wrapped = _extractWrappedMap(secondMap);
          if (wrapped != null) return wrapped;
          return Map<String, dynamic>.from(secondMap);
        }
        if (first.containsKey('data') &&
            first['data'] is List &&
            (first['data'] as List).isEmpty) {
          return <String, dynamic>{};
        }
        final wrapped = _extractWrappedMap(firstMap);
        if (wrapped != null) return wrapped;
        return Map<String, dynamic>.from(firstMap);
      }
      if (first is List && first.isEmpty) {
        return <String, dynamic>{};
      }
      if (first is List && first.isNotEmpty && first.first is Map) {
        return Map<String, dynamic>.from(first.first as Map);
      }
    }
    if (responseData is List && responseData.isEmpty) {
      return <String, dynamic>{};
    }
    if (responseData is List &&
        responseData.isNotEmpty &&
        responseData.first is Map) {
      return Map<String, dynamic>.from(responseData.first as Map);
    }
    throw const ServerException('Invalid response structure: expected Map');
  }

  /// Extracts a List from the response data.
  static List<dynamic> extractDataList(dynamic responseData) {
    if (responseData == null) {
      return [];
    }
    if (responseData is Map) {
      final first = responseData['data'];
      if (first == null) {
        final wrapped = _extractWrappedList(responseData);
        if (wrapped != null) return wrapped;
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
      'sites',
      'site',
      'plants',
      'plant',
      'devices',
      'device',
      'sensors',
      'sensor',
      'device_sensors',
      'deviceSensors',
      'reads',
      'notes',
      'tasks',
      'users',
      'user',
      'units',
      'unit',
      'roles',
      'role',
      'permissions',
      'permission',
      'list_permission',
      'varietas',
      'phases',
      'recommendations',
    ];

    for (final key in keys) {
      final value = data[key];
      if (value is List) return value;
    }
    return null;
  }

  static Map<String, dynamic>? _extractWrappedMap(Map<dynamic, dynamic> data) {
    final nonMetadataKeys = data.keys
        .where((key) => key != 'status' && key != 'message' && key != 'msg')
        .toList();
    if (nonMetadataKeys.length != 1) return null;

    const keys = [
      'item',
      'record',
      'result',
      'site',
      'user',
      'role',
      'permission',
      'unit',
      'device',
      'sensor',
      'device_sensor',
      'deviceSensor',
      'note',
      'plant',
      'varietas',
    ];

    for (final key in keys) {
      if (nonMetadataKeys.single != key) continue;
      final value = data[key];
      if (value is Map) return Map<String, dynamic>.from(value);
    }
    return null;
  }

  /// Extracts messages from response body.
  static String extractMessage(
    dynamic responseData, [
    String defaultMessage = 'Success',
  ]) {
    if (responseData is Map) {
      final message = responseData['message'] ?? responseData['msg'];
      if (message is String && message.trim().isNotEmpty) return message;
      if (message is List && message.isNotEmpty) {
        return message.map((item) => item.toString()).join(', ');
      }
      final error = responseData['error'];
      if (error is String && error.trim().isNotEmpty) return error;
      if (error is Map) {
        final nested = error['message'] ?? error['msg'];
        if (nested is String && nested.trim().isNotEmpty) return nested;
        if (nested is List && nested.isNotEmpty) {
          return nested.map((item) => item.toString()).join(', ');
        }
      }
    }
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData;
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
