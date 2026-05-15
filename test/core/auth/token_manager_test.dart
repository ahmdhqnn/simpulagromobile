import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/auth/token_manager.dart';
import 'package:simpulagromobile/core/storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockSecureStorage mockStorage;
  late TokenManager tokenManager;

  setUp(() {
    mockStorage = MockSecureStorage();
    tokenManager = TokenManager(mockStorage);
  });

  group('TokenManager', () {
    group('hasValidSession', () {
      test('returns true when access token exists', () async {
        when(
          () => mockStorage.getAccessToken(),
        ).thenAnswer((_) async => 'valid_token');

        final result = await tokenManager.hasValidSession();

        expect(result, isTrue);
        verify(() => mockStorage.getAccessToken()).called(1);
      });

      test('returns false when access token is null', () async {
        when(() => mockStorage.getAccessToken()).thenAnswer((_) async => null);

        final result = await tokenManager.hasValidSession();

        expect(result, isFalse);
      });

      test('returns false when access token is empty', () async {
        when(() => mockStorage.getAccessToken()).thenAnswer((_) async => '');

        final result = await tokenManager.hasValidSession();

        expect(result, isFalse);
      });
    });

    group('isAccessTokenExpired', () {
      test('delegates to storage', () async {
        when(
          () => mockStorage.isAccessTokenExpired(),
        ).thenAnswer((_) async => true);

        final result = await tokenManager.isAccessTokenExpired();

        expect(result, isTrue);
        verify(() => mockStorage.isAccessTokenExpired()).called(1);
      });

      test('returns false when token is still valid', () async {
        when(
          () => mockStorage.isAccessTokenExpired(),
        ).thenAnswer((_) async => false);

        final result = await tokenManager.isAccessTokenExpired();

        expect(result, isFalse);
      });
    });

    group('saveTokens', () {
      test('saves tokens to storage', () async {
        when(
          () => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            expiresInSeconds: any(named: 'expiresInSeconds'),
          ),
        ).thenAnswer((_) async {});

        await tokenManager.saveTokens(
          accessToken: 'access_123',
          refreshToken: 'refresh_456',
          expiresInSeconds: 3600,
        );

        verify(
          () => mockStorage.saveTokens(
            accessToken: 'access_123',
            refreshToken: 'refresh_456',
            expiresInSeconds: 3600,
          ),
        ).called(1);
      });
    });

    group('clearTokens', () {
      test('clears session from storage', () async {
        when(() => mockStorage.clearSession()).thenAnswer((_) async {});

        await tokenManager.clearTokens();

        verify(() => mockStorage.clearSession()).called(1);
      });
    });

    group('refreshAccessToken', () {
      test('returns false when no refresh token available', () async {
        when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => null);

        final result = await tokenManager.refreshAccessToken();

        expect(result, isFalse);
      });

      test('returns false when refresh token is empty', () async {
        when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => '');

        final result = await tokenManager.refreshAccessToken();

        expect(result, isFalse);
      });
    });
  });
}
