import '../entities/post.dart';
import '../entities/comment.dart';
import '../entities/reaction.dart';

/// Repository Interface (Contract)
/// Domain layer tidak tahu implementasi detail
abstract class ForumRepository {
  // ─── Posts ─────────────────────────────────────────
  Future<List<Post>> getPosts({int page = 1, int limit = 20, String? siteId});
  Future<Post> getPostById(String postId);
  Future<Post> createPost({
    required String siteId,
    required String content,
    String? imageUrl,
  });
  Future<Post> updatePost({
    required String postId,
    String? content,
    String? imageUrl,
  });
  Future<void> deletePost(String postId);
  Future<List<Post>> getMyPosts({int page = 1, int limit = 20});

  // ─── Interactions ──────────────────────────────────
  Future<({bool isLiked, int likeCount})> toggleLike(String postId);
  Future<void> sharePost(String postId);

  // ─── Comments ──────────────────────────────────────
  Future<List<Comment>> getComments({
    required String postId,
    int page = 1,
    int limit = 50,
  });
  Future<Comment> createComment({
    required String postId,
    required String content,
  });
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  });

  // ─── Reactions ─────────────────────────────────────
  Future<List<Reaction>> getReactions(String postId);
}
