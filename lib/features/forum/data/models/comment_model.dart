import '../../domain/entities/comment.dart';

/// Data Model: Comment
/// Extends Entity dan menambahkan serialization logic
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
    return CommentModel(
      commentId: json['comment_id'] ?? '',
      postId: json['post_id'] ?? '',
      userId: json['user_id'] ?? '',
      commentContent: json['comment_content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      user: CommentUserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'post_id': postId,
      'user_id': userId,
      'comment_content': commentContent,
      'created_at': createdAt.toIso8601String(),
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
