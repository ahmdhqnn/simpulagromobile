import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _onboardingKey = 'onboarding_completed';

  // ─── Token ───────────────────────────────────────────────
  Future<void> saveToken(String token) =>
      _storage.write(key: ApiConfig.tokenKey, value: token);

  Future<String?> getToken() => _storage.read(key: ApiConfig.tokenKey);

  Future<void> deleteToken() => _storage.delete(key: ApiConfig.tokenKey);

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
  /// Hapus semua data sesi (token, user, site) tapi pertahankan onboarding
  Future<void> clearSession() async {
    await Future.wait([
      deleteToken(),
      _storage.delete(key: ApiConfig.userKey),
      deleteSelectedSiteId(),
    ]);
  }

  /// Hapus semua data termasuk onboarding
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
