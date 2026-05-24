import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/plant/data/models/plant_model.dart';
import 'package:simpulagromobile/features/plant/domain/entities/plant.dart';
import 'package:simpulagromobile/features/plant/domain/plant_status_extension.dart';

void main() {
  group('PlantModel', () {
    // ─── fromJson ───────────────────────────────────────────────────────────

    group('fromJson', () {
      test('parses all fields correctly', () {
        final json = {
          'plant_id': 'PLANT_001',
          'site_id': 'SITE_001',
          'varietas_id': 'VAR_001',
          'plant_name': 'Padi Demo',
          'plant_type': 'PADI',
          'plant_species': 'IR64',
          'plant_date': '2026-05-01T00:00:00.000Z',
          'plant_harvest': null,
          'plant_sts': 1,
        };

        final model = PlantModel.fromJson(json);

        expect(model.plantId, 'PLANT_001');
        expect(model.siteId, 'SITE_001');
        expect(model.varietasId, 'VAR_001');
        expect(model.plantName, 'Padi Demo');
        expect(model.plantType, 'PADI');
        expect(model.plantSpecies, 'IR64');
        expect(model.plantDate, isNotNull);
        expect(model.plantHarvest, isNull);
        expect(model.plantSts, 1);
      });

      test('handles null plant_id by defaulting to empty string', () {
        final json = {'plant_id': null};
        final model = PlantModel.fromJson(json);
        expect(model.plantId, '');
      });

      test('parses plant_sts from string "1"', () {
        final json = {'plant_id': 'P1', 'plant_sts': '1'};
        final model = PlantModel.fromJson(json);
        expect(model.plantSts, 1);
      });

      test('parses plant_sts from string "active"', () {
        final json = {'plant_id': 'P1', 'plant_sts': 'active'};
        final model = PlantModel.fromJson(json);
        expect(model.plantSts, 1);
      });

      test('parses plant_sts from bool true', () {
        final json = {'plant_id': 'P1', 'plant_sts': true};
        final model = PlantModel.fromJson(json);
        expect(model.plantSts, 1);
      });

      test('falls back to status field when plant_sts is null', () {
        final json = {'plant_id': 'P1', 'plant_sts': null, 'status': 1};
        final model = PlantModel.fromJson(json);
        expect(model.plantSts, 1);
      });

      test('parses ISO date string for plant_date', () {
        final json = {
          'plant_id': 'P1',
          'plant_date': '2026-05-01T00:00:00.000Z',
        };
        final model = PlantModel.fromJson(json);
        expect(model.plantDate, isNotNull);
        expect(model.plantDate!.year, 2026);
        expect(model.plantDate!.month, 5);
        expect(model.plantDate!.day, 1);
      });

      test('parses harvest date when present', () {
        final json = {
          'plant_id': 'P1',
          'plant_harvest': '2026-08-15T00:00:00.000Z',
        };
        final model = PlantModel.fromJson(json);
        expect(model.plantHarvest, isNotNull);
        expect(model.plantHarvest!.month, 8);
      });
    });

    // ─── toEntity ───────────────────────────────────────────────────────────

    group('toEntity', () {
      test('converts PADI type correctly', () {
        final model = PlantModel(
          plantId: 'PLANT_001',
          siteId: 'SITE_001',
          plantName: 'Padi Demo',
          plantType: 'PADI',
          plantSts: 1,
        );

        final entity = model.toEntity();

        expect(entity, isA<Plant>());
        expect(entity.plantId, 'PLANT_001');
        expect(entity.plantType, CropType.PADI);
        expect(entity.isActive, true);
      });

      test('converts JAGUNG type correctly', () {
        final model = PlantModel(
          plantId: 'P1',
          plantType: 'JAGUNG',
          plantSts: 1,
        );
        final entity = model.toEntity();
        expect(entity.plantType, CropType.JAGUNG);
      });

      test('converts KEDELAI type correctly', () {
        final model = PlantModel(
          plantId: 'P1',
          plantType: 'KEDELAI',
          plantSts: 1,
        );
        final entity = model.toEntity();
        expect(entity.plantType, CropType.KEDELAI);
      });

      test('defaults to PADI for unknown plant type', () {
        final model = PlantModel(
          plantId: 'P1',
          plantType: 'UNKNOWN_TYPE',
          plantSts: 1,
        );
        final entity = model.toEntity();
        // PlantTypeValidator falls back to PADI with a warning
        expect(entity.plantType, CropType.PADI);
      });

      test('sets plantType to null when plantType field is null', () {
        final model = PlantModel(plantId: 'P1', plantSts: 1);
        final entity = model.toEntity();
        expect(entity.plantType, isNull);
      });

      test('isCurrentPlanting is true for active plant without harvest', () {
        final model = PlantModel(
          plantId: 'P1',
          plantSts: 1,
          plantHarvest: null,
        );
        final entity = model.toEntity();
        expect(entity.isCurrentPlanting, true);
      });

      test('isHarvested is true when plantHarvest is set', () {
        final model = PlantModel(
          plantId: 'P1',
          plantSts: 1,
          plantHarvest: DateTime(2026, 8, 1),
        );
        final entity = model.toEntity();
        expect(entity.isHarvested, true);
        expect(entity.isCurrentPlanting, false);
      });
    });

    // ─── toJson / PlantWritePayload ───────────────────────────────────────────

    group('toJson', () {
      test('serializes plant_date as YYYY-MM-DD', () {
        final model = PlantModel(
          plantId: 'P1',
          plantDate: DateTime(2026, 5, 1, 14, 30),
        );

        final json = model.toJson();

        expect(json['plant_date'], '2026-05-01');
      });
    });

    group('PlantWritePayload', () {
      test('fromMap produces swagger-safe body', () {
        final payload = PlantWritePayload.fromMap({
          'plant_name': ' Padi Demo ',
          'varietas_id': 'VAR_001',
          'plant_type': 'padi',
          'plant_date': '2026-05-01T00:00:00.000Z',
        });

        expect(payload.toJson(), {
          'plant_name': 'Padi Demo',
          'varietas_id': 'VAR_001',
          'plant_type': 'PADI',
          'plant_date': '2026-05-01',
        });
      });

      test('strips read-only fields from raw map', () {
        final payload = PlantWritePayload.fromMap({
          'plant_id': 'SHOULD_NOT_SEND',
          'site_id': 'SITE_001',
          'plant_name': 'Padi',
          'varietas_id': 'VAR_001',
          'plant_date': '2026-05-01',
          'plant_sts': 1,
        });

        final body = payload.toJson();
        expect(body.containsKey('plant_id'), false);
        expect(body.containsKey('site_id'), false);
        expect(body.containsKey('plant_sts'), false);
      });
    });

    // ─── fromEntity ─────────────────────────────────────────────────────────

    group('fromEntity', () {
      test('round-trips entity → model → entity correctly', () {
        final original = Plant(
          plantId: 'PLANT_001',
          siteId: 'SITE_001',
          varietasId: 'VAR_001',
          plantName: 'Padi Demo',
          plantType: CropType.PADI,
          plantDate: DateTime(2026, 5, 1),
          plantSts: 1,
        );

        final model = PlantModel.fromEntity(original);
        final restored = model.toEntity();

        expect(restored.plantId, original.plantId);
        expect(restored.siteId, original.siteId);
        expect(restored.plantName, original.plantName);
        expect(restored.plantType, original.plantType);
        expect(restored.plantSts, original.plantSts);
      });
    });

    // ─── computed properties ─────────────────────────────────────────────────

    group('computed properties', () {
      test('isActive returns true for plant_sts = 1', () {
        final model = PlantModel(plantId: 'P1', plantSts: 1);
        expect(model.isActive, true);
      });

      test('isHarvested returns true when plantHarvest is set', () {
        final model = PlantModel(
          plantId: 'P1',
          plantHarvest: DateTime(2026, 8, 1),
        );
        expect(model.isHarvested, true);
      });

      test('isCurrentPlanting returns true for active without harvest', () {
        final model = PlantModel(
          plantId: 'P1',
          plantSts: 1,
          plantHarvest: null,
        );
        expect(model.isCurrentPlanting, true);
      });

      test('status is harvested when plantHarvest is set', () {
        final model = PlantModel(
          plantId: 'P1',
          plantSts: 1,
          plantHarvest: DateTime(2026, 8, 1),
        );
        expect(model.status, PlantStatusEnum.harvested);
      });

      test('status is active when plant_sts=1 and no harvest', () {
        final model = PlantModel(plantId: 'P1', plantSts: 1);
        expect(model.status, PlantStatusEnum.active);
      });

      test('isValidType returns true for PADI', () {
        final model = PlantModel(plantId: 'P1', plantType: 'PADI');
        expect(model.isValidType(), true);
      });

      test('isValidType returns false for unknown type', () {
        final model = PlantModel(plantId: 'P1', plantType: 'UNKNOWN');
        expect(model.isValidType(), false);
      });
    });
  });
}
