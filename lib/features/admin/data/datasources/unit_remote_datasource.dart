import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
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

      final unitsData = ResponseParser.extractDataList(response.data);

      return unitsData
          .whereType<Map>()
          .map(
            (json) => UnitModel.fromJson(
              _normalizeUnit(Map<String, dynamic>.from(json)),
            ),
          )
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
      final units = await getAllUnits();
      final unit = units.where((item) => item.unitId == unitId).firstOrNull;
      if (unit == null) throw Exception('Unit tidak ditemukan');
      return unit;
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

      return UnitModel.fromJson(
        _normalizeUnit(ResponseParser.extractDataMap(responseData)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create unit: $e');
    }
  }

  @override
  Future<UnitModel> updateUnit(String unitId, Map<String, dynamic> data) async {
    throw const UnsupportedBackendEndpointException(
      'Update unit belum didukung oleh server',
    );
  }

  @override
  Future<void> deleteUnit(String unitId) async {
    throw const UnsupportedBackendEndpointException(
      'Hapus unit belum didukung oleh server',
    );
  }

  Map<String, dynamic> _normalizeUnit(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    const stringKeys = ['unit_id', 'unit_name', 'unit_symbol', 'unit_desc'];
    for (final key in stringKeys) {
      final value = normalized[key];
      if (value != null && value is! String) {
        normalized[key] = value.toString();
      }
    }
    final sts = normalized['unit_sts'];
    if (sts is String) normalized['unit_sts'] = int.tryParse(sts);
    return normalized;
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Koneksi timeout. Periksa koneksi internet Anda.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = ResponseParser.extractMessage(
          error.response?.data,
          'Terjadi kesalahan: $statusCode',
        );

        switch (statusCode) {
          case 400:
            return Exception(message);
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
            return Exception(message);
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
