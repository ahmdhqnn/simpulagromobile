import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/paginated_result.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../data/datasources/forum_remote_datasource.dart';
import '../../data/repositories/forum_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/user_comment.dart';
import '../../domain/entities/reaction.dart';
import '../../domain/repositories/forum_repository.dart';

final forumRemoteDataSourceProvider = Provider<ForumRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ForumRemoteDataSource(dioClient.dio);
});

final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  final remoteDataSource = ref.watch(forumRemoteDataSourceProvider);
  return ForumRepositoryImpl(remoteDataSource);
});

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
  Timer? _pollingTimer;

  static const _pollingInterval = Duration(seconds: 30);
  static const _pageLimit = 20;

  ForumNotifier(this._repository) : super(const ForumState());

  void startRealtime() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      _silentRefresh();
    });
  }

  void stopRealtime() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _silentRefresh() async {
    if (state.isLoading) return;
    try {
      final result = await _repository.getPaginatedPosts(
        page: 1,
        limit: _pageLimit,
      );
      result.fold((_) {}, (newPosts) {
        if (!mounted) return;

        final existingIds = state.posts.map((p) => p.postId).toSet();
        final newIds = newPosts.items.map((p) => p.postId).toSet();
        final incomingById = <String, Post>{
          for (final item in newPosts.items) item.postId: item,
        };

        final addedPosts = newPosts.items
            .where((p) => !existingIds.contains(p.postId))
            .cast<Post>()
            .toList();

        final updatedExisting = state.posts
            .map((existing) => incomingById[existing.postId] ?? existing)
            .toList();

        final filteredExisting = updatedExisting
            .where((p) => newIds.contains(p.postId))
            .toList();

        final mergedPosts = [...addedPosts, ...filteredExisting];
        state = state.copyWith(posts: mergedPosts);
        unawaited(_hydrateCommentCounts(mergedPosts));
      });
    } catch (_) {
      // Silent polling must never crash the app.
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

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
    final result = await _repository.getPaginatedPosts(
      page: page,
      limit: _pageLimit,
    );

    result.fold(
      (failure) {
        if (mounted) {
          state = state.copyWith(isLoading: false, error: failure.message);

          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && state.error != null && !state.isLoading) {
              loadPosts(refresh: refresh);
            }
          });
        }
      },
      (pageData) {
        if (mounted) {
          final newPosts = pageData.items;
          final hasMore = pageData.meta.hasExplicitPageBoundary
              ? pageData.hasNextPage
              : newPosts.length >= _pageLimit;
          if (refresh) {
            state = ForumState(
              posts: newPosts,
              isLoading: false,
              hasMore: hasMore,
              currentPage: 2,
            );
            unawaited(_hydrateCommentCounts(newPosts));
          } else {
            state = ForumState(
              posts: [...state.posts, ...newPosts],
              isLoading: false,
              hasMore: hasMore,
              currentPage: page + 1,
            );
            unawaited(_hydrateCommentCounts(newPosts));
          }
        }
      },
    );
  }

  Future<void> refreshPosts() async {
    state = state.copyWith(isLoading: false, currentPage: 1, hasMore: true);
    await loadPosts(refresh: true);
  }

  Future<void> toggleDislike(String postId) async {
    final result = await _repository.toggleDislike(postId);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (data) => _applyLikeUpdate(postId, data.isLiked, data.likeCount),
    );
  }

  void _applyLikeUpdate(String postId, bool isLiked, int likeCount) {
    final updatedPosts = state.posts.map((post) {
      if (post.postId == postId) {
        return Post(
          postId: post.postId,
          postTitle: post.postTitle,
          userId: post.userId,
          siteId: post.siteId,
          postContent: post.postContent,
          postImage: post.postImage,
          likeCount: likeCount,
          commentCount: post.commentCount,
          shareCount: post.shareCount,
          isLiked: isLiked,
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

  Future<void> toggleLike(String postId) async {
    final result = await _repository.toggleLike(postId);
    result.fold((failure) {
      state = state.copyWith(error: failure.message);
    }, (data) => _applyLikeUpdate(postId, data.isLiked, data.likeCount));
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

  Future<void> _hydrateCommentCounts(List<Post> posts) async {
    if (posts.isEmpty) return;

    final results = await Future.wait(
      posts.map((post) async {
        final response = await _repository.getPaginatedComments(
          postId: post.postId,
          page: 1,
          limit: 1,
        );
        return response.fold<MapEntry<String, int>?>((_) => null, (page) {
          final count = _resolveHydratedCommentCount(page);
          return MapEntry(post.postId, count);
        });
      }),
    );

    if (!mounted) return;

    final countByPostId = <String, int>{
      for (final entry in results)
        if (entry != null) entry.key: entry.value,
    };

    if (countByPostId.isEmpty) return;

    var hasChanges = false;
    final updatedPosts = state.posts.map((post) {
      final hydratedCount = countByPostId[post.postId];
      if (hydratedCount == null || hydratedCount == post.commentCount) {
        return post;
      }

      hasChanges = true;
      return Post(
        postId: post.postId,
        postTitle: post.postTitle,
        userId: post.userId,
        siteId: post.siteId,
        postContent: post.postContent,
        postImage: post.postImage,
        likeCount: post.likeCount,
        commentCount: hydratedCount,
        shareCount: post.shareCount,
        isLiked: post.isLiked,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        user: post.user,
        site: post.site,
      );
    }).toList();

    if (!hasChanges) return;
    state = state.copyWith(posts: updatedPosts);
  }

  int _resolveHydratedCommentCount(PaginatedResult<Comment> page) {
    final total = page.meta.total;
    if (total != null) return total;

    final totalPages = page.meta.totalPages;
    if (totalPages != null && page.meta.limit == 1) {
      return totalPages;
    }

    return page.items.length;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final forumProvider = StateNotifierProvider<ForumNotifier, ForumState>((ref) {
  final repository = ref.watch(forumRepositoryProvider);
  return ForumNotifier(repository);
});

final postDetailProvider = FutureProvider.autoDispose.family<Post, String>((
  ref,
  postId,
) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getPostById(postId);
    return result.fold((failure) => throw failure, (post) => post);
  });
});

class CommentsState {
  final List<Comment> comments;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const CommentsState({
    this.comments = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  CommentsState copyWith({
    List<Comment>? comments,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
    int? totalCount,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class CommentsNotifier extends StateNotifier<CommentsState> {
  final ForumRepository _repository;
  final String _postId;
  final Ref _ref;

  CommentsNotifier(this._repository, this._postId, this._ref)
    : super(const CommentsState());

  static const _pageLimit = 30;

  Future<void> loadComments({bool refresh = true}) async {
    if (state.isLoading) return;
    if (!refresh && !state.hasMore) return;

    final page = refresh ? 1 : state.currentPage;
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
      hasMore: refresh ? true : state.hasMore,
    );

    final result = await _repository.getPaginatedComments(
      postId: _postId,
      page: page,
      limit: _pageLimit,
    );
    result.fold(
      (failure) {
        if (mounted) {
          state = state.copyWith(isLoading: false, error: failure.message);

          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && state.error != null && !state.isLoading) {
              loadComments(refresh: refresh);
            }
          });
        }
      },
      (pageData) {
        if (mounted) {
          final comments = refresh
              ? pageData.items
              : [...state.comments, ...pageData.items];
          final totalCount = pageData.meta.total ?? comments.length;
          state = CommentsState(
            comments: comments,
            isLoading: false,
            hasMore: pageData.meta.hasExplicitPageBoundary
                ? pageData.hasNextPage
                : pageData.items.length >= _pageLimit,
            currentPage: page + 1,
            totalCount: totalCount,
          );
        }
      },
    );
  }

  Future<void> loadMoreComments() => loadComments(refresh: false);

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
        state = state.copyWith(
          comments: [newComment, ...state.comments],
          totalCount: state.totalCount + 1,
        );

        _ref.read(forumProvider.notifier).updateCommentCount(_postId, 1);
        _ref.invalidate(postDetailProvider(_postId));
      },
    );
  }

  Future<void> updateComment(String commentId, String content) async {
    final result = await _repository.updateComment(
      commentId: commentId,
      content: content,
    );
    result.fold((failure) => state = state.copyWith(error: failure.message), (
      updated,
    ) {
      final list = state.comments
          .map((c) => c.commentId == commentId ? updated : c)
          .toList();
      state = state.copyWith(comments: list);
      _ref.invalidate(myCommentsProvider);
    });
  }

  Future<void> deleteComment(String commentId) async {
    final result = await _repository.deleteComment(
      postId: _postId,
      commentId: commentId,
    );
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (_) {
        final updatedComments = state.comments
            .where((c) => c.commentId != commentId)
            .toList();
        state = state.copyWith(
          comments: updatedComments,
          totalCount: (state.totalCount - 1).clamp(0, 999999),
        );

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

final myPostsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getMyPosts();
    return result.fold((failure) => throw failure, (posts) => posts);
  });
});

final likedPostsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getLikedPosts();
    return result.fold((failure) => throw failure, (posts) => posts);
  });
});

final postReactionsProvider = FutureProvider.autoDispose
    .family<List<Reaction>, String>((ref, postId) async {
      final repository = ref.watch(forumRepositoryProvider);
      return ref.retryOnError(() async {
        final result = await repository.getReactions(postId);
        return result.fold((f) => throw f, (data) => data);
      });
    });

final myCommentsProvider = FutureProvider.autoDispose<List<UserComment>>((
  ref,
) async {
  final repository = ref.watch(forumRepositoryProvider);
  return await ref.retryOnError(() async {
    final result = await repository.getMyComments();
    return result.fold((failure) => throw failure, (comments) => comments);
  });
});
