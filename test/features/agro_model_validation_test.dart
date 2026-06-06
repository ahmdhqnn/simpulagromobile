import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/agro/data/models/agro_model.dart';
import 'package:simpulagromobile/features/agro/domain/entities/agro_entity.dart';
import 'package:simpulagromobile/features/agro/presentation/widgets/environmental_health_widget.dart';
import 'package:simpulagromobile/features/agro/presentation/widgets/etc_widget.dart';
import 'package:simpulagromobile/features/agro/presentation/widgets/vdp_widget.dart';
import 'package:simpulagromobile/features/dashboard/domain/entities/dashboard_entity.dart';

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

    test('fromJson parses compact kPa fields and unit strings', () {
      final json = {'v': '0,50 kPa', 'd': '0.30 kPa', 'p': '0.20 kPa'};
      final vdp = VdpModel.fromJson(json);
      expect(vdp.vdp, equals(0.5));
      expect(vdp.es, equals(0.3));
      expect(vdp.ea, equals(0.2));
      expect(vdp.temperature, isNull);
      expect(vdp.humidity, isNull);
    });

    test('fromJson parses VDP detail keys case-insensitively', () {
      final json = {'V': '1.49 kPa', 'D': '1.80 kPa', 'P': '0.31 kPa'};
      final vdp = VdpModel.fromJson(json);
      expect(vdp.vdp, equals(1.49));
      expect(vdp.es, equals(1.8));
      expect(vdp.ea, equals(0.31));
    });
  });

  group('VdpWidget', () {
    testWidgets('renders kPa details without placeholder units', (
      WidgetTester tester,
    ) async {
      const vdp = VdpEntity(vdp: 0.5, es: 0.3, ea: 0.2);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: VdpWidget(vdpData: vdp)),
          ),
        ),
      );

      expect(find.text('0.50'), findsOneWidget);
      expect(find.text('0.50 kPa'), findsOneWidget);
      expect(find.text('0.30 kPa'), findsOneWidget);
      expect(find.text('0.20 kPa'), findsOneWidget);
      expect(find.text('Detail VPD'), findsOneWidget);
      expect(find.text('V (VDP)'), findsOneWidget);
      expect(find.text('D (Es)'), findsOneWidget);
      expect(find.text('P (Ea)'), findsOneWidget);
      expect(find.text('- kPa'), findsNothing);
      expect(find.text('-%'), findsNothing);
      expect(find.text('- C'), findsNothing);
    });

    testWidgets('keeps D and P slots visible when backend only sends VDP', (
      WidgetTester tester,
    ) async {
      const vdp = VdpEntity(vdp: 1.49);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: VdpWidget(vdpData: vdp)),
          ),
        ),
      );

      expect(find.text('V (VDP)'), findsOneWidget);
      expect(find.text('D (Es)'), findsOneWidget);
      expect(find.text('P (Ea)'), findsOneWidget);
      expect(find.text('1.49 kPa'), findsOneWidget);
      expect(find.text('Belum ada'), findsNWidgets(2));
      expect(find.text('- kPa'), findsNothing);
      expect(find.text('-%'), findsNothing);
    });
  });

  group('EnvironmentalHealthWidget', () {
    testWidgets('renders backend total sensors and sensor health rows', (
      WidgetTester tester,
    ) async {
      const health = EnvironmentalHealthEntity(
        overallHealth: 88.5,
        totalSensors: 12,
        sensors: [
          SensorHealthEntity(
            devId: 'DEV_001',
            dsId: 'DS_001',
            readUpdateValue: '25.3',
            persentase: 85,
          ),
        ],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: EnvironmentalHealthWidget(healthData: health),
            ),
          ),
        ),
      );

      expect(find.text('12 sensor dipantau'), findsOneWidget);
      expect(find.text('88.5/100'), findsOneWidget);
      expect(find.text('DEV_001 - 25.3'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
    });
  });

  group('EtcWidget', () {
    testWidgets(
      'renders Swagger ETC payload without missing optional metrics',
      (WidgetTester tester) async {
        const etc = [
          EtcDailyEntity(
            etc: 4.12,
            day: '2026-05-13',
            tempMin: 20.1,
            tempMax: 28.7,
            rhMin: 60,
            rhMax: 85,
          ),
        ];

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: EtcWidget(etcData: etc)),
            ),
          ),
        );

        expect(find.text('4.12'), findsOneWidget);
        expect(find.text('Kc'), findsNothing);
        expect(find.text('Kebutuhan'), findsNothing);
        expect(find.text('Kebutuhan Air'), findsNothing);
        expect(find.text('Status ETC'), findsOneWidget);
        expect(find.text('20.1 C - 28.7 C'), findsOneWidget);
        expect(find.text('60.0% - 85.0%'), findsOneWidget);
      },
    );
  });

  group('GddDailyModel', () {
    test('isValid returns true for valid values', () {
      final gdd = GddDailyModel(
        day: '2024-01-15',
        tempMin: 10.0,
        tempMax: 25.0,
        gdd: 15.0,
      );
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

    test('fromJson keeps companion D and P when VDP is a scalar field', () {
      final agro = AgroModel.fromJson({
        'vdp': '1.49 kPa',
        'D': '1.80 kPa',
        'P': '0.31 kPa',
      });

      expect(agro.vdp?.vdp, equals(1.49));
      expect(agro.vdp?.es, equals(1.8));
      expect(agro.vdp?.ea, equals(0.31));
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
      // dataSourceCount dihapus dari AgroModel — test ini diganti dengan isEmpty check
      final vdp = VdpModel(vdp: 50.0);
      final daily = [GddDailyModel(day: '2024-01-15', gdd: 10.0)];
      final gdd = GddModel(totalGDD: 10.0, daily: daily);
      final etc = [EtcDailyModel(day: '2024-01-15', etc: 5.0)];

      final agro = AgroModel(vdp: vdp, gdd: gdd, etc: etc);
      expect(agro.isEmpty, isFalse);
    });

    test('fromJson parses complete response', () {
      final json = {
        'vdp': {'vdp': 50.0, 'temperature': 25.0, 'humidity': 60.0},
        'gdd': {
          'totalGDD': 22.0,
          'daily': [
            {
              'day': '2024-01-15',
              'tempMin': 10.0,
              'tempMax': 25.0,
              'gdd': 15.0,
            },
            {
              'day': '2024-01-16',
              'tempMin': 12.0,
              'tempMax': 26.0,
              'gdd': 14.0,
            },
          ],
        },
        'etc': [
          {
            'day': '2024-01-15',
            'etc': 5.2,
            'kc': 1.1,
            'waterNeeds': 5.0,
            'tempMin': 15.0,
            'tempMax': 28.0,
          },
        ],
      };

      final agro = AgroModel.fromJson(json);
      expect(agro.vdp, isNotNull);
      expect(agro.gdd, isNotNull);
      expect(agro.etc, isNotEmpty);
    });

    test('fromJson accepts vpd alias for agro response', () {
      final agro = AgroModel.fromJson({'vpd': '0.75 kPa'});
      expect(agro.vdp?.vdp, equals(0.75));
    });
  });
}
