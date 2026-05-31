import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/response_parser.dart';
import '../models/plant_model.dart';

class PlantRemoteDataSource {
  final Dio _dio;

  PlantRemoteDataSource(this._dio);

  void _log(String message) {
    assert(() {
      developer.log(message, name: 'PlantRemoteDataSource');
      return true;
    }());
  }

  /// Header JSON eksplisit; token Bearer di-inject oleh [_AuthInterceptor] di [DioClient].
  static final Options _jsonOptions = Options(
    contentType: Headers.jsonContentType,
    headers: <String, dynamic>{'Accept': 'application/json'},
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

      return _mapPlantList(response.data);
    } on DioException catch (e) {
      _log('❌ Plant datasource error (getPlants): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _log('❌ Unexpected error in plant datasource (getPlants): $e');
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

      return _mapPlantObject(
        response.data,
        notFoundMessage: 'Plant data not found',
      );
    } on DioException catch (e) {
      _log('❌ Plant datasource error (getPlantById): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _log('❌ Unexpected error in plant datasource (getPlantById): $e');
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
      _log('📤 POST plants payload: $payload (siteId: $siteId)');

      final response = await _dio.post(
        ApiEndpoints.plants(siteId),
        data: payload,
        options: _jsonOptions,
      );

      return _mapPlantObject(
        response.data,
        notFoundMessage: 'No data returned from create plant',
        useNotFoundFailure: false,
      );
    } on FormatException catch (e) {
      throw ValidationFailure(e.message);
    } on DioException catch (e) {
      _log('❌ Plant datasource error (createPlant): ${e.message}');
      _log('❌ Response data: ${e.response?.data}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _log('❌ Unexpected error in plant datasource (createPlant): $e');
      rethrow;
    }
  }

  /// PUT /sites/{siteId}/plants/{plantId} — body sama dengan [PlantCreateRequest]
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
      _log('📤 PUT $path body: $payload');

      final response = await _dio.put(
        path,
        data: payload,
        options: _jsonOptions,
      );

      return _mapPlantObject(
        response.data,
        notFoundMessage: 'No data returned from update plant',
        useNotFoundFailure: false,
      );
    } on FormatException catch (e) {
      throw ValidationFailure(e.message);
    } on DioException catch (e) {
      _log('❌ Plant datasource error (updatePlant): ${e.message}');
      _log('❌ Status: ${e.response?.statusCode}');
      _log('❌ Response data: ${e.response?.data}');
      if (e.response?.statusCode == 500) {
        _log(
          '⚠️ PUT plant HTTP 500: payload sudah sama format dengan POST create. '
          'Jika POST/harvest OK, kemungkinan besar bug di handler PUT backend.',
        );
      }
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _log('❌ Unexpected error in plant datasource (updatePlant): $e');
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

      return _mapPlantObject(
        response.data,
        notFoundMessage: 'No data returned from harvest plant',
        useNotFoundFailure: false,
      );
    } on DioException catch (e) {
      _log('❌ Plant datasource error (harvestPlant): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _log('❌ Unexpected error in plant datasource (harvestPlant): $e');
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
      _log('❌ Plant datasource error (deletePlant): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _log('❌ Unexpected error in plant datasource (deletePlant): $e');
      rethrow;
    }
  }

  Map<String, dynamic> _normalizeWritePayload(Map<String, dynamic> raw) {
    return PlantWritePayload.fromMap(raw).toJson();
  }

  List<PlantModel> _mapPlantList(dynamic responseData) {
    _ensureSuccessEnvelope(responseData);

    try {
      return ResponseParser.extractDataList(responseData)
          .whereType<Map>()
          .map((json) {
            return PlantModel.fromJson(Map<String, dynamic>.from(json));
          })
          .where((plant) => plant.plantId.isNotEmpty)
          .toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Failed to parse plants: $e');
    }
  }

  PlantModel _mapPlantObject(
    dynamic responseData, {
    required String notFoundMessage,
    bool useNotFoundFailure = true,
  }) {
    _ensureSuccessEnvelope(responseData);

    final jsonData = _extractPlantObjectMap(responseData);
    if (jsonData == null) {
      if (useNotFoundFailure) {
        throw NotFoundFailure(notFoundMessage);
      }
      throw ServerFailure(notFoundMessage);
    }

    try {
      return PlantModel.fromJson(jsonData);
    } catch (e) {
      throw ServerFailure('Failed to parse plant: $e');
    }
  }

  Map<String, dynamic>? _extractPlantObjectMap(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) return null;

    if (responseData.containsKey('data')) {
      final data = responseData['data'];
      if (data == null) return null;
      if (data is Map<String, dynamic>) {
        final nestedPlant = _extractPlantFromWrapper(data);
        return nestedPlant ?? data;
      }
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final nestedPlant = _extractPlantFromWrapper(map);
        return nestedPlant ?? map;
      }
      throw const ServerFailure('Invalid plant response structure');
    }

    if (responseData.containsKey('plant_id')) {
      return responseData;
    }
    final wrappedPlant = _extractPlantFromWrapper(responseData);
    if (wrappedPlant != null) return wrappedPlant;

    try {
      return ResponseParser.extractDataMap(responseData);
    } on ServerException {
      return null;
    }
  }

  Map<String, dynamic>? _extractPlantFromWrapper(Map<String, dynamic> data) {
    final plant = data['plant'] ?? data['item'] ?? data['result'];
    if (plant is Map<String, dynamic>) return plant;
    if (plant is Map) return Map<String, dynamic>.from(plant);
    return null;
  }

  /// Validasi envelope `{ success, message, data }` dari backend.
  void _ensureSuccessEnvelope(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) return;
    if (!responseData.containsKey('success')) return;

    final success = responseData['success'];
    if (success == false) {
      final message = ResponseParser.extractMessage(
        responseData,
        'Permintaan gagal',
      );
      throw ServerFailure(message);
    }
  }
}
