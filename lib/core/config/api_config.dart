import 'app_environment.dart';

class ApiConfig {
  static String get baseUrl => AppEnvironmentConfig.apiBaseUrl;

  static AppEnvironment get environment => AppEnvironmentConfig.environment;

  static bool get isProduction => environment == AppEnvironment.production;

  static bool get usesCleartextHttp =>
      Uri.tryParse(baseUrl)?.scheme.toLowerCase() == 'http';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tokenExpiryKey = 'token_expiry';
  static const String userKey = 'user_data';
  static const String selectedSiteKey = 'selected_site_id';

  /// Deprecated. Use [accessTokenKey] instead.
  static const String tokenKey = 'access_token';

  // Token config
  static const Duration tokenRefreshBuffer = Duration(minutes: 2);

  // Retry config
  static const int maxRetries = 1;
  static const Duration retryDelay = Duration(seconds: 3);

  // Single-core backend protection: keep mobile request bursts bounded.
  static const int maxConcurrentRequests = 2;
}
