import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/network/paginated_result.dart';
import 'package:simpulagromobile/features/forum/domain/repositories/forum_repository.dart';
import 'package:simpulagromobile/features/forum/domain/entities/comment.dart';
import 'package:simpulagromobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:simpulagromobile/features/forum/domain/entities/post.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockForumRepository extends Mock implements ForumRepository {}

void main() {
  late MockForumRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockForumRepository();
    container = ProviderContainer(
      overrides: [forumRepositoryProvider.overrideWithValue(mockRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ForumNotifier Provider Tests', () {
    final dummyPost = Post(
      postId: 'POST_123',
      postTitle: 'Test Title',
      userId: 'USR_001',
      postContent: 'Test Content',
      likeCount: 5,
      commentCount: 2,
      shareCount: 1,
      isLiked: false,
      createdAt: DateTime.now(),
      user: const PostUser(userId: 'USR_001', userName: 'Test User'),
    );

    test(
      'toggleLike updates state with new like properties on success',
      () async {
        when(
          () => mockRepository.toggleLike('POST_123'),
        ).thenAnswer((_) async => const Right((isLiked: true, likeCount: 6)));

        // Initialize state with a post
        final notifier = container.read(forumProvider.notifier);
        notifier.state = ForumState(posts: [dummyPost]);

        await notifier.toggleLike('POST_123');

        final updatedPost = container.read(forumProvider).posts.first;
        expect(updatedPost.isLiked, isTrue);
        expect(updatedPost.likeCount, equals(6));
      },
    );

    test('deletePost removes post from state on success', () async {
      when(
        () => mockRepository.deletePost('POST_123'),
      ).thenAnswer((_) async => const Right(null));

      final notifier = container.read(forumProvider.notifier);
      notifier.state = ForumState(posts: [dummyPost]);

      await notifier.deletePost('POST_123');

      expect(container.read(forumProvider).posts, isEmpty);
    });

    test('sharePost updates shareCount on success', () async {
      when(
        () => mockRepository.sharePost('POST_123'),
      ).thenAnswer((_) async => const Right(10));

      final notifier = container.read(forumProvider.notifier);
      notifier.state = ForumState(posts: [dummyPost]);

      await notifier.sharePost('POST_123');

      final updatedPost = container.read(forumProvider).posts.first;
      expect(updatedPost.shareCount, equals(10));
    });

    test(
      'CommentsNotifier appends paginated comments and stops at last page',
      () async {
        final page1 = [
          Comment(
            commentId: 'C1',
            postId: 'POST_123',
            userId: 'USR_001',
            commentContent: 'First',
            createdAt: DateTime(2026, 5, 1),
            user: const CommentUser(userId: 'USR_001', userName: 'User 1'),
          ),
        ];
        final page2 = [
          Comment(
            commentId: 'C2',
            postId: 'POST_123',
            userId: 'USR_002',
            commentContent: 'Second',
            createdAt: DateTime(2026, 5, 2),
            user: const CommentUser(userId: 'USR_002', userName: 'User 2'),
          ),
        ];

        when(
          () => mockRepository.getPaginatedComments(
            postId: 'POST_123',
            page: 1,
            limit: 30,
          ),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult.fromItems(
              page1,
              page: 1,
              limit: 30,
              meta: const {'page': 1, 'limit': 30, 'total_pages': 2},
            ),
          ),
        );
        when(
          () => mockRepository.getPaginatedComments(
            postId: 'POST_123',
            page: 2,
            limit: 30,
          ),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult.fromItems(
              page2,
              page: 2,
              limit: 30,
              meta: const {'page': 2, 'limit': 30, 'total_pages': 2},
            ),
          ),
        );

        final notifier = container.read(commentsProvider('POST_123').notifier);

        await notifier.loadComments();
        expect(
          container.read(commentsProvider('POST_123')).comments,
          hasLength(1),
        );
        expect(container.read(commentsProvider('POST_123')).hasMore, isTrue);

        await notifier.loadMoreComments();
        final state = container.read(commentsProvider('POST_123'));
        expect(state.comments, hasLength(2));
        expect(state.hasMore, isFalse);
        expect(state.currentPage, 3);
      },
    );

    test('CommentsNotifier keeps totalCount from pagination meta', () async {
      final comments = [
        Comment(
          commentId: 'C1',
          postId: 'POST_123',
          userId: 'USR_001',
          commentContent: 'First',
          createdAt: DateTime(2026, 5, 1),
          user: const CommentUser(userId: 'USR_001', userName: 'User 1'),
        ),
      ];

      when(
        () => mockRepository.getPaginatedComments(
          postId: 'POST_123',
          page: 1,
          limit: 30,
        ),
      ).thenAnswer(
        (_) async => Right(
          PaginatedResult.fromItems(
            comments,
            page: 1,
            limit: 30,
            meta: const {
              'page': 1,
              'limit': 30,
              'total': 14,
              'total_pages': 14,
            },
          ),
        ),
      );

      final notifier = container.read(commentsProvider('POST_123').notifier);
      await notifier.loadComments();

      final state = container.read(commentsProvider('POST_123'));
      expect(state.comments, hasLength(1));
      expect(state.totalCount, 14);
    });

    test(
      'loadPosts hydrates commentCount from comments pagination total',
      () async {
        when(
          () => mockRepository.getPaginatedPosts(page: 1, limit: 20),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult.fromItems(
              [dummyPost],
              page: 1,
              limit: 20,
              meta: const {'page': 1, 'limit': 20, 'total_pages': 1},
            ),
          ),
        );
        when(
          () => mockRepository.getPaginatedComments(
            postId: 'POST_123',
            page: 1,
            limit: 1,
          ),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult.fromItems(
              const [],
              page: 1,
              limit: 1,
              meta: const {'page': 1, 'limit': 1, 'total_pages': 9},
            ),
          ),
        );

        final notifier = container.read(forumProvider.notifier);
        await notifier.loadPosts(refresh: true);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        final hydratedPost = container.read(forumProvider).posts.first;
        expect(hydratedPost.commentCount, 9);
      },
    );
  });
}
