import '../../domain/entities/site_note.dart';

class SiteNoteModel {
  final String noteId;
  final String? siteId;
  final String userId;
  final String noteTitle;
  final String noteDesc;
  final String noteContent;
  final DateTime? createdAt;

  const SiteNoteModel({
    required this.noteId,
    this.siteId,
    required this.userId,
    required this.noteTitle,
    required this.noteDesc,
    required this.noteContent,
    this.createdAt,
  });

  factory SiteNoteModel.fromJson(Map<String, dynamic> json) {
    final title = json['note_title']?.toString() ?? '';
    final desc =
        json['note_desc']?.toString() ?? json['note_content']?.toString() ?? '';
    return SiteNoteModel(
      noteId: json['note_id']?.toString() ?? '',
      siteId: json['site_id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      noteTitle: title,
      noteDesc: desc,
      noteContent: title.isEmpty ? desc : title,
      createdAt: _dateTimeValue(json['created_at'] ?? json['note_createed']),
    );
  }

  SiteNote toEntity() => SiteNote(
    noteId: noteId,
    siteId: siteId,
    userId: userId,
    noteTitle: noteTitle,
    noteDesc: noteDesc,
    noteContent: noteContent,
    createdAt: createdAt,
  );
}

DateTime? _dateTimeValue(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
