import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paginated_result.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/reaction.dart';
import '../../domain/entities/user_comment.dart';
import '../../domain/repositories/forum_repository.dart';
import '../datasources/forum_remote_datasource.dart';

class ForumRepositoryImpl implements ForumRepository {
  final ForumRemoteDataSource _remoteDataSource;

  ForumRepositoryImpl(this._remoteDataSource);

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timeout');
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('No internet connection');
    }
    final statusCode = e.response?.statusCode;
    String message = 'Unknown error';
    if (e.response?.data is Map) {
      message = e.response?.data['message'] ?? e.message ?? 'Unknown error';
    } else {
      message = e.message ?? 'Unknown error';
    }

    switch (statusCode) {
      case 401:
        return AuthFailure(message);
      case 403:
        return PermissionFailure(message);
      case 404:
        return NotFoundFailure(message);
      case 409:
        return ValidationFailure(message);
      default:
        return ServerFailure(message, statusCode: statusCode);
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts({
    int page = 1,
    int limit = 20,
    String? siteId,
  }) async {
    final result = await getPaginatedPosts(
      page: page,
      limit: limit,
      siteId: siteId,
    );
    return result.map((page) => page.items);
  }

  @override
  Future<Either<Failure, PaginatedResult<Post>>> getPaginatedPosts({
    int page = 1,
    int limit = 20,
    String? siteId,
  }) async {
    try {
      final pageData = await _remoteDataSource.getPaginatedPosts(
        page: page,
        limit: limit,
        siteId: siteId,
      );
      return Right(
        PaginatedResult<Post>(items: pageData.items, meta: pageData.meta),
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> getPostById(String postId) async {
    try {
      final post = await _remoteDataSource.getPostById(postId);
      return Right(post);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost({
    required String title,
    required String siteId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final post = await _remoteDataSource.createPost(
        title: title,
        siteId: siteId,
        content: content,
        imageUrl: imageUrl,
      );
      return Right(post);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> updatePost({
    required String postId,
    String? title,
    String? content,
    String? imageUrl,
  }) async {
    try {
      final post = await _remoteDataSource.updatePost(
        postId: postId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      );
      return Right(post);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await _remoteDataSource.deletePost(postId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getMyPosts({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final posts = await _remoteDataSource.getMyPosts(
        page: page,
        limit: limit,
      );
      return Right(posts);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getLikedPosts({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final posts = await _remoteDataSource.getLikedPosts(
        page: page,
        limit: limit,
      );
      return Right(posts);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserComment>>> getMyComments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final comments = await _remoteDataSource.getMyComments(
        page: page,
        limit: limit,
      );
      return Right(comments);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({bool isLiked, int likeCount})>> toggleLike(
    String postId,
  ) async {
    try {
      final result = await _remoteDataSource.toggleLike(postId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({bool isLiked, int likeCount})>> toggleDislike(
    String postId,
  ) async {
    try {
      final result = await _remoteDataSource.toggleDislike(postId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> sharePost(String postId) async {
    try {
      final result = await _remoteDataSource.sharePost(postId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments({
    required String postId,
    int page = 1,
    int limit = 50,
  }) async {
    final result = await getPaginatedComments(
      postId: postId,
      page: page,
      limit: limit,
    );
    return result.map((page) => page.items);
  }

  @override
  Future<Either<Failure, PaginatedResult<Comment>>> getPaginatedComments({
    required String postId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final pageData = await _remoteDataSource.getPaginatedComments(
        postId: postId,
        page: page,
        limit: limit,
      );
      return Right(
        PaginatedResult<Comment>(items: pageData.items, meta: pageData.meta),
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      final comment = await _remoteDataSource.createComment(
        postId: postId,
        content: content,
      );
      return Right(comment);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _remoteDataSource.deleteComment(
        postId: postId,
        commentId: commentId,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      final comment = await _remoteDataSource.updateComment(
        commentId: commentId,
        content: content,
      );
      return Right(comment);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCommentGlobal(String commentId) async {
    try {
      await _remoteDataSource.deleteCommentGlobal(commentId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Reaction>>> getReactions(String postId) async {
    try {
      final reactions = await _remoteDataSource.getReactions(postId);
      return Right(reactions);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
