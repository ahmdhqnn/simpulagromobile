import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/app_startup_provider.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// ─── Data Source ─────────────────────────────────────────
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSource(dioClient.dio);
});

// ─── Repository ─────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(secureStorageProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return AuthRepositoryImpl(remoteDataSource, storage, tokenManager);
});

// ─── Auth Status ─────────────────────────────────────────
enum AuthStatus { initial, authenticated, unauthenticated, loading }

// ─── Auth State ──────────────────────────────────────────
class AuthState {
  final AuthStatus status;
  final User? user;
  final List<String> permissions;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.permissions = const [],
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    List<String>? permissions,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      permissions: permissions ?? this.permissions,
      error: error,
    );
  }

  bool hasPermission(String permission) => permissions.contains(permission);
  bool get isAdmin => user?.roleId == 'ROLE001';
  bool get isAuthenticated => status == AuthStatus.authenticated;
}

// ─── Auth Notifier ───────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository, {AppStartupData? startupData})
    : super(const AuthState()) {
    if (startupData != null) {
      _initFromStartupData(startupData);
    }
  }

  void _initFromStartupData(AppStartupData data) {
    if (data.isLoggedIn && data.userData != null) {
      try {
        final user = UserModel.fromJsonString(data.userData!);
        state = AuthState(status: AuthStatus.authenticated, user: user);
        _loadPermissions();
      } catch (_) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> checkAuthStatus() async {
    if (state.status == AuthStatus.authenticated) return;
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _repository.getCachedUser();
        if (user != null) {
          state = AuthState(status: AuthStatus.authenticated, user: user);
          _loadPermissions();
          return;
        }
      }
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Login dengan username dan password
  Future<bool> login(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repository.login(username, password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
      _loadPermissions();
      return true;
    } catch (e) {
      final msg = e.toString();
      String errorMsg;
      if (msg.contains('SocketException') ||
          msg.contains('connection') ||
          msg.contains('timeout')) {
        errorMsg = 'Tidak Ada Koneksi Internet';
      } else {
        errorMsg = 'Username atau Password salah';
      }
      state = AuthState(status: AuthStatus.unauthenticated, error: errorMsg);
      return false;
    }
  }

  /// Logout — hapus sesi dan reset state
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Dipanggil saat session benar-benar expired (refresh token juga gagal)
  Future<void> handleSessionExpired() async {
    if (state.status != AuthStatus.authenticated) return;
    await _repository.logout();
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      error: 'Sesi Anda telah berakhir. Silakan login kembali.',
    );
  }

  /// Refresh profil user dari server
  Future<void> refreshProfile() async {
    try {
      final user = await _repository.getProfile();
      if (mounted) state = state.copyWith(user: user);
    } catch (_) {}
  }

  Future<void> _loadPermissions() async {
    try {
      final perms = await _repository.getPermissions();
      if (mounted) state = state.copyWith(permissions: perms);
    } catch (_) {}
  }
}

// ─── Provider ────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final startupData = ref.read(appStartupDataProvider);
  final notifier = AuthNotifier(repository, startupData: startupData);

  // Wire TokenManager.onSessionExpired → auto logout saat refresh gagal
  final tokenManager = ref.read(tokenManagerProvider);
  tokenManager.onSessionExpired = () {
    Future.microtask(() => notifier.handleSessionExpired());
  };

  // Wire DioClient.onSessionExpired → auto logout saat 401 + refresh gagal
  final dioClient = ref.read(dioClientProvider);
  dioClient.onSessionExpired = () {
    Future.microtask(() => notifier.handleSessionExpired());
  };

  return notifier;
});

// ─── Onboarding Provider ─────────────────────────────────
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((
  ref,
) {
  final storage = ref.watch(secureStorageProvider);
  final startupData = ref.read(appStartupDataProvider);
  return OnboardingNotifier(storage, startupData.onboardingCompleted);
});

class OnboardingNotifier extends StateNotifier<bool> {
  final SecureStorage _storage;

  OnboardingNotifier(this._storage, bool initialValue) : super(initialValue);

  Future<void> completeOnboarding() async {
    await _storage.setOnboardingCompleted(true);
    state = true;
  }

  Future<void> resetOnboarding() async {
    await _storage.setOnboardingCompleted(false);
    state = false;
  }
}
