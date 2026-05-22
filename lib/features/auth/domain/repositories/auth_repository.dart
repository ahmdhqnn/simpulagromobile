import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Login and persist dual tokens + user data
  Future<Either<Failure, User>> login(String username, String password);

  /// Logout — invalidate tokens on server and clear local storage
  Future<Either<Failure, void>> logout();

  /// Get user profile from server
  Future<Either<Failure, User>> getProfile();

  /// Get user permissions from server
  Future<Either<Failure, List<String>>> getPermissions();

  /// Check if user has a valid session (tokens exist)
  Future<bool> isLoggedIn();

  /// Get cached user data from secure storage
  Future<User?> getCachedUser();
}
