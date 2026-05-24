import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:simpulagromobile/features/forum/data/datasources/forum_remote_datasource.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';

class MockDio extends Mock implements Dio {}
class FakeFormData extends Fake implements FormData {}

void main() {
  late MockDio mockDio;
  late ForumRemoteDataSource remoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeFormData());
  });

  setUp(() {
    mockDio = MockDio();
    remoteDataSource = ForumRemoteDataSource(mockDio);
  });

  group('ForumRemoteDataSource Tests', () {
    final dummyPostResponse = {
      'data': {
        'forum_id': 'POST_123',
        'forum_title': 'Test Title',
        'forum_content': 'Test Content',
        'forum_user_id': 'USR_001',
        'forum_image_url': 'https://example.com/img.png',
        'forum_like_count': 5,
        'comment_count': 2,
        'forum_share_count': 1,
        'is_liked': 'LIKE',
        'forum_created': '2026-05-24T00:00:00.000Z',
        'user': {
          'user_id': 'USR_001',
          'user_name': 'Test User',
          'user_avatar': 'https://example.com/avatar.png'
        }
      }
    };

    group('toggleLike', () {
      test('sends action: LIKE in the request body', () async {
        final mockLikeResponse = {
          'data': {
            'is_liked': 'LIKE',
            'like_count': 6,
          }
        };

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/forum/posts/POST_123/like'),
              data: mockLikeResponse,
              statusCode: 200,
            ));

        final result = await remoteDataSource.toggleLike('POST_123');

        expect(result.isLiked, isTrue);
        expect(result.likeCount, equals(6));

        verify(() => mockDio.post(
              ApiEndpoints.forumPostLike('POST_123'),
              data: {'action': 'LIKE'},
            )).called(1);
      });
    });

    group('createPost', () {
      test('sends remote image URL as string fields in FormData', () async {
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/forum/posts'),
              data: dummyPostResponse,
              statusCode: 200,
            ));

        final post = await remoteDataSource.createPost(
          title: 'Test Title',
          siteId: 'SITE_001',
          content: 'Test Content',
          imageUrl: 'https://example.com/img.png',
        );

        expect(post.postId, equals('POST_123'));
        expect(post.postTitle, equals('Test Title'));

        final captured = verify(() => mockDio.post(
              ApiEndpoints.forumPosts,
              data: captureAny(named: 'data'),
            )).captured.single as FormData;

        // Verify fields
        final fields = captured.fields.fold<Map<String, String>>({}, (map, entry) {
          map[entry.key] = entry.value;
          return map;
        });

        expect(fields['site_id'], equals('SITE_001'));
        expect(fields['forum_title'], equals('Test Title'));
        expect(fields['forum_content'], equals('Test Content'));
        expect(fields['forum_image_url'], equals('https://example.com/img.png'));
        expect(fields['image'], equals('https://example.com/img.png'));
      });
    });

    group('updatePost', () {
      test('sends remote image URL as string fields in FormData for update', () async {
        when(() => mockDio.put(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/forum/posts/POST_123'),
              data: dummyPostResponse,
              statusCode: 200,
            ));

        final post = await remoteDataSource.updatePost(
          postId: 'POST_123',
          title: 'Test Title',
          content: 'Test Content',
          imageUrl: 'https://example.com/img.png',
        );

        expect(post.postId, equals('POST_123'));

        final captured = verify(() => mockDio.put(
              ApiEndpoints.forumPostById('POST_123'),
              data: captureAny(named: 'data'),
            )).captured.single as FormData;

        final fields = captured.fields.fold<Map<String, String>>({}, (map, entry) {
          map[entry.key] = entry.value;
          return map;
        });

        expect(fields['forum_title'], equals('Test Title'));
        expect(fields['forum_content'], equals('Test Content'));
        expect(fields['forum_image_url'], equals('https://example.com/img.png'));
        expect(fields['image'], equals('https://example.com/img.png'));
      });
    });
  });
}
