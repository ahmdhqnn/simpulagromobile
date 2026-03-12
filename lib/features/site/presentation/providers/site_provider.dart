import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/site_remote_datasource.dart';
import '../../data/models/site_model.dart';

final siteRemoteDataSourceProvider = Provider<SiteRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SiteRemoteDataSource(dioClient.dio);
});

/// All sites
final sitesProvider = FutureProvider<List<SiteModel>>((ref) async {
  final dataSource = ref.watch(siteRemoteDataSourceProvider);
  return dataSource.getAllSites();
});

/// Currently selected site ID
final selectedSiteIdProvider = StateProvider<String?>((ref) => null);

/// Currently selected site object
final selectedSiteProvider = Provider<SiteModel?>((ref) {
  final selectedId = ref.watch(selectedSiteIdProvider);
  final sitesAsync = ref.watch(sitesProvider);
  return sitesAsync.whenOrNull(
    data: (sites) {
      if (selectedId == null && sites.isNotEmpty) {
        // Auto-select first site
        Future.microtask(
            () => ref.read(selectedSiteIdProvider.notifier).state = sites.first.siteId);
        return sites.first;
      }
      try {
        return sites.firstWhere((s) => s.siteId == selectedId);
      } catch (_) {
        return sites.isNotEmpty ? sites.first : null;
      }
    },
  );
});
