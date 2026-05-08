import 'package:dio/dio.dart';
import '../models/agro_model.dart';

class AgroRemoteDataSource {
  final Dio _dio;

  AgroRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/agro
  ///
  /// Response structure (nested):
  /// { "message": "Success", "data": { "status": 200, "data": { "vdp": {...}, "gdd": {...}, "etc": [...] } } }
  Future<AgroModel> getAgroData(String siteId) async {
    final response = await _dio.get('/sites/$siteId/agro');

    final outer = response.data;
    if (outer == null) return const AgroModel();

    // Handle nested response: response.data.data.data
    dynamic inner = outer['data'];
    if (inner == null) return const AgroModel();

    // Agro endpoint wraps data twice: { data: { status, data: { ... } } }
    if (inner is Map && inner.containsKey('data')) {
      inner = inner['data'];
    }

    // If data is empty list or null, return empty model
    if (inner == null || inner is List) return const AgroModel();
    if (inner is! Map<String, dynamic>) return const AgroModel();

    return AgroModel.fromJson(inner);
  }
}
