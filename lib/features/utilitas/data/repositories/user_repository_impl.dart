import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<User>> getAllUsers() async {
    try {
      return await remoteDatasource.getAllUsers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    try {
      return await remoteDatasource.getUserById(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> createUser(User user, String password) async {
    try {
      final data = {
        'user_id': user.userId,
        'user_name': user.userName,
        'user_email': user.userEmail,
        'user_phone': user.userPhone,
        'user_password': password,
        'role_id': user.roleId,
      };

      // Remove null values
      data.removeWhere((key, value) => value == null);

      return await remoteDatasource.createUser(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateUser(String userId, User user) async {
    try {
      final data = {
        'user_name': user.userName,
        'user_email': user.userEmail,
        'user_phone': user.userPhone,
        'user_sts': user.userSts,
        'role_id': user.roleId,
      };

      // Remove null values
      data.removeWhere((key, value) => value == null);

      return await remoteDatasource.updateUser(userId, data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await remoteDatasource.deleteUser(userId);
    } catch (e) {
      rethrow;
    }
  }
}
