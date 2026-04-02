import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/user_profile.dart';

// Datasource provider
final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  return ProfileRemoteDatasource(Dio());
});

// Repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.read(profileRemoteDatasourceProvider));
});

// User profile provider
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  return ref.read(profileRepositoryProvider).getUserProfile();
});

// Settings provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Map<String, dynamic>>((ref) {
      return SettingsNotifier();
    });

class SettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  SettingsNotifier()
    : super({
        'notifications': true,
        'autoRefresh': true,
        'refreshInterval': 30,
        'language': 'id',
        'theme': 'light',
        'temperatureUnit': 'celsius',
        'dateFormat': 'dd/MM/yyyy',
      });

  void updateSetting(String key, dynamic value) {
    state = {...state, key: value};
    _saveSettings();
  }

  Future<void> _saveSettings() async {
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
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final newState = <String, dynamic>{};

    state.forEach((key, defaultValue) {
      if (defaultValue is bool) {
        newState[key] = prefs.getBool(key) ?? defaultValue;
      } else if (defaultValue is int) {
        newState[key] = prefs.getInt(key) ?? defaultValue;
      } else if (defaultValue is String) {
        newState[key] = prefs.getString(key) ?? defaultValue;
      }
    });

    state = newState;
  }
}

// Logout provider
final logoutProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
  };
});
