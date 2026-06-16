import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/notes/data/models/site_note_model.dart';

void main() {
  test('SiteNoteModel parses backend fields', () {
    final model = SiteNoteModel.fromJson({
      'note_id': 'NOTE_001',
      'site_id': 'SITE_001',
      'user_id': 'USR_001',
      'note_title': 'Irigasi',
      'note_desc': 'Catatan penting',
      'note_createed': '2026-05-13T00:00:00.000Z',
    });

    expect(model.noteId, 'NOTE_001');
    expect(model.siteId, 'SITE_001');
    expect(model.userId, 'USR_001');
    expect(model.noteTitle, 'Irigasi');
    expect(model.noteDesc, 'Catatan penting');
    expect(model.noteContent, 'Irigasi');
    expect(model.createdAt, isNotNull);

    final entity = model.toEntity();
    expect(entity.noteTitle, 'Irigasi');
    expect(entity.noteDesc, 'Catatan penting');
  });
}
