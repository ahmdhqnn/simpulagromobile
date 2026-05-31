import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/admin/data/datasources/permission_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PermissionRemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = PermissionRemoteDatasourceImpl(mockDio);
  });

  group('PermissionRemoteDatasourceImpl', () {
    test(
      'getAllPermissions parses permission list from backend response',
      () async {
        when(() => mockDio.get(ApiEndpoints.permissionsAll)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ApiEndpoints.permissionsAll),
            statusCode: 200,
            data: {
              'data': [
                {'perm_id': 'PM001', 'perm_name': 'role:read', 'perm_sts': '1'},
              ],
            },
          ),
        );

        final result = await datasource.getAllPermissions();

        expect(result, hasLength(1));
        expect(result.first.permId, 'PM001');
        expect(result.first.permSts, 1);
      },
    );

    test(
      'getPermissionsByRole supports nested permission object rows',
      () async {
        when(
          () => mockDio.get(ApiEndpoints.permissionsByRole('ROLE001')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.permissionsByRole('ROLE001'),
            ),
            statusCode: 200,
            data: {
              'data': [
                {
                  'rp_id': 'RP001',
                  'permission': {
                    'perm_id': 'PM010',
                    'perm_name': 'user:create',
                    'perm_sts': '1',
                  },
                },
              ],
            },
          ),
        );

        final result = await datasource.getPermissionsByRole('ROLE001');

        expect(result, hasLength(1));
        expect(result.first.permId, 'PM010');
        expect(result.first.permName, 'user:create');
        expect(result.first.permSts, 1);
      },
    );

    test('getAllPermissions maps 403 into readable exception', () async {
      when(() => mockDio.get(ApiEndpoints.permissionsAll)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.permissionsAll),
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.permissionsAll),
            statusCode: 403,
            data: {'message': 'Forbidden by policy'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.getAllPermissions(),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('Forbidden by policy'),
          ),
        ),
      );
    });

    test('getPermissionsByRole maps 401 into readable exception', () async {
      when(
        () => mockDio.get(ApiEndpoints.permissionsByRole('ROLE001')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: ApiEndpoints.permissionsByRole('ROLE001'),
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.permissionsByRole('ROLE001'),
            ),
            statusCode: 401,
            data: {'message': 'Unauthorized request'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.getPermissionsByRole('ROLE001'),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('Unauthorized request'),
          ),
        ),
      );
    });

    test('deleteRolePermission maps 404 into readable exception', () async {
      when(
        () => mockDio.delete(
          ApiEndpoints.permissionsDeleteRolePermission('PM001', 'ROLE404'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: ApiEndpoints.permissionsDeleteRolePermission(
              'PM001',
              'ROLE404',
            ),
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: ApiEndpoints.permissionsDeleteRolePermission(
                'PM001',
                'ROLE404',
              ),
            ),
            statusCode: 404,
            data: {'message': 'Role-permission not found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.deleteRolePermission('PM001', 'ROLE404'),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Role-permission not found'),
          ),
        ),
      );
    });

    test('deleteRolePermission calls documented endpoint', () async {
      when(
        () => mockDio.delete(
          ApiEndpoints.permissionsDeleteRolePermission('PM001', 'ROLE001'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: ApiEndpoints.permissionsDeleteRolePermission(
              'PM001',
              'ROLE001',
            ),
          ),
          statusCode: 200,
          data: {'message': 'ok'},
        ),
      );

      await datasource.deleteRolePermission('PM001', 'ROLE001');

      verify(
        () => mockDio.delete(
          ApiEndpoints.permissionsDeleteRolePermission('PM001', 'ROLE001'),
        ),
      ).called(1);
    });
  });
}
