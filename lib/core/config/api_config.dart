import 'dart:io';

class ApiConfig {
  static const String _localIp = '192.168.12.93';

  static String get baseUrl {
    if (Platform.isAndroid) {
      // Untuk device fisik Android, gunakan IP lokal komputer
      return 'http://$_localIp:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
}

// url host
// import 'dart:io';

// class ApiConfig {
//   static const String baseUrl = 'http://202.10.37.32/api';

//   static const Duration connectTimeout = Duration(seconds: 15);
//   static const Duration receiveTimeout = Duration(seconds: 15);
//   static const String tokenKey = 'jwt_token';
//   static const String userKey = 'user_data';
// }
