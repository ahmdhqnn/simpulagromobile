import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/reaction_model.dart';

/// Remote Data Source
/// Bertanggung jawab untuk komunikasi dengan API
class ForumRemoteDataSource {
  final Dio _dio;

  ForumRemoteDataSource(this._dio);

  // ═══════════════════════════════════════════════════════════
  // POSTS
  // ═══════════════════════════════════════════════════════════

  Future<List<PostModel>> getPosts({
    int page = 1,
    int limit = 20,
    String? siteId,
  }) async {
    try {
      final response = await _dio.get(
        '/forum/posts',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (siteId != null) 'site_id': siteId,
        },
      );

      final data = response.data['data'] as List;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostModel> getPostById(String postId) async {
    try {
      final response = await _dio.get('/forum/posts/$postId');
      return PostModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostModel> createPost({
    required String siteId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/forum/posts',
        data: {
          'site_id': siteId,
          'post_content': content,
          if (imageUrl != null) 'post_image': imageUrl,
        },
      );
      return PostModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostModel> updatePost({
    required String postId,
    String? content,
    String? imageUrl,
  }) async {
    try {
      final response = await _dio.put(
        '/forum/posts/$postId',
        data: {
          if (content != null) 'post_content': content,
          if (imageUrl != null) 'post_image': imageUrl,
        },
      );
      return PostModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _dio.delete('/forum/posts/$postId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PostModel>> getMyPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/forum/my-posts',
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'] as List;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // INTERACTIONS
  // ═══════════════════════════════════════════════════════════

  Future<({bool isLiked, int likeCount})> toggleLike(String postId) async {
    try {
      final response = await _dio.post('/forum/posts/$postId/like');
      final data = response.data['data'];
      return (
        isLiked: (data['is_liked'] ?? false) as bool,
        likeCount: (data['like_count'] ?? 0) as int,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> sharePost(String postId) async {
    try {
      await _dio.post('/forum/posts/$postId/share');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // COMMENTS
  // ═══════════════════════════════════════════════════════════

  Future<List<CommentModel>> getComments({
    required String postId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        '/forum/posts/$postId/comments',
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'] as List;
      return data.map((json) => CommentModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<CommentModel> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        '/forum/posts/$postId/comments',
        data: {'comment_content': content},
      );
      return CommentModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _dio.delete('/forum/posts/$postId/comments/$commentId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // REACTIONS
  // ═══════════════════════════════════════════════════════════

  Future<List<ReactionModel>> getReactions(String postId) async {
    try {
      final response = await _dio.get('/forum/posts/$postId/reactions');
      final data = response.data['data'] as List;
      return data.map((json) => ReactionModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ERROR HANDLING
  // ═══════════════════════════════════════════════════════════

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Koneksi timeout. Periksa koneksi internet Anda.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message =
              error.response?.data['message'] ?? 'Terjadi kesalahan';
          if (statusCode == 404) {
            return Exception('Data tidak ditemukan');
          } else if (statusCode == 403) {
            return Exception('Anda tidak memiliki akses');
          } else if (statusCode == 401) {
            return Exception(
              'Sesi Anda telah berakhir. Silakan login kembali.',
            );
          }
          return Exception(message);
        case DioExceptionType.cancel:
          return Exception('Request dibatalkan');
        case DioExceptionType.unknown:
          if (error.message?.contains('SocketException') ?? false) {
            return Exception('Tidak dapat terhubung ke server');
          }
          return Exception('Terjadi kesalahan: ${error.message}');
        default:
          return Exception('Terjadi kesalahan tidak terduga');
      }
    }
    return Exception('Terjadi kesalahan: $error');
  }
}
