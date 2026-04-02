import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/site_remote_datasource.dart';
import '../../data/repositories/site_repository_impl.dart';
import '../../domain/entities/site.dart';
import '../../domain/repositories/site_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATA SOURCE
// ═══════════════════════════════════════════════════════════
final siteRemoteDataSourceProvider = Provider<SiteRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SiteRemoteDataSource(dioClient.dio);
});

// ═══════════════════════════════════════════════════════════
// REPOSITORY
// ═══════════════════════════════════════════════════════════
final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  final remoteDataSource = ref.watch(siteRemoteDataSourceProvider);
  return SiteRepositoryImpl(remoteDataSource);
});

// ═══════════════════════════════════════════════════════════
// SITE LIST PROVIDER
// ═══════════════════════════════════════════════════════════
final siteListProvider = FutureProvider<List<Site>>((ref) async {
  final repository = ref.watch(siteRepositoryProvider);
  return await repository.getSites();
});

// ═══════════════════════════════════════════════════════════
// SITE DETAIL PROVIDER (by ID)
// ═══════════════════════════════════════════════════════════
final siteDetailProvider = FutureProvider.family<Site, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(siteRepositoryProvider);
  return await repository.getSiteById(siteId);
});

// ═══════════════════════════════════════════════════════════
// SELECTED SITE PROVIDER (for app-wide site context)
// ═══════════════════════════════════════════════════════════
final selectedSiteProvider = StateProvider<Site?>((ref) => null);

// Helper provider to get selected site ID
final selectedSiteIdProvider = Provider<String?>((ref) {
  final selectedSite = ref.watch(selectedSiteProvider);
  return selectedSite?.siteId;
});

// Alias for backward compatibility
final sitesProvider = siteListProvider;

// ═══════════════════════════════════════════════════════════
// SITE FORM NOTIFIER (for Create/Update)
// ═══════════════════════════════════════════════════════════
class SiteFormState {
  final bool isLoading;
  final String? error;
  final Site? savedSite;

  const SiteFormState({this.isLoading = false, this.error, this.savedSite});

  SiteFormState copyWith({bool? isLoading, String? error, Site? savedSite}) {
    return SiteFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedSite: savedSite ?? this.savedSite,
    );
  }
}

class SiteFormNotifier extends StateNotifier<SiteFormState> {
  final SiteRepository _repository;

  SiteFormNotifier(this._repository) : super(const SiteFormState());

  Future<bool> createSite(Site site) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final savedSite = await _repository.createSite(site);
      state = SiteFormState(savedSite: savedSite);
      return true;
    } catch (e) {
      state = SiteFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateSite(String siteId, Site site) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final savedSite = await _repository.updateSite(siteId, site);
      state = SiteFormState(savedSite: savedSite);
      return true;
    } catch (e) {
      state = SiteFormState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const SiteFormState();
  }
}

final siteFormProvider = StateNotifierProvider<SiteFormNotifier, SiteFormState>(
  (ref) {
    final repository = ref.watch(siteRepositoryProvider);
    return SiteFormNotifier(repository);
  },
);
