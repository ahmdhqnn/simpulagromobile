import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/site_note_model.dart';

class NotesRemoteDataSource {
  final Dio _dio;

  const NotesRemoteDataSource(this._dio);

  /// GET /sites/{siteId}/notes
  Future<List<SiteNoteModel>> getNotes(
    String siteId, {
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.siteNotes(siteId),
        queryParameters: {
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
      );
      final rows = _extractNotesList(response.data);
      return rows.map((json) => SiteNoteModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /sites/{siteId}/notes
  Future<SiteNoteModel> createNote({
    required String siteId,
    required String noteTitle,
    required String noteDesc,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.siteNotes(siteId),
        data: {'note_title': noteTitle.trim(), 'note_desc': noteDesc.trim()},
      );
      final data = _extractCreatedNote(response.data);
      return SiteNoteModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  List<Map<String, dynamic>> _extractNotesList(dynamic body) {
    if (body is! Map) {
      throw const ServerException('Invalid notes response: expected object');
    }
    final data = body['data'];
    if (data == null) return const [];
    if (data is! List) {
      throw const ServerException('Invalid notes response: data must be list');
    }
    return data
        .whereType<Map>()
        .map((json) => Map<String, dynamic>.from(json))
        .toList();
  }

  Map<String, dynamic> _extractCreatedNote(dynamic body) {
    if (body is! Map) {
      throw const ServerException(
        'Invalid create note response: expected object',
      );
    }
    final data = body['data'];
    if (data is! Map) {
      throw const ServerException(
        'Invalid create note response: data must be object',
      );
    }
    return Map<String, dynamic>.from(data);
  }

  Exception _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = ResponseParser.extractMessage(
      error.response?.data,
      'Gagal memproses catatan: $statusCode',
    );
    return Exception(message);
  }
}
