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

    test('parses legacy history strings and keeps backend pH errors', () async {
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
                'ph_error': 'Insufficient pH data',
                'nitrogen': 12,
                'phosphorus': 8,
                'potassium': 10,
                'ph_value': 0,
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
      expect(result.where((item) => item.type == 'ph'), hasLength(2));
      final errorPh = result.singleWhere(
        (item) =>
            item.type == 'ph' &&
            item.recommendationId.contains('1777462702340'),
      );
      expect(errorPh.errorMessage, 'Insufficient pH data');
      expect(errorPh.description, 'Insufficient pH data');
      expect(errorPh.parameters?.sensorData?.nitrogen, 12);
      expect(errorPh.parameters?.sensorData?.ph, 0);
    });

    test(
      'does not show history when live endpoint returns transient 500',
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
        expect(
          () => datasource.getRecommendationsBySite('SITE001'),
          throwsA(isA<DioException>()),
        );
        verifyNever(() => mockDio.get(ApiEndpoints.recHistory('SITE001')));
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

    test('parses NPK with deficient elements and sets correct priority, status, and title', () async {
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
      final npk = result.first;
      expect(npk.type, 'npk');
      expect(npk.priority, 'high');
      expect(npk.title, 'Pemupukan NPK Diperlukan (Nutrisi Rendah)');
    });

    test('parses NPK with mixed (deficient and excess) elements and sets correct priority, status, and title', () async {
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
                  'k': {
                    'status': 'tinggi',
                    'pesan': 'Kelebihan Kalium',
                  },
                },
              },
            },
          },
        ),
      );

      final result = await datasource.getRecommendationsBySite('SITE001');

      expect(result, hasLength(1));
      final npk = result.first;
      expect(npk.type, 'npk');
      expect(npk.priority, 'critical');
      expect(npk.title, 'Penyesuaian Nutrisi NPK (Kondisi Kritis)');
    });

    test(
      'keeps sensor data and exposes partial ML errors from a 400 response',
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
              statusCode: 400,
              data: {
                'message': 'Partial recommendation result',
                'data': {
                  'sensor_data': {
                    'nitrogen': 45.2,
                    'phosphorus': 18.7,
                    'potassium': 120.5,
                    'ph': 0,
                  },
                  'recommendations': {
                    'npk': {
                      'status': 'optimal',
                      'recommendation': 'Pertahankan kondisi NPK',
                    },
                    'ph': {'error': 'Insufficient pH data'},
                  },
                },
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await datasource.getRecommendationsBySite('SITE001');

        expect(result, hasLength(2));
        final npk = result.singleWhere((item) => item.type == 'npk');
        final ph = result.singleWhere((item) => item.type == 'ph');
        expect(npk.description, 'Pertahankan kondisi NPK');
        expect(npk.parameters?.sensorData?.nitrogen, 45.2);
        expect(ph.errorMessage, 'Insufficient pH data');
        expect(ph.description, 'Insufficient pH data');
        expect(ph.actionItems, isEmpty);
      },
    );

    test(
      'gets automatic plant recommendations from seven-day endpoint',
      () async {
        when(
          () => mockDio.get(ApiEndpoints.plantRecBySite('SITE001')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.plantRecBySite('SITE001'),
            ),
            statusCode: 200,
            data: {
              'message': 'Plant recommendations retrieved successfully',
              'data': {
                'recommended_plants': ['Padi', 'Kedelai'],
                'confidence': [0.91, 0.68],
              },
            },
          ),
        );

        final result = await datasource.getLatestRecommendationsForSite(
          'SITE001',
        );

        expect(result.map((item) => item.title), ['Padi', 'Kedelai']);
        verify(
          () => mockDio.get(ApiEndpoints.plantRecBySite('SITE001')),
        ).called(1);
        verifyNever(() => mockDio.get(ApiEndpoints.recHistory('SITE001')));
      },
    );

    test(
      'parses plant-by-site response when ML returns data list directly',
      () async {
        when(
          () => mockDio.get(ApiEndpoints.plantRecBySite('SITE001')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.plantRecBySite('SITE001'),
            ),
            statusCode: 200,
            data: {
              'message': 'Plant recommendations retrieved successfully',
              'data': ['Padi', 'Jagung'],
            },
          ),
        );

        final result = await datasource.getLatestRecommendationsForSite(
          'SITE001',
        );

        expect(result.map((item) => item.title), ['Padi', 'Jagung']);
        expect(result.every((item) => item.siteId == 'SITE001'), isTrue);
      },
    );

    test('parses plant-by-site response when ML returns comma text', () async {
      when(
        () => mockDio.get(ApiEndpoints.plantRecBySite('SITE001')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantRecBySite('SITE001'),
          ),
          statusCode: 200,
          data: {
            'message': 'Plant recommendations retrieved successfully',
            'data': 'Padi, Kedelai',
          },
        ),
      );

      final result = await datasource.getLatestRecommendationsForSite(
        'SITE001',
      );

      expect(result.map((item) => item.title), ['Padi', 'Kedelai']);
    });

    test('parses plant-by-site prediction score map from ML', () async {
      when(
        () => mockDio.get(ApiEndpoints.plantRecBySite('SITE001')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantRecBySite('SITE001'),
          ),
          statusCode: 200,
          data: {
            'message': 'Plant recommendations retrieved successfully',
            'data': {
              'predictions': {'Padi': 91, 'Kedelai': 0.68},
              'details': {
                'Padi': {'reason': 'Cocok dengan rata-rata sensor 7 hari'},
              },
            },
          },
        ),
      );

      final result = await datasource.getLatestRecommendationsForSite(
        'SITE001',
      );

      expect(result.map((item) => item.title), ['Padi', 'Kedelai']);
      expect(result.first.confidenceScore, 0.91);
      expect(result.first.description, 'Cocok dengan rata-rata sensor 7 hari');
    });

    test(
      'does not treat recommendation history rows as plant ML output',
      () async {
        when(
          () => mockDio.get(ApiEndpoints.plantRecBySite('SITE001')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.plantRecBySite('SITE001'),
            ),
            statusCode: 200,
            data: {
              'status': 200,
              'data': [
                {
                  'rec_id': 'REC001',
                  'title': 'Pemupukan NPK',
                  'description': 'Tambah pupuk nitrogen.',
                },
              ],
            },
          ),
        );

        final result = await datasource.getLatestRecommendationsForSite(
          'SITE001',
        );

        expect(result, isEmpty);
      },
    );

    test('keeps plant-by-site documented ML error as empty state', () async {
      when(() => mockDio.get(ApiEndpoints.plantRecBySite('SITE001'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantRecBySite('SITE001'),
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.plantRecBySite('SITE001'),
            ),
            statusCode: 500,
            data: {
              'message': 'Error retrieving plant recommendations',
              'data': null,
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await datasource.getLatestRecommendationsForSite(
        'SITE001',
      );

      expect(result, isEmpty);
    });

    test('parses plant ML result into one recommendation per plant', () async {
      const payload = {
        'soil_nitro': 40.0,
        'soil_phos': 15.0,
        'soil_pot': 200.0,
        'env_temp': 28.0,
        'env_hum': 75.0,
        'soil_ph': 6.5,
      };
      when(
        () => mockDio.post(
          ApiEndpoints.plantRecommendations('SITE001'),
          data: payload,
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantRecommendations('SITE001'),
          ),
          statusCode: 200,
          data: {
            'message': 'Plant recommendations retrieved successfully',
            'data': {
              'recommended_plants': ['Padi', 'Jagung'],
              'confidence': [0.85, 72],
            },
          },
        ),
      );

      final result = await datasource.postPlantRecommendation(
        'SITE001',
        payload,
      );

      expect(result.map((item) => item.title), ['Padi', 'Jagung']);
      expect(result.every((item) => item.type == 'planting'), isTrue);
      expect(result[0].confidenceScore, 0.85);
      expect(result[1].confidenceScore, 0.72);
    });
  });
}
