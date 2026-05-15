class ApiConfig {
  static const String baseUrl = 'http://202.10.37.32/api';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ─── Storage Keys ──────────────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tokenExpiryKey = 'token_expiry';
  static const String userKey = 'user_data';
  static const String selectedSiteKey = 'selected_site_id';

  /// @deprecated Use [accessTokenKey] instead
  static const String tokenKey = 'access_token';

  // ─── Token Config ──────────────────────────────────────────
  /// Buffer sebelum token benar-benar expired (refresh lebih awal)
  static const Duration tokenRefreshBuffer = Duration(minutes: 2);

  // ─── Retry Config ──────────────────────────────────────────
  static const int maxRetries = 2;
  static const Duration retryDelay = Duration(seconds: 2);
}
