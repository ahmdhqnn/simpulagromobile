import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/monitoring/presentation/utils/monitoring_display_utils.dart';

void main() {
  group('Monitoring display utils', () {
    test('sampleForChart keeps full list when below the max point count', () {
      final values = [1, 2, 3];

      expect(sampleForChart(values, maxPoints: 5), values);
    });

    test(
      'sampleForChart caps dense data while keeping first and last points',
      () {
        final values = List<int>.generate(100, (index) => index);
        final sampled = sampleForChart(values, maxPoints: 10);

        expect(sampled, hasLength(10));
        expect(sampled.first, 0);
        expect(sampled.last, 99);
      },
    );

    test('boundedHistoryStartDate clamps long ranges to max history days', () {
      final end = DateTime(2026, 5, 27);
      final start = DateTime(2026, 1, 1);

      final bounded = boundedHistoryStartDate(start, end);

      expect(bounded, end.subtract(const Duration(days: maxHistoryRangeDays)));
    });

    test('maxHistoryEndDate prevents end date beyond max history days', () {
      final start = DateTime(2026, 5, 1);
      final now = DateTime(2026, 7, 1);

      expect(
        maxHistoryEndDate(start, now),
        start.add(const Duration(days: maxHistoryRangeDays)),
      );
    });

    test('isMonitoringStale turns true after two refresh intervals', () {
      final now = DateTime(2026, 5, 27, 12);
      final lastUpdated = now.subtract(const Duration(seconds: 61));

      expect(
        isMonitoringStale(
          lastUpdated: lastUpdated,
          now: now,
          refreshInterval: const Duration(seconds: 30),
        ),
        isTrue,
      );
    });
  });
}
