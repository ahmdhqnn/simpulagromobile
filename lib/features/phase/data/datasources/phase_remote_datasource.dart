import 'package:dio/dio.dart';
import '../models/phase_model.dart';

class PhaseRemoteDatasource {
  // ignore: unused_field
  final Dio _dio;

  PhaseRemoteDatasource(this._dio);

  /// Mock data for phases
  Future<List<PhaseModel>> getPhasesByPlant(String plantId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock phases for Padi Varietas IR64
    return [
      PhaseModel(
        id: 'phase-1',
        plantId: plantId,
        plantName: 'Padi Varietas IR64',
        phaseName: 'Perkecambahan',
        description: 'Fase awal pertumbuhan benih hingga muncul tunas',
        startHst: 0,
        endHst: 10,
        currentHst: 12,
        requiredGdd: 150.0,
        currentGdd: 165.0,
        progress: 1.0,
        status: 'completed',
        startDate: DateTime.now().subtract(const Duration(days: 12)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PhaseModel(
        id: 'phase-2',
        plantId: plantId,
        plantName: 'Padi Varietas IR64',
        phaseName: 'Vegetatif',
        description: 'Pertumbuhan batang, daun, dan sistem perakaran',
        startHst: 11,
        endHst: 55,
        currentHst: 12,
        requiredGdd: 650.0,
        currentGdd: 25.0,
        progress: 0.02,
        status: 'active',
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: null,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
      ),
      PhaseModel(
        id: 'phase-3',
        plantId: plantId,
        plantName: 'Padi Varietas IR64',
        phaseName: 'Reproduktif',
        description: 'Pembentukan malai dan pengisian bulir',
        startHst: 56,
        endHst: 85,
        currentHst: 12,
        requiredGdd: 450.0,
        currentGdd: 0.0,
        progress: 0.0,
        status: 'upcoming',
        startDate: DateTime.now().add(const Duration(days: 44)),
        endDate: null,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now(),
      ),
      PhaseModel(
        id: 'phase-4',
        plantId: plantId,
        plantName: 'Padi Varietas IR64',
        phaseName: 'Pematangan',
        description: 'Pematangan bulir hingga siap panen',
        startHst: 86,
        endHst: 120,
        currentHst: 12,
        requiredGdd: 500.0,
        currentGdd: 0.0,
        progress: 0.0,
        status: 'upcoming',
        startDate: DateTime.now().add(const Duration(days: 74)),
        endDate: null,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Future<PhaseModel> getPhaseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final phases = await getPhasesByPlant('plant-1');
    return phases.firstWhere((p) => p.id == id);
  }

  Future<PhaseModel?> getCurrentPhase(String plantId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final phases = await getPhasesByPlant(plantId);
    try {
      return phases.firstWhere((p) => p.status == 'active');
    } catch (e) {
      return null;
    }
  }

  Future<List<PhaseModel>> getPhaseHistory(String plantId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final phases = await getPhasesByPlant(plantId);
    return phases.where((p) => p.status == 'completed').toList();
  }
}
