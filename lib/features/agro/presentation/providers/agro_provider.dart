import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/agro_remote_datasource.dart';
import '../../data/models/agro_model.dart';

final agroRemoteDataSourceProvider = Provider<AgroRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AgroRemoteDataSource(dioClient.dio);
});

final agroDataProvider = FutureProvider.autoDispose<AgroModel>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return const AgroModel();
  final ds = ref.watch(agroRemoteDataSourceProvider);
  return ds.getAgroData(siteId);
});
