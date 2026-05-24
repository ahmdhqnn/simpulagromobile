import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/reaction_model.dart';
import '../models/user_comment_model.dart';
import '../models/json_parser.dart';

class ForumRemoteDataSource {
  final Dio _dio;

  ForumRemoteDataSource(this._dio);

  // ═══════════════════════════════════════════════════════════
  // HELPER: Response data extraction
  // ═══════════════════════════════════════════════════════════

  dynamic _extractResponseData(dynamic responseData) {
    if (responseData is Map) {
      final map = JsonParser.parseMap(responseData);
      if (map.containsKey('data')) return map['data'];
      if (map.containsKey('result')) return map['result'];
      return map;
    }
    return responseData;
  }

  List _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final map = JsonParser.parseMap(data);
      const possibleKeys = [
        'posts',
        'rows',
        'comments',
        'reactions',
        'items',
        'data',
        'results',
        'list',
      ];
      for (final key in possibleKeys) {
        if (map[key] is List) return map[key] as List;
      }

      for (final value in map.values) {
        if (value is List) return value;
      }
    }
    return [];
  }

  Map<String, dynamic>? _extractObject(
    dynamic data, {
    List<String> nestedKeys = const ['post', 'comment', 'reaction'],
    List<String> requiredFieldsAny = const [],
  }) {
    if (data is! Map) return null;
    final map = JsonParser.parseMap(data);

    for (final field in requiredFieldsAny) {
      if (map.containsKey(field)) return map;
    }

    // Coba nested keys
    for (final key in nestedKeys) {
      if (map[key] is Map) {
        return JsonParser.parseMap(map[key]);
      }
    }

    return map;
  }

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
        ApiEndpoints.forumPosts,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (siteId != null) 'site_id': siteId,
        },
      );

      final rawData = _extractResponseData(response.data);
      final list = _extractList(rawData);
      return list
          .map((json) => PostModel.fromJson(JsonParser.parseMap(json)))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostModel> getPostById(String postId) async {
    try {
      final response = await _dio.get(ApiEndpoints.forumPostById(postId));
      final data = _extractResponseData(response.data);
      final obj = _extractObject(
        data,
        requiredFieldsAny: ['forum_id', 'post_id', 'id'],
      );
      if (obj == null) {
        throw Exception('Format response tidak valid');
      }
      return PostModel.fromJson(obj);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostModel> createPost({
    required String title,
    required String siteId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final formData = FormData.fromMap({
        'site_id': siteId,
        'forum_title': title,
        'forum_content': content,
      });

      if (imageUrl != null && imageUrl.isNotEmpty) {
        if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
          formData.fields.add(MapEntry('forum_image_url', imageUrl));
          formData.fields.add(MapEntry('image', imageUrl));
        } else {
          formData.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(imageUrl),
          ));
        }
      }

      final response = await _dio.post(ApiEndpoints.forumPosts, data: formData);
      final data = _extractResponseData(response.data);
      final obj = _extractObject(
        data,
        requiredFieldsAny: ['forum_id', 'post_id', 'id'],
      );
      if (obj == null) {
        throw Exception('Format response tidak valid');
      }
      return PostModel.fromJson(obj);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostModel> updatePost({
    required String postId,
    String? title,
    String? content,
    String? imageUrl,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (title != null) 'forum_title': title,
        if (content != null) 'forum_content': content,
      });

      if (imageUrl != null && imageUrl.isNotEmpty) {
        if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
          formData.fields.add(MapEntry('forum_image_url', imageUrl));
          formData.fields.add(MapEntry('image', imageUrl));
        } else {
          formData.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(imageUrl),
          ));
        }
      }

      final response = await _dio.put(ApiEndpoints.forumPostById(postId), data: formData);
      final data = _extractResponseData(response.data);
      final obj = _extractObject(
        data,
        requiredFieldsAny: ['forum_id', 'post_id', 'id'],
      );
      if (obj == null) {
        throw Exception('Format response tidak valid');
      }
      return PostModel.fromJson(obj);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _dio.delete(ApiEndpoints.forumPostById(postId));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PostModel>> getMyPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.forumMyPosts,
        queryParameters: {'page': page, 'limit': limit},
      );

      final rawData = _extractResponseData(response.data);
      final list = _extractList(rawData);
      return list
          .map((json) => PostModel.fromJson(JsonParser.parseMap(json)))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PostModel>> getLikedPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.forumLikedPosts,
        queryParameters: {'page': page, 'limit': limit},
      );

      final rawData = _extractResponseData(response.data);
      final list = _extractList(rawData);
      return list
          .map((json) => PostModel.fromJson(JsonParser.parseMap(json)))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserCommentModel>> getMyComments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.forumMyComments,
        queryParameters: {'page': page, 'limit': limit},
      );

      final rawData = _extractResponseData(response.data);
      final list = _extractList(rawData);
      return list
          .map((json) => UserCommentModel.fromJson(JsonParser.parseMap(json)))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // INTERACTIONS
  // ═══════════════════════════════════════════════════════════

  Future<({bool isLiked, int likeCount})> toggleLike(String postId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.forumPostLike(postId),
        data: {'action': 'LIKE'},
      );
      final data = _extractResponseData(response.data);
      final map = JsonParser.parseMap(data);
      return (
        isLiked: JsonParser.parseBool(map['is_liked']),
        likeCount: JsonParser.parseInt(
          map['like_count'] ?? map['forum_like_count'],
        ),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<int> sharePost(String postId) async {
    try {
      final response = await _dio.post(ApiEndpoints.forumPostShare(postId));
      final data = _extractResponseData(response.data);
      if (data is num) return data.toInt();
      final map = JsonParser.parseMap(data);
      return JsonParser.parseInt(
        map['share_count'] ?? map['forum_share_count'],
      );
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
        ApiEndpoints.forumPostComments(postId),
        queryParameters: {'page': page, 'limit': limit},
      );

      final rawData = _extractResponseData(response.data);
      final list = _extractList(rawData);
      return list
          .map((json) => CommentModel.fromJson(JsonParser.parseMap(json)))
          .toList();
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
        ApiEndpoints.forumPostComments(postId),
        data: {'cf_content': content},
      );
      final data = _extractResponseData(response.data);
      final obj = _extractObject(data, requiredFieldsAny: ['comment_id', 'id']);
      if (obj == null) {
        throw Exception('Format response tidak valid');
      }
      return CommentModel.fromJson(obj);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _dio.delete(ApiEndpoints.forumDeleteComment(postId, commentId));
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // REACTIONS
  // ═══════════════════════════════════════════════════════════

  Future<List<ReactionModel>> getReactions(String postId) async {
    try {
      final response = await _dio.get(ApiEndpoints.forumPostReactions(postId));
      final rawData = _extractResponseData(response.data);
      final list = _extractList(rawData);
      return list
          .map((json) => ReactionModel.fromJson(JsonParser.parseMap(json)))
          .toList();
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
          String message = 'Terjadi kesalahan';
          final responseData = error.response?.data;
          if (responseData is Map) {
            final map = JsonParser.parseMap(responseData);
            message = JsonParser.parseString(
              map['message'] ?? map['error'] ?? map['detail'],
              defaultValue: message,
            );
          }
          if (statusCode == 404) {
            return Exception('Data tidak ditemukan');
          } else if (statusCode == 403) {
            return Exception('Anda tidak memiliki akses');
          } else if (statusCode == 401) {
            return Exception(
              'Sesi Anda telah berakhir. Silakan login kembali.',
            );
          } else if (statusCode == 422 || statusCode == 400) {
            return Exception(
              message.isEmpty ? 'Data yang dikirim tidak valid' : message,
            );
          } else if (statusCode != null && statusCode >= 500) {
            return Exception(
              'Server sedang bermasalah. Coba beberapa saat lagi.',
            );
          }
          return Exception(message);
        case DioExceptionType.cancel:
          return Exception('Request dibatalkan');
        case DioExceptionType.connectionError:
          return Exception('Tidak dapat terhubung ke server');
        case DioExceptionType.unknown:
          if (error.message?.contains('SocketException') ?? false) {
            return Exception('Tidak dapat terhubung ke server');
          }
          return Exception('Terjadi kesalahan: ${error.message}');
        default:
          return Exception('Terjadi kesalahan tidak terduga');
      }
    }
    if (error is Exception) return error;
    return Exception('Terjadi kesalahan: $error');
  }
}
