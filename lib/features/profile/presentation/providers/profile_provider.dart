import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return ProfileRemoteDatasource(dioClient.dio);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final datasource = ref.watch(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(datasource);
});

final userProfileProvider = FutureProvider.autoDispose<UserProfile>((
  ref,
) async {
  ref.cacheFor(stableDataCardCacheDuration);
  final repository = ref.watch(profileRepositoryProvider);
  return ref.retryOnError(() async {
    final result = await repository.getUserProfile();
    return result.fold((failure) => throw failure, (profile) => profile);
  });
});

final userPermissionsProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  ref.cacheFor(stableDataCardCacheDuration);
  final datasource = ref.watch(profileRemoteDatasourceProvider);
  return ref.retryOnError(datasource.getUserPermissions);
});
