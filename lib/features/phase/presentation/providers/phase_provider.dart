import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/phase_remote_datasource.dart';
import '../../data/repositories/phase_repository_impl.dart';
import '../../domain/entities/phase.dart';
import '../../domain/repositories/phase_repository.dart';

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

// ─── Phase List Provider (by plantId/siteId) ─────────────
/// Mengambil semua fase untuk plant/site tertentu
final phaseListProvider = FutureProvider.family<List<Phase>, String>((
  ref,
  plantId,
) async {
  return ref.read(phaseRepositoryProvider).getPhasesByPlant(plantId);
});

// ─── Phase List for Selected Site ────────────────────────
/// Shortcut provider yang otomatis menggunakan selectedSiteProvider
final phasesForSelectedSiteProvider = FutureProvider<List<Phase>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return ref.read(phaseRepositoryProvider).getPhasesByPlant(siteId);
});

// ─── Current Phase Provider ───────────────────────────────
final currentPhaseProvider = FutureProvider.family<Phase?, String>((
  ref,
  plantId,
) async {
  return ref.read(phaseRepositoryProvider).getCurrentPhase(plantId);
});

// ─── Phase Detail Provider ────────────────────────────────
final phaseDetailProvider = FutureProvider.family<Phase, String>((
  ref,
  phaseId,
) async {
  final phase = await ref.read(phaseRepositoryProvider).getPhaseById(phaseId);
  return phase;
});

// ─── Phase History Provider ───────────────────────────────
final phaseHistoryProvider = FutureProvider.family<List<Phase>, String>((
  ref,
  plantId,
) async {
  return ref.read(phaseRepositoryProvider).getPhaseHistory(plantId);
});

// ─── Phase Statistics Provider ───────────────────────────
final phaseStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  plantId,
) async {
  final phases = await ref
      .read(phaseRepositoryProvider)
      .getPhasesByPlant(plantId);

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
