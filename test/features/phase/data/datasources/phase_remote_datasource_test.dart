import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/phase/data/datasources/phase_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PhaseRemoteDatasource datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = PhaseRemoteDatasource(mockDio);
  });

  group('PhaseRemoteDatasource', () {
    test('corrects explicit HST 0 using backend plant_date', () async {
      when(() => mockDio.get(ApiEndpoints.phasesByHst('SITE001'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.phasesByHst('SITE001'),
          ),
          statusCode: 200,
          data: {
            'status': 200,
            'data': {
              'current_hst': 0,
              'current_date': '2026-06-02',
              'plant': {'plant_date': '2026-05-25', 'plant_type': 'PADI'},
              'current_phase': {
                'phase_id': 'PHASE001',
                'phase_name': 'Perkecambahan',
                'chrop_type': 'PADI',
                'phase_order': 1,
                'phase_hst_min': 0,
                'phase_hst_max': 7,
              },
            },
          },
        ),
      );
      when(() => mockDio.get(ApiEndpoints.phasesByType('PADI'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.phasesByType('PADI'),
          ),
          statusCode: 200,
          data: {
            'status': 200,
            'data': [
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
            ],
          },
        ),
      );

      final phases = await datasource.getPhasesByPlant('SITE001');

      expect(phases[0].status, 'completed');
      expect(phases[0].currentHst, 8);
      expect(phases[1].phaseName, 'Fase Bibit');
      expect(phases[1].status, 'active');
      expect(phases[1].currentHst, 8);

      final current = await datasource.getCurrentPhase('SITE001');

      expect(current?.id, 'PHASE002');
      expect(current?.currentHst, 8);
    });
  });
}
