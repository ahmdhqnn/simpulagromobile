import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../data/datasources/forum_remote_datasource.dart';
import '../../data/repositories/forum_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/user_comment.dart';
import '../../domain/repositories/forum_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATA SOURCE & REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════

final forumRemoteDataSourceProvider = Provider<ForumRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ForumRemoteDataSource(dioClient.dio);
});

final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  final remoteDataSource = ref.watch(forumRemoteDataSourceProvider);
  return ForumRepositoryImpl(remoteDataSource);
});

// ═══════════════════════════════════════════════════════════
// FORUM POSTS STATE & NOTIFIER
// ═══════════════════════════════════════════════════════════

class ForumState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const ForumState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ForumState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return ForumState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ForumNotifier extends StateNotifier<ForumState> {
  final ForumRepository _repository;

  ForumNotifier(this._repository) : super(const ForumState());

  Future<void> loadPosts({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMore: true,
      );
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true, error: null);
    }

    final page = refresh ? 1 : state.currentPage;
    final result = await _repository.getPosts(page: page, limit: 20);

    result.fold(
      (failure) {
        if (mounted) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
          // Auto retry after 5 seconds if error persists
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && state.error != null && !state.isLoading) {
              loadPosts(refresh: refresh);
            }
          });
        }
      },
      (newPosts) {
        if (mounted) {
          if (refresh) {
            state = ForumState(
              posts: newPosts,
              isLoading: false,
              hasMore: newPosts.length >= 20,
              currentPage: 2, // Next page to fetch
            );
          } else {
            state = ForumState(
              posts: [...state.posts, ...newPosts],
              isLoading: false,
              hasMore: newPosts.length >= 20,
              currentPage: page + 1,
            );
          }
        }
      },
    );
  }

  Future<void> refreshPosts() async {
    state = state.copyWith(isLoading: false, currentPage: 1, hasMore: true);
    await loadPosts(refresh: true);
  }

  Future<void> toggleLike(String postId) async {
    final result = await _repository.toggleLike(postId);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (data) {
        final updatedPosts = state.posts.map((post) {
          if (post.postId == postId) {
            return Post(
              postId: post.postId,
              postTitle: post.postTitle,
              userId: post.userId,
              siteId: post.siteId,
              postContent: post.postContent,
              postImage: post.postImage,
              likeCount: data.likeCount,
              commentCount: post.commentCount,
              shareCount: post.shareCount,
              isLiked: data.isLiked,
              createdAt: post.createdAt,
              updatedAt: post.updatedAt,
              user: post.user,
              site: post.site,
            );
          }
          return post;
        }).toList();

        state = state.copyWith(posts: updatedPosts);
      },
    );
  }

  Future<void> deletePost(String postId) async {
    final result = await _repository.deletePost(postId);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (_) {
        final updatedPosts = state.posts
            .where((p) => p.postId != postId)
            .toList();
        state = state.copyWith(posts: updatedPosts);
      },
    );
  }

  Future<void> sharePost(String postId) async {
    final result = await _repository.sharePost(postId);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (shareCount) {
        final updatedPosts = state.posts.map((post) {
          if (post.postId == postId) {
            return Post(
              postId: post.postId,
              postTitle: post.postTitle,
              userId: post.userId,
              siteId: post.siteId,
              postContent: post.postContent,
              postImage: post.postImage,
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              shareCount: shareCount,
              isLiked: post.isLiked,
              createdAt: post.createdAt,
              updatedAt: post.updatedAt,
              user: post.user,
              site: post.site,
            );
          }
          return post;
        }).toList();

        state = state.copyWith(posts: updatedPosts);
      },
    );
  }

  void updateCommentCount(String postId, int delta) {
    final updatedPosts = state.posts.map((post) {
      if (post.postId == postId) {
        final newCount = (post.commentCount + delta).clamp(0, 999999);
        return Post(
          postId: post.postId,
          postTitle: post.postTitle,
          userId: post.userId,
          siteId: post.siteId,
          postContent: post.postContent,
          postImage: post.postImage,
          likeCount: post.likeCount,
          commentCount: newCount,
          shareCount: post.shareCount,
          isLiked: post.isLiked,
          createdAt: post.createdAt,
          updatedAt: post.updatedAt,
          user: post.user,
          site: post.site,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final forumProvider = StateNotifierProvider<ForumNotifier, ForumState>((ref) {
  final repository = ref.watch(forumRepositoryProvider);
  return ForumNotifier(repository);
});

// ═══════════════════════════════════════════════════════════
// POST DETAIL PROVIDER
// ═══════════════════════════════════════════════════════════

final postDetailProvider = FutureProvider.autoDispose.family<Post, String>((
  ref,
  postId,
) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getPostById(postId);
    return result.fold(
      (failure) => throw failure,
      (post) => post,
    );
  });
});

// ═══════════════════════════════════════════════════════════
// COMMENTS PROVIDER
// ═══════════════════════════════════════════════════════════

class CommentsState {
  final List<Comment> comments;
  final bool isLoading;
  final String? error;

  const CommentsState({
    this.comments = const [],
    this.isLoading = false,
    this.error,
  });

  CommentsState copyWith({
    List<Comment>? comments,
    bool? isLoading,
    String? error,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CommentsNotifier extends StateNotifier<CommentsState> {
  final ForumRepository _repository;
  final String _postId;
  final Ref _ref;

  CommentsNotifier(this._repository, this._postId, this._ref)
    : super(const CommentsState());

  Future<void> loadComments() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.getComments(postId: _postId);
    result.fold(
      (failure) {
        if (mounted) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
          // Auto retry after 5 seconds if error persists
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && state.error != null && !state.isLoading) {
              loadComments();
            }
          });
        }
      },
      (comments) {
        if (mounted) {
          state = CommentsState(comments: comments, isLoading: false);
        }
      },
    );
  }

  Future<void> addComment(String content) async {
    final result = await _repository.createComment(
      postId: _postId,
      content: content,
    );
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (newComment) {
        state = state.copyWith(comments: [newComment, ...state.comments]);
        // Sync comment count ke forum list & post detail
        _ref.read(forumProvider.notifier).updateCommentCount(_postId, 1);
        _ref.invalidate(postDetailProvider(_postId));
      },
    );
  }

  Future<void> deleteComment(String commentId) async {
    final result = await _repository.deleteComment(postId: _postId, commentId: commentId);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (_) {
        final updatedComments = state.comments
            .where((c) => c.commentId != commentId)
            .toList();
        state = state.copyWith(comments: updatedComments);
        // Sync comment count ke forum list & post detail
        _ref.read(forumProvider.notifier).updateCommentCount(_postId, -1);
        _ref.invalidate(postDetailProvider(_postId));

        _ref.invalidate(myCommentsProvider);
      },
    );
  }
}

final commentsProvider = StateNotifierProvider.autoDispose
    .family<CommentsNotifier, CommentsState, String>((ref, postId) {
      final repository = ref.watch(forumRepositoryProvider);
      return CommentsNotifier(repository, postId, ref);
    });

// ═══════════════════════════════════════════════════════════
// MY POSTS PROVIDER
// ═══════════════════════════════════════════════════════════

final myPostsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getMyPosts();
    return result.fold(
      (failure) => throw failure,
      (posts) => posts,
    );
  });
});

final likedPostsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getLikedPosts();
    return result.fold(
      (failure) => throw failure,
      (posts) => posts,
    );
  });
});

final myCommentsProvider = FutureProvider.autoDispose<List<UserComment>>((
  ref,
) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getMyComments();
    return result.fold(
      (failure) => throw failure,
      (comments) => comments,
    );
  });
});
