import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/agro_remote_datasource.dart';
import '../../data/models/agro_model.dart';
import '../../data/repositories/agro_repository_impl.dart';
import '../../domain/repositories/agro_repository.dart';
import '../../domain/usecases/get_agro_data_usecase.dart';

final agroRemoteDataSourceProvider = Provider<AgroRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AgroRemoteDataSource(dioClient.dio);
});

final agroRepositoryProvider = Provider<AgroRepository>((ref) {
  final dataSource = ref.watch(agroRemoteDataSourceProvider);
  return AgroRepositoryImpl(dataSource);
});

final getAgroDataUseCaseProvider = Provider<GetAgroDataUseCase>((ref) {
  final repository = ref.watch(agroRepositoryProvider);
  return GetAgroDataUseCase(repository);
});

final agroDataProvider = FutureProvider.autoDispose<AgroModel>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return const AgroModel();
  
  final useCase = ref.watch(getAgroDataUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase(siteId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  });
});
