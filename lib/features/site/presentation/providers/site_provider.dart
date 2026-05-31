import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/providers/app_startup_provider.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../data/datasources/site_remote_datasource.dart';
import '../../data/repositories/site_repository_impl.dart';
import '../../domain/entities/site.dart';
import '../../domain/repositories/site_repository.dart';

part 'site_provider.g.dart';

final siteRemoteDataSourceProvider = Provider<SiteRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SiteRemoteDataSource(dioClient.dio);
});

final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  final remoteDataSource = ref.watch(siteRemoteDataSourceProvider);
  return SiteRepositoryImpl(remoteDataSource);
});

final siteListProvider = FutureProvider.autoDispose<List<Site>>((ref) async {
  final repository = ref.watch(siteRepositoryProvider);
  return ref.retryOnError(() async {
    final result = await repository.getSites();
    return result.fold((failure) => throw failure, (sites) => sites);
  });
});

final sitesProvider = siteListProvider;

final siteDetailProvider = FutureProvider.autoDispose.family<Site, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(siteRepositoryProvider);
  return ref.retryOnError(() async {
    final result = await repository.getSiteById(siteId);
    return result.fold((failure) => throw failure, (site) => site);
  });
});

@Riverpod(keepAlive: true)
class SelectedSite extends _$SelectedSite {
  SecureStorage get _storage => ref.read(secureStorageProvider);

  @override
  Site? build() {
    final startupData = ref.read(appStartupDataProvider);

    ref.listen<AsyncValue<List<Site>>>(siteListProvider, (previous, next) {
      next.whenOrNull(
        data: (sites) {
          updateFromSiteList(sites, startupData.selectedSiteId);
        },
      );
    }, fireImmediately: true);

    return null;
  }

  Future<void> selectSite(Site? site) async {
    state = site;
    if (site != null) {
      await _storage.saveSelectedSiteId(site.siteId);
    } else {
      await _storage.deleteSelectedSiteId();
    }
  }

  Future<void> autoSelectFirstSite(List<Site> sites) async {
    if (state != null || sites.isEmpty) return;
    await selectSite(sites.first);
  }

  Future<void> updateFromSiteList(
    List<Site> sites,
    String? preloadedSiteId,
  ) async {
    final current = state;
    if (current != null) {
      final matching = _findSite(sites, current.siteId);
      if (matching != null) {
        await selectSite(matching);
        return;
      }

      final preloadedSite = _findSite(sites, preloadedSiteId);
      if (preloadedSite != null) {
        await selectSite(preloadedSite);
      } else if (sites.isNotEmpty) {
        await selectSite(sites.first);
      } else {
        await selectSite(null);
      }
      return;
    }

    final preloadedSite = _findSite(sites, preloadedSiteId);
    if (preloadedSite != null) {
      await selectSite(preloadedSite);
    } else if (sites.isNotEmpty) {
      await selectSite(sites.first);
    }
  }

  Site? _findSite(List<Site> sites, String? siteId) {
    if (siteId == null) return null;
    return sites.where((site) => site.siteId == siteId).firstOrNull;
  }
}

@Riverpod(keepAlive: true)
String? selectedSiteId(Ref ref) {
  return ref.watch(selectedSiteProvider)?.siteId;
}

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
    final result = await _repository.createSite(site);
    return result.fold(
      (failure) {
        state = SiteFormState(error: failure.message);
        return false;
      },
      (savedSite) {
        state = SiteFormState(savedSite: savedSite);
        _ref.invalidate(siteListProvider);
        return true;
      },
    );
  }

  Future<bool> updateSite(String siteId, Site site) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.updateSite(siteId, site);
    return result.fold(
      (failure) {
        state = SiteFormState(error: failure.message);
        return false;
      },
      (savedSite) {
        state = SiteFormState(savedSite: savedSite);
        _ref.invalidate(siteListProvider);
        _ref.invalidate(siteDetailProvider(siteId));
        return true;
      },
    );
  }

  void reset() {
    state = const SiteFormState();
  }
}

final siteFormProvider =
    StateNotifierProvider.autoDispose<SiteFormNotifier, SiteFormState>((ref) {
      final repository = ref.watch(siteRepositoryProvider);
      return SiteFormNotifier(repository, ref);
    });

enum SiteMemberInviteErrorType {
  badRequest,
  forbidden,
  conflict,
  noSiteSelected,
  unknown,
}

class SiteMemberInviteState {
  final bool isLoading;
  final bool success;
  final String? message;
  final SiteMemberInviteErrorType? errorType;

  const SiteMemberInviteState({
    this.isLoading = false,
    this.success = false,
    this.message,
    this.errorType,
  });
}

class SiteMemberInviteNotifier extends StateNotifier<SiteMemberInviteState> {
  SiteMemberInviteNotifier(this._repository, this._ref)
    : super(const SiteMemberInviteState());

  final SiteRepository _repository;
  final Ref _ref;

  Future<bool> inviteMember({required String userId, String? siteId}) async {
    final resolvedSiteId =
        siteId ?? _ref.read(selectedSiteProvider)?.siteId ?? '';
    if (resolvedSiteId.trim().isEmpty) {
      state = const SiteMemberInviteState(
        isLoading: false,
        success: false,
        errorType: SiteMemberInviteErrorType.noSiteSelected,
      );
      return false;
    }

    state = const SiteMemberInviteState(isLoading: true);

    final result = await _repository.inviteMember(
      resolvedSiteId,
      userId.trim(),
    );
    return result.fold(
      (failure) {
        state = SiteMemberInviteState(
          isLoading: false,
          success: false,
          message: failure.message,
          errorType: _mapFailure(failure),
        );
        return false;
      },
      (_) {
        state = const SiteMemberInviteState(isLoading: false, success: true);
        return true;
      },
    );
  }

  SiteMemberInviteErrorType _mapFailure(Failure failure) {
    if (failure is PermissionFailure || failure.message == 'INVITE_FORBIDDEN') {
      return SiteMemberInviteErrorType.forbidden;
    }
    if (failure is ValidationFailure) {
      if (failure.message == 'INVITE_CONFLICT') {
        return SiteMemberInviteErrorType.conflict;
      }
      return SiteMemberInviteErrorType.badRequest;
    }
    return SiteMemberInviteErrorType.unknown;
  }

  void reset() {
    state = const SiteMemberInviteState();
  }
}

final siteMemberInviteProvider =
    StateNotifierProvider.autoDispose<
      SiteMemberInviteNotifier,
      SiteMemberInviteState
    >((ref) {
      final repository = ref.watch(siteRepositoryProvider);
      return SiteMemberInviteNotifier(repository, ref);
    });
