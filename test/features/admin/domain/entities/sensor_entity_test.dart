import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/admin/domain/entities/sensor.dart';

void main() {
  group('Admin Sensor entity', () {
    test('treats only explicit zero status as inactive', () {
      const unknownStatus = Sensor(sensId: 'SENS001');
      const inactive = Sensor(sensId: 'SENS002', sensSts: 0);
      const active = Sensor(sensId: 'SENS003', sensSts: 1);

      expect(unknownStatus.isActive, isTrue);
      expect(inactive.isActive, isFalse);
      expect(active.isActive, isTrue);
    });
  });
}
