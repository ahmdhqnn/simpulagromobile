import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/monitoring/data/models/monitoring_models.dart';
import 'package:simpulagromobile/features/monitoring/presentation/utils/sensor_metadata_adapter.dart';

void main() {
  group('SensorMetadataAdapter', () {
    test('uses backend name and unit when available', () {
      final adapter = SensorMetadataAdapter([
        DeviceSensorThresholdModel(
          dsId: 'custom_sensor',
          devId: 'DEV_1',
          dsName: 'Custom Sensor Name',
          unitSymbol: 'ppm',
        ),
      ]);

      expect(
        adapter.labelFor('custom_sensor', devId: 'DEV_1'),
        'Custom Sensor Name',
      );
      expect(adapter.unitFor('custom_sensor', devId: 'DEV_1'), 'ppm');
    });

    test('falls back to legacy local mapping for unknown backend metadata', () {
      final adapter = SensorMetadataAdapter(const []);

      expect(adapter.labelFor('env_temp'), 'Suhu Udara');
      expect(adapter.unitFor('env_temp').isNotEmpty, isTrue);
    });

    test('computes threshold-driven status from backend ranges', () {
      final adapter = SensorMetadataAdapter([
        DeviceSensorThresholdModel(
          dsId: 'soil_ph',
          devId: 'DEV_1',
          dsMinNormValue: 5.5,
          dsMaxNormValue: 7.0,
          dsMinValWarn: 5.0,
          dsMaxValWarn: 8.0,
          dsMinValue: 4.0,
          dsMaxValue: 9.0,
        ),
      ]);

      expect(
        adapter.statusFor(dsId: 'soil_ph', devId: 'DEV_1', value: 6.2),
        SensorReadingStatus.optimal,
      );
      expect(
        adapter.statusFor(dsId: 'soil_ph', devId: 'DEV_1', value: 5.2),
        SensorReadingStatus.warning,
      );
      expect(
        adapter.statusFor(dsId: 'soil_ph', devId: 'DEV_1', value: 3.9),
        SensorReadingStatus.critical,
      );
      expect(
        adapter.statusFor(dsId: 'soil_ph', devId: 'DEV_1', value: 0),
        SensorReadingStatus.offline,
      );
    });
  });
}
