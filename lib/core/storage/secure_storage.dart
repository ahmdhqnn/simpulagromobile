import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

/// Secure storage wrapper for sensitive data (tokens, user info).
/// Uses EncryptedSharedPreferences on Android and Keychain on iOS.
class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _onboardingKey = 'onboarding_completed';

  // ─── Access Token ────────────────────────────────────────
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: ApiConfig.accessTokenKey, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: ApiConfig.accessTokenKey);

  Future<void> deleteAccessToken() =>
      _storage.delete(key: ApiConfig.accessTokenKey);

  // ─── Refresh Token ───────────────────────────────────────
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: ApiConfig.refreshTokenKey, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: ApiConfig.refreshTokenKey);

  Future<void> deleteRefreshToken() =>
      _storage.delete(key: ApiConfig.refreshTokenKey);

  // ─── Token Expiry ────────────────────────────────────────
  Future<void> saveTokenExpiry(DateTime expiry) => _storage.write(
    key: ApiConfig.tokenExpiryKey,
    value: expiry.toIso8601String(),
  );

  Future<DateTime?> getTokenExpiry() async {
    final value = await _storage.read(key: ApiConfig.tokenExpiryKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  Future<void> deleteTokenExpiry() =>
      _storage.delete(key: ApiConfig.tokenExpiryKey);

  // ─── Save All Tokens (atomic) ────────────────────────────
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  }) async {
    final expiry = DateTime.now().add(Duration(seconds: expiresInSeconds));
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveTokenExpiry(expiry),
    ]);
  }

  /// Check if access token is expired or about to expire
  Future<bool> isAccessTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    // Consider expired if within the buffer window
    return DateTime.now().isAfter(
      expiry.subtract(ApiConfig.tokenRefreshBuffer),
    );
  }

  // ─── Legacy compatibility ────────────────────────────────
  /// @deprecated Use [saveAccessToken] instead
  Future<void> saveToken(String token) => saveAccessToken(token);

  /// @deprecated Use [getAccessToken] instead
  Future<String?> getToken() => getAccessToken();

  /// @deprecated Use [deleteAccessToken] instead
  Future<void> deleteToken() => deleteAccessToken();

  // ─── User Data ───────────────────────────────────────────
  Future<void> saveUserData(String userData) =>
      _storage.write(key: ApiConfig.userKey, value: userData);

  Future<String?> getUserData() => _storage.read(key: ApiConfig.userKey);

  // ─── Selected Site ───────────────────────────────────────
  Future<void> saveSelectedSiteId(String siteId) =>
      _storage.write(key: ApiConfig.selectedSiteKey, value: siteId);

  Future<String?> getSelectedSiteId() =>
      _storage.read(key: ApiConfig.selectedSiteKey);

  Future<void> deleteSelectedSiteId() =>
      _storage.delete(key: ApiConfig.selectedSiteKey);

  // ─── Onboarding ──────────────────────────────────────────
  Future<void> setOnboardingCompleted(bool completed) =>
      _storage.write(key: _onboardingKey, value: completed.toString());

  Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }

  // ─── Clear ───────────────────────────────────────────────
  /// Hapus semua data sesi (tokens, user, site) tapi pertahankan onboarding
  Future<void> clearSession() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
      deleteTokenExpiry(),
      _storage.delete(key: ApiConfig.userKey),
      deleteSelectedSiteId(),
    ]);
  }

  /// Hapus semua data termasuk onboarding
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
