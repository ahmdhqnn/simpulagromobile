import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:simpulagromobile/core/auth/token_manager.dart';
import 'package:simpulagromobile/core/storage/secure_storage.dart';
import 'package:simpulagromobile/features/auth/domain/constants/auth_failure_messages.dart';
import 'package:simpulagromobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:simpulagromobile/features/auth/data/models/user_model.dart';
import 'package:simpulagromobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:simpulagromobile/core/error/failures.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockTokenManager extends Mock implements TokenManager {}

DioException loginDioException({
  required DioExceptionType type,
  int? statusCode,
  Object? data,
  String? message,
}) {
  final requestOptions = RequestOptions(path: '/auth/login');
  return DioException(
    requestOptions: requestOptions,
    type: type,
    message: message,
    response: statusCode == null
        ? null
        : Response(
            requestOptions: requestOptions,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockSecureStorage mockStorage;
  late MockTokenManager mockTokenManager;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockStorage = MockSecureStorage();
    mockTokenManager = MockTokenManager();
    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockStorage,
      mockTokenManager,
    );
  });

  group('AuthRepositoryImpl', () {
    group('login', () {
      const loginResponse = LoginResponseModel(
        accessToken: 'access_token_123',
        refreshToken: 'refresh_token_456',
        expiresIn: 3600,
        tokenType: 'Bearer',
        user: UserModel(
          userId: 'USR_001',
          userName: 'John Doe',
          userEmail: 'john@example.com',
          roleId: 'ROLE002',
        ),
      );

      test('saves dual tokens and user data on successful login', () async {
        when(
          () => mockRemoteDataSource.login('john', 'pass123'),
        ).thenAnswer((_) async => loginResponse);
        when(
          () => mockTokenManager.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            expiresInSeconds: any(named: 'expiresInSeconds'),
          ),
        ).thenAnswer((_) async {});
        when(() => mockStorage.saveUserData(any())).thenAnswer((_) async {});

        final result = await repository.login('john', 'pass123');

        result.fold((failure) => fail('Should not fail'), (user) {
          expect(user.userId, equals('USR_001'));
          expect(user.userName, equals('John Doe'));
        });

        verify(
          () => mockTokenManager.saveTokens(
            accessToken: 'access_token_123',
            refreshToken: 'refresh_token_456',
            expiresInSeconds: 3600,
          ),
        ).called(1);
        verify(() => mockStorage.saveUserData(any())).called(1);
      });

      test(
        'maps invalid credential response to friendly auth failure',
        () async {
          when(() => mockRemoteDataSource.login('john', 'wrong')).thenThrow(
            loginDioException(
              type: DioExceptionType.badResponse,
              statusCode: 401,
              data: {'message': 'ERR_AUTH_401: invalid credential hash'},
            ),
          );

          final result = await repository.login('john', 'wrong');
          result.fold((failure) {
            expect(failure, isA<AuthFailure>());
            expect(
              failure.message,
              equals(AuthFailureMessages.invalidCredentials),
            );
            expect(failure.message, isNot(contains('ERR_AUTH_401')));
          }, (_) => fail('Should fail'));
        },
      );

      test('maps login timeout to friendly network failure', () async {
        when(() => mockRemoteDataSource.login('john', 'pass123')).thenThrow(
          loginDioException(
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timed out after 0:00:30',
          ),
        );

        final result = await repository.login('john', 'pass123');
        result.fold((failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals(AuthFailureMessages.network));
          expect(failure.message, isNot(contains('Connection timed out')));
        }, (_) => fail('Should fail'));
      });

      test('maps server error to friendly login failure', () async {
        when(() => mockRemoteDataSource.login('john', 'pass123')).thenThrow(
          loginDioException(
            type: DioExceptionType.badResponse,
            statusCode: 500,
            data: 'NullReferenceException at AuthController.login',
          ),
        );

        final result = await repository.login('john', 'pass123');
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals(AuthFailureMessages.server));
          expect(failure.message, isNot(contains('NullReferenceException')));
        }, (_) => fail('Should fail'));
      });

      test(
        'maps unexpected login failure to friendly unknown failure',
        () async {
          when(
            () => mockRemoteDataSource.login('john', 'wrong'),
          ).thenThrow(Exception('Invalid credentials'));

          final result = await repository.login('john', 'wrong');
          result.fold((failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, equals(AuthFailureMessages.unknown));
            expect(failure.message, isNot(contains('Invalid credentials')));
          }, (_) => fail('Should fail'));
        },
      );
    });

    group('logout', () {
      test(
        'invalidates refresh token on server and clears local session',
        () async {
          when(
            () => mockStorage.getRefreshToken(),
          ).thenAnswer((_) async => 'refresh_token_456');
          when(
            () => mockRemoteDataSource.logout('refresh_token_456'),
          ).thenAnswer((_) async {});
          when(() => mockStorage.clearSession()).thenAnswer((_) async {});

          await repository.logout();

          verify(
            () => mockRemoteDataSource.logout('refresh_token_456'),
          ).called(1);
          verify(() => mockStorage.clearSession()).called(1);
        },
      );

      test('clears session even if server logout fails', () async {
        when(
          () => mockStorage.getRefreshToken(),
        ).thenAnswer((_) async => 'refresh_token_456');
        when(
          () => mockRemoteDataSource.logout('refresh_token_456'),
        ).thenAnswer((_) async {}); // logout is best-effort
        when(() => mockStorage.clearSession()).thenAnswer((_) async {});

        await repository.logout();

        verify(() => mockStorage.clearSession()).called(1);
      });
    });

    group('isLoggedIn', () {
      test('delegates to token manager', () async {
        when(
          () => mockTokenManager.hasValidSession(),
        ).thenAnswer((_) async => true);

        final result = await repository.isLoggedIn();

        expect(result, isTrue);
        verify(() => mockTokenManager.hasValidSession()).called(1);
      });

      test('returns false when no valid session', () async {
        when(
          () => mockTokenManager.hasValidSession(),
        ).thenAnswer((_) async => false);

        final result = await repository.isLoggedIn();

        expect(result, isFalse);
      });
    });

    group('getCachedUser', () {
      test('returns user from storage', () async {
        final userModel = const UserModel(
          userId: 'USR_001',
          userName: 'John Doe',
        );
        when(
          () => mockStorage.getUserData(),
        ).thenAnswer((_) async => userModel.toJsonString());

        final user = await repository.getCachedUser();

        expect(user, isNotNull);
        expect(user!.userId, equals('USR_001'));
        expect(user.userName, equals('John Doe'));
      });

      test('returns null when no cached data', () async {
        when(() => mockStorage.getUserData()).thenAnswer((_) async => null);

        final user = await repository.getCachedUser();

        expect(user, isNull);
      });

      test('returns null on invalid cached data', () async {
        when(
          () => mockStorage.getUserData(),
        ).thenAnswer((_) async => 'invalid_json{{{');

        final user = await repository.getCachedUser();

        expect(user, isNull);
      });
    });

    group('getProfile', () {
      test('fetches profile and caches it', () async {
        const userModel = UserModel(
          userId: 'USR_001',
          userName: 'John Updated',
          userEmail: 'john.new@example.com',
        );
        when(
          () => mockRemoteDataSource.getProfile(),
        ).thenAnswer((_) async => userModel);
        when(() => mockStorage.saveUserData(any())).thenAnswer((_) async {});

        final result = await repository.getProfile();

        result.fold((f) => fail('Should not fail'), (user) {
          expect(user.userId, equals('USR_001'));
          expect(user.userName, equals('John Updated'));
        });
        verify(() => mockStorage.saveUserData(any())).called(1);
      });
    });

    group('getPermissions', () {
      test('returns permissions list', () async {
        when(
          () => mockRemoteDataSource.getPermissions(),
        ).thenAnswer((_) async => ['read:site', 'write:site']);

        final result = await repository.getPermissions();

        result.fold((f) => fail('Should not fail'), (perms) {
          expect(perms, equals(['read:site', 'write:site']));
        });
      });
    });

    group('changePassword', () {
      test('returns success message on 200', () async {
        when(
          () => mockRemoteDataSource.changePassword(
            oldPassword: 'old-pass',
            newPassword: 'new-pass',
            confirmPassword: 'new-pass',
          ),
        ).thenAnswer((_) async => 'Password berhasil diubah');

        final result = await repository.changePassword(
          oldPassword: 'old-pass',
          newPassword: 'new-pass',
          confirmPassword: 'new-pass',
        );

        result.fold((f) => fail('Should not fail'), (message) {
          expect(message, 'Password berhasil diubah');
        });
      });

      test('maps 400 to ValidationFailure', () async {
        when(
          () => mockRemoteDataSource.changePassword(
            oldPassword: 'old-pass',
            newPassword: 'new-pass',
            confirmPassword: 'invalid-confirm',
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/change-password'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/auth/change-password'),
              statusCode: 400,
              data: {'message': 'Konfirmasi password tidak cocok'},
            ),
          ),
        );

        final result = await repository.changePassword(
          oldPassword: 'old-pass',
          newPassword: 'new-pass',
          confirmPassword: 'invalid-confirm',
        );

        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Should fail'),
        );
      });

      test('maps 401 to AuthFailure', () async {
        when(
          () => mockRemoteDataSource.changePassword(
            oldPassword: 'wrong-old',
            newPassword: 'new-pass',
            confirmPassword: 'new-pass',
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/change-password'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/auth/change-password'),
              statusCode: 401,
              data: {'message': 'Unauthorized'},
            ),
          ),
        );

        final result = await repository.changePassword(
          oldPassword: 'wrong-old',
          newPassword: 'new-pass',
          confirmPassword: 'new-pass',
        );

        result.fold(
          (failure) => expect(failure, isA<AuthFailure>()),
          (_) => fail('Should fail'),
        );
      });

      test('maps 404 to NotFoundFailure', () async {
        when(
          () => mockRemoteDataSource.changePassword(
            oldPassword: 'old-pass',
            newPassword: 'new-pass',
            confirmPassword: 'new-pass',
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/change-password'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/auth/change-password'),
              statusCode: 404,
              data: {'message': 'User tidak ditemukan'},
            ),
          ),
        );

        final result = await repository.changePassword(
          oldPassword: 'old-pass',
          newPassword: 'new-pass',
          confirmPassword: 'new-pass',
        );

        result.fold(
          (failure) => expect(failure, isA<NotFoundFailure>()),
          (_) => fail('Should fail'),
        );
      });
    });
  });
}
