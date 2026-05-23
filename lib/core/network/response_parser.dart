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
        if (first.containsKey('data') && first['data'] is Map<String, dynamic>) {
          return first['data'] as Map<String, dynamic>;
        }
        return first;
      }
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
        if (second is Map) return [second];
        return [];
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

  /// Extracts messages from response body.
  static String extractMessage(dynamic responseData, [String defaultMessage = 'Success']) {
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
      if (responseData.containsKey('total') || responseData.containsKey('page')) {
        return {
          'page': responseData['page'],
          'limit': responseData['limit'],
          'total': responseData['total'],
          'total_pages': responseData['total_pages'],
        };
      }
    }
    return null;
  }
}
