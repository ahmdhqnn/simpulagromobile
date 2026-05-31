import '../../domain/entities/unit.dart';
import '../../domain/repositories/unit_repository.dart';
import '../datasources/unit_remote_datasource.dart';
import '../models/unit_model.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitRemoteDatasource remoteDatasource;

  UnitRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Unit>> getAllUnits() async {
    try {
      final models = await remoteDatasource.getAllUnits();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> getUnitById(String unitId) async {
    try {
      final model = await remoteDatasource.getUnitById(unitId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> createUnit(Unit unit) async {
    try {
      final model = UnitModel.fromEntity(unit);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null || key == 'unit_created' || key == 'unit_update',
      );

      final createdModel = await remoteDatasource.createUnit(data);
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> updateUnit(String unitId, Unit unit) async {
    try {
      final model = UnitModel.fromEntity(unit);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'unit_id' ||
            key == 'unit_created' ||
            key == 'unit_update',
      );

      final updatedModel = await remoteDatasource.updateUnit(unitId, data);
      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUnit(String unitId) async {
    try {
      await remoteDatasource.deleteUnit(unitId);
    } catch (e) {
      rethrow;
    }
  }
}
