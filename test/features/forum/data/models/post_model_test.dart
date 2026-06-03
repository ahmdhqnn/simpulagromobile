import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/forum/data/models/post_model.dart';

void main() {
  group('PostModel', () {
    test('parses alternate count keys from nested summary fields', () {
      final model = PostModel.fromJson({
        'forum_id': 'POST_123',
        'forum_title': 'Judul',
        'forum_content': 'Konten',
        'forum_user_id': 'USR_001',
        'forum_created': '2026-05-24T00:00:00.000Z',
        'stats': {'forum_like_count': '8'},
        'summary': {'total_comments': 5},
        'totals': {'shares_count': 3},
        'user': {'user_id': 'USR_001', 'user_name': 'Test User'},
      });

      expect(model.likeCount, 8);
      expect(model.commentCount, 5);
      expect(model.shareCount, 3);
    });

    test(
      'falls back to nested collection totals when direct keys are absent',
      () {
        final model = PostModel.fromJson({
          'forum_id': 'POST_123',
          'forum_title': 'Judul',
          'forum_content': 'Konten',
          'forum_user_id': 'USR_001',
          'forum_created': '2026-05-24T00:00:00.000Z',
          'reactions': [1, 2, 3],
          'comments': {'total': 6},
          'shares': [
            {'id': 1},
            {'id': 2},
          ],
          'user': {'user_id': 'USR_001', 'user_name': 'Test User'},
        });

        expect(model.likeCount, 3);
        expect(model.commentCount, 6);
        expect(model.shareCount, 2);
      },
    );
  });
}
