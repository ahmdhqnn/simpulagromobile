import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../auth/domain/entities/user.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE PROVIDER
// ═══════════════════════════════════════════════════════════
final userRemoteDatasourceProvider = Provider<UserRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UserRemoteDatasourceImpl(dioClient.dio);
});

// ═══════════════════════════════════════════════════════════
// REPOSITORY PROVIDER
// ═══════════════════════════════════════════════════════════
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final datasource = ref.watch(userRemoteDatasourceProvider);
  return UserRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// USER LIST PROVIDER
// ═══════════════════════════════════════════════════════════
final utilitasUserListProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAllUsers();
});

// ═══════════════════════════════════════════════════════════
// USER DETAIL PROVIDER (by ID)
// ═══════════════════════════════════════════════════════════
final utilitasUserDetailProvider = FutureProvider.family<User, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(userId);
});

// ═══════════════════════════════════════════════════════════
// USER FORM STATE
// ═══════════════════════════════════════════════════════════
class UserFormState {
  final bool isLoading;
  final String? error;
  final User? savedUser;

  const UserFormState({this.isLoading = false, this.error, this.savedUser});

  UserFormState copyWith({bool? isLoading, String? error, User? savedUser}) {
    return UserFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedUser: savedUser ?? this.savedUser,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// USER FORM NOTIFIER
// ═══════════════════════════════════════════════════════════
class UserFormNotifier extends StateNotifier<UserFormState> {
  final UserRepository _repository;
  final Ref _ref;

  UserFormNotifier(this._repository, this._ref) : super(const UserFormState());

  Future<bool> createUser(User user, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedUser = await _repository.createUser(user, password);
      state = UserFormState(savedUser: savedUser);
      _ref.invalidate(utilitasUserListProvider);
      return true;
    } catch (e) {
      state = UserFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateUser(String userId, User user) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedUser = await _repository.updateUser(userId, user);
      state = UserFormState(savedUser: savedUser);
      _ref.invalidate(utilitasUserListProvider);
      _ref.invalidate(utilitasUserDetailProvider(userId));
      return true;
    } catch (e) {
      state = UserFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteUser(userId);
      state = const UserFormState();
      _ref.invalidate(utilitasUserListProvider);
      return true;
    } catch (e) {
      state = UserFormState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const UserFormState();
  }
}

// ═══════════════════════════════════════════════════════════
// USER FORM PROVIDER
// ═══════════════════════════════════════════════════════════
final userFormProvider = StateNotifierProvider<UserFormNotifier, UserFormState>(
  (ref) {
    final repository = ref.watch(userRepositoryProvider);
    return UserFormNotifier(repository, ref);
  },
);
