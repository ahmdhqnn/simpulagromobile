import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/notes/data/datasources/notes_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(String path, dynamic data) {
  return Response(
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
    data: data,
  );
}

void main() {
  late MockDio dio;
  late NotesRemoteDataSource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = NotesRemoteDataSource(dio);
  });

  test('getNotes accepts dynamic map rows from backend', () async {
    when(
      () => dio.get(
        ApiEndpoints.siteNotes('SITE001'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => _response(ApiEndpoints.siteNotes('SITE001'), {
        'success': true,
        'data': [
          {
            'note_id': 'NOTE001',
            'site_id': 'SITE001',
            'user_id': 'USR001',
            'note_title': 'Irigasi',
            'note_desc': 'Perlu cek irigasi',
          },
        ],
      }),
    );

    final result = await dataSource.getNotes('SITE001');

    expect(result, hasLength(1));
    expect(result.first.noteTitle, 'Irigasi');
    expect(result.first.noteDesc, 'Perlu cek irigasi');
  });

  test('createNote parses documented created note object', () async {
    when(
      () => dio.post(
        ApiEndpoints.siteNotes('SITE001'),
        data: {'note_title': 'Irigasi', 'note_desc': 'Catatan baru'},
      ),
    ).thenAnswer(
      (_) async => _response(ApiEndpoints.siteNotes('SITE001'), {
        'success': true,
        'data': {
          'note_id': 'NOTE002',
          'site_id': 'SITE001',
          'user_id': 'USR001',
          'note_title': 'Irigasi',
          'note_desc': 'Catatan baru',
          'created_at': '2026-05-13T00:00:00.000Z',
        },
      }),
    );

    final result = await dataSource.createNote(
      siteId: 'SITE001',
      noteTitle: 'Irigasi',
      noteDesc: 'Catatan baru',
    );

    expect(result.noteId, 'NOTE002');
    expect(result.siteId, 'SITE001');
    expect(result.noteTitle, 'Irigasi');
    expect(result.noteDesc, 'Catatan baru');
  });
}
