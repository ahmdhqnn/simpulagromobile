import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/auth/token_manager.dart';
import 'package:simpulagromobile/core/storage/secure_storage.dart';
import 'package:simpulagromobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:simpulagromobile/features/auth/data/models/user_model.dart';
import 'package:simpulagromobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:simpulagromobile/core/error/failures.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockTokenManager extends Mock implements TokenManager {}

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

        result.fold(
          (failure) => fail('Should not fail'),
          (user) {
            expect(user.userId, equals('USR_001'));
            expect(user.userName, equals('John Doe'));
          },
        );

        verify(
          () => mockTokenManager.saveTokens(
            accessToken: 'access_token_123',
            refreshToken: 'refresh_token_456',
            expiresInSeconds: 3600,
          ),
        ).called(1);
        verify(() => mockStorage.saveUserData(any())).called(1);
      });

      test('throws on login failure', () async {
        when(
          () => mockRemoteDataSource.login('john', 'wrong'),
        ).thenThrow(Exception('Invalid credentials'));

        final result = await repository.login('john', 'wrong');
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Should fail'),
        );
      });
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

        result.fold(
          (f) => fail('Should not fail'),
          (user) {
            expect(user.userId, equals('USR_001'));
            expect(user.userName, equals('John Updated'));
          },
        );
        verify(() => mockStorage.saveUserData(any())).called(1);
      });
    });

    group('getPermissions', () {
      test('returns permissions list', () async {
        when(
          () => mockRemoteDataSource.getPermissions(),
        ).thenAnswer((_) async => ['read:site', 'write:site']);

        final result = await repository.getPermissions();

        result.fold(
          (f) => fail('Should not fail'),
          (perms) {
            expect(perms, equals(['read:site', 'write:site']));
          },
        );
      });
    });
  });
}
