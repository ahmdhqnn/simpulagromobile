class UserComment {
  final String commentId;
  final String forumId;
  final String postTitle;
  final String commentContent;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserComment({
    required this.commentId,
    required this.forumId,
    required this.postTitle,
    required this.commentContent,
    required this.createdAt,
    this.updatedAt,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}
