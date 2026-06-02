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
  });
}
