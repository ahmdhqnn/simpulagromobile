/// Base Exception class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Server exception (API errors)
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

/// Network exception (connection issues)
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Cache exception (local storage issues)
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode});
}

/// Permission exception
class PermissionException extends AppException {
  const PermissionException(super.message);
}

/// Not found exception
class NotFoundException extends AppException {
  const NotFoundException(super.message);
}
