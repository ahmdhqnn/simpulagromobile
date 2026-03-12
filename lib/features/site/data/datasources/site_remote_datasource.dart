import 'package:dio/dio.dart';
import '../models/site_model.dart';

class SiteRemoteDataSource {
  final Dio _dio;

  SiteRemoteDataSource(this._dio);

  /// GET /api/sites/
  Future<List<SiteModel>> getAllSites() async {
    final response = await _dio.get('/sites/');
    final data = response.data['data'] as List? ?? [];
    return data.map((json) => SiteModel.fromJson(json)).toList();
  }
}
