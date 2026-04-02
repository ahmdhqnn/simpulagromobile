import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserProfile> getUserProfile() async {
    final model = await remoteDatasource.getUserProfile();
    return model.toEntity();
  }

  @override
  Future<UserProfile> updateProfile(
    String name,
    String email,
    String phone,
  ) async {
    final model = await remoteDatasource.updateProfile(name, email, phone);
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    // Handled by auth feature
  }
}
