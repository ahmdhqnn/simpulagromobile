import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/config/api_config.dart';

void main() {
  group('ApiConfig', () {
    test('has correct storage keys for dual-token system', () {
      expect(ApiConfig.accessTokenKey, equals('access_token'));
      expect(ApiConfig.refreshTokenKey, equals('refresh_token'));
      expect(ApiConfig.tokenExpiryKey, equals('token_expiry'));
      expect(ApiConfig.userKey, equals('user_data'));
      expect(ApiConfig.selectedSiteKey, equals('selected_site_id'));
    });

    test('tokenKey is backward compatible with accessTokenKey', () {
      // ignore: deprecated_member_use_from_same_package
      expect(ApiConfig.tokenKey, equals(ApiConfig.accessTokenKey));
    });

    test('tokenRefreshBuffer is 2 minutes', () {
      expect(ApiConfig.tokenRefreshBuffer, equals(const Duration(minutes: 2)));
    });

    test('has reasonable timeout values', () {
      expect(ApiConfig.connectTimeout.inSeconds, equals(30));
      expect(ApiConfig.receiveTimeout.inSeconds, equals(60));
      expect(ApiConfig.sendTimeout.inSeconds, equals(30));
    });

    test('retry config is reasonable', () {
      expect(ApiConfig.maxRetries, equals(1));
      expect(ApiConfig.retryDelay.inSeconds, equals(3));
    });
  });
}
