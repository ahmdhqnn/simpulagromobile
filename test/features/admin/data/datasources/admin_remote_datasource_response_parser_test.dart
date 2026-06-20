import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/admin/data/datasources/device_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/datasources/device_sensor_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/datasources/role_remote_datasource.dart';
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

    test('device detail unwraps singular device object', () async {
      when(
        () => dio.get(ApiEndpoints.deviceById('SITE001', 'DEV001')),
      ).thenAnswer(
        (_) async => _response(ApiEndpoints.deviceById('SITE001', 'DEV001'), {
          'data': {
            'device': {
              'dev_id': 'DEV001',
              'dev_name': 'Gateway',
              'dev_sts': '1',
            },
          },
        }),
      );

      final result = await DeviceRemoteDatasourceImpl(
        dio,
      ).getDeviceById('SITE001', 'DEV001');

      expect(result.devId, 'DEV001');
      expect(result.devSts, 1);
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
  });
}
