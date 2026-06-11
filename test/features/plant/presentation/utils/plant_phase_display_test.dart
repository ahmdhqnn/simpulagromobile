import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/plant/domain/entities/plant.dart';
import 'package:simpulagromobile/features/plant/presentation/utils/plant_phase_display.dart';

void main() {
  group('phaseSiteIdForPlant', () {
    test('uses plant site id when available', () {
      const plant = Plant(plantId: 'PLANT001', siteId: 'SITE001');

      expect(
        phaseSiteIdForPlant(plant, fallbackSiteId: 'SITE_FALLBACK'),
        'SITE001',
      );
    });

    test('uses selected site fallback when plant site id is missing', () {
      const plant = Plant(plantId: 'PLANT001');

      expect(
        phaseSiteIdForPlant(plant, fallbackSiteId: 'SITE_SELECTED'),
        'SITE_SELECTED',
      );
    });

    test('falls back to plant id only when no site context is available', () {
      const plant = Plant(plantId: 'PLANT001');

      expect(phaseSiteIdForPlant(plant), 'PLANT001');
    });
  });
}
