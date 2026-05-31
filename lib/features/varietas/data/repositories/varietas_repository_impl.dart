import '../../domain/entities/varietas_item.dart';
import '../../domain/repositories/varietas_repository.dart';
import '../datasources/varietas_remote_datasource.dart';

class VarietasRepositoryImpl implements VarietasRepository {
  VarietasRepositoryImpl(this._datasource);

  final VarietasRemoteDatasource _datasource;

  @override
  Future<List<VarietasItem>> getAllVarietas() async {
    final models = await _datasource.getAllVarietas();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<VarietasItem> getVarietasById(String id) async {
    final model = await _datasource.getVarietasById(id);
    return model.toEntity();
  }

  @override
  Future<VarietasItem> createVarietas({
    required String varietasName,
    String? varietasDesc,
    int? varietasSts,
  }) async {
    final payload = <String, dynamic>{
      'varietas_name': varietasName.trim(),
      if (varietasDesc != null && varietasDesc.trim().isNotEmpty)
        'varietas_desc': varietasDesc.trim(),
      if (varietasSts != null) 'varietas_sts': varietasSts,
    };
    final model = await _datasource.createVarietas(payload);
    return model.toEntity();
  }

  @override
  Future<VarietasItem> updateVarietas(
    String id, {
    String? varietasName,
    String? varietasDesc,
    int? varietasSts,
  }) async {
    final payload = <String, dynamic>{};
    if (varietasName != null && varietasName.trim().isNotEmpty) {
      payload['varietas_name'] = varietasName.trim();
    }
    if (varietasDesc != null) {
      payload['varietas_desc'] = varietasDesc.trim();
    }
    if (varietasSts != null) {
      payload['varietas_sts'] = varietasSts;
    }
    final model = await _datasource.updateVarietas(id, payload);
    return model.toEntity();
  }

  @override
  Future<void> deleteVarietas(String id) {
    return _datasource.deleteVarietas(id);
  }
}
