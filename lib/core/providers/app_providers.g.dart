// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appEnvironmentHash() => r'e12470693fb5d57d30a9547ada9d5c2fba7f608d';

/// See also [appEnvironment].
@ProviderFor(appEnvironment)
final appEnvironmentProvider = Provider<AppEnvironment>.internal(
  appEnvironment,
  name: r'appEnvironmentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appEnvironmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppEnvironmentRef = ProviderRef<AppEnvironment>;
String _$apiBaseUrlHash() => r'b8aad56ba235a60073ced2589f2b94dcd843f038';

/// See also [apiBaseUrl].
@ProviderFor(apiBaseUrl)
final apiBaseUrlProvider = Provider<String>.internal(
  apiBaseUrl,
  name: r'apiBaseUrlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiBaseUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiBaseUrlRef = ProviderRef<String>;
String _$appLocaleHash() => r'3da76ab29c40f8604063ff55502fd18018b2e585';

/// See also [appLocale].
@ProviderFor(appLocale)
final appLocaleProvider = Provider<Locale>.internal(
  appLocale,
  name: r'appLocaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppLocaleRef = ProviderRef<Locale>;
String _$appThemeModeHash() => r'5c05cede33ffcccda94e7187af70e346e97616da';

/// See also [appThemeMode].
@ProviderFor(appThemeMode)
final appThemeModeProvider = Provider<ThemeMode>.internal(
  appThemeMode,
  name: r'appThemeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppThemeModeRef = ProviderRef<ThemeMode>;
String _$appAutoRefreshEnabledHash() =>
    r'f9feed43169618fc22c139e925704a063fd24f1f';

/// See also [appAutoRefreshEnabled].
@ProviderFor(appAutoRefreshEnabled)
final appAutoRefreshEnabledProvider = Provider<bool>.internal(
  appAutoRefreshEnabled,
  name: r'appAutoRefreshEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appAutoRefreshEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppAutoRefreshEnabledRef = ProviderRef<bool>;
String _$appRealtimeRefreshIntervalHash() =>
    r'3b32e445c9759f6e322cc0c11f08351d42195599';

/// See also [appRealtimeRefreshInterval].
@ProviderFor(appRealtimeRefreshInterval)
final appRealtimeRefreshIntervalProvider = Provider<Duration>.internal(
  appRealtimeRefreshInterval,
  name: r'appRealtimeRefreshIntervalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appRealtimeRefreshIntervalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRealtimeRefreshIntervalRef = ProviderRef<Duration>;
String _$realtimeRefreshTickHash() =>
    r'1b1f3a842aabc94c989e7fc2f72933dc871a4dc9';

/// See also [realtimeRefreshTick].
@ProviderFor(realtimeRefreshTick)
final realtimeRefreshTickProvider = StreamProvider<int>.internal(
  realtimeRefreshTick,
  name: r'realtimeRefreshTickProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$realtimeRefreshTickHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RealtimeRefreshTickRef = StreamProviderRef<int>;
String _$appSettingsHash() => r'f0c5767076d37c8a340a688ab2b7554b1b89bfce';

/// See also [AppSettings].
@ProviderFor(AppSettings)
final appSettingsProvider =
    NotifierProvider<AppSettings, Map<String, dynamic>>.internal(
      AppSettings.new,
      name: r'appSettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppSettings = Notifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
