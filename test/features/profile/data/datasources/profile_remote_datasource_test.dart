import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/profile/data/datasources/profile_remote_datasource.dart';

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
  late ProfileRemoteDatasource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = ProfileRemoteDatasource(dio);
  });

  group('ProfileRemoteDatasource', () {
    test('getUserProfile parses numeric profile fields safely', () async {
      when(() => dio.get(ApiEndpoints.profileMe)).thenAnswer(
        (_) async => _response(ApiEndpoints.profileMe, {
          'data': {
            'user_id': 12,
            'user_name': 'Admin',
            'user_sts': 1,
            'role': {'role_id': 'ROLE001', 'role_name': 'Admin'},
          },
        }),
      );

      final result = await dataSource.getUserProfile();

      expect(result.userId, '12');
      expect(result.userName, 'Admin');
      expect(result.userSts, 'active');
      expect(result.roleId, 'ROLE001');
    });

    test('getUserPermissions parses mixed permission payloads', () async {
      when(() => dio.get(ApiEndpoints.profilePermissions)).thenAnswer(
        (_) async => _response(ApiEndpoints.profilePermissions, {
          'data': {
            'permissions': [
              'site:read',
              {'perm_slug': 'site:create'},
              {
                'permission': {'perm_name': 'site:update'},
              },
            ],
          },
        }),
      );

      final result = await dataSource.getUserPermissions();

      expect(result, ['site:read', 'site:create', 'site:update']);
    });
  });
}
