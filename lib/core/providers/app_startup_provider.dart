import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';

/// Data yang sudah di-preload dari storage sebelum app start.
/// Ini menghindari pembacaan storage yang lambat di constructor provider.
class AppStartupData {
  final String? token;
  final String? userData;
  final String? selectedSiteId;
  final bool onboardingCompleted;

  const AppStartupData({
    this.token,
    this.userData,
    this.selectedSiteId,
    this.onboardingCompleted = false,
  });

  bool get isLoggedIn => token != null && token!.isNotEmpty;
}

/// Provider yang menyimpan data startup — di-override dari main()
final appStartupDataProvider = Provider<AppStartupData>((ref) {
  return const AppStartupData();
});

/// Baca semua data yang dibutuhkan dari storage sekaligus.
/// Dipanggil sekali di main() sebelum runApp().
Future<AppStartupData> preloadAppData() async {
  final storage = SecureStorage();

  // Baca semua data secara paralel untuk efisiensi
  final results = await Future.wait([
    storage.getAccessToken(),
    storage.getUserData(),
    storage.getSelectedSiteId(),
    storage.isOnboardingCompleted(),
  ]);

  return AppStartupData(
    token: results[0] as String?,
    userData: results[1] as String?,
    selectedSiteId: results[2] as String?,
    onboardingCompleted: results[3] as bool,
  );
}
