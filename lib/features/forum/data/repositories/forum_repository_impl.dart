import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/reaction.dart';
import '../../domain/repositories/forum_repository.dart';
import '../datasources/forum_remote_datasource.dart';

/// Repository Implementation
/// Mengimplementasikan contract dari domain layer
/// Bertanggung jawab untuk orchestration data dari berbagai sumber
class ForumRepositoryImpl implements ForumRepository {
  final ForumRemoteDataSource _remoteDataSource;

  ForumRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Post>> getPosts({
    int page = 1,
    int limit = 20,
    String? siteId,
  }) async {
    try {
      return await _remoteDataSource.getPosts(
        page: page,
        limit: limit,
        siteId: siteId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Post> getPostById(String postId) async {
    try {
      return await _remoteDataSource.getPostById(postId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Post> createPost({
    required String siteId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      return await _remoteDataSource.createPost(
        siteId: siteId,
        content: content,
        imageUrl: imageUrl,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Post> updatePost({
    required String postId,
    String? content,
    String? imageUrl,
  }) async {
    try {
      return await _remoteDataSource.updatePost(
        postId: postId,
        content: content,
        imageUrl: imageUrl,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _remoteDataSource.deletePost(postId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Post>> getMyPosts({int page = 1, int limit = 20}) async {
    try {
      return await _remoteDataSource.getMyPosts(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<({bool isLiked, int likeCount})> toggleLike(String postId) async {
    try {
      return await _remoteDataSource.toggleLike(postId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sharePost(String postId) async {
    try {
      await _remoteDataSource.sharePost(postId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Comment>> getComments({
    required String postId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      return await _remoteDataSource.getComments(
        postId: postId,
        page: page,
        limit: limit,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Comment> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      return await _remoteDataSource.createComment(
        postId: postId,
        content: content,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _remoteDataSource.deleteComment(
        postId: postId,
        commentId: commentId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Reaction>> getReactions(String postId) async {
    try {
      return await _remoteDataSource.getReactions(postId);
    } catch (e) {
      rethrow;
    }
  }
}
