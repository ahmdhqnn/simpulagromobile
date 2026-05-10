import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/user_profile.dart';

// ─── DataSource ──────────────────────────────────────────
final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return ProfileRemoteDatasource(dioClient.dio);
});

// ─── Repository ──────────────────────────────────────────
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final datasource = ref.watch(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(datasource);
});

// ─── User Profile ─────────────────────────────────────────
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getUserProfile();
});

// ─── User Permissions ────────────────────────────────────
final userPermissionsProvider = FutureProvider<List<String>>((ref) async {
  final datasource = ref.watch(profileRemoteDatasourceProvider);
  return datasource.getUserPermissions();
});

// ─── Settings ────────────────────────────────────────────
/// Settings disimpan di SharedPreferences (bukan SecureStorage)
/// karena bukan data sensitif
class SettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  static const _defaults = {
    'notifications': true,
    'autoRefresh': true,
    'refreshInterval': 30,
    'language': 'id',
    'theme': 'light',
    'temperatureUnit': 'celsius',
    'dateFormat': 'dd/MM/yyyy',
  };

  SettingsNotifier() : super(_defaults) {
    _loadSettings();
  }

  void updateSetting(String key, dynamic value) {
    state = {...state, key: value};
    _persistSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loaded = <String, dynamic>{};
      _defaults.forEach((key, defaultValue) {
        if (defaultValue is bool) {
          loaded[key] = prefs.getBool(key) ?? defaultValue;
        } else if (defaultValue is int) {
          loaded[key] = prefs.getInt(key) ?? defaultValue;
        } else if (defaultValue is String) {
          loaded[key] = prefs.getString(key) ?? defaultValue;
        }
      });
      if (mounted) state = loaded;
    } catch (_) {
      // Gagal load — gunakan defaults
    }
  }

  Future<void> _persistSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state.forEach((key, value) {
        if (value is bool) {
          prefs.setBool(key, value);
        } else if (value is int) {
          prefs.setInt(key, value);
        } else if (value is String) {
          prefs.setString(key, value);
        }
      });
    } catch (_) {}
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Map<String, dynamic>>(
      (ref) => SettingsNotifier(),
    );
