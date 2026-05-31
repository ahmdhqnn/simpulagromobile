import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../data/datasources/varietas_remote_datasource.dart';
import '../../data/repositories/varietas_repository_impl.dart';
import '../../domain/entities/varietas_item.dart';
import '../../domain/repositories/varietas_repository.dart';

final varietasRemoteDatasourceProvider = Provider<VarietasRemoteDatasource>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return VarietasRemoteDatasource(dioClient.dio);
});

final varietasRepositoryProvider = Provider<VarietasRepository>((ref) {
  final datasource = ref.watch(varietasRemoteDatasourceProvider);
  return VarietasRepositoryImpl(datasource);
});

/// Source of truth list varietas from backend.
///
/// - Refresh manual saat screen/form membutuhkan data terbaru.
/// - Tetap return list kosong saat backend return null/empty.
final varietasListProvider = FutureProvider.autoDispose<List<VarietasItem>>((
  ref,
) async {
  final repository = ref.watch(varietasRepositoryProvider);

  return ref.retryOnError(() async {
    final items = await repository.getAllVarietas();
    items.sort(
      (a, b) =>
          a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
    );
    return items;
  });
});

final activeVarietasListProvider = Provider.autoDispose<List<VarietasItem>>((
  ref,
) {
  final items =
      ref.watch(varietasListProvider).valueOrNull ?? const <VarietasItem>[];
  return items.where((item) => item.isActive).toList(growable: false);
});
