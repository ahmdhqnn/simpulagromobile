import '../entities/varietas_item.dart';

abstract class VarietasRepository {
  Future<List<VarietasItem>> getAllVarietas();
  Future<VarietasItem> getVarietasById(String id);
  Future<VarietasItem> createVarietas({
    required String varietasName,
    String? varietasDesc,
    int? varietasSts,
  });
  Future<VarietasItem> updateVarietas(
    String id, {
    String? varietasName,
    String? varietasDesc,
    int? varietasSts,
  });
  Future<void> deleteVarietas(String id);
}
