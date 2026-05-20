import '../../domain/entities/post.dart';
import 'json_parser.dart';

/// Data Model: Post
/// Extends Entity dan menambahkan serialization logic.
/// Robust terhadap variasi response API (type casting safe).
class PostModel extends Post {
  const PostModel({
    required super.postId,
    required super.postTitle,
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
    final userJson = JsonParser.parseMap(json['user']);
    final siteJson = JsonParser.parseMapOrNull(json['site']);

    return PostModel(
      postId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['forum_id', 'post_id', 'id']),
      ),
      postTitle: JsonParser.parseString(
        JsonParser.tryKeys(json, ['forum_title', 'post_title', 'title']),
      ),
      userId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['forum_user_id', 'user_id']) ??
            userJson['user_id'],
      ),
      siteId: JsonParser.parseStringOrNull(
        JsonParser.tryKeys(json, ['forum_site_id', 'site_id']),
      ),
      postContent: JsonParser.parseString(
        JsonParser.tryKeys(json, ['forum_content', 'post_content', 'content']),
      ),
      postImage: JsonParser.parseStringOrNull(
        JsonParser.tryKeys(json, ['forum_image_url', 'post_image', 'image_url']),
      ),
      likeCount: JsonParser.parseInt(
        JsonParser.tryKeys(json, ['forum_like_count', 'like_count']),
      ),
      commentCount: JsonParser.parseInt(
        JsonParser.tryKeys(json, ['comment_count', 'forum_comment_count']),
      ),
      shareCount: JsonParser.parseInt(
        JsonParser.tryKeys(json, ['forum_share_count', 'share_count']),
      ),
      isLiked: JsonParser.parseBool(json['is_liked']),
      createdAt: JsonParser.parseDateTime(
        JsonParser.tryKeys(json, ['forum_created', 'created_at', 'createdAt']),
      ),
      updatedAt: JsonParser.parseDateTimeOrNull(
        JsonParser.tryKeys(json, ['forum_update', 'updated_at', 'updatedAt']),
      ),
      user: PostUserModel.fromJson(userJson),
      site: siteJson != null ? PostSiteModel.fromJson(siteJson) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'forum_id': postId,
      'forum_title': postTitle,
      'forum_user_id': userId,
      'forum_site_id': siteId,
      'forum_content': postContent,
      'forum_image_url': postImage,
      'forum_like_count': likeCount,
      'comment_count': commentCount,
      'forum_share_count': shareCount,
      'is_liked': isLiked,
      'forum_created': createdAt.toIso8601String(),
      'forum_update': updatedAt?.toIso8601String(),
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
      userId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['user_id', 'forum_user_id', 'id']),
      ),
      userName: JsonParser.parseString(
        JsonParser.tryKeys(json, ['user_name', 'username', 'name']),
        defaultValue: 'Unknown User',
      ),
      userAvatar: JsonParser.parseStringOrNull(
        JsonParser.tryKeys(json, ['user_avatar', 'avatar', 'avatar_url']),
      ),
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
      siteId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['site_id', 'id']),
      ),
      siteName: JsonParser.parseString(
        JsonParser.tryKeys(json, ['site_name', 'name']),
        defaultValue: 'Unknown Site',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'site_id': siteId, 'site_name': siteName};
  }
}
