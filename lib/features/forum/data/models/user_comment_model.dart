import '../../domain/entities/user_comment.dart';
import 'json_parser.dart';

class UserCommentModel extends UserComment {
  const UserCommentModel({
    required super.commentId,
    required super.forumId,
    required super.postTitle,
    required super.commentContent,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserCommentModel.fromJson(Map<String, dynamic> json) {
    final postJson = JsonParser.parseMap(json['post']);

    return UserCommentModel(
      commentId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['comment_id', 'id']),
      ),
      forumId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['forum_id', 'post_id']) ??
            postJson['forum_id'] ??
            postJson['post_id'],
      ),
      postTitle: JsonParser.parseString(
        postJson['forum_title'] ??
            postJson['post_title'] ??
            postJson['title'] ??
            JsonParser.tryKeys(json, ['forum_title', 'post_title']),
        defaultValue: 'Tanpa Judul',
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
      updatedAt: JsonParser.parseDateTimeOrNull(
        JsonParser.tryKeys(json, [
          'cf_updated',
          'comment_update',
          'updated_at',
          'updatedAt',
        ]),
      ),
    );
  }
}
