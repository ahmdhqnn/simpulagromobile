import 'package:dio/dio.dart';
import '../models/agro_model.dart';

class AgroRemoteDataSource {
  final Dio _dio;

  AgroRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/agro
  Future<AgroModel> getAgroData(String siteId) async {
    final response = await _dio.get('/sites/$siteId/agro');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return AgroModel.fromJson(data);
  }
}
