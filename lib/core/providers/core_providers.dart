import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/token_manager.dart';
import '../network/dio_client.dart';
import '../services/image_upload_service.dart';
import '../storage/secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final tokenManagerProvider = Provider<TokenManager>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenManager(storage);
});

final dioClientProvider = Provider<DioClient>((ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return DioClient(tokenManager);
});

final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return ImageUploadService(tokenManager);
});
