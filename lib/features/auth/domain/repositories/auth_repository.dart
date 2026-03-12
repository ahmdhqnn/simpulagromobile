import '../entities/user.dart';

abstract class AuthRepository {
  Future<({String token, User user})> login(String username, String password);
  Future<User> getProfile();
  Future<List<String>> getPermissions();
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<User?> getCachedUser();
}
