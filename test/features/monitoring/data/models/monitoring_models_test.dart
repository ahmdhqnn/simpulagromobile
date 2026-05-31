import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/monitoring/data/models/monitoring_models.dart';

void main() {
  group('Monitoring model contract parsing', () {
    test(
      'SensorReadUpdate parses backend update fields and dynamic sensor IDs',
      () {
        final model = SensorReadUpdate.fromJson({
          'ds_id': 'custom_sensor_001',
          'dev_id': 'DEV_001',
          'read_update_date': '2026-05-13T00:00:00.000Z',
          'read_update_value': '0',
        });

        expect(model.readUpdateId, 'DEV_001-custom_sensor_001');
        expect(model.dsId, 'custom_sensor_001');
        expect(model.devId, 'DEV_001');
        expect(
          model.readUpdateDate,
          DateTime.parse('2026-05-13T00:00:00.000Z'),
        );
        expect(model.numericValue, 0);
        expect(model.hasValue, isTrue);
      },
    );

    test('SensorReadModel accepts numeric strings and update aliases', () {
      final model = SensorReadModel.fromJson({
        'read_id': 'READ_001',
        'ds_id': 'soil_ph',
        'dev_id': 'DEV_001',
        'read_update_date': '2026-05-13T01:00:00.000Z',
        'read_update_value': '6.4',
        'read_sts': '1',
      });

      expect(model.readDate, DateTime.parse('2026-05-13T01:00:00.000Z'));
      expect(model.numericValue, 6.4);
      expect(model.readSts, 1);
    });

    test('SensorReadModel treats zero as valid numeric sensor data', () {
      final model = SensorReadModel.fromJson({
        'readId': 'READ_ZERO',
        'dsId': 'soil_hum',
        'devId': 'DEV_001',
        'readDate': '2026-05-13T02:00:00.000Z',
        'readValue': '0',
      });

      expect(model.hasNumericValue, isTrue);
      expect(model.isValid, isTrue);
      expect(model.numericValue, 0);
    });

    test('SensorDailyModel parses string aggregate numbers', () {
      final model = SensorDailyModel.fromJson({
        'day': '2026-05-13T00:00:00.000Z',
        'dev_id': 'DEV_001',
        'ds_id': 'env_temp',
        'avg_val': '24.4',
        'min_val': '20.1',
        'max_val': '28.7',
      });

      expect(model.day, DateTime.parse('2026-05-13T00:00:00.000Z'));
      expect(model.avgVal, 24.4);
      expect(model.minVal, 20.1);
      expect(model.maxVal, 28.7);
    });

    test(
      'MonthlyRekapModel aggregates backend nested day_reads by device sensor',
      () {
        final models = MonthlyRekapModel.fromBackendJson({
          'month': {'year': 2026, 'month': 5},
          'day_reads': [
            {
              'day': '2026-05-13T00:00:00.000Z',
              'dev_id': 'DEV_001',
              'ds_id': 'env_temp',
              'avg_val': '24',
              'min_val': '20',
              'max_val': '28',
            },
            {
              'day': '2026-05-14T00:00:00.000Z',
              'dev_id': 'DEV_001',
              'ds_id': 'env_temp',
              'avg_val': '26',
              'min_val': '22',
              'max_val': '30',
            },
            {
              'day': '2026-05-14T00:00:00.000Z',
              'dev_id': 'DEV_001',
              'ds_id': 'soil_hum',
              'avg_val': '75',
              'min_val': '70',
              'max_val': '80',
            },
          ],
        });

        expect(models, hasLength(2));

        final envTemp = models.singleWhere((model) => model.dsId == 'env_temp');
        expect(envTemp.month, '2026-05');
        expect(envTemp.avgVal, 25);
        expect(envTemp.minVal, 20);
        expect(envTemp.maxVal, 30);

        final soilHum = models.singleWhere((model) => model.dsId == 'soil_hum');
        expect(soilHum.month, '2026-05');
        expect(soilHum.avgVal, 75);
      },
    );

    test('MonthlyRekapModel accepts camelCase backend aggregate aliases', () {
      final models = MonthlyRekapModel.fromBackendJson({
        'month': {'year': 2026, 'month': 6},
        'dayReads': [
          {
            'date': '2026-06-01T00:00:00.000Z',
            'device_id': 'DEV_001',
            'dsId': 'soil_ph',
            'avgValue': '6.2',
            'minValue': '5.9',
            'maxValue': '6.7',
          },
        ],
      });

      expect(models, hasLength(1));
      expect(models.first.month, '2026-06');
      expect(models.first.dsId, 'soil_ph');
      expect(models.first.avgVal, 6.2);
      expect(models.first.minVal, 5.9);
      expect(models.first.maxVal, 6.7);
    });

    test('DeviceSensorThresholdModel parses backend threshold metadata', () {
      final model = DeviceSensorThresholdModel.fromJson({
        'ds_id': 'soil_ph',
        'dev_id': 'DEV_001',
        'sens_id': 'SENS_001',
        'ds_name': 'Soil pH Sensor',
        'unit': {'unit_id': 'UNIT_001', 'unit_symbol': 'pH'},
        'ds_min_norm_value': '5.5',
        'ds_max_norm_value': '7.0',
        'ds_min_val_warn': '5.0',
        'ds_max_val_warn': '8.0',
        'ds_min_value': '4.0',
        'ds_max_value': '9.0',
      });

      expect(model.dsId, 'soil_ph');
      expect(model.devId, 'DEV_001');
      expect(model.sensId, 'SENS_001');
      expect(model.dsName, 'Soil pH Sensor');
      expect(model.unitId, 'UNIT_001');
      expect(model.unitSymbol, 'pH');
      expect(model.dsMinNormValue, 5.5);
      expect(model.dsMaxNormValue, 7.0);
      expect(model.dsMinValWarn, 5.0);
      expect(model.dsMaxValWarn, 8.0);
      expect(model.dsMinValue, 4.0);
      expect(model.dsMaxValue, 9.0);
    });
  });
}
