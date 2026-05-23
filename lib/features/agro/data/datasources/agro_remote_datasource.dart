import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../models/agro_model.dart';

class AgroRemoteDataSource {
  final Dio _dio;

  AgroRemoteDataSource(this._dio);

  /// GET /sites/{siteId}/agro
  /// Response: { "status": 200, "message": "...", "data": { "vdp": {...}, "gdd": {...}, "etc": [...] } }
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<AgroModel> getAgroData(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.agro(siteId));
      return _parseAgroResponse(response.data);
    } on DioException catch (e) {
      debugPrint('❌ Agro datasource error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in agro datasource: $e');
      rethrow;
    }
  }

  /// Parse response agro dengan validasi struktur
  static AgroModel _parseAgroResponse(dynamic responseData) {
    if (responseData == null) {
      throw const ServerFailure('Response data is null');
    }
    if (responseData is! Map<String, dynamic>) {
      throw const ServerFailure('Invalid agro response structure');
    }

    // Ekstrak layer 'data' pertama
    dynamic inner = responseData['data'];
    if (inner == null) return const AgroModel();

    // Handle double-wrapped: { data: { status, data: { ... } } }
    if (inner is Map && inner.containsKey('data')) {
      inner = inner['data'];
    }

    if (inner == null) return const AgroModel();
    if (inner is List) return const AgroModel();
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
