import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> updateProfile(String name, String email, String phone);
  Future<void> logout();
}
