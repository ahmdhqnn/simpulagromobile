import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/phase_remote_datasource.dart';
import '../../data/repositories/phase_repository_impl.dart';
import '../../domain/entities/phase.dart';
import '../../domain/repositories/phase_repository.dart';

// Datasource provider
final phaseRemoteDatasourceProvider = Provider<PhaseRemoteDatasource>((ref) {
  return PhaseRemoteDatasource(Dio());
});

// Repository provider
final phaseRepositoryProvider = Provider<PhaseRepository>((ref) {
  return PhaseRepositoryImpl(ref.read(phaseRemoteDatasourceProvider));
});

// Phase list provider
final phaseListProvider = FutureProvider.family<List<Phase>, String>((
  ref,
  plantId,
) async {
  return ref.read(phaseRepositoryProvider).getPhasesByPlant(plantId);
});

// Current phase provider
final currentPhaseProvider = FutureProvider.family<Phase?, String>((
  ref,
  plantId,
) async {
  return ref.read(phaseRepositoryProvider).getCurrentPhase(plantId);
});

// Phase detail provider
final phaseDetailProvider = FutureProvider.family<Phase, String>((
  ref,
  phaseId,
) async {
  return ref.read(phaseRepositoryProvider).getPhaseById(phaseId);
});

// Phase history provider
final phaseHistoryProvider = FutureProvider.family<List<Phase>, String>((
  ref,
  plantId,
) async {
  return ref.read(phaseRepositoryProvider).getPhaseHistory(plantId);
});

// Phase statistics provider
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
