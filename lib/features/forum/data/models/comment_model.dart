import '../../domain/entities/comment.dart';
import 'json_parser.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.commentId,
    required super.postId,
    required super.userId,
    required super.commentContent,
    required super.createdAt,
    required super.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final userJson = JsonParser.parseMap(json['user']);

    return CommentModel(
      commentId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['comment_id', 'id']),
      ),
      postId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['forum_id', 'post_id']),
      ),
      userId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['user_id', 'comment_user_id']) ??
            userJson['user_id'],
      ),
      commentContent: JsonParser.parseString(
        JsonParser.tryKeys(json, ['cf_content', 'comment_content', 'content']),
      ),
      createdAt: JsonParser.parseDateTime(
        JsonParser.tryKeys(json, [
          'cf_created',
          'comment_created',
          'created_at',
          'createdAt',
        ]),
      ),
      user: CommentUserModel.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'forum_id': postId,
      'user_id': userId,
      'comment_content': commentContent,
      'comment_created': createdAt.toIso8601String(),
    };
  }
}

class CommentUserModel extends CommentUser {
  const CommentUserModel({
    required super.userId,
    required super.userName,
    super.userAvatar,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      userId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['user_id', 'id']),
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
