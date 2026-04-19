import '../../domain/entities/post.dart';

/// Data Model: Post
/// Extends Entity dan menambahkan serialization logic
class PostModel extends Post {
  const PostModel({
    required super.postId,
    required super.userId,
    super.siteId,
    required super.postContent,
    super.postImage,
    required super.likeCount,
    required super.commentCount,
    required super.shareCount,
    required super.isLiked,
    required super.createdAt,
    super.updatedAt,
    required super.user,
    super.site,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'] ?? '',
      userId: json['user_id'] ?? '',
      siteId: json['site_id'],
      postContent: json['post_content'] ?? '',
      postImage: json['post_image'],
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      user: PostUserModel.fromJson(json['user'] ?? {}),
      site: json['site'] != null ? PostSiteModel.fromJson(json['site']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'site_id': siteId,
      'post_content': postContent,
      'post_image': postImage,
      'like_count': likeCount,
      'comment_count': commentCount,
      'share_count': shareCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class PostUserModel extends PostUser {
  const PostUserModel({
    required super.userId,
    required super.userName,
    super.userAvatar,
  });

  factory PostUserModel.fromJson(Map<String, dynamic> json) {
    return PostUserModel(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? 'Unknown User',
      userAvatar: json['user_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
    };
  }
}

class PostSiteModel extends PostSite {
  const PostSiteModel({required super.siteId, required super.siteName});

  factory PostSiteModel.fromJson(Map<String, dynamic> json) {
    return PostSiteModel(
      siteId: json['site_id'] ?? '',
      siteName: json['site_name'] ?? 'Unknown Site',
    );
  }

  Map<String, dynamic> toJson() {
    return {'site_id': siteId, 'site_name': siteName};
  }
}
