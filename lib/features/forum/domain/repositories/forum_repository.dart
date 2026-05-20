import '../entities/post.dart';
import '../entities/comment.dart';
import '../entities/reaction.dart';
import '../entities/user_comment.dart';

abstract class ForumRepository {
  // ─── Posts ─────────────────────────────────────────
  Future<List<Post>> getPosts({int page = 1, int limit = 20, String? siteId});
  Future<Post> getPostById(String postId);
  Future<Post> createPost({
    required String title,
    required String siteId,
    required String content,
    String? imageUrl,
  });
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    String? imageUrl,
  });
  Future<void> deletePost(String postId);
  Future<List<Post>> getMyPosts({int page = 1, int limit = 20});
  Future<List<Post>> getLikedPosts({int page = 1, int limit = 20});
  Future<List<UserComment>> getMyComments({int page = 1, int limit = 20});

  // ─── Interactions ──────────────────────────────────
  Future<({bool isLiked, int likeCount})> toggleLike(String postId);
  Future<int> sharePost(String postId);

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
