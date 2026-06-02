import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../config/app_environment.dart';

part 'app_providers.g.dart';

const Duration defaultRealtimeRefreshInterval = Duration(seconds: 30);

const List<Locale> supportedAppLocales = [Locale('id'), Locale('en')];

@Riverpod(keepAlive: true)
AppEnvironment appEnvironment(Ref ref) {
  return ApiConfig.environment;
}

@Riverpod(keepAlive: true)
String apiBaseUrl(Ref ref) {
  return ApiConfig.baseUrl;
}

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  static const defaults = <String, dynamic>{
    'notifications': true,
    'autoRefresh': true,
    'refreshInterval': 30,
    'language': 'id',
    'theme': 'light',
    'temperatureUnit': 'celsius',
    'dateFormat': 'dd/MM/yyyy',
  };

  @override
  Map<String, dynamic> build() {
    unawaited(_loadSettings());
    return defaults;
  }

  void updateSetting(String key, dynamic value) {
    if (!defaults.containsKey(key)) return;

    final normalized = _normalizeValue(key, value);
    state = {...state, key: normalized};
    unawaited(_persistSetting(key, normalized));
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loaded = <String, dynamic>{};

      for (final entry in defaults.entries) {
        final key = entry.key;
        final defaultValue = entry.value;

        if (defaultValue is bool) {
          loaded[key] = prefs.getBool(key) ?? defaultValue;
        } else if (defaultValue is int) {
          loaded[key] = prefs.getInt(key) ?? defaultValue;
        } else if (defaultValue is String) {
          loaded[key] = prefs.getString(key) ?? defaultValue;
        }
      }

      state = _normalizeSettings(loaded);
    } catch (_) {
      state = defaults;
    }
  }

  Future<void> _persistSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (_) {
      // Keep in-memory state even when persistence fails.
    }
  }

  Map<String, dynamic> _normalizeSettings(Map<String, dynamic> values) {
    return {
      for (final entry in defaults.entries)
        entry.key: _normalizeValue(entry.key, values[entry.key]),
    };
  }

  dynamic _normalizeValue(String key, dynamic value) {
    final fallback = defaults[key];

    switch (key) {
      case 'refreshInterval':
        final seconds = value is int ? value : fallback as int;
        return seconds.clamp(15, 300).toInt();
      case 'language':
        return value == 'en' ? 'en' : 'id';
      case 'theme':
        return value == 'dark' || value == 'system' ? value : 'light';
      default:
        if (fallback is bool) return value is bool ? value : fallback;
        if (fallback is int) return value is int ? value : fallback;
        if (fallback is String) return value is String ? value : fallback;
        return value ?? fallback;
    }
  }
}

/// Backward-compatible name used by the existing settings screen.
final settingsProvider = appSettingsProvider;

@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) {
  final language = ref.watch(
    appSettingsProvider.select((settings) => settings['language'] as String?),
  );

  return language == 'en' ? const Locale('en') : const Locale('id');
}

@Riverpod(keepAlive: true)
ThemeMode appThemeMode(Ref ref) {
  final theme = ref.watch(
    appSettingsProvider.select((settings) => settings['theme'] as String?),
  );

  switch (theme) {
    case 'dark':
      return ThemeMode.dark;
    case 'system':
      return ThemeMode.system;
    case 'light':
    default:
      return ThemeMode.light;
  }
}

@Riverpod(keepAlive: true)
bool appAutoRefreshEnabled(Ref ref) {
  return ref.watch(
        appSettingsProvider.select(
          (settings) => settings['autoRefresh'] as bool?,
        ),
      ) ??
      true;
}

@Riverpod(keepAlive: true)
Duration appRealtimeRefreshInterval(Ref ref) {
  final seconds =
      ref.watch(
        appSettingsProvider.select(
          (settings) => settings['refreshInterval'] as int?,
        ),
      ) ??
      defaultRealtimeRefreshInterval.inSeconds;

  return Duration(seconds: seconds.clamp(15, 300).toInt());
}

@Riverpod(keepAlive: true)
Stream<int> realtimeRefreshTick(Ref ref) {
  final enabled = ref.watch(appAutoRefreshEnabledProvider);
  if (!enabled) return const Stream<int>.empty();

  final interval = ref.watch(appRealtimeRefreshIntervalProvider);
  return Stream<int>.periodic(interval, (tick) => tick + 1);
}

/// Shared bottom navigation state for [MainShell] and dashboard shortcuts.
final mainShellTabIndexProvider = StateProvider<int>((ref) => 0);
