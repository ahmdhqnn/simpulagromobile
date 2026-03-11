import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConfig.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: ApiConfig.tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: ApiConfig.tokenKey);
  }

  Future<void> saveUserData(String userData) async {
    await _storage.write(key: ApiConfig.userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: ApiConfig.userKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
