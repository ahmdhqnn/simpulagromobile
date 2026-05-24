import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../data/datasources/recommendation_remote_datasource.dart';
import '../../data/repositories/recommendation_repository_impl.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../domain/usecases/generate_recommendation_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/manage_recommendation_usecase.dart';

// ─── DataSource Provider ─────────────────────────────────
final recommendationDatasourceProvider =
    Provider<RecommendationRemoteDatasource>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return RecommendationRemoteDatasourceImpl(dioClient.dio);
    });

// ─── Repository Provider ─────────────────────────────────
final recommendationRepositoryProvider = Provider<RecommendationRepository>((ref) {
  final datasource = ref.watch(recommendationDatasourceProvider);
  return RecommendationRepositoryImpl(datasource);
});

final getRecommendationsUseCaseProvider = Provider<GetRecommendationsUseCase>((ref) {
  return GetRecommendationsUseCase(ref.watch(recommendationRepositoryProvider));
});

final getRecommendationsBySiteUseCaseProvider = Provider<GetRecommendationsBySiteUseCase>((ref) {
  return GetRecommendationsBySiteUseCase(ref.watch(recommendationRepositoryProvider));
});

final getRecommendationsByPlantUseCaseProvider = Provider<GetRecommendationsByPlantUseCase>((ref) {
  return GetRecommendationsByPlantUseCase(ref.watch(recommendationRepositoryProvider));
});

final getRecommendationsByTypeUseCaseProvider = Provider<GetRecommendationsByTypeUseCase>((ref) {
  return GetRecommendationsByTypeUseCase(ref.watch(recommendationRepositoryProvider));
});

final getRecommendationByIdUseCaseProvider = Provider<GetRecommendationByIdUseCase>((ref) {
  return GetRecommendationByIdUseCase(ref.watch(recommendationRepositoryProvider));
});

final generateRecommendationUseCaseProvider = Provider<GenerateRecommendationUseCase>((ref) {
  return GenerateRecommendationUseCase(ref.watch(recommendationRepositoryProvider));
});

final applyRecommendationUseCaseProvider = Provider<ApplyRecommendationUseCase>((ref) {
  return ApplyRecommendationUseCase(ref.watch(recommendationRepositoryProvider));
});

final dismissRecommendationUseCaseProvider = Provider<DismissRecommendationUseCase>((ref) {
  return DismissRecommendationUseCase(ref.watch(recommendationRepositoryProvider));
});

/// History rekomendasi site
final recommendationHistoryProvider =
    FutureProvider.autoDispose<List<Recommendation>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final ds = ref.watch(recommendationDatasourceProvider);
  return ref.retryOnError(() async {
    final models = await ds.getRecommendationHistory(siteId);
    return models.map((m) => m.toEntity()).toList();
  });
});

final selectedPhaseIdForRecProvider = StateProvider<String?>((ref) => null);

final recommendationByPhaseProvider =
    FutureProvider.autoDispose<List<Recommendation>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  final phaseId = ref.watch(selectedPhaseIdForRecProvider);
  if (siteId == null || phaseId == null) return [];
  final ds = ref.watch(recommendationDatasourceProvider);
  return ref.retryOnError(() async {
    final models = await ds.getRecommendationsByPhase(siteId, phaseId);
    return models.map((m) => m.toEntity()).toList();
  });
});

// ─── Recommendation List for Selected Site ────────────────
/// Mengambil rekomendasi untuk site yang sedang dipilih
final recommendationListProvider = FutureProvider<List<Recommendation>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];

  // Halt recommendations if there is no active plant
  final activePlant = ref.watch(currentPlantProvider);
  if (activePlant == null) return [];

  final useCase = ref.watch(getRecommendationsBySiteUseCaseProvider);
  return await ref.retryOnError(() async {
    final result = await useCase(siteId);
    return result.fold(
      (failure) => throw failure,
      (recommendations) => List<Recommendation>.from(recommendations),
    );
  });
});

// ─── Recommendations by Site ─────────────────────────────
final recommendationsBySiteProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, siteId) async {
      final useCase = ref.watch(getRecommendationsBySiteUseCaseProvider);
      return await ref.retryOnError(() async {
        final result = await useCase(siteId);
        return result.fold(
          (failure) => throw failure,
          (recommendations) => List<Recommendation>.from(recommendations),
        );
      });
    });

// ─── Recommendations by Plant ─────────────────────────────
final recommendationsByPlantProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, plantId) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      final useCase = ref.watch(getRecommendationsByPlantUseCaseProvider);
      return await ref.retryOnError(() async {
        final result = await useCase(siteId, plantId);
        return result.fold(
          (failure) => throw failure,
          (recommendations) => List<Recommendation>.from(recommendations),
        );
      });
    });

// ─── Recommendations by Type ─────────────────────────────
final recommendationsByTypeProvider =
    FutureProvider.family<List<Recommendation>, RecommendationType>((
      ref,
      type,
    ) async {
      final useCase = ref.watch(getRecommendationsByTypeUseCaseProvider);
      return await ref.retryOnError(() async {
        final result = await useCase(type);
        return result.fold(
          (failure) => throw failure,
          (recommendations) => List<Recommendation>.from(recommendations),
        );
      });
    });

// ─── Recommendation Detail (cache-only, no GET /recommendations/{id}) ───
final recommendationDetailProvider =
    FutureProvider.family<Recommendation, String>((
      ref,
      recommendationId,
    ) async {
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) {
        throw const ServerFailure('Pilih site terlebih dahulu');
      }

      Recommendation? findInList(List<Recommendation> list) {
        for (final r in list) {
          if (r.recommendationId == recommendationId) return r;
        }
        return null;
      }

      final listAsync = ref.read(recommendationListProvider);
      final cached = listAsync.whenOrNull(data: findInList);
      if (cached != null) return cached;

      // Reload list site-scoped lalu cari lokal
      ref.invalidate(recommendationListProvider);
      final refreshed = await ref.read(recommendationListProvider.future);
      final fromRefresh = findInList(refreshed);
      if (fromRefresh != null) return fromRefresh;

      throw const NotFoundFailure(
        'Data rekomendasi tidak tersedia. Buka daftar rekomendasi terlebih dahulu.',
      );
    });

// ─── Recommendation Filter ────────────────────────────────
final recommendationFilterProvider = StateProvider<RecommendationFilter>(
  (ref) => RecommendationFilter.all,
);

// ─── Filtered Recommendations ────────────────────────────
final filteredRecommendationsProvider =
    Provider<AsyncValue<List<Recommendation>>>((ref) {
      final recommendationsAsync = ref.watch(recommendationListProvider);
      final filter = ref.watch(recommendationFilterProvider);

      return recommendationsAsync.whenData((recommendations) {
        switch (filter) {
          case RecommendationFilter.all:
            return recommendations;
          case RecommendationFilter.pending:
            return recommendations
                .where((r) => r.status == RecommendationStatus.pending)
                .toList();
          case RecommendationFilter.applied:
            return recommendations
                .where((r) => r.status == RecommendationStatus.applied)
                .toList();
          case RecommendationFilter.highPriority:
            return recommendations
                .where(
                  (r) =>
                      r.priority == RecommendationPriority.high ||
                      r.priority == RecommendationPriority.critical,
                )
                .toList();
          case RecommendationFilter.actionable:
            return recommendations.where((r) => r.isActionable).toList();
        }
      });
    });

// ─── Recommendation Statistics ────────────────────────────
final recommendationStatsProvider = Provider<RecommendationStats>((ref) {
  final recommendationsAsync = ref.watch(recommendationListProvider);

  return recommendationsAsync.when(
    data: (recommendations) {
      final total = recommendations.length;
      final pending = recommendations
          .where((r) => r.status == RecommendationStatus.pending)
          .length;
      final applied = recommendations
          .where((r) => r.status == RecommendationStatus.applied)
          .length;
      final dismissed = recommendations
          .where((r) => r.status == RecommendationStatus.dismissed)
          .length;
      final highPriority = recommendations
          .where(
            (r) =>
                r.priority == RecommendationPriority.high ||
                r.priority == RecommendationPriority.critical,
          )
          .length;

      return RecommendationStats(
        total: total,
        pending: pending,
        applied: applied,
        dismissed: dismissed,
        highPriority: highPriority,
      );
    },
    loading: () => const RecommendationStats(),
    error: (_, __) => const RecommendationStats(),
  );
});

// ─── Generate Recommendations (refresh) ──────────────────
class GenerateRecommendationState {
  final bool isLoading;
  final String? error;
  final List<Recommendation> recommendations;

  const GenerateRecommendationState({
    this.isLoading = false,
    this.error,
    this.recommendations = const [],
  });

  GenerateRecommendationState copyWith({
    bool? isLoading,
    String? error,
    List<Recommendation>? recommendations,
  }) {
    return GenerateRecommendationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}

class GenerateRecommendationNotifier
    extends StateNotifier<GenerateRecommendationState> {
  final GenerateRecommendationUseCase _useCase;
  final Ref _ref;

  GenerateRecommendationNotifier(this._useCase, this._ref)
    : super(const GenerateRecommendationState());

  Future<bool> generate(String siteId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _useCase(siteId);
      return result.fold(
        (failure) {
          state = GenerateRecommendationState(error: failure.message);
          return false;
        },
        (recommendations) {
          state = GenerateRecommendationState(recommendations: recommendations);
          // Invalidate list agar refresh otomatis
          _ref.invalidate(recommendationListProvider);
          _ref.invalidate(recommendationsBySiteProvider(siteId));
          return true;
        },
      );
    } catch (e) {
      state = GenerateRecommendationState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const GenerateRecommendationState();
  }
}

final generateRecommendationProvider =
    StateNotifierProvider<
      GenerateRecommendationNotifier,
      GenerateRecommendationState
    >((ref) {
      final useCase = ref.watch(generateRecommendationUseCaseProvider);
      return GenerateRecommendationNotifier(useCase, ref);
    });

// ─── Enums & Models ───────────────────────────────────────
enum RecommendationFilter {
  all,
  pending,
  applied,
  highPriority,
  actionable;

  String get label {
    switch (this) {
      case RecommendationFilter.all:
        return 'Semua';
      case RecommendationFilter.pending:
        return 'Menunggu';
      case RecommendationFilter.applied:
        return 'Diterapkan';
      case RecommendationFilter.highPriority:
        return 'Prioritas Tinggi';
      case RecommendationFilter.actionable:
        return 'Perlu Tindakan';
    }
  }
}

class RecommendationStats {
  final int total;
  final int pending;
  final int applied;
  final int dismissed;
  final int highPriority;

  const RecommendationStats({
    this.total = 0,
    this.pending = 0,
    this.applied = 0,
    this.dismissed = 0,
    this.highPriority = 0,
  });

  double get applicationRate {
    if (total == 0) return 0;
    return (applied / total) * 100;
  }
}
