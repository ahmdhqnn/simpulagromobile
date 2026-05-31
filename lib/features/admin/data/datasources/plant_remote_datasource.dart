import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/plant_model.dart';

/// Remote datasource for Plant operations
/// Handles all HTTP requests related to plants
abstract class PlantRemoteDatasource {
  /// Get all plants for a specific site
  Future<List<PlantModel>> getPlantsBySite(String siteId);

  /// Get plant by ID
  Future<PlantModel> getPlantById(String siteId, String plantId);

  /// Create new plant
  Future<PlantModel> createPlant(String siteId, Map<String, dynamic> data);

  /// Update existing plant
  Future<PlantModel> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  );

  /// Harvest plant (special operation)
  Future<PlantModel> harvestPlant(String siteId, String plantId);

  /// Delete plant
  Future<void> deletePlant(String siteId, String plantId);
}

class PlantRemoteDatasourceImpl implements PlantRemoteDatasource {
  final Dio dio;

  PlantRemoteDatasourceImpl(this.dio);

  @override
  Future<List<PlantModel>> getPlantsBySite(String siteId) async {
    try {
      final response = await dio.get(ApiEndpoints.plants(siteId));

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      final plantsData = data['data'] ?? data;

      if (plantsData is! List) {
        throw Exception('Invalid response format: expected List');
      }

      return plantsData
          .map((json) => PlantModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get plants: $e');
    }
  }

  @override
  Future<PlantModel> getPlantById(String siteId, String plantId) async {
    try {
      final response = await dio.get(ApiEndpoints.plantById(siteId, plantId));

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      final plantData = data['data'] ?? data;

      return PlantModel.fromJson(plantData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get plant: $e');
    }
  }

  @override
  Future<PlantModel> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(ApiEndpoints.plants(siteId), data: data);

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      final plantData = responseData['data'] ?? responseData;

      return PlantModel.fromJson(plantData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create plant: $e');
    }
  }

  @override
  Future<PlantModel> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiEndpoints.plantById(siteId, plantId),
        data: data,
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      final plantData = responseData['data'] ?? responseData;

      return PlantModel.fromJson(plantData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update plant: $e');
    }
  }

  @override
  Future<PlantModel> harvestPlant(String siteId, String plantId) async {
    try {
      final response = await dio.post(
        ApiEndpoints.harvestPlant(siteId, plantId),
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      final plantData = responseData['data'] ?? responseData;

      return PlantModel.fromJson(plantData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to harvest plant: $e');
    }
  }

  @override
  Future<void> deletePlant(String siteId, String plantId) async {
    try {
      await dio.delete(ApiEndpoints.plantById(siteId, plantId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete plant: $e');
    }
  }

  /// Handle Dio errors and convert to user-friendly messages
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Koneksi timeout. Periksa koneksi internet Anda.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'];

        switch (statusCode) {
          case 400:
            return Exception(message ?? 'Data tidak valid');
          case 401:
            return Exception(
              'Sesi Anda telah berakhir. Silakan login kembali.',
            );
          case 403:
            return Exception(
              'Anda tidak memiliki izin untuk melakukan aksi ini',
            );
          case 404:
            return Exception('Tanaman tidak ditemukan');
          case 409:
            return Exception('Tanaman dengan ID ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
          default:
            return Exception(message ?? 'Terjadi kesalahan: $statusCode');
        }

      case DioExceptionType.cancel:
        return Exception('Request dibatalkan');

      case DioExceptionType.connectionError:
        return Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );

      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
