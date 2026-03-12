import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
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
  return AuthRepositoryImpl(remoteDataSource, storage);
});

// ─── Auth State ─────────────────────────────────────────
enum AuthStatus { initial, authenticated, unauthenticated, loading }

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
}

// ─── Auth Notifier ──────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _repository.getCachedUser();
        if (user != null) {
          state = AuthState(status: AuthStatus.authenticated, user: user);
          // Fetch permissions in background
          _loadPermissions();
          return;
        }
      }
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final result = await _repository.login(username, password);
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
      _loadPermissions();
      return true;
    } catch (e) {
      String errorMsg = 'Login gagal';
      if (e.toString().contains('404')) {
        errorMsg = 'Username tidak ditemukan';
      } else if (e.toString().contains('401')) {
        errorMsg = 'Password salah';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('connection')) {
        errorMsg = 'Tidak dapat terhubung ke server';
      }
      state = AuthState(status: AuthStatus.unauthenticated, error: errorMsg);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> refreshProfile() async {
    try {
      final user = await _repository.getProfile();
      state = state.copyWith(user: user);
    } catch (_) {}
  }

  Future<void> _loadPermissions() async {
    try {
      final perms = await _repository.getPermissions();
      state = state.copyWith(permissions: perms);
    } catch (_) {}
  }
}

// ─── Provider ───────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
