import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/phase/data/models/phase_model.dart';

void main() {
  group('PhaseModel active HST mapping', () {
    test('maps HST 8 to Fase Bibit instead of Perkecambahan', () {
      final phases =
          [
                {
                  'phase_id': 'PHASE001',
                  'phase_name': 'Perkecambahan',
                  'chrop_type': 'PADI',
                  'phase_order': 1,
                  'phase_hst_min': 0,
                  'phase_hst_max': 7,
                },
                {
                  'phase_id': 'PHASE002',
                  'phase_name': 'Fase Bibit',
                  'chrop_type': 'PADI',
                  'phase_order': 2,
                  'phase_hst_min': 8,
                  'phase_hst_max': 21,
                },
              ]
              .map(PhaseModel.fromApiJson)
              .map((phase) => phase.enrichWithHst(currentHst: 8))
              .toList();

      expect(phases[0].status, 'completed');
      expect(phases[1].status, 'active');
      expect(phases[1].toEntity().phaseName, 'Fase Bibit');
      expect(phases[1].toEntity().currentHst, 8);
    });
  });
}
