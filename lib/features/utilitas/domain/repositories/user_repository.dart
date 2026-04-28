import '../../../auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User> getUserById(String userId);
  Future<User> createUser(User user, String password);
  Future<User> updateUser(String userId, User user);
  Future<void> deleteUser(String userId);
}
