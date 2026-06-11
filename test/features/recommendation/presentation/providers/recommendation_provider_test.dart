import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/recommendation/domain/entities/recommendation.dart';
import 'package:simpulagromobile/features/recommendation/presentation/providers/recommendation_provider.dart';

void main() {
  group('isRecommendationFromToday', () {
    final now = DateTime(2026, 6, 11, 14);

    Recommendation recommendationAt(DateTime? createdAt) {
      return Recommendation(
        recommendationId: 'REC001',
        type: RecommendationType.npk,
        title: 'Rekomendasi NPK',
        description: 'Pertahankan kondisi tanah.',
        priority: RecommendationPriority.low,
        createdAt: createdAt,
      );
    }

    test('includes recommendation created today', () {
      expect(
        isRecommendationFromToday(
          recommendationAt(DateTime(2026, 6, 11, 8)),
          now: now,
        ),
        isTrue,
      );
    });

    test('excludes cached recommendation from a previous day', () {
      expect(
        isRecommendationFromToday(
          recommendationAt(DateTime(2026, 6, 10, 23, 59)),
          now: now,
        ),
        isFalse,
      );
    });

    test('keeps live response without timestamp', () {
      expect(
        isRecommendationFromToday(recommendationAt(null), now: now),
        isTrue,
      );
    });
  });
}
