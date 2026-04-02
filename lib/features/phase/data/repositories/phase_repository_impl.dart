import '../../domain/entities/phase.dart';
import '../../domain/repositories/phase_repository.dart';
import '../datasources/phase_remote_datasource.dart';

class PhaseRepositoryImpl implements PhaseRepository {
  final PhaseRemoteDatasource remoteDatasource;

  PhaseRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Phase>> getPhasesByPlant(String plantId) async {
    final models = await remoteDatasource.getPhasesByPlant(plantId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Phase> getPhaseById(String id) async {
    final model = await remoteDatasource.getPhaseById(id);
    return model.toEntity();
  }

  @override
  Future<Phase?> getCurrentPhase(String plantId) async {
    final model = await remoteDatasource.getCurrentPhase(plantId);
    return model?.toEntity();
  }

  @override
  Future<List<Phase>> getPhaseHistory(String plantId) async {
    final models = await remoteDatasource.getPhaseHistory(plantId);
    return models.map((m) => m.toEntity()).toList();
  }
}
