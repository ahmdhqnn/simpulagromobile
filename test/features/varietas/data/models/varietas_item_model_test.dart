import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/varietas/data/models/varietas_item_model.dart';

void main() {
  group('VarietasItemModel', () {
    test('fromJson parses valid payload', () {
      final model = VarietasItemModel.fromJson({
        'varietas_id': 'VAR_001',
        'varietas_name': 'Ciherang',
        'varietas_desc': 'Padi unggul',
        'varietas_sts': '1',
        'varietas_update': '2026-05-01T10:00:00.000Z',
      });

      expect(model.varietasId, 'VAR_001');
      expect(model.varietasName, 'Ciherang');
      expect(model.varietasDesc, 'Padi unggul');
      expect(model.varietasSts, 1);
      expect(model.varietasUpdate, isNotNull);
      expect(model.toEntity().isActive, isTrue);
    });

    test('fromJson throws when varietas_id is empty', () {
      expect(
        () => VarietasItemModel.fromJson({'varietas_name': 'Invalid'}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
