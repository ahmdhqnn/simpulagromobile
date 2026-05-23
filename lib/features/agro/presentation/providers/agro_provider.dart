import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/agro_remote_datasource.dart';
import '../../data/repositories/agro_repository_impl.dart';
import '../../domain/entities/agro_entity.dart';
import '../../domain/repositories/agro_repository.dart';
import '../../domain/usecases/get_agro_data_usecase.dart';

// ─── DataSource Provider ─────────────────────────────────
final agroRemoteDataSourceProvider = Provider<AgroRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AgroRemoteDataSource(dioClient.dio);
});

// ─── Repository Provider ─────────────────────────────────
final agroRepositoryProvider = Provider<AgroRepository>((ref) {
  final dataSource = ref.watch(agroRemoteDataSourceProvider);
  return AgroRepositoryImpl(dataSource);
});

// ─── UseCase Provider ─────────────────────────────────────
final getAgroDataUseCaseProvider = Provider<GetAgroDataUseCase>((ref) {
  return GetAgroDataUseCase(ref.watch(agroRepositoryProvider));
});

// ─── Agro Data Provider ───────────────────────────────────
/// GET /sites/{siteId}/agro — mengembalikan AgroEntity (domain entity)
final agroDataProvider = FutureProvider.autoDispose<AgroEntity>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return const AgroEntity();

  final useCase = ref.watch(getAgroDataUseCaseProvider);
  return ref.retryOnError(() async {
    final result = await useCase(siteId);
    return result.fold(
      (failure) => throw failure,
      (entity) => entity,
    );
  });
});
