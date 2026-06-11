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
    test('keeps explicit HST 0 as a valid planting-day value', () async {
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

      expect(phases[0].status, 'active');
      expect(phases[0].currentHst, 0);
      expect(phases[1].phaseName, 'Fase Bibit');
      expect(phases[1].status, 'upcoming');
      expect(phases[1].currentHst, 0);

      final current = await datasource.getCurrentPhase('SITE001');

      expect(current?.id, 'PHASE001');
      expect(current?.currentHst, 0);
    });

    test('treats a body-level 404 as no active phase', () async {
      when(() => mockDio.get(ApiEndpoints.phasesByHst('SITE001'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.phasesByHst('SITE001'),
          ),
          statusCode: 200,
          data: {
            'status': 404,
            'message': 'Tidak ada tanaman aktif di Site ID ini',
            'data': null,
          },
        ),
      );

      final current = await datasource.getCurrentPhaseByHst('SITE001');

      expect(current, isNull);
    });

    test('sorts crop phases by phase_order', () async {
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
                'phase_id': 'PH002',
                'phase_name': 'Vegetatif',
                'chrop_type': 'PADI',
                'phase_order': 2,
                'phase_hst_min': 15,
                'phase_hst_max': 55,
              },
              {
                'phase_id': 'PH001',
                'phase_name': 'Perkecambahan',
                'chrop_type': 'PADI',
                'phase_order': 1,
                'phase_hst_min': 0,
                'phase_hst_max': 14,
              },
            ],
          },
        ),
      );

      final phases = await datasource.getPhasesByCropType('PADI');

      expect(phases.map((phase) => phase.id), ['PH001', 'PH002']);
    });
  });
}
