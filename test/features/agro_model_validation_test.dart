import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/agro/data/models/agro_model.dart';

void main() {
  group('VdpModel', () {
    test('isValid returns true for valid values', () {
      final vdp = VdpModel(vdp: 50.0, temperature: 25.0, humidity: 60.0);
      expect(vdp.isValid(), isTrue);
    });

    test('isValid returns false when vdp is out of range', () {
      final vdp = VdpModel(vdp: 150.0);
      expect(vdp.isValid(), isFalse);
    });

    test('isValid returns false when temperature is out of range', () {
      final vdp = VdpModel(temperature: 100.0);
      expect(vdp.isValid(), isFalse);
    });

    test('isValid returns false when humidity is out of range', () {
      final vdp = VdpModel(humidity: 150.0);
      expect(vdp.isValid(), isFalse);
    });

    test('isValid allows null values', () {
      final vdp = VdpModel();
      expect(vdp.isValid(), isTrue);
    });

    test('fromJson parses correctly', () {
      final json = {'vdp': 45.5, 'temperature': 22.0, 'humidity': 65.0};
      final vdp = VdpModel.fromJson(json);
      expect(vdp.vdp, equals(45.5));
      expect(vdp.temperature, equals(22.0));
      expect(vdp.humidity, equals(65.0));
    });
  });

  group('GddDailyModel', () {
    test('isValid returns true for valid values', () {
      final gdd = GddDailyModel(day: '2024-01-15', tempMin: 10.0, tempMax: 25.0, gdd: 15.0);
      expect(gdd.isValid(), isTrue);
    });

    test('isValid returns false when gdd is negative', () {
      final gdd = GddDailyModel(gdd: -5.0);
      expect(gdd.isValid(), isFalse);
    });

    test('isValid returns false when temperature is out of range', () {
      final gdd = GddDailyModel(tempMin: -100.0);
      expect(gdd.isValid(), isFalse);
    });
  });

  group('GddModel', () {
    test('isValid returns true for valid structure', () {
      final daily = [
        GddDailyModel(day: '2024-01-15', gdd: 10.0),
        GddDailyModel(day: '2024-01-16', gdd: 12.0),
      ];
      final gdd = GddModel(totalGDD: 22.0, daily: daily);
      expect(gdd.isValid(), isTrue);
    });

    test('isValid returns false when totalGDD is negative', () {
      final daily = [GddDailyModel(day: '2024-01-15', gdd: 10.0)];
      final gdd = GddModel(totalGDD: -5.0, daily: daily);
      expect(gdd.isValid(), isFalse);
    });

    test('isValid returns false when daily list is empty', () {
      final gdd = GddModel(totalGDD: 22.0, daily: []);
      expect(gdd.isValid(), isFalse);
    });

    test('isEmpty returns true when no meaningful data', () {
      final gdd = GddModel(totalGDD: null, daily: []);
      expect(gdd.isEmpty, isTrue);
    });
  });

  group('EtcDailyModel', () {
    test('isValid returns true for valid values', () {
      final etc = EtcDailyModel(
        day: '2024-01-15',
        etc: 5.2,
        kc: 1.1,
        waterNeeds: 5.0,
        tempMin: 15.0,
        tempMax: 28.0,
        rhMin: 40.0,
        rhMax: 90.0,
      );
      expect(etc.isValid(), isTrue);
    });

    test('isValid returns false when etc is negative', () {
      final etc = EtcDailyModel(etc: -2.0);
      expect(etc.isValid(), isFalse);
    });

    test('isValid returns false when kc is out of range', () {
      final etc = EtcDailyModel(kc: 5.0);
      expect(etc.isValid(), isFalse);
    });

    test('isEmpty returns true when no meaningful data', () {
      final etc = EtcDailyModel();
      expect(etc.isEmpty, isTrue);
    });
  });

  group('AgroModel', () {
    test('isEmpty returns true when all fields are empty', () {
      final agro = AgroModel();
      expect(agro.isEmpty, isTrue);
    });

    test('isEmpty returns false when vdp is present', () {
      final vdp = VdpModel(vdp: 50.0);
      final agro = AgroModel(vdp: vdp);
      expect(agro.isEmpty, isFalse);
    });

    test('isValid returns false when all fields are empty', () {
      final agro = AgroModel();
      expect(agro.isValid(), isFalse);
    });

    test('isValid returns false when vdp is invalid', () {
      final vdp = VdpModel(vdp: 150.0);
      final agro = AgroModel(vdp: vdp);
      expect(agro.isValid(), isFalse);
    });

    test('isValid returns true when vdp is valid', () {
      final vdp = VdpModel(vdp: 50.0);
      final agro = AgroModel(vdp: vdp);
      expect(agro.isValid(), isTrue);
    });

    test('isValid returns true when gdd is valid', () {
      final daily = [GddDailyModel(day: '2024-01-15', gdd: 10.0)];
      final gdd = GddModel(totalGDD: 10.0, daily: daily);
      final agro = AgroModel(gdd: gdd);
      expect(agro.isValid(), isTrue);
    });

    test('isValid returns true when etc is valid', () {
      final etc = [EtcDailyModel(day: '2024-01-15', etc: 5.0)];
      final agro = AgroModel(etc: etc);
      expect(agro.isValid(), isTrue);
    });

    test('dataSourceCount returns correct count', () {
      final vdp = VdpModel(vdp: 50.0);
      final daily = [GddDailyModel(day: '2024-01-15', gdd: 10.0)];
      final gdd = GddModel(totalGDD: 10.0, daily: daily);
      final etc = [EtcDailyModel(day: '2024-01-15', etc: 5.0)];
      
      final agro = AgroModel(vdp: vdp, gdd: gdd, etc: etc);
      expect(agro.dataSourceCount, equals(3));
    });

    test('fromJson parses complete response', () {
      final json = {
        'vdp': {
          'vdp': 50.0,
          'temperature': 25.0,
          'humidity': 60.0,
        },
        'gdd': {
          'totalGDD': 22.0,
          'daily': [
            {'day': '2024-01-15', 'tempMin': 10.0, 'tempMax': 25.0, 'gdd': 15.0},
            {'day': '2024-01-16', 'tempMin': 12.0, 'tempMax': 26.0, 'gdd': 14.0},
          ]
        },
        'etc': [
          {
            'day': '2024-01-15',
            'etc': 5.2,
            'kc': 1.1,
            'waterNeeds': 5.0,
            'tempMin': 15.0,
            'tempMax': 28.0,
          }
        ]
      };

      final agro = AgroModel.fromJson(json);
      expect(agro.vdp, isNotNull);
      expect(agro.gdd, isNotNull);
      expect(agro.etc, isNotEmpty);
    });
  });
}
