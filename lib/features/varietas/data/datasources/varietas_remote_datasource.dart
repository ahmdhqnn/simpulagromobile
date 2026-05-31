import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
import '../models/varietas_item_model.dart';

class VarietasRemoteDatasource {
  VarietasRemoteDatasource(this._dio);

  final Dio _dio;

  Future<List<VarietasItemModel>> getAllVarietas() async {
    final response = await _dio.get(ApiEndpoints.varietas);
    final rows = ResponseParser.extractDataList(response.data);
    return rows
        .whereType<Map<String, dynamic>>()
        .map(VarietasItemModel.fromJson)
        .toList();
  }

  Future<VarietasItemModel> getVarietasById(String id) async {
    final response = await _dio.get(ApiEndpoints.varietasById(id));
    final map = ResponseParser.extractDataMap(response.data);
    return VarietasItemModel.fromJson(map);
  }

  Future<VarietasItemModel> createVarietas(Map<String, dynamic> payload) async {
    final response = await _dio.post(ApiEndpoints.varietas, data: payload);
    final map = ResponseParser.extractDataMap(response.data);
    return VarietasItemModel.fromJson(map);
  }

  Future<VarietasItemModel> updateVarietas(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.put(
      ApiEndpoints.varietasById(id),
      data: payload,
    );
    final map = ResponseParser.extractDataMap(response.data);
    return VarietasItemModel.fromJson(map);
  }

  Future<void> deleteVarietas(String id) async {
    await _dio.delete(ApiEndpoints.varietasById(id));
  }
}
