import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/phase_remote_datasource.dart';
import '../../data/repositories/phase_repository_impl.dart';
import '../../domain/entities/phase.dart';
import '../../domain/repositories/phase_repository.dart';
import '../../domain/usecases/get_phases_usecase.dart';
import '../../domain/usecases/get_current_phase_usecase.dart';
import '../../domain/usecases/get_phase_history_usecase.dart';

// ─── DataSource Provider ─────────────────────────────────
/// Menggunakan dioClientProvider agar JWT token disertakan
final phaseRemoteDatasourceProvider = Provider<PhaseRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PhaseRemoteDatasource(dioClient.dio);
});

// ─── Repository Provider ─────────────────────────────────
final phaseRepositoryProvider = Provider<PhaseRepository>((ref) {
  final datasource = ref.watch(phaseRemoteDatasourceProvider);
  return PhaseRepositoryImpl(datasource);
});

final getPhasesByPlantUseCaseProvider = Provider<GetPhasesByPlantUseCase>((ref) {
  return GetPhasesByPlantUseCase(ref.watch(phaseRepositoryProvider));
});

final getPhaseByIdUseCaseProvider = Provider<GetPhaseByIdUseCase>((ref) {
  return GetPhaseByIdUseCase(ref.watch(phaseRepositoryProvider));
});

final getCurrentPhaseUseCaseProvider = Provider<GetCurrentPhaseUseCase>((ref) {
  return GetCurrentPhaseUseCase(ref.watch(phaseRepositoryProvider));
});

final getPhaseHistoryUseCaseProvider = Provider<GetPhaseHistoryUseCase>((ref) {
  return GetPhaseHistoryUseCase(ref.watch(phaseRepositoryProvider));
});

// ─── Phase List Provider (by plantId/siteId) ─────────────
/// Mengambil semua fase untuk plant/site tertentu
final phaseListProvider = FutureProvider.autoDispose.family<List<Phase>, String>((
  ref,
  plantId,
) async {
  return ref.retryOnError(() async {
    final useCase = ref.watch(getPhasesByPlantUseCaseProvider);
    final result = await useCase(plantId);
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─── Phase List for Selected Site ────────────────────────
/// Shortcut provider yang otomatis menggunakan selectedSiteProvider
final phasesForSelectedSiteProvider = FutureProvider.autoDispose<List<Phase>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.retryOnError(() async {
    final useCase = ref.watch(getPhasesByPlantUseCaseProvider);
    final result = await useCase(siteId);
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─── Current Phase Provider ───────────────────────────────
final currentPhaseProvider = FutureProvider.autoDispose.family<Phase?, String>((
  ref,
  plantId,
) async {
  return ref.retryOnError(() async {
    final useCase = ref.watch(getCurrentPhaseUseCaseProvider);
    final result = await useCase(plantId);
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─── Phase Detail Provider ────────────────────────────────
final phaseDetailProvider = FutureProvider.autoDispose.family<Phase, String>((
  ref,
  phaseId,
) async {
  return ref.retryOnError(() async {
    final useCase = ref.watch(getPhaseByIdUseCaseProvider);
    final result = await useCase(phaseId);
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─── Phase History Provider ───────────────────────────────
final phaseHistoryProvider = FutureProvider.autoDispose.family<List<Phase>, String>((
  ref,
  plantId,
) async {
  return ref.retryOnError(() async {
    final useCase = ref.watch(getPhaseHistoryUseCaseProvider);
    final result = await useCase(plantId);
    return result.fold((f) => throw f, (data) => data);
  });
});

// ─── Phase Statistics Provider ───────────────────────────
final phaseStatsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((
  ref,
  plantId,
) async {
  final phases = await ref.retryOnError(() async {
    final useCase = ref.watch(getPhasesByPlantUseCaseProvider);
    final result = await useCase(plantId);
    return result.fold((f) => throw f, (data) => data);
  });

  final completed = phases.where((p) => p.isCompleted).length;
  final active = phases.where((p) => p.isActive).length;
  final upcoming = phases.where((p) => p.isUpcoming).length;
  final total = phases.length;

  final currentPhase = phases.where((p) => p.isActive).firstOrNull;
  final totalGdd = phases.fold<double>(0, (sum, p) => sum + p.requiredGdd);
  final completedGdd = phases
      .where((p) => p.isCompleted)
      .fold<double>(0, (sum, p) => sum + p.currentGdd);

  return {
    'total': total,
    'completed': completed,
    'active': active,
    'upcoming': upcoming,
    'currentPhase': currentPhase,
    'totalGdd': totalGdd,
    'completedGdd': completedGdd,
    'overallProgress': total > 0 ? completed / total : 0.0,
  };
});
