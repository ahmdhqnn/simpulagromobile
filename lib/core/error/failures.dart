/// Base Failure class for error handling
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Server-related failures (API errors)
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

/// Network-related failures (connection issues)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Cache-related failures (local storage issues)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Validation failures (input validation)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Authentication failures (token expired, unauthorized)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Permission failures (forbidden access)
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Not found failures (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
