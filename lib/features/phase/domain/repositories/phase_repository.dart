import '../entities/phase.dart';

/// Repository interface for phase operations
abstract class PhaseRepository {
  /// Get all phases for a plant
  Future<List<Phase>> getPhasesByPlant(String plantId);

  /// Get phase by ID
  Future<Phase> getPhaseById(String id);

  /// Get current active phase for a plant
  Future<Phase?> getCurrentPhase(String plantId);

  /// Get phase history for a plant
  Future<List<Phase>> getPhaseHistory(String plantId);
}
