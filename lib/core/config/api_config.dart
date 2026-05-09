class ApiConfig {
  static const String baseUrl = 'http://202.10.37.32/api';

  // Timeout lebih panjang karena server bisa lambat
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
  static const String selectedSiteKey = 'selected_site_id';

  // Retry config
  static const int maxRetries = 2;
  static const Duration retryDelay = Duration(seconds: 2);
}
