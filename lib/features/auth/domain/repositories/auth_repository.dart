import '../entities/user.dart';

abstract class AuthRepository {
  /// Login and persist dual tokens + user data
  Future<User> login(String username, String password);

  /// Logout — invalidate tokens on server and clear local storage
  Future<void> logout();

  /// Get user profile from server
  Future<User> getProfile();

  /// Get user permissions from server
  Future<List<String>> getPermissions();

  /// Check if user has a valid session (tokens exist)
  Future<bool> isLoggedIn();

  /// Get cached user data from secure storage
  Future<User?> getCachedUser();
}
