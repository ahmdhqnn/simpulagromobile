import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paginated_result.dart';
import '../entities/post.dart';
import '../entities/comment.dart';
import '../entities/reaction.dart';
import '../entities/user_comment.dart';

abstract class ForumRepository {
  // ─── Posts ─────────────────────────────────────────
  Future<Either<Failure, List<Post>>> getPosts({
    int page = 1,
    int limit = 20,
    String? siteId,
  });
  Future<Either<Failure, PaginatedResult<Post>>> getPaginatedPosts({
    int page = 1,
    int limit = 20,
    String? siteId,
  });
  Future<Either<Failure, Post>> getPostById(String postId);
  Future<Either<Failure, Post>> createPost({
    required String title,
    required String siteId,
    required String content,
    String? imageUrl,
  });
  Future<Either<Failure, Post>> updatePost({
    required String postId,
    String? title,
    String? content,
    String? imageUrl,
  });
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, List<Post>>> getMyPosts({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<Post>>> getLikedPosts({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<UserComment>>> getMyComments({
    int page = 1,
    int limit = 20,
  });

  // ─── Interactions ──────────────────────────────────
  Future<Either<Failure, ({bool isLiked, int likeCount})>> toggleLike(
    String postId,
  );
  Future<Either<Failure, ({bool isLiked, int likeCount})>> toggleDislike(
    String postId,
  );
  Future<Either<Failure, int>> sharePost(String postId);

  // ─── Comments ──────────────────────────────────────
  Future<Either<Failure, List<Comment>>> getComments({
    required String postId,
    int page = 1,
    int limit = 50,
  });
  Future<Either<Failure, PaginatedResult<Comment>>> getPaginatedComments({
    required String postId,
    int page = 1,
    int limit = 50,
  });
  Future<Either<Failure, Comment>> createComment({
    required String postId,
    required String content,
  });
  Future<Either<Failure, void>> deleteComment({
    required String postId,
    required String commentId,
  });
  Future<Either<Failure, Comment>> updateComment({
    required String commentId,
    required String content,
  });
  Future<Either<Failure, void>> deleteCommentGlobal(String commentId);

  // ─── Reactions ─────────────────────────────────────
  Future<Either<Failure, List<Reaction>>> getReactions(String postId);
}
