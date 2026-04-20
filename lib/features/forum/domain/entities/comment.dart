/// Domain Entity: Comment
/// Pure Dart class, no dependencies
class Comment {
  final String commentId;
  final String postId;
  final String userId;
  final String commentContent;
  final DateTime createdAt;
  final CommentUser user;

  const Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.commentContent,
    required this.createdAt,
    required this.user,
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

class CommentUser {
  final String userId;
  final String userName;
  final String? userAvatar;

  const CommentUser({
    required this.userId,
    required this.userName,
    this.userAvatar,
  });
}
