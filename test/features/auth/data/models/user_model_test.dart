import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    const testJson = {
      'user_id': 'USR_001',
      'user_name': 'John Doe',
      'user_email': 'john@example.com',
      'user_phone': '081234567890',
      'user_sts': 'active',
      'role_id': 'ROLE001',
    };

    test('fromJson creates correct model', () {
      final user = UserModel.fromJson(testJson);

      expect(user.userId, equals('USR_001'));
      expect(user.userName, equals('John Doe'));
      expect(user.userEmail, equals('john@example.com'));
      expect(user.userPhone, equals('081234567890'));
      expect(user.userSts, equals('active'));
      expect(user.roleId, equals('ROLE001'));
    });

    test('toJson produces correct map', () {
      final user = UserModel.fromJson(testJson);
      final json = user.toJson();

      expect(json['user_id'], equals('USR_001'));
      expect(json['user_name'], equals('John Doe'));
      expect(json['user_email'], equals('john@example.com'));
      expect(json['user_phone'], equals('081234567890'));
      expect(json['user_sts'], equals('active'));
      expect(json['role_id'], equals('ROLE001'));
    });

    test('toJsonString and fromJsonString are inverse operations', () {
      final user = UserModel.fromJson(testJson);
      final jsonString = user.toJsonString();
      final restored = UserModel.fromJsonString(jsonString);

      expect(restored.userId, equals(user.userId));
      expect(restored.userName, equals(user.userName));
      expect(restored.userEmail, equals(user.userEmail));
      expect(restored.userPhone, equals(user.userPhone));
      expect(restored.userSts, equals(user.userSts));
      expect(restored.roleId, equals(user.roleId));
    });

    test('fromJson handles missing optional fields', () {
      final user = UserModel.fromJson({
        'user_id': 'USR_002',
        'user_name': 'Jane',
      });

      expect(user.userId, equals('USR_002'));
      expect(user.userName, equals('Jane'));
      expect(user.userEmail, isNull);
      expect(user.userPhone, isNull);
      expect(user.userSts, isNull);
      expect(user.roleId, isNull);
    });

    test('fromJson handles null values gracefully', () {
      final user = UserModel.fromJson({'user_id': null, 'user_name': null});

      expect(user.userId, equals(''));
      expect(user.userName, equals(''));
    });

    test('fromJson normalizes numeric ids and statuses', () {
      final user = UserModel.fromJson({
        'user_id': 12,
        'user_name': 99,
        'user_sts': 1,
        'role_id': 1,
      });

      expect(user.userId, '12');
      expect(user.userName, '99');
      expect(user.userSts, 'active');
      expect(user.roleId, '1');
    });

    test('isAdmin returns true for ROLE001', () {
      final user = UserModel.fromJson(testJson);
      expect(user.isAdmin, isTrue);
    });

    test('isAdmin returns false for non-admin role', () {
      final user = UserModel.fromJson({...testJson, 'role_id': 'ROLE002'});
      expect(user.isAdmin, isFalse);
    });

    test('isActive returns true for active status', () {
      final user = UserModel.fromJson(testJson);
      expect(user.isActive, isTrue);
    });

    test('isActive returns false for inactive status', () {
      final user = UserModel.fromJson({...testJson, 'user_sts': 'inactive'});
      expect(user.isActive, isFalse);
    });
  });

  group('LoginResponseModel', () {
    test('fromJson parses dual-token response correctly', () {
      final json = {
        'access_token': 'eyJhbGciOiJIUzI1NiJ9.access',
        'refresh_token': 'eyJhbGciOiJIUzI1NiJ9.refresh',
        'expires_in': 3600,
        'token_type': 'Bearer',
        'user': {
          'user_id': 'USR_001',
          'user_name': 'John Doe',
          'user_email': 'john@example.com',
          'user_phone': '081234567890',
          'user_sts': 'active',
          'role_id': 'ROLE002',
        },
      };

      final response = LoginResponseModel.fromJson(json);

      expect(response.accessToken, equals('eyJhbGciOiJIUzI1NiJ9.access'));
      expect(response.refreshToken, equals('eyJhbGciOiJIUzI1NiJ9.refresh'));
      expect(response.expiresIn, equals(3600));
      expect(response.tokenType, equals('Bearer'));
      expect(response.user.userId, equals('USR_001'));
      expect(response.user.userName, equals('John Doe'));
    });

    test('fromJson handles legacy single-token response (backward compat)', () {
      final json = {
        'token': 'legacy_jwt_token',
        'user': {'user_id': 'USR_001', 'user_name': 'John Doe'},
      };

      final response = LoginResponseModel.fromJson(json);

      expect(response.accessToken, equals('legacy_jwt_token'));
      expect(response.refreshToken, equals(''));
      expect(response.expiresIn, equals(3600)); // default
      expect(response.tokenType, equals('Bearer')); // default
    });

    test('fromJson handles missing fields with defaults', () {
      final json = {
        'access_token': 'token_123',
        'user': {'user_id': 'USR_001', 'user_name': 'Test'},
      };

      final response = LoginResponseModel.fromJson(json);

      expect(response.accessToken, equals('token_123'));
      expect(response.refreshToken, equals(''));
      expect(response.expiresIn, equals(3600));
      expect(response.tokenType, equals('Bearer'));
    });

    test('fromJson handles data-wrapped response and string expires_in', () {
      final response = LoginResponseModel.fromJson({
        'data': {
          'access_token': 'access',
          'refresh_token': 'refresh',
          'expires_in': '7200',
          'token_type': 'Bearer',
          'user': {'user_id': 7, 'user_name': 'Admin', 'user_sts': 1},
        },
      });

      expect(response.accessToken, 'access');
      expect(response.refreshToken, 'refresh');
      expect(response.expiresIn, 7200);
      expect(response.user.userId, '7');
      expect(response.user.userSts, 'active');
    });

    test('fromJson handles completely empty response', () {
      final response = LoginResponseModel.fromJson({});

      expect(response.accessToken, equals(''));
      expect(response.refreshToken, equals(''));
      expect(response.expiresIn, equals(3600));
      expect(response.tokenType, equals('Bearer'));
      expect(response.user.userId, equals(''));
      expect(response.user.userName, equals(''));
    });
  });
}
