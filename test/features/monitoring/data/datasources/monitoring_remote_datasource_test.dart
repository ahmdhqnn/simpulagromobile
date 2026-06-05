import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/monitoring/data/datasources/monitoring_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MonitoringRemoteDataSource datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = MonitoringRemoteDataSource(mockDio);
  });

  group('MonitoringRemoteDataSource', () {
    test(
      'falls back to by-day when daily today returns database error',
      () async {
        final today = DateTime.now();
        final day =
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

        when(
          () => mockDio.get(ApiEndpoints.readsDailyToday('SITE001')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiEndpoints.readsDailyToday('SITE001'),
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: ApiEndpoints.readsDailyToday('SITE001'),
              ),
              statusCode: 500,
              data: {'message': 'database error'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        when(
          () => mockDio.get(
            ApiEndpoints.readsDailyByDay('SITE001'),
            queryParameters: {'day': day},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.readsDailyByDay('SITE001'),
            ),
            statusCode: 200,
            data: {
              'status': 200,
              'data': [
                {
                  'day': day,
                  'dev_id': 'DEV001',
                  'ds_id': 'soil_nitro',
                  'avg_val': 80,
                  'min_val': 75,
                  'max_val': 85,
                },
              ],
            },
          ),
        );

        final result = await datasource.getDailyToday('SITE001');

        expect(result, hasLength(1));
        expect(result.first.dsId, 'soil_nitro');
        expect(result.first.avgVal, 80);
      },
    );

    test(
      'does not call aggregate daily reads when by-day fallback is empty',
      () async {
        final today = DateTime.now();
        final day =
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

        when(
          () => mockDio.get(ApiEndpoints.readsDailyToday('SITE001')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiEndpoints.readsDailyToday('SITE001'),
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: ApiEndpoints.readsDailyToday('SITE001'),
              ),
              statusCode: 500,
              data: {'message': 'database error'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        when(
          () => mockDio.get(
            ApiEndpoints.readsDailyByDay('SITE001'),
            queryParameters: {'day': day},
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiEndpoints.readsDailyByDay('SITE001'),
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: ApiEndpoints.readsDailyByDay('SITE001'),
              ),
              statusCode: 404,
              data: {'message': 'no data for today'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await datasource.getDailyToday('SITE001');

        expect(result, isEmpty);
        verifyNever(() => mockDio.get(ApiEndpoints.readsDaily('SITE001')));
      },
    );

    test(
      'falls back to daily reads when monthly recap returns server error',
      () async {
        when(() => mockDio.get(ApiEndpoints.readsMonthly('SITE001'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiEndpoints.readsMonthly('SITE001'),
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: ApiEndpoints.readsMonthly('SITE001'),
              ),
              statusCode: 500,
              data: {'message': 'database timeout'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        when(() => mockDio.get(ApiEndpoints.readsDaily('SITE001'))).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.readsDaily('SITE001'),
            ),
            statusCode: 200,
            data: {
              'status': 200,
              'data': [
                {
                  'day': '2026-06-01',
                  'dev_id': 'DEV001',
                  'ds_id': 'soil_ph',
                  'avg_val': 6.2,
                  'min_val': 6.0,
                  'max_val': 6.4,
                },
                {
                  'day': '2026-06-02',
                  'dev_id': 'DEV001',
                  'ds_id': 'soil_ph',
                  'avg_val': 6.6,
                  'min_val': 6.1,
                  'max_val': 6.9,
                },
              ],
            },
          ),
        );

        final result = await datasource.getMonthlyReads('SITE001');

        expect(result, hasLength(1));
        expect(result.first.month, '2026-06');
        expect(result.first.dsId, 'soil_ph');
        expect(result.first.avgVal, 6.4);
        expect(result.first.minVal, 6.0);
        expect(result.first.maxVal, 6.9);
      },
    );

    test(
      'merges site sensors into devices when devices omit nested sensors',
      () async {
        when(() => mockDio.get(ApiEndpoints.devices('SITE001'))).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.devices('SITE001'),
            ),
            statusCode: 200,
            data: {
              'status': 200,
              'data': [
                {
                  'site_id': 'SITE001',
                  'dev_id': 'DEV001',
                  'dev_name': 'Device 1',
                  'dev_sts': 1,
                },
                {
                  'site_id': 'SITE001',
                  'dev_id': 'DEV002',
                  'dev_name': 'Device 2',
                  'dev_sts': 1,
                },
              ],
            },
          ),
        );
        when(() => mockDio.get(ApiEndpoints.sensors('SITE001'))).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.sensors('SITE001'),
            ),
            statusCode: 200,
            data: {
              'status': 200,
              'data': [
                {
                  'site_id': 'SITE001',
                  'dev_id': 'DEV001',
                  'sens_id': 'SENS001',
                  'sens_name': 'Suhu Udara',
                },
                {
                  'site_id': 'SITE001',
                  'dev_id': 'DEV002',
                  'sens_id': 'SENS002',
                  'sens_name': 'pH Tanah',
                },
                {
                  'site_id': 'SITE999',
                  'dev_id': 'DEV001',
                  'sens_id': 'SENS999',
                  'sens_name': 'Sensor Site Lain',
                },
              ],
            },
          ),
        );

        final result = await datasource.getDevices('SITE001');

        expect(result, hasLength(2));
        expect(result.first.sensors, hasLength(1));
        expect(result.first.sensors.first.sensId, 'SENS001');
        expect(result[1].sensors.first.sensId, 'SENS002');
        expect(
          result
              .expand((device) => device.sensors)
              .map((sensor) => sensor.sensId),
          isNot(contains('SENS999')),
        );
      },
    );

    test(
      'falls back to site recommendation when plant-by-site is empty',
      () async {
        when(
          () => mockDio.get(ApiEndpoints.plantRecBySite('SITE001')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiEndpoints.plantRecBySite('SITE001'),
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: ApiEndpoints.plantRecBySite('SITE001'),
              ),
              statusCode: 404,
              data: {'message': 'No sensor data found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        when(
          () => mockDio.get(ApiEndpoints.recommendations('SITE001')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.recommendations('SITE001'),
            ),
            statusCode: 200,
            data: {
              'status': 200,
              'data': {
                'site_id': 'SITE001',
                'sensor_data': {'nitrogen': 80},
                'recommendations': {
                  'npk': {
                    'n': {'status': 'normal', 'pesan': 'Nitrogen cukup'},
                  },
                },
              },
            },
          ),
        );

        final result = await datasource.getPlantRecommendation('SITE001');

        expect(result['recommendations'], isA<Map>());
        expect((result['sensor_data'] as Map)['nitrogen'], 80);
      },
    );
  });
}
