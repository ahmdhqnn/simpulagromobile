class SiteNote {
  final String noteId;
  final String? siteId;
  final String userId;
  final String noteTitle;
  final String noteDesc;
  final String noteContent;
  final DateTime? createdAt;

  const SiteNote({
    required this.noteId,
    this.siteId,
    required this.userId,
    required this.noteTitle,
    required this.noteDesc,
    required this.noteContent,
    this.createdAt,
  });
}
