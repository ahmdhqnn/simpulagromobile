import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../models/plant_model.dart';

class PlantRemoteDataSource {
  final Dio _dio;

  PlantRemoteDataSource(this._dio);

  /// Header JSON eksplisit; token Bearer di-inject oleh [_AuthInterceptor] di [DioClient].
  static final Options _jsonOptions = Options(
    contentType: Headers.jsonContentType,
    headers: <String, dynamic>{
      'Accept': 'application/json',
    },
  );

  /// GET /sites/{siteId}/plants
  ///
  /// Query [isOnGoingPlant]: `true` = hanya planting aktif (`plant_harvest = null`).
  Future<List<PlantModel>> getPlants(
    String siteId, {
    bool? isOnGoingPlant,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (isOnGoingPlant != null) {
        queryParameters['isOnGoingPlant'] = isOnGoingPlant;
      }

      final response = await _dio.get(
        ApiEndpoints.plants(siteId),
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
        options: _jsonOptions,
      );

      _ensureSuccessEnvelope(response.data);
      final data = _extractListPayload(response.data);

      try {
        return data.map((json) {
          if (json is! Map<String, dynamic>) {
            throw const ServerFailure('Invalid plant item structure');
          }
          return PlantModel.fromJson(json);
        }).toList();
      } catch (e) {
        if (e is Failure) rethrow;
        throw ServerFailure('Failed to parse plants: $e');
      }
    } on DioException catch (e) {
      debugPrint('❌ Plant datasource error (getPlants): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in plant datasource (getPlants): $e');
      rethrow;
    }
  }

  /// GET /sites/{siteId}/plants/{plantId}
  Future<PlantModel> getPlantById(String siteId, String plantId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.plantById(siteId, plantId),
        options: _jsonOptions,
      );

      _ensureSuccessEnvelope(response.data);
      final jsonData = _extractObjectPayload(response.data);

      if (jsonData == null) {
        throw const NotFoundFailure('Plant data not found');
      }

      return PlantModel.fromJson(jsonData);
    } on DioException catch (e) {
      debugPrint('❌ Plant datasource error (getPlantById): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in plant datasource (getPlantById): $e');
      rethrow;
    }
  }

  /// POST /sites/{siteId}/plants — body [PlantCreateRequest]
  Future<PlantModel> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final payload = _normalizeWritePayload(data);
      debugPrint('📤 POST plants payload: $payload (siteId: $siteId)');

      final response = await _dio.post(
        ApiEndpoints.plants(siteId),
        data: payload,
        options: _jsonOptions,
      );

      _ensureSuccessEnvelope(response.data);
      final jsonData = _extractObjectPayload(response.data);
      if (jsonData == null) {
        throw const ServerFailure('No data returned from create plant');
      }

      return PlantModel.fromJson(jsonData);
    } on FormatException catch (e) {
      throw ValidationFailure(e.message);
    } on DioException catch (e) {
      debugPrint('❌ Plant datasource error (createPlant): ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in plant datasource (createPlant): $e');
      rethrow;
    }
  }

  /// PUT /sites/{siteId}/plants/{plantId} — body sama dengan POST
  Future<PlantModel> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) async {
    final normalizedSiteId = siteId.trim();
    final normalizedPlantId = plantId.trim();

    try {
      final payload = _normalizeWritePayload(data);
      final path = ApiEndpoints.plantById(normalizedSiteId, normalizedPlantId);
      debugPrint(
        '📤 PUT $path body: $payload',
      );

      final response = await _dio.put(
        path,
        data: payload,
        options: _jsonOptions,
      );

      _ensureSuccessEnvelope(response.data);
      final jsonData = _extractObjectPayload(response.data);
      if (jsonData == null) {
        throw const ServerFailure('No data returned from update plant');
      }

      return PlantModel.fromJson(jsonData);
    } on FormatException catch (e) {
      throw ValidationFailure(e.message);
    } on DioException catch (e) {
      debugPrint('❌ Plant datasource error (updatePlant): ${e.message}');
      debugPrint('❌ Status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      if (e.response?.statusCode == 500) {
        debugPrint(
          '⚠️ PUT plant HTTP 500: payload sudah sama format dengan POST create. '
          'Jika POST/harvest OK, kemungkinan besar bug di handler PUT backend.',
        );
      }
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in plant datasource (updatePlant): $e');
      rethrow;
    }
  }

  /// POST /sites/{siteId}/plants/{plantId}/harvest
  Future<PlantModel> harvestPlant(String siteId, String plantId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.harvestPlant(siteId, plantId),
        options: _jsonOptions,
      );

      _ensureSuccessEnvelope(response.data);
      final jsonData = _extractObjectPayload(response.data);
      if (jsonData != null) {
        return PlantModel.fromJson(jsonData);
      }

      throw const ServerFailure('No data returned from harvest plant');
    } on DioException catch (e) {
      debugPrint('❌ Plant datasource error (harvestPlant): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in plant datasource (harvestPlant): $e');
      rethrow;
    }
  }

  /// DELETE /sites/{siteId}/plants/{plantId} — Admin only
  Future<void> deletePlant(String siteId, String plantId) async {
    try {
      final response = await _dio.delete(
        ApiEndpoints.plantById(siteId, plantId),
        options: _jsonOptions,
      );

      _ensureSuccessEnvelope(response.data);
    } on DioException catch (e) {
      debugPrint('❌ Plant datasource error (deletePlant): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in plant datasource (deletePlant): $e');
      rethrow;
    }
  }

  Future<List<VarietasModel>> getVarietas() async {
    throw const UnsupportedBackendEndpointException(
      'Daftar varietas belum didukung oleh server',
    );
  }

  Future<VarietasModel> getVarietasById(String varietasId) async {
    throw const UnsupportedBackendEndpointException(
      'Detail varietas belum didukung oleh server',
    );
  }

  Map<String, dynamic> _normalizeWritePayload(Map<String, dynamic> raw) {
    return PlantWritePayload.fromMap(raw).toJson();
  }

  /// Validasi envelope `{ success, message, data }` dari backend.
  void _ensureSuccessEnvelope(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) return;
    if (!responseData.containsKey('success')) return;

    final success = responseData['success'];
    if (success == false) {
      final message = responseData['message']?.toString();
      throw ServerFailure(message ?? 'Permintaan gagal');
    }
  }

  List<dynamic> _extractListPayload(dynamic responseData) {
    if (responseData is List) return responseData;

    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is List) return data;
      if (data == null) return [];
    }

    throw const ServerFailure('Invalid plants list response structure');
  }

  Map<String, dynamic>? _extractObjectPayload(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) return data;
      if (!responseData.containsKey('data')) return responseData;
    }
    return null;
  }
}
