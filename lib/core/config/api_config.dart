class ApiConfig {
  static const String baseUrl = 'http://202.10.37.32/api';

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
