enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment fromValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'dev':
      case 'development':
      case 'local':
        return AppEnvironment.development;
      case 'stage':
      case 'staging':
        return AppEnvironment.staging;
      case 'prod':
      case 'production':
      default:
        return AppEnvironment.production;
    }
  }
}

class AppEnvironmentConfig {
  const AppEnvironmentConfig._();

  static const String productionApiBaseUrl = 'http://202.10.37.32/api';
  static const String stagingApiBaseUrl = productionApiBaseUrl;
  static const String developmentApiBaseUrl = 'http://localhost:3000/api';

  static const String _environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );

  static AppEnvironment get environment =>
      AppEnvironment.fromValue(_environmentName);

  static String get apiBaseUrl => _normalizeBaseUrl(
    _apiBaseUrlOverride.trim().isNotEmpty
        ? _apiBaseUrlOverride
        : _defaultBaseUrlFor(environment),
  );

  static String _defaultBaseUrlFor(AppEnvironment environment) {
    switch (environment) {
      case AppEnvironment.development:
        return developmentApiBaseUrl;
      case AppEnvironment.staging:
        return stagingApiBaseUrl;
      case AppEnvironment.production:
        return productionApiBaseUrl;
    }
  }

  static String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }
}
