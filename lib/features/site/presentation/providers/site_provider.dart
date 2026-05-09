import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/site_remote_datasource.dart';
import '../../data/repositories/site_repository_impl.dart';
import '../../domain/entities/site.dart';
import '../../domain/repositories/site_repository.dart';

// ─── DataSource ──────────────────────────────────────────
final siteRemoteDataSourceProvider = Provider<SiteRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SiteRemoteDataSource(dioClient.dio);
});

// ─── Repository ──────────────────────────────────────────
final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  final remoteDataSource = ref.watch(siteRemoteDataSourceProvider);
  return SiteRepositoryImpl(remoteDataSource);
});

// ─── Site List ───────────────────────────────────────────
final siteListProvider = FutureProvider<List<Site>>((ref) async {
  final repository = ref.watch(siteRepositoryProvider);
  return await repository.getSites();
});

// Alias untuk backward compatibility
final sitesProvider = siteListProvider;

// ─── Site Detail ─────────────────────────────────────────
final siteDetailProvider = FutureProvider.family<Site, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(siteRepositoryProvider);
  return await repository.getSiteById(siteId);
});

// ─── Selected Site (dengan persistensi) ──────────────────
/// StateNotifier yang menyimpan site terpilih ke SecureStorage
/// sehingga tidak hilang saat app restart
class SelectedSiteNotifier extends StateNotifier<Site?> {
  final SecureStorage _storage;
  final Ref _ref;

  SelectedSiteNotifier(this._storage, this._ref) : super(null) {
    _restoreSelectedSite();
  }

  /// Restore site terpilih dari storage saat app start
  Future<void> _restoreSelectedSite() async {
    final savedSiteId = await _storage.getSelectedSiteId();
    if (savedSiteId == null || !mounted) return;

    try {
      // Tunggu sites loaded, lalu cari site yang cocok
      final sites = await _ref.read(siteListProvider.future);
      final site = sites.where((s) => s.siteId == savedSiteId).firstOrNull;
      if (site != null && mounted) {
        state = site;
      }
    } catch (_) {
      // Jika gagal load sites, biarkan null — akan dipilih manual
    }
  }

  /// Set site terpilih dan simpan ke storage
  Future<void> selectSite(Site? site) async {
    state = site;
    if (site != null) {
      await _storage.saveSelectedSiteId(site.siteId);
    } else {
      await _storage.deleteSelectedSiteId();
    }
  }

  /// Auto-select site pertama jika belum ada yang dipilih
  Future<void> autoSelectFirstSite(List<Site> sites) async {
    if (state != null || sites.isEmpty) return;
    await selectSite(sites.first);
  }
}

final selectedSiteProvider = StateNotifierProvider<SelectedSiteNotifier, Site?>(
  (ref) {
    final storage = ref.watch(secureStorageProvider);
    return SelectedSiteNotifier(storage, ref);
  },
);

// Helper provider untuk mendapatkan siteId saja
final selectedSiteIdProvider = Provider<String?>((ref) {
  return ref.watch(selectedSiteProvider)?.siteId;
});

// ─── Site Form ───────────────────────────────────────────
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
  final Ref _ref;

  SiteFormNotifier(this._repository, this._ref) : super(const SiteFormState());

  Future<bool> createSite(Site site) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final savedSite = await _repository.createSite(site);
      state = SiteFormState(savedSite: savedSite);
      _ref.invalidate(siteListProvider);
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
      _ref.invalidate(siteListProvider);
      _ref.invalidate(siteDetailProvider(siteId));
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
    return SiteFormNotifier(repository, ref);
  },
);
