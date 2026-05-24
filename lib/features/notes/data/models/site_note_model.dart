import '../../domain/entities/site_note.dart';

class SiteNoteModel {
  final String noteId;
  final String? siteId;
  final String userId;
  final String noteContent;
  final DateTime? createdAt;

  const SiteNoteModel({
    required this.noteId,
    this.siteId,
    required this.userId,
    required this.noteContent,
    this.createdAt,
  });

  factory SiteNoteModel.fromJson(Map<String, dynamic> json) {
    return SiteNoteModel(
      noteId: json['note_id']?.toString() ?? '',
      siteId: json['site_id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      noteContent: json['note_content']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  SiteNote toEntity() => SiteNote(
        noteId: noteId,
        siteId: siteId,
        userId: userId,
        noteContent: noteContent,
        createdAt: createdAt,
      );
}
