import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:simpulagromobile/features/dashboard/data/models/environmental_health_model.dart';

void main() {
  group('Dashboard model contract parsing', () {
    test('SensorReadModel parses latest read backend fields', () {
      final model = SensorReadModel.fromJson({
        'dev_id': 'DEV_001',
        'ds_id': 'env_temp',
        'read_update_date': '2026-05-13T00:00:00.000Z',
        'read_update_value': '25.3',
      });

      expect(model.devId, 'DEV_001');
      expect(model.dsId, 'env_temp');
      expect(model.value, '25.3');
      expect(model.readAt, DateTime.parse('2026-05-13T00:00:00.000Z'));
    });

    test('SensorReadModel can display aggregate daily rows', () {
      final model = SensorReadModel.fromJson({
        'dev_id': 'DEV_001',
        'ds_id': 'soil_hum',
        'day': '2026-05-13T00:00:00.000Z',
        'avg_val': '77.5',
      });

      expect(model.value, '77.5');
      expect(model.readAt, DateTime.parse('2026-05-13T00:00:00.000Z'));
    });

    test(
      'EnvironmentalHealthModel parses numeric strings and skips invalid sensors',
      () {
        final model = EnvironmentalHealthModel.fromJson({
          'overall_health': '88.5',
          'total_sensors': '12',
          'sensors': [
            {
              'dev_id': 'DEV_001',
              'ds_id': 'soil_ph',
              'read_update_value': '6.4',
              'persentase': '91.5',
            },
            'invalid',
          ],
        });

        expect(model.overallHealth, 88.5);
        expect(model.totalSensors, 12);
        expect(model.sensors, hasLength(1));
        expect(model.sensors.first.persentase, 91.5);
      },
    );

    test('EnvironmentalHealthModel accepts alternate score keys', () {
      final model = EnvironmentalHealthModel.fromJson({
        'score': '76.5',
        'sensors': [
          <dynamic, dynamic>{
            'dev_id': 'DEV_001',
            'ds_id': 'env_temp',
            'value': '28.2',
            'percentage': '80',
          },
        ],
      });

      expect(model.overallHealth, 76.5);
      expect(model.totalSensors, 1);
      expect(model.sensors.single.dsId, 'env_temp');
    });
  });
}
