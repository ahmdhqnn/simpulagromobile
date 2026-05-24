import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
import '../models/site_note_model.dart';

class NotesRemoteDataSource {
  final Dio _dio;

  const NotesRemoteDataSource(this._dio);

  /// GET /sites/{siteId}/notes
  Future<List<SiteNoteModel>> getNotes(String siteId, {int? page, int? limit}) async {
    final response = await _dio.get(
      ApiEndpoints.siteNotes(siteId),
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
    return ResponseParser.extractDataList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(SiteNoteModel.fromJson)
        .toList();
  }

  /// POST /sites/{siteId}/notes
  Future<SiteNoteModel> createNote(String siteId, String noteContent) async {
    final response = await _dio.post(
      ApiEndpoints.siteNotes(siteId),
      data: {'note_content': noteContent},
    );
    final data = ResponseParser.extractDataMap(response.data);
    return SiteNoteModel.fromJson(data);
  }
}
