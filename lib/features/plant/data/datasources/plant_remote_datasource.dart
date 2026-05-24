import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../models/plant_model.dart';

class PlantRemoteDataSource {
  final Dio _dio;

  PlantRemoteDataSource(this._dio);

  /// GET /api/sites/:siteId/plants
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<PlantModel>> getPlants(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.plants(siteId));
      final data = response.data['data'] as List? ?? [];

      try {
        return data.map((json) {
          if (json is! Map<String, dynamic>) {
            throw const ServerFailure('Invalid plant item structure');
          }
          return PlantModel.fromJson(json);
        }).toList();
      } catch (e) {
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

  /// GET /api/sites/:siteId/plants/:plantId
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<PlantModel> getPlantById(String siteId, String plantId) async {
    try {
      final response = await _dio.get(ApiEndpoints.plantById(siteId, plantId));
      final jsonData = response.data['data'];

      if (jsonData == null) {
        throw const NotFoundFailure('Plant data not found');
      }

      if (jsonData is! Map<String, dynamic>) {
        throw const ServerFailure('Invalid plant data structure');
      }

      try {
        return PlantModel.fromJson(jsonData);
      } catch (e) {
        throw ServerFailure('Failed to parse plant: $e');
      }
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

  /// POST /api/sites/:siteId/plants
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [ValidationFailure], [UnknownFailure]
  Future<PlantModel> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(ApiEndpoints.plants(siteId), data: data);
      final jsonData = response.data['data'];

      if (jsonData == null) {
        throw const ServerFailure('No data returned from create plant');
      }

      if (jsonData is! Map<String, dynamic>) {
        throw const ServerFailure('Invalid create plant response structure');
      }

      try {
        return PlantModel.fromJson(jsonData);
      } catch (e) {
        throw ServerFailure('Failed to parse created plant: $e');
      }
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

  /// PUT /api/sites/:siteId/plants/:plantId
  ///
  /// Throws: [UnsupportedBackendEndpointException]
  Future<PlantModel> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) async {
    throw const UnsupportedBackendEndpointException('Update tanaman belum didukung oleh server');
  }

  /// POST /api/sites/:siteId/plants/:plantId/harvest
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<void> harvestPlant(String siteId, String plantId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.harvestPlant(siteId, plantId),
      );
      
      final data = response.data;
      if (data != null && data['status'] != 0) {
        throw ServerFailure(data['message'] ?? 'Failed to harvest plant');
      }
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

  /// GET /api/varietas
  ///
  /// Throws: [UnsupportedBackendEndpointException]
  Future<List<VarietasModel>> getVarietas() async {
    throw const UnsupportedBackendEndpointException('Daftar varietas belum didukung oleh server');
  }

  /// GET /api/varietas/:varietasId
  ///
  /// Throws: [UnsupportedBackendEndpointException]
  Future<VarietasModel> getVarietasById(String varietasId) async {
    throw const UnsupportedBackendEndpointException('Detail varietas belum didukung oleh server');
  }
}
