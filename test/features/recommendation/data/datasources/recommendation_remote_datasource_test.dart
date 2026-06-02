import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/recommendation/data/datasources/recommendation_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late RecommendationRemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = RecommendationRemoteDatasourceImpl(mockDio);
  });

  group('RecommendationRemoteDatasourceImpl', () {
    test('parses by-phase rows using backend category mapping', () async {
      when(
        () => mockDio.get(ApiEndpoints.recByPhase('SITE001', 'PHASE002')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.recByPhase('SITE001', 'PHASE002'),
          ),
          statusCode: 200,
          data: {
            'status': 200,
            'data': [
              {
                'rec_id': 'REC006',
                'phase_id': 'PHASE002',
                'title': 'Pengaturan Air',
                'description': 'Pertahankan tinggi air 2-3 cm.',
                'priority': 'high',
                'category': 'air',
              },
            ],
          },
        ),
      );

      final result = await datasource.getRecommendationsByPhase(
        'SITE001',
        'PHASE002',
      );

      expect(result, hasLength(1));
      expect(result.first.recommendationId, 'REC006');
      expect(result.first.title, 'Pengaturan Air');
      expect(result.first.type, 'watering');
      expect(result.first.priority, 'high');
    });

    test('parses legacy history strings and skips failed pH rows', () async {
      when(() => mockDio.get(ApiEndpoints.recHistory('SITE001'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.recHistory('SITE001'),
          ),
          statusCode: 200,
          data: {
            'status': 200,
            'data': [
              {
                'rec_id': 'REC-SITE_ID-1777462702340',
                'site_id': 'SITE001',
                'rec_date': '2026-04-29',
                'npk_recommendation':
                    '{"n":{"status":"rendah","pesan":"Tambah Urea","dosis_kg_ha":54},"p":"Kondisi normal","k":"Kondisi normal"}',
                'npk_status': 'success',
                'ph_recommendation': null,
                'ph_status': 'error',
                'rec_created': '2026-04-29 11:38:23',
              },
              {
                'rec_id': 'REC-SITE001-1778125552204',
                'site_id': 'SITE001',
                'rec_date': '2026-05-07',
                'npk_recommendation':
                    '{"n":"Kondisi normal","p":"Kondisi normal","k":"Kondisi normal","ph":"Kondisi normal"}',
                'npk_status': 'success',
                'ph_recommendation': '"Kondisi normal"',
                'ph_status': 'success',
                'rec_created': '2026-05-07 03:45:52',
              },
            ],
          },
        ),
      );

      final result = await datasource.getRecommendationHistory('SITE001');

      expect(result.where((item) => item.type == 'npk'), hasLength(2));
      expect(result.where((item) => item.type == 'ph'), hasLength(1));
      expect(
        result.any(
          (item) =>
              item.type == 'ph' &&
              item.recommendationId.contains('1777462702340'),
        ),
        isFalse,
      );
    });

    test(
      'falls back to history when live endpoint returns transient 500',
      () async {
        when(
          () => mockDio.get(
            ApiEndpoints.recommendations('SITE001'),
            queryParameters: null,
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiEndpoints.recommendations('SITE001'),
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: ApiEndpoints.recommendations('SITE001'),
              ),
              statusCode: 500,
              data: {'message': 'database error'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        when(() => mockDio.get(ApiEndpoints.recHistory('SITE001'))).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.recHistory('SITE001'),
            ),
            statusCode: 200,
            data: {
              'status': 200,
              'data': [
                {
                  'rec_id': 'REC-SITE001-1778125552204',
                  'rec_date': '2026-05-07',
                  'npk_recommendation':
                      '{"n":"Kondisi normal","p":"Kondisi normal","k":"Kondisi normal"}',
                  'npk_status': 'success',
                  'rec_created': '2026-05-07 03:45:52',
                },
              ],
            },
          ),
        );

        final result = await datasource.getRecommendationsBySite('SITE001');

        expect(result, isNotEmpty);
        expect(result.first.type, 'npk');
      },
    );

    test('parses live compound NPK dose from N/P/K payload', () async {
      when(
        () => mockDio.get(
          ApiEndpoints.recommendations('SITE001'),
          queryParameters: null,
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.recommendations('SITE001'),
          ),
          statusCode: 200,
          data: {
            'status': 200,
            'data': {
              'recommendations': {
                'npk': {
                  'n': {
                    'status': 'rendah',
                    'pesan': 'Tambah Urea',
                    'dosis_kg_ha': 54,
                  },
                  'p': 'Kondisi normal',
                  'k': 'Kondisi normal',
                },
              },
            },
          },
        ),
      );

      final result = await datasource.getRecommendationsBySite('SITE001');

      expect(result, hasLength(1));
      expect(result.first.type, 'npk');
      expect(result.first.parameters?.npk?.dosisKgHa, 54);
      expect(result.first.actionItems, contains('Dosis N: 54 kg/ha'));
    });
  });
}
