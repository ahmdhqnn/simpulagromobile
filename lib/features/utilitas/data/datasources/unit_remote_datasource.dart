import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/unit_model.dart';

/// Remote datasource for Unit operations
abstract class UnitRemoteDatasource {
  Future<List<UnitModel>> getAllUnits();
  Future<UnitModel> getUnitById(String unitId);
  Future<UnitModel> createUnit(Map<String, dynamic> data);
  Future<UnitModel> updateUnit(String unitId, Map<String, dynamic> data);
  Future<void> deleteUnit(String unitId);
}

class UnitRemoteDatasourceImpl implements UnitRemoteDatasource {
  final Dio dio;

  UnitRemoteDatasourceImpl(this.dio);

  @override
  Future<List<UnitModel>> getAllUnits() async {
    try {
      final response = await dio.get(ApiEndpoints.units);

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      final unitsData = data['data'] ?? data;

      if (unitsData is! List) {
        throw Exception('Invalid response format: expected List');
      }

      return unitsData
          .map((json) => UnitModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get units: $e');
    }
  }

  @override
  Future<UnitModel> getUnitById(String unitId) async {
    try {
      final response = await dio.get(ApiEndpoints.unitById(unitId));

      final data = response.data;
      if (data == null) {
        throw Exception('Response data is null');
      }

      final unitData = data['data'] ?? data;

      return UnitModel.fromJson(unitData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get unit: $e');
    }
  }

  @override
  Future<UnitModel> createUnit(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(ApiEndpoints.createUnits, data: data);

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      final unitData = responseData['data'] ?? responseData;

      return UnitModel.fromJson(unitData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create unit: $e');
    }
  }

  @override
  Future<UnitModel> updateUnit(String unitId, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(
        ApiEndpoints.updateUnit(unitId),
        data: data,
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Response data is null');
      }

      final unitData = responseData['data'] ?? responseData;

      return UnitModel.fromJson(unitData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update unit: $e');
    }
  }

  @override
  Future<void> deleteUnit(String unitId) async {
    try {
      await dio.delete(ApiEndpoints.unitById(unitId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to delete unit: $e');
    }
  }

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
            return Exception('Unit tidak ditemukan');
          case 409:
            return Exception('Unit dengan ID ini sudah ada');
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
