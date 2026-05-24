import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/plant/domain/entities/plant.dart';

void main() {
  group('Plant entity', () {
    // ─── isActive ───────────────────────────────────────────────────────────

    group('isActive', () {
      test('returns true when plant_sts is 1', () {
        final plant = Plant(plantId: 'P1', plantSts: 1);
        expect(plant.isActive, true);
      });

      test('returns false when plant_sts is 0', () {
        final plant = Plant(plantId: 'P1', plantSts: 0);
        expect(plant.isActive, false);
      });

      test('returns false when plant_sts is null', () {
        final plant = Plant(plantId: 'P1');
        expect(plant.isActive, false);
      });
    });

    // ─── isHarvested ────────────────────────────────────────────────────────

    group('isHarvested', () {
      test('returns true when plantHarvest is set', () {
        final plant = Plant(
          plantId: 'P1',
          plantSts: 1,
          plantHarvest: DateTime(2026, 8, 1),
        );
        expect(plant.isHarvested, true);
      });

      test('returns false when plantHarvest is null', () {
        final plant = Plant(plantId: 'P1', plantSts: 1);
        expect(plant.isHarvested, false);
      });
    });

    // ─── isCurrentPlanting ──────────────────────────────────────────────────

    group('isCurrentPlanting', () {
      test('returns true when active and not harvested', () {
        final plant = Plant(plantId: 'P1', plantSts: 1, plantHarvest: null);
        expect(plant.isCurrentPlanting, true);
      });

      test('returns false when harvested even if active', () {
        final plant = Plant(
          plantId: 'P1',
          plantSts: 1,
          plantHarvest: DateTime(2026, 8, 1),
        );
        expect(plant.isCurrentPlanting, false);
      });

      test('returns false when inactive', () {
        final plant = Plant(plantId: 'P1', plantSts: 0, plantHarvest: null);
        expect(plant.isCurrentPlanting, false);
      });
    });

    // ─── displayName ────────────────────────────────────────────────────────

    group('displayName', () {
      test('returns plantName when set', () {
        final plant = Plant(plantId: 'P1', plantName: 'Padi Sawah');
        expect(plant.displayName, 'Padi Sawah');
      });

      test('falls back to plantId when plantName is null', () {
        final plant = Plant(plantId: 'PLANT_001');
        expect(plant.displayName, 'PLANT_001');
      });
    });

    // ─── hst ────────────────────────────────────────────────────────────────

    group('hst (days since planting)', () {
      test('returns null when plantDate is null', () {
        final plant = Plant(plantId: 'P1');
        expect(plant.hst, isNull);
      });

      test('returns non-negative integer when plantDate is set', () {
        final plant = Plant(
          plantId: 'P1',
          plantDate: DateTime.now().subtract(const Duration(days: 30)),
        );
        expect(plant.hst, greaterThanOrEqualTo(30));
      });
    });

    // ─── growthPhase ────────────────────────────────────────────────────────

    group('growthPhase', () {
      test('returns null when plantDate is null', () {
        final plant = Plant(plantId: 'P1');
        expect(plant.growthPhase, isNull);
      });

      test('returns Vegetatif Awal for < 20 days', () {
        final plant = Plant(
          plantId: 'P1',
          plantDate: DateTime.now().subtract(const Duration(days: 10)),
        );
        expect(plant.growthPhase, 'Vegetatif Awal');
      });

      test('returns Vegetatif for 20-39 days', () {
        final plant = Plant(
          plantId: 'P1',
          plantDate: DateTime.now().subtract(const Duration(days: 25)),
        );
        expect(plant.growthPhase, 'Vegetatif');
      });

      test('returns Siap Panen for >= 100 days', () {
        final plant = Plant(
          plantId: 'P1',
          plantDate: DateTime.now().subtract(const Duration(days: 105)),
        );
        expect(plant.growthPhase, 'Siap Panen');
      });
    });

    // ─── statusText ─────────────────────────────────────────────────────────

    group('statusText', () {
      test('returns Sudah Panen when harvested', () {
        final plant = Plant(
          plantId: 'P1',
          plantSts: 1,
          plantHarvest: DateTime(2026, 8, 1),
        );
        expect(plant.statusText, 'Sudah Panen');
      });

      test('returns Sedang Tumbuh when currently planting', () {
        final plant = Plant(plantId: 'P1', plantSts: 1);
        expect(plant.statusText, 'Sedang Tumbuh');
      });

      test('returns Tidak Aktif when inactive', () {
        final plant = Plant(plantId: 'P1', plantSts: 0);
        expect(plant.statusText, 'Tidak Aktif');
      });
    });

    // ─── CropType extension ─────────────────────────────────────────────────

    group('CropType extension', () {
      test('PADI has correct displayName and icon', () {
        expect(CropType.PADI.displayName, 'Padi');
        expect(CropType.PADI.icon, '🌾');
      });

      test('JAGUNG has correct displayName and icon', () {
        expect(CropType.JAGUNG.displayName, 'Jagung');
        expect(CropType.JAGUNG.icon, '🌽');
      });

      test('KEDELAI has correct displayName and icon', () {
        expect(CropType.KEDELAI.displayName, 'Kedelai');
        expect(CropType.KEDELAI.icon, '🫘');
      });
    });
  });
}
