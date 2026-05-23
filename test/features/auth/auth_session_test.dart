import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:simpulagromobile/core/auth/token_manager.dart';
import 'package:simpulagromobile/core/storage/secure_storage.dart';
import 'package:simpulagromobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';

class MockDio extends Mock implements Dio {}
class MockSecureStorage extends Mock implements SecureStorage {}
class MockTokenManager extends Mock implements TokenManager {}

void main() {
  group('Auth & Session Tests', () {
    late MockDio mockDio;
    late AuthRemoteDataSource remoteDataSource;

    setUp(() {
      mockDio = MockDio();
      remoteDataSource = AuthRemoteDataSource(mockDio);
    });

    group('AuthRemoteDataSource Login & Logout', () {
      test('login success returns LoginResponseModel', () async {
        final rawResponse = {
          'access_token': 'test_access',
          'refresh_token': 'test_refresh',
          'expires_in': 3600,
          'token_type': 'Bearer',
          'user': {
            'user_id': 'USR_001',
            'user_name': 'Test User',
          }
        };

        when(() => mockDio.post(
          ApiEndpoints.login,
          data: {'username': 'testuser', 'password': 'password123'},
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          data: rawResponse,
          statusCode: 200,
        ));

        final result = await remoteDataSource.login('testuser', 'password123');

        expect(result.accessToken, equals('test_access'));
        expect(result.refreshToken, equals('test_refresh'));
        expect(result.user.userId, equals('USR_001'));
      });

      test('login failure (401) throws DioException', () async {
        when(() => mockDio.post(
          ApiEndpoints.login,
          data: {'username': 'testuser', 'password': 'wrong_password'},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.login),
            statusCode: 401,
          ),
        ));

        expect(
          () => remoteDataSource.login('testuser', 'wrong_password'),
          throwsA(isA<DioException>()),
        );
      });

      test('logout calls the correct endpoint and parameters', () async {
        when(() => mockDio.post(
          ApiEndpoints.logout,
          data: {'refresh_token': 'test_refresh'},
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.logout),
          statusCode: 200,
        ));

        await remoteDataSource.logout('test_refresh');

        verify(() => mockDio.post(
          ApiEndpoints.logout,
          data: {'refresh_token': 'test_refresh'},
        )).called(1);
      });
    });

    group('AuthRemoteDataSource Permissions Parser', () {
      test('handles Map response with permissions key', () async {
        final rawResponse = {
          'data': {
            'permissions': ['read:site', 'write:site']
          }
        };

        when(() => mockDio.get(ApiEndpoints.profilePermissions)).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.profilePermissions),
          data: rawResponse,
          statusCode: 200,
        ));

        final result = await remoteDataSource.getPermissions();
        expect(result, equals(['read:site', 'write:site']));
      });

      test('handles List response of permissions objects', () async {
        final rawResponse = {
          'data': [
            {'perm_name': 'read:site'},
            {'perm_name': 'write:site'}
          ]
        };

        when(() => mockDio.get(ApiEndpoints.profilePermissions)).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.profilePermissions),
          data: rawResponse,
          statusCode: 200,
        ));

        final result = await remoteDataSource.getPermissions();
        expect(result, equals(['read:site', 'write:site']));
      });
    });

    group('TokenManager Concurrent Refresh & Expiry', () {
      late MockSecureStorage mockStorage;
      late MockDio mockRefreshDio;
      late TokenManager tokenManager;

      setUp(() {
        mockStorage = MockSecureStorage();
        mockRefreshDio = MockDio();
        tokenManager = TokenManager(mockStorage, refreshDio: mockRefreshDio);
      });

      test('returns false when getRefreshToken returns empty or null', () async {
        when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => null);

        final result = await tokenManager.refreshAccessToken();
        expect(result, isFalse);
      });

      test('concurrent refresh calls resolve to same result and do not trigger multiple calls', () async {
        when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => 'some_refresh_token');
        when(() => mockStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
          expiresInSeconds: any(named: 'expiresInSeconds'),
        )).thenAnswer((_) async {});

        when(() => mockRefreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh_token': 'some_refresh_token'},
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return Response(
            requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
            statusCode: 200,
            data: {
              'access_token': 'new_access_token',
              'refresh_token': 'new_refresh_token',
              'expires_in': 3600,
            },
          );
        });

        final future1 = tokenManager.refreshAccessToken();
        final future2 = tokenManager.refreshAccessToken();

        final results = await Future.wait([future1, future2]);
        expect(results[0], isTrue);
        expect(results[1], isTrue);

        verify(() => mockRefreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh_token': 'some_refresh_token'},
        )).called(1);
      });

      test('refresh failure (401) clears tokens and calls onSessionExpired', () async {
        when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => 'some_refresh_token');
        when(() => mockStorage.clearSession()).thenAnswer((_) async {});
        
        bool sessionExpiredCalled = false;
        tokenManager.onSessionExpired = () {
          sessionExpiredCalled = true;
        };

        when(() => mockRefreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh_token': 'some_refresh_token'},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
            statusCode: 401,
          ),
        ));

        final result = await tokenManager.refreshAccessToken();

        expect(result, isFalse);
        expect(sessionExpiredCalled, isTrue);
        verify(() => mockStorage.clearSession()).called(1);
      });
    });
  });
}
