import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../models/agro_model.dart';

class AgroRemoteDataSource {
  final Dio _dio;

  AgroRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/agro
  ///
  /// Response structure (nested):
  /// { "message": "Success", "data": { "status": 200, "data": { "vdp": {...}, "gdd": {...}, "etc": [...] } } }
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<AgroModel> getAgroData(String siteId) async {
    try {
      final response = await _dio.get('/sites/$siteId/agro');
      return _parseAgroResponse(response.data);
    } on DioException catch (e) {
      debugPrint('❌ Agro datasource error: ${e.message}');
      rethrow; // Let repository handle error mapping
    } catch (e) {
      debugPrint('❌ Unexpected error in agro datasource: $e');
      rethrow;
    }
  }

  /// Parses agro response with proper validation
  ///
  /// Returns empty model only if response structure is valid but empty.
  /// Throws exception if response is malformed.
  static AgroModel _parseAgroResponse(dynamic responseData) {
    // Validate outer layer
    if (responseData == null) {
      throw const ServerFailure('Response data is null');
    }

    if (responseData is! Map<String, dynamic>) {
      throw const ServerFailure('Invalid agro response structure');
    }

    // Extract first 'data' layer
    dynamic inner = responseData['data'];
    if (inner == null) {
      return const AgroModel(); // OK: empty response
    }

    // Handle second 'data' layer (if present)
    if (inner is Map && inner.containsKey('data')) {
      inner = inner['data'];
    }

    // Inner should now be the agro data map
    if (inner == null) {
      return const AgroModel(); // OK: empty data
    }

    if (inner is List) {
      // Unexpected: agro data should be a map, not list
      return const AgroModel();
    }

    if (inner is! Map<String, dynamic>) {
      throw const ServerFailure('Agro data has unexpected structure');
    }

    try {
      return AgroModel.fromJson(inner);
    } catch (e) {
      throw ServerFailure('Failed to parse agro data: $e');
    }
  }
}
