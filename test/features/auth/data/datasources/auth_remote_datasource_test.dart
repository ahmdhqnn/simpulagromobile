import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/auth/data/datasources/auth_remote_datasource.dart';

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
  late AuthRemoteDataSource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = AuthRemoteDataSource(dio);
  });

  group('AuthRemoteDataSource', () {
    test('getProfile parses profile from response envelope', () async {
      when(() => dio.get(ApiEndpoints.profileMe)).thenAnswer(
        (_) async => _response(ApiEndpoints.profileMe, {
          'data': {'user_id': 12, 'user_name': 'Admin', 'user_sts': 1},
        }),
      );

      final result = await dataSource.getProfile();

      expect(result.userId, '12');
      expect(result.userName, 'Admin');
      expect(result.userSts, 'active');
    });

    test('getPermissions parses mixed string and map permissions', () async {
      when(() => dio.get(ApiEndpoints.profilePermissions)).thenAnswer(
        (_) async => _response(ApiEndpoints.profilePermissions, {
          'data': {
            'permissions': [
              'site:read',
              {'perm_name': 'site:create'},
              {
                'permission': {'perm_slug': 'site:update'},
              },
            ],
          },
        }),
      );

      final result = await dataSource.getPermissions();

      expect(result, ['site:read', 'site:create', 'site:update']);
    });

    test('getPermissions accepts top-level string list', () async {
      when(() => dio.get(ApiEndpoints.profilePermissions)).thenAnswer(
        (_) async => _response(ApiEndpoints.profilePermissions, [
          'site:read',
          'site:create',
        ]),
      );

      final result = await dataSource.getPermissions();

      expect(result, ['site:read', 'site:create']);
    });
  });
}
