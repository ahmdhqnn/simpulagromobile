import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/response_parser.dart';
import '../models/agro_environmental_health_model.dart';
import '../models/agro_model.dart';

void _debugLog(String message) {
  assert(() {
    developer.log(message, name: 'AgroRemoteDataSource');
    return true;
  }());
}

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
      _debugLog('Agro datasource error: ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog('Unexpected error in agro datasource: $e');
      rethrow;
    }
  }

  Future<AgroEnvironmentalHealthModel> getEnvironmentalHealth(
    String siteId,
  ) async {
    try {
      final response = await _dio.get(ApiEndpoints.envHealth(siteId));
      _throwForBodyError(response.data, 'environmental health');
      final data = ResponseParser.extractDataMap(response.data);
      return AgroEnvironmentalHealthModel.fromJson(data);
    } on DioException catch (e) {
      _debugLog('Environmental health datasource error: ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog('Unexpected environmental health datasource error: $e');
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
    _throwForBodyError(responseData, 'agro');

    // Ekstrak layer 'data' pertama
    dynamic inner = responseData['data'];
    if (inner == null) return const AgroModel();

    // Handle double-wrapped: { data: { status, data: { ... } } }
    if (inner is Map && inner.containsKey('data')) {
      _throwForBodyError(inner, 'agro');
      inner = inner['data'];
    }

    if (inner == null) return const AgroModel();
    if (inner is List) return const AgroModel();
    if (inner is! Map) {
      throw const ServerFailure('Agro data has unexpected structure');
    }

    try {
      return AgroModel.fromJson(Map<String, dynamic>.from(inner));
    } catch (e) {
      throw ServerFailure('Failed to parse agro data: $e');
    }
  }

  static void _throwForBodyError(dynamic responseData, String feature) {
    if (responseData is! Map) return;
    final rawStatus = responseData['status'];
    final status = rawStatus is num
        ? rawStatus.toInt()
        : int.tryParse(rawStatus?.toString() ?? '');
    if (status != null && status >= 400) {
      final message = (responseData['message'] ?? responseData['error'])
          ?.toString()
          .trim();
      throw ServerFailure(
        message?.isNotEmpty == true ? message! : 'Failed to load $feature data',
        statusCode: status,
      );
    }
    final nested = responseData['data'];
    if (nested is Map) {
      _throwForBodyError(nested, feature);
    }
  }
}
