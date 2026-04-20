/// Domain Entity: Post
/// Pure Dart class, no dependencies
class Post {
  final String postId;
  final String userId;
  final String? siteId;
  final String postContent;
  final String? postImage;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PostUser user;
  final PostSite? site;

  const Post({
    required this.postId,
    required this.userId,
    this.siteId,
    required this.postContent,
    this.postImage,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.isLiked,
    required this.createdAt,
    this.updatedAt,
    required this.user,
    this.site,
  });

  bool get hasImage => postImage != null && postImage!.isNotEmpty;
  bool get isOwnPost =>
      false; // Will be determined by comparing with current user

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} tahun lalu';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan lalu';
    } else if (difference.inDays > 0) {
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

class PostUser {
  final String userId;
  final String userName;
  final String? userAvatar;

  const PostUser({
    required this.userId,
    required this.userName,
    this.userAvatar,
  });
}

class PostSite {
  final String siteId;
  final String siteName;

  const PostSite({required this.siteId, required this.siteName});
}
