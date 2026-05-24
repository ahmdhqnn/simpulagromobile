import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/plant/domain/plant_status_extension.dart';

void main() {
  // ─── parsePlantStatusCode ─────────────────────────────────────────────────

  group('parsePlantStatusCode', () {
    test('returns 1 for int 1', () => expect(parsePlantStatusCode(1), 1));
    test('returns 0 for int 0', () => expect(parsePlantStatusCode(0), 0));
    test(
      'returns null for null',
      () => expect(parsePlantStatusCode(null), isNull),
    );
    test(
      'returns 1 for string "1"',
      () => expect(parsePlantStatusCode('1'), 1),
    );
    test(
      'returns 0 for string "0"',
      () => expect(parsePlantStatusCode('0'), 0),
    );
    test(
      'returns 1 for string "active"',
      () => expect(parsePlantStatusCode('active'), 1),
    );
    test(
      'returns 1 for string "aktif"',
      () => expect(parsePlantStatusCode('aktif'), 1),
    );
    test(
      'returns 0 for string "inactive"',
      () => expect(parsePlantStatusCode('inactive'), 0),
    );
    test(
      'returns 0 for string "harvest"',
      () => expect(parsePlantStatusCode('harvest'), 0),
    );
    test(
      'returns 0 for string "panen"',
      () => expect(parsePlantStatusCode('panen'), 0),
    );
    test(
      'returns 1 for bool true',
      () => expect(parsePlantStatusCode(true), 1),
    );
    test(
      'returns 0 for bool false',
      () => expect(parsePlantStatusCode(false), 0),
    );
    test(
      'returns null for empty string',
      () => expect(parsePlantStatusCode(''), isNull),
    );
    test(
      'returns null for unknown string',
      () => expect(parsePlantStatusCode('xyz'), isNull),
    );
    test('returns 1 for num 1.0', () => expect(parsePlantStatusCode(1.0), 1));
  });

  // ─── parsePlantDateValue ──────────────────────────────────────────────────

  group('parsePlantDateValue', () {
    test(
      'returns null for null',
      () => expect(parsePlantDateValue(null), isNull),
    );
    test(
      'returns null for empty string',
      () => expect(parsePlantDateValue(''), isNull),
    );

    test('parses ISO 8601 string', () {
      final result = parsePlantDateValue('2026-05-01T00:00:00.000Z');
      expect(result, isNotNull);
      expect(result!.year, 2026);
      expect(result.month, 5);
      expect(result.day, 1);
    });

    test('parses date-only string', () {
      final result = parsePlantDateValue('2026-05-01');
      expect(result, isNotNull);
      expect(result!.year, 2026);
    });

    test('returns DateTime as-is', () {
      final dt = DateTime(2026, 5, 1);
      expect(parsePlantDateValue(dt), dt);
    });

    test('returns null for non-string non-DateTime', () {
      expect(parsePlantDateValue(12345), isNull);
    });
  });

  // ─── isActivePlantStatus ──────────────────────────────────────────────────

  group('isActivePlantStatus', () {
    test('returns true for plantSts = 1', () {
      expect(isActivePlantStatus(plantSts: 1), true);
    });

    test('returns false for plantSts = 0', () {
      expect(isActivePlantStatus(plantSts: 0), false);
    });

    test('returns false for plantSts = null', () {
      expect(isActivePlantStatus(plantSts: null), false);
    });
  });

  // ─── isHarvestedPlantLifecycle ────────────────────────────────────────────

  group('isHarvestedPlantLifecycle', () {
    test('returns true when plantHarvest is set', () {
      expect(
        isHarvestedPlantLifecycle(plantHarvest: DateTime(2026, 8, 1)),
        true,
      );
    });

    test('returns false when plantHarvest is null', () {
      expect(isHarvestedPlantLifecycle(plantHarvest: null), false);
    });
  });

  // ─── isCurrentPlantingLifecycle ───────────────────────────────────────────

  group('isCurrentPlantingLifecycle', () {
    test('returns true when active and not harvested', () {
      expect(isCurrentPlantingLifecycle(plantSts: 1, plantHarvest: null), true);
    });

    test('returns false when harvested', () {
      expect(
        isCurrentPlantingLifecycle(
          plantSts: 1,
          plantHarvest: DateTime(2026, 8, 1),
        ),
        false,
      );
    });

    test('returns false when inactive', () {
      expect(
        isCurrentPlantingLifecycle(plantSts: 0, plantHarvest: null),
        false,
      );
    });

    test('returns false when both inactive and harvested', () {
      expect(
        isCurrentPlantingLifecycle(
          plantSts: 0,
          plantHarvest: DateTime(2026, 8, 1),
        ),
        false,
      );
    });
  });

  // ─── PlantStatusEnum ──────────────────────────────────────────────────────

  group('PlantStatusEnum', () {
    test('active.label is "Active"', () {
      expect(PlantStatusEnum.active.label, 'Active');
    });

    test('harvested.label is "Harvested"', () {
      expect(PlantStatusEnum.harvested.label, 'Harvested');
    });

    test('inactive.label is "Inactive"', () {
      expect(PlantStatusEnum.inactive.label, 'Inactive');
    });

    test('unknown.label is "Unknown"', () {
      expect(PlantStatusEnum.unknown.label, 'Unknown');
    });

    test('active.isActive is true', () {
      expect(PlantStatusEnum.active.isActive, true);
    });

    test('harvested.isActive is false', () {
      expect(PlantStatusEnum.harvested.isActive, false);
    });
  });
}
