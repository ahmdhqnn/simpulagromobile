import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/providers/app_startup_provider.dart';
import 'package:simpulagromobile/features/auth/data/models/user_model.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/auth/domain/constants/auth_failure_messages.dart';
import 'package:simpulagromobile/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('AuthNotifier', () {
    group('initialization from startup data', () {
      test('sets authenticated when startup has valid user data', () {
        final user = const UserModel(
          userId: 'USR_001',
          userName: 'John Doe',
          roleId: 'ROLE002',
        );
        final startupData = AppStartupData(
          token: 'valid_token',
          userData: user.toJsonString(),
        );

        // Stub permissions call that happens during init
        when(
          () => mockRepository.getPermissions(),
        ).thenAnswer((_) async => const Right(['read:site']));

        final notifier = AuthNotifier(mockRepository, startupData: startupData);

        expect(notifier.state.status, equals(AuthStatus.authenticated));
        expect(notifier.state.user?.userId, equals('USR_001'));
        expect(notifier.state.user?.userName, equals('John Doe'));
      });

      test('sets unauthenticated when startup has no token', () {
        const startupData = AppStartupData(token: null, userData: null);

        final notifier = AuthNotifier(mockRepository, startupData: startupData);

        expect(notifier.state.status, equals(AuthStatus.unauthenticated));
        expect(notifier.state.user, isNull);
      });

      test('sets unauthenticated when startup has invalid user data', () {
        const startupData = AppStartupData(
          token: 'valid_token',
          userData: 'invalid_json{{{',
        );

        final notifier = AuthNotifier(mockRepository, startupData: startupData);

        expect(notifier.state.status, equals(AuthStatus.unauthenticated));
      });
    });

    group('login', () {
      test('returns true and sets authenticated on success', () async {
        const user = User(
          userId: 'USR_001',
          userName: 'John Doe',
          roleId: 'ROLE002',
        );
        when(
          () => mockRepository.login('john', 'pass123'),
        ).thenAnswer((_) async => const Right(user));
        when(
          () => mockRepository.getPermissions(),
        ).thenAnswer((_) async => const Right(['read:site']));

        final notifier = AuthNotifier(mockRepository);
        final result = await notifier.login('john', 'pass123');

        expect(result, isTrue);
        expect(notifier.state.status, equals(AuthStatus.authenticated));
        expect(notifier.state.user?.userId, equals('USR_001'));
        expect(notifier.state.error, isNull);
      });

      test('returns false and sets error on failure', () async {
        when(() => mockRepository.login('john', 'wrong')).thenAnswer(
          (_) async => const Left(AuthFailure('Username atau Password salah')),
        );

        final notifier = AuthNotifier(mockRepository);
        final result = await notifier.login('john', 'wrong');

        expect(result, isFalse);
        expect(notifier.state.status, equals(AuthStatus.unauthenticated));
        expect(notifier.state.error, isNotNull);
        expect(
          notifier.state.error,
          equals(AuthFailureMessages.invalidCredentials),
        );
      });

      test('sets connection error message on network failure', () async {
        when(() => mockRepository.login('john', 'pass')).thenAnswer(
          (_) async => const Left(NetworkFailure('Tidak Ada Koneksi Internet')),
        );

        final notifier = AuthNotifier(mockRepository);
        final result = await notifier.login('john', 'pass');

        expect(result, isFalse);
        expect(notifier.state.error, equals(AuthFailureMessages.network));
      });
    });

    group('logout', () {
      test('clears state and calls repository logout', () async {
        const user = User(userId: 'USR_001', userName: 'John');
        when(
          () => mockRepository.login('john', 'pass'),
        ).thenAnswer((_) async => const Right(user));
        when(
          () => mockRepository.getPermissions(),
        ).thenAnswer((_) async => const Right([]));
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        final notifier = AuthNotifier(mockRepository);
        await notifier.login('john', 'pass');

        expect(notifier.state.status, equals(AuthStatus.authenticated));

        await notifier.logout();

        expect(notifier.state.status, equals(AuthStatus.unauthenticated));
        expect(notifier.state.user, isNull);
        verify(() => mockRepository.logout()).called(1);
      });
    });

    group('handleSessionExpired', () {
      test('logs out and sets session expired error', () async {
        const user = User(userId: 'USR_001', userName: 'John');
        when(
          () => mockRepository.login('john', 'pass'),
        ).thenAnswer((_) async => const Right(user));
        when(
          () => mockRepository.getPermissions(),
        ).thenAnswer((_) async => const Right([]));
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        final notifier = AuthNotifier(mockRepository);
        await notifier.login('john', 'pass');

        await notifier.handleSessionExpired();

        expect(notifier.state.status, equals(AuthStatus.unauthenticated));
        expect(notifier.state.error, contains('Sesi Anda telah berakhir'));
        verify(() => mockRepository.logout()).called(1);
      });

      test('does nothing if already unauthenticated', () async {
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        final notifier = AuthNotifier(mockRepository);

        await notifier.handleSessionExpired();

        verifyNever(() => mockRepository.logout());
      });
    });

    group('checkAuthStatus', () {
      test('sets authenticated when logged in with cached user', () async {
        const user = UserModel(userId: 'USR_001', userName: 'John');
        when(() => mockRepository.isLoggedIn()).thenAnswer((_) async => true);
        when(
          () => mockRepository.getCachedUser(),
        ).thenAnswer((_) async => user);
        when(
          () => mockRepository.getPermissions(),
        ).thenAnswer((_) async => const Right(['read:site']));

        final notifier = AuthNotifier(mockRepository);
        await notifier.checkAuthStatus();

        expect(notifier.state.status, equals(AuthStatus.authenticated));
        expect(notifier.state.user?.userId, equals('USR_001'));
      });

      test('sets unauthenticated when not logged in', () async {
        when(() => mockRepository.isLoggedIn()).thenAnswer((_) async => false);

        final notifier = AuthNotifier(mockRepository);
        await notifier.checkAuthStatus();

        expect(notifier.state.status, equals(AuthStatus.unauthenticated));
      });

      test('sets unauthenticated when logged in but no cached user', () async {
        when(() => mockRepository.isLoggedIn()).thenAnswer((_) async => true);
        when(
          () => mockRepository.getCachedUser(),
        ).thenAnswer((_) async => null);

        final notifier = AuthNotifier(mockRepository);
        await notifier.checkAuthStatus();

        expect(notifier.state.status, equals(AuthStatus.unauthenticated));
      });

      test('skips check if already authenticated', () async {
        const user = User(userId: 'USR_001', userName: 'John');
        when(
          () => mockRepository.login('john', 'pass'),
        ).thenAnswer((_) async => const Right(user));
        when(
          () => mockRepository.getPermissions(),
        ).thenAnswer((_) async => const Right([]));

        final notifier = AuthNotifier(mockRepository);
        await notifier.login('john', 'pass');

        // Should not call isLoggedIn since already authenticated
        await notifier.checkAuthStatus();

        verifyNever(() => mockRepository.isLoggedIn());
      });
    });
  });

  group('AuthState', () {
    test('hasPermission returns true for existing permission', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        permissions: ['read:site', 'write:site'],
      );

      expect(state.hasPermission('read:site'), isTrue);
      expect(state.hasPermission('delete:site'), isFalse);
    });

    test('isAdmin returns true for ROLE001', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        user: User(userId: 'USR_001', userName: 'Admin', roleId: 'ROLE001'),
      );

      expect(state.isAdmin, isTrue);
    });

    test('isAuthenticated returns true only for authenticated status', () {
      const authenticated = AuthState(status: AuthStatus.authenticated);
      const unauthenticated = AuthState(status: AuthStatus.unauthenticated);
      const loading = AuthState(status: AuthStatus.loading);

      expect(authenticated.isAuthenticated, isTrue);
      expect(unauthenticated.isAuthenticated, isFalse);
      expect(loading.isAuthenticated, isFalse);
    });

    test('copyWith preserves unchanged fields', () {
      const original = AuthState(
        status: AuthStatus.authenticated,
        user: User(userId: 'USR_001', userName: 'John'),
        permissions: ['read:site'],
      );

      final updated = original.copyWith(error: 'Some error');

      expect(updated.status, equals(AuthStatus.authenticated));
      expect(updated.user?.userId, equals('USR_001'));
      expect(updated.permissions, equals(['read:site']));
      expect(updated.error, equals('Some error'));
    });
  });

  group('ChangePasswordNotifier', () {
    test('returns success and sets success state', () async {
      when(
        () => mockRepository.changePassword(
          oldPassword: 'old-pass',
          newPassword: 'new-pass',
          confirmPassword: 'new-pass',
        ),
      ).thenAnswer((_) async => const Right('Password berhasil diubah'));

      final notifier = ChangePasswordNotifier(mockRepository);
      final result = await notifier.submit(
        oldPassword: 'old-pass',
        newPassword: 'new-pass',
        confirmPassword: 'new-pass',
      );

      expect(result, isTrue);
      expect(notifier.state.isSuccess, isTrue);
      expect(notifier.state.errorType, isNull);
    });

    test('maps ValidationFailure to confirmMismatch error type', () async {
      when(
        () => mockRepository.changePassword(
          oldPassword: 'old-pass',
          newPassword: 'new-pass',
          confirmPassword: 'bad-confirm',
        ),
      ).thenAnswer(
        (_) async =>
            const Left(ValidationFailure('Konfirmasi password tidak cocok')),
      );

      final notifier = ChangePasswordNotifier(mockRepository);
      final result = await notifier.submit(
        oldPassword: 'old-pass',
        newPassword: 'new-pass',
        confirmPassword: 'bad-confirm',
      );

      expect(result, isFalse);
      expect(notifier.state.isSuccess, isFalse);
      expect(notifier.state.errorType, ChangePasswordErrorType.confirmMismatch);
    });

    test('maps AuthFailure to unauthorized error type', () async {
      when(
        () => mockRepository.changePassword(
          oldPassword: 'wrong-old',
          newPassword: 'new-pass',
          confirmPassword: 'new-pass',
        ),
      ).thenAnswer((_) async => const Left(AuthFailure('Unauthorized')));

      final notifier = ChangePasswordNotifier(mockRepository);
      final result = await notifier.submit(
        oldPassword: 'wrong-old',
        newPassword: 'new-pass',
        confirmPassword: 'new-pass',
      );

      expect(result, isFalse);
      expect(notifier.state.errorType, ChangePasswordErrorType.unauthorized);
    });
  });
}
