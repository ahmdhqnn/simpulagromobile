import '../entities/unit.dart';

abstract class UnitRepository {
  Future<List<Unit>> getAllUnits();
  Future<Unit> getUnitById(String unitId);
  Future<Unit> createUnit(Unit unit);
  Future<Unit> updateUnit(String unitId, Unit unit);
  Future<void> deleteUnit(String unitId);
}
