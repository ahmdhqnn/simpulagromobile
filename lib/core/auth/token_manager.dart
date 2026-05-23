import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../constants/api_endpoints.dart';
import '../storage/secure_storage.dart';

/// Manages token lifecycle: storage, refresh, and expiry detection.
/// This is the single source of truth for token operations.
class TokenManager {
  final SecureStorage _storage;

  /// Completer to prevent concurrent refresh requests (token refresh queue)
  Completer<bool>? _refreshCompleter;

  /// Dedicated Dio instance for refresh calls — no auth interceptor to avoid loops
  late final Dio _refreshDio;

  /// Callback invoked when refresh fails and session is truly expired
  VoidCallback? onSessionExpired;

  TokenManager(this._storage, {Dio? refreshDio}) {
    _refreshDio = refreshDio ?? Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  // ─── Token Access ──────────────────────────────────────────

  Future<String?> getAccessToken() => _storage.getAccessToken();

  Future<String?> getRefreshToken() => _storage.getRefreshToken();

  Future<bool> hasValidSession() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Check if access token needs refresh (expired or about to expire)
  Future<bool> isAccessTokenExpired() => _storage.isAccessTokenExpired();

  // ─── Token Persistence ─────────────────────────────────────

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  }) async {
    await _storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresInSeconds: expiresInSeconds,
    );
  }

  Future<void> clearTokens() => _storage.clearSession();

  // ─── Silent Refresh ────────────────────────────────────────

  /// Attempts to refresh the access token using the stored refresh token.
  /// Returns true if refresh succeeded, false if session is expired.
  ///
  /// Uses a Completer to queue concurrent refresh requests — only one
  /// network call is made even if multiple 401s arrive simultaneously.
  Future<bool> refreshAccessToken() async {
    // If a refresh is already in progress, wait for it
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await _storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('🔒 No refresh token available — session expired');
        _refreshCompleter!.complete(false);
        return false;
      }

      debugPrint('🔄 Attempting silent token refresh...');

      final response = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;
        final expiresIn = data['expires_in'] as int?;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken ?? refreshToken,
            expiresInSeconds: expiresIn ?? 3600,
          );

          debugPrint('✅ Token refreshed successfully');
          _refreshCompleter!.complete(true);
          return true;
        }
      }

      debugPrint('❌ Token refresh failed — invalid response');
      _refreshCompleter!.complete(false);
      return false;
    } on DioException catch (e) {
      debugPrint('❌ Token refresh failed: ${e.response?.statusCode}');

      // 401/403 on refresh means refresh token is also expired
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await clearTokens();
        onSessionExpired?.call();
      }

      _refreshCompleter!.complete(false);
      return false;
    } catch (e) {
      debugPrint('❌ Token refresh error: $e');
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }
}
