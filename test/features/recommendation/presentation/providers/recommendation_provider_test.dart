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

  group('primaryRecommendationForOverview', () {
    Recommendation plantRecommendation(
      String id,
      double confidence, {
      RecommendationPriority priority = RecommendationPriority.medium,
    }) {
      return Recommendation(
        recommendationId: id,
        type: RecommendationType.planting,
        title: id,
        description: 'Rekomendasi tanaman',
        priority: priority,
        createdAt: DateTime(2026, 6, 11, 8),
        confidenceScore: confidence,
      );
    }

    test(
      'uses top recommendation confidence instead of average confidence',
      () {
        final items = [
          plantRecommendation('padi', 0.56),
          plantRecommendation('jagung', 0.18),
          plantRecommendation('kedelai', 0.37),
        ];

        final primary = primaryRecommendationForOverview(items);
        final sorted = sortRecommendationOverviewItems(items);

        expect(primary?.recommendationId, 'padi');
        expect(primary?.confidenceScore, 0.56);
        expect(sorted.map((item) => item.confidenceScore), [0.56, 0.37, 0.18]);
      },
    );

    test('keeps error recommendations after valid recommendations', () {
      final items = [
        Recommendation(
          recommendationId: 'error',
          type: RecommendationType.ph,
          title: 'pH tidak tersedia',
          description: 'Data pH tidak cukup',
          priority: RecommendationPriority.high,
          errorMessage: 'Data pH tidak cukup',
        ),
        plantRecommendation('padi', 0.56),
      ];

      expect(primaryRecommendationForOverview(items)?.recommendationId, 'padi');
    });
  });
}
