import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/agro/data/datasources/agro_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late AgroRemoteDataSource datasource;

  setUp(() {
    dio = MockDio();
    datasource = AgroRemoteDataSource(dio);
  });

  test('parses the documented double-nested agro response', () async {
    when(() => dio.get(ApiEndpoints.agro('SITE001'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiEndpoints.agro('SITE001')),
        statusCode: 200,
        data: {
          'message': 'Success',
          'data': {
            'status': 200,
            'message': 'Data Agro Ditemukan',
            'data': {
              'vdp': {
                'temp': 28.5,
                'rh': 72,
                'svp': 3.8564,
                'avp': 2.7766,
                'vpd': 1.0798,
                'status': 'Optimal',
              },
              'gdd': {
                'totalGDD': 16,
                'daily': [
                  {
                    'day': '2026-01-15',
                    'tempMin': 22,
                    'tempMax': 32,
                    'gdd': 16,
                  },
                ],
              },
              'etc': [
                {
                  'hst': 42,
                  'phase': 'Vegetatif',
                  'et0': 4.2345,
                  'kc': 1.05,
                  'etc': 4.4462,
                  'waterStatus': 'Normal',
                  'recommendation': 'Pertahankan jadwal irigasi.',
                  'riceType': 'sawah',
                  'day': '2026-01-15',
                },
              ],
            },
          },
        },
      ),
    );

    final result = await datasource.getAgroData('SITE001');

    expect(result.vdp?.vdp, 1.0798);
    expect(result.vdp?.temperature, 28.5);
    expect(result.gdd?.totalGDD, 16);
    expect(result.etc.single.hst, 42);
    expect(result.etc.single.phase, 'Vegetatif');
    expect(result.etc.single.et0, 4.2345);
    expect(result.etc.single.waterStatus, 'Normal');
    expect(result.etc.single.riceType, 'sawah');
  });

  test('parses the documented environmental health response', () async {
    when(() => dio.get(ApiEndpoints.envHealth('SITE001'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiEndpoints.envHealth('SITE001')),
        statusCode: 200,
        data: {
          'message': 'Success',
          'data': {
            'status': 200,
            'data': {
              'overall_health': 78.5,
              'total_sensors': 1,
              'sensors': [
                {
                  'dev_id': 'DEV_001',
                  'ds_id': 'env_temp',
                  'read_update_value': '28.5',
                  'persentase': 100,
                },
              ],
            },
          },
        },
      ),
    );

    final result = await datasource.getEnvironmentalHealth('SITE001');

    expect(result.overallHealth, 78.5);
    expect(result.totalSensors, 1);
    expect(result.sensors.single.percentage, 100);
  });

  test('calculates overall health when the aggregate is omitted', () async {
    when(() => dio.get(ApiEndpoints.envHealth('SITE001'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiEndpoints.envHealth('SITE001')),
        statusCode: 200,
        data: {
          'data': {
            'status': 200,
            'data': {
              'total_sensors': 2,
              'sensors': [
                {
                  'dev_id': 'DEV_001',
                  'ds_id': 'env_temp',
                  'read_update_value': '28.5',
                  'persentase': 100,
                },
                {
                  'dev_id': 'DEV_001',
                  'ds_id': 'soil_nitro',
                  'read_update_value': '8',
                  'persentase': 50,
                },
              ],
            },
          },
        },
      ),
    );

    final result = await datasource.getEnvironmentalHealth('SITE001');

    expect(result.overallHealth, 75);
  });
}
