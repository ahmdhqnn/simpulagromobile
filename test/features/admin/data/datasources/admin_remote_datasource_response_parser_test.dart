import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/admin/data/datasources/device_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/datasources/device_sensor_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/datasources/role_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/datasources/sensor_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/datasources/user_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(String path, dynamic data) {
  return Response(
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
    data: data,
  );
}

void main() {
  late MockDio dio;

  setUp(() {
    dio = MockDio();
  });

  group('Admin datasource response parsing', () {
    test('user list accepts direct list response', () async {
      when(() => dio.get(ApiEndpoints.users)).thenAnswer(
        (_) async => _response(ApiEndpoints.users, [
          {'user_id': 'USR_001', 'user_name': 'Admin'},
        ]),
      );

      final result = await UserRemoteDatasourceImpl(dio).getAllUsers();

      expect(result, hasLength(1));
      expect(result.first.userId, 'USR_001');
    });

    test('user detail filters from documented user list endpoint', () async {
      when(() => dio.get(ApiEndpoints.users)).thenAnswer(
        (_) async => _response(ApiEndpoints.users, {
          'data': [
            {'user_id': 'USR_001', 'user_name': 'Admin'},
            {'user_id': 'USR_002', 'user_name': 'Operator'},
          ],
        }),
      );

      final result = await UserRemoteDatasourceImpl(dio).getUserById('USR_002');

      expect(result.userId, 'USR_002');
      verify(() => dio.get(ApiEndpoints.users)).called(1);
      verifyNever(() => dio.get(ApiEndpoints.userById('USR_002')));
    });

    test('role update unwraps singular role object', () async {
      when(
        () =>
            dio.put(ApiEndpoints.roleById('ROLE001'), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(ApiEndpoints.roleById('ROLE001'), {
          'message': 'ok',
          'data': {
            'role': {
              'role_id': 'ROLE001',
              'role_name': 'Admin',
              'role_sts': '1',
            },
          },
        }),
      );

      final result = await RoleRemoteDatasourceImpl(
        dio,
      ).updateRole('ROLE001', {'role_name': 'Admin'});

      expect(result.roleId, 'ROLE001');
      expect(result.roleSts, 1);
    });

    test(
      'device detail uses documented dev_id query and parses metadata',
      () async {
        when(
          () => dio.get(
            ApiEndpoints.devices('SITE001'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => _response(ApiEndpoints.devices('SITE001'), {
            'data': {
              'devices': [
                {
                  'dev_id': 'DEV001',
                  'dev_name': 'Gateway',
                  'dev_sts': '1',
                  'created_at': '2026-06-01T00:00:00.000Z',
                  'updated_at': '2026-06-02T00:00:00.000Z',
                },
              ],
            },
          }),
        );

        final result = await DeviceRemoteDatasourceImpl(
          dio,
        ).getDeviceById('SITE001', 'DEV001');

        expect(result.devId, 'DEV001');
        expect(result.devSts, 1);
        expect(result.devCreated, DateTime.parse('2026-06-01T00:00:00.000Z'));
        expect(result.devUpdate, DateTime.parse('2026-06-02T00:00:00.000Z'));
        verify(
          () => dio.get(
            ApiEndpoints.devices('SITE001'),
            queryParameters: any(
              named: 'queryParameters',
              that: containsPair('dev_id', 'DEV001'),
            ),
          ),
        ).called(1);
      },
    );

    test('sensor detail accepts nested sensor list response', () async {
      when(
        () => dio.get(ApiEndpoints.sensorDetail('SITE001', 'SENS002')),
      ).thenAnswer(
        (_) async =>
            _response(ApiEndpoints.sensorDetail('SITE001', 'SENS002'), {
              'data': {
                'sensor': [
                  {
                    'sens_id': 'SENS002',
                    'dev_id': 'DEV001',
                    'sens_name': 'Soil pH',
                    'sens_sts': null,
                  },
                ],
              },
            }),
      );

      final result = await SensorRemoteDatasourceImpl(
        dio,
      ).getSensorById('SITE001', 'SENS002');

      expect(result.sensId, 'SENS002');
      expect(result.devId, 'DEV001');
      expect(result.sensSts, isNull);
    });

    test(
      'device-sensor list accepts documented device_sensors wrapper',
      () async {
        when(() => dio.get(ApiEndpoints.deviceSensors('SITE001'))).thenAnswer(
          (_) async => _response(ApiEndpoints.deviceSensors('SITE001'), {
            'data': {
              'device_sensors': [
                {
                  'ds_id': 'DS001',
                  'dev_id': 'DEV001',
                  'ds_sequence': '2',
                  'ds_sts': '1',
                },
              ],
            },
          }),
        );

        final result = await DeviceSensorRemoteDatasourceImpl(
          dio,
        ).getAllDeviceSensors('SITE001');

        expect(result, hasLength(1));
        expect(result.first.dsId, 'DS001');
        expect(result.first.dsSeq, 2);
      },
    );

    test(
      'device-sensor detail merges threshold values by ds_id and dev_id',
      () async {
        when(() => dio.get(ApiEndpoints.deviceSensors('SITE001'))).thenAnswer(
          (_) async => _response(ApiEndpoints.deviceSensors('SITE001'), {
            'data': {
              'device_sensors': [
                {
                  'ds_id': 'soil_ph',
                  'dev_id': 'DEV001',
                  'sens_id': 'SENS001',
                  'unit_id': 'UNIT001',
                  'ds_created': '2026-06-01T00:00:00.000Z',
                  'ds_update': '2026-06-02T00:00:00.000Z',
                },
              ],
            },
          }),
        );
        when(
          () => dio.get(ApiEndpoints.deviceSensorValues('SITE001')),
        ).thenAnswer(
          (_) async => _response(ApiEndpoints.deviceSensorValues('SITE001'), {
            'data': {
              'values': [
                {
                  'ds_id': 'soil_ph',
                  'dev_id': 'DEV001',
                  'min_norm': '5.5',
                  'max_norm': '7.0',
                  'min_warn': '5.0',
                  'max_warn': '8.0',
                  'min_val': '4.0',
                  'max_val': '9.0',
                },
              ],
            },
          }),
        );

        final result = await DeviceSensorRemoteDatasourceImpl(
          dio,
        ).getDeviceSensorById('SITE001', 'soil_ph');

        expect(result.dsMinNormValue, 5.5);
        expect(result.dsMaxNormValue, 7.0);
        expect(result.dsMinValWarn, 5.0);
        expect(result.dsMaxValWarn, 8.0);
        expect(result.dsMinValue, 4.0);
        expect(result.dsMaxValue, 9.0);
        expect(result.dsCreated, DateTime.parse('2026-06-01T00:00:00.000Z'));
        expect(result.dsUpdate, DateTime.parse('2026-06-02T00:00:00.000Z'));
      },
    );

    test('device-sensor detail filters duplicate ds_id by dev_id', () async {
      when(() => dio.get(ApiEndpoints.deviceSensors('SITE001'))).thenAnswer(
        (_) async => _response(ApiEndpoints.deviceSensors('SITE001'), {
          'data': {
            'device_sensors': [
              {
                'ds_id': 'soil_ph',
                'dev_id': 'DEV_A',
                'ds_name': 'Wrong mapping',
                'sensor': [
                  {'sens_id': 'SENS_A'},
                ],
                'ds_created_at': '2026-06-01 01:02:03',
              },
              {
                'ds_id': 'soil_ph',
                'dev_id': 'DEV_B',
                'ds_name': 'Correct mapping',
                'sensors': [
                  {'sens_id': 'SENS_B'},
                ],
                'ds_created_at': '2026-06-03 01:02:03',
              },
            ],
          },
        }),
      );
      when(
        () => dio.get(ApiEndpoints.deviceSensorValues('SITE001')),
      ).thenAnswer(
        (_) async => _response(ApiEndpoints.deviceSensorValues('SITE001'), {
          'data': {
            'values': [
              {'ds_id': 'soil_ph', 'dev_id': 'DEV_B', 'min_norm': '6.0'},
            ],
          },
        }),
      );

      final result = await DeviceSensorRemoteDatasourceImpl(
        dio,
      ).getDeviceSensorById('SITE001', 'soil_ph', devId: 'DEV_B');

      expect(result.devId, 'DEV_B');
      expect(result.sensId, 'SENS_B');
      expect(result.dsName, 'Correct mapping');
      expect(result.dsMinNormValue, 6.0);
      expect(result.dsCreated, DateTime.parse('2026-06-03T01:02:03'));
    });

    test('threshold values are enriched with mapping sensor fields', () async {
      when(
        () => dio.get(ApiEndpoints.deviceSensorValues('SITE001')),
      ).thenAnswer(
        (_) async => _response(ApiEndpoints.deviceSensorValues('SITE001'), {
          'data': {
            'values': [
              {
                'ds_id': 'soil_ph',
                'dev_id': 'TELU0200',
                'ds_min_norm_value': 5.5,
                'ds_max_norm_value': 7.5,
              },
            ],
          },
        }),
      );
      when(() => dio.get(ApiEndpoints.deviceSensors('SITE001'))).thenAnswer(
        (_) async => _response(ApiEndpoints.deviceSensors('SITE001'), {
          'data': {
            'device_sensors': [
              {
                'ds_id': 'soil_ph',
                'dev_id': 'TELU0200',
                'sens_id': 'SENSOR002',
                'unit_id': 'ph',
                'ds_name': 'Soil pH',
                'dc_normal_value': 6.5,
              },
            ],
          },
        }),
      );

      final result = await DeviceSensorRemoteDatasourceImpl(
        dio,
      ).getThresholdValues('SITE001');

      expect(result, hasLength(1));
      expect(result.first['sens_id'], 'SENSOR002');
      expect(result.first['unit_id'], 'ph');
      expect(result.first['ds_name'], 'Soil pH');
      expect(result.first['dc_normal_value'], 6.5);
      expect(result.first['ds_min_norm_value'], 5.5);
    });

    test(
      'threshold values fall back to mapping rows when values endpoint is empty',
      () async {
        when(
          () => dio.get(ApiEndpoints.deviceSensorValues('SITE001')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: ApiEndpoints.deviceSensorValues('SITE001'),
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: ApiEndpoints.deviceSensorValues('SITE001'),
              ),
              statusCode: 404,
              data: {'message': 'No threshold values found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        when(() => dio.get(ApiEndpoints.deviceSensors('SITE001'))).thenAnswer(
          (_) async => _response(ApiEndpoints.deviceSensors('SITE001'), {
            'data': {
              'device_sensors': [
                {
                  'ds_id': 'env_hum',
                  'dev_id': 'TELU0200',
                  'sens_id': 'SENSOR001',
                  'dc_normal_value': 70,
                  'ds_min_norm_value': 40,
                  'ds_max_norm_value': 90,
                  'ds_min_value': 0,
                  'ds_max_value': 100,
                  'ds_min_val_warn': 20,
                  'ds_max_val_warn': 95,
                },
              ],
            },
          }),
        );

        final result = await DeviceSensorRemoteDatasourceImpl(
          dio,
        ).getThresholdValues('SITE001');

        expect(result, hasLength(1));
        expect(result.first['ds_id'], 'env_hum');
        expect(result.first['sens_id'], 'SENSOR001');
        expect(result.first['ds_min_norm_value'], 40);
        expect(result.first['ds_max_val_warn'], 95);
      },
    );
  });
}
