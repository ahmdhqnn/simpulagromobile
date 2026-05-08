import 'package:dio/dio.dart';
import '../models/phase_model.dart';

/// Remote datasource untuk Fase Pertumbuhan & GDD
/// API: /fase/phases-list, /fase/phases-by-hst/:siteId, /fase/gdd-standards
class PhaseRemoteDatasource {
  final Dio _dio;

  PhaseRemoteDatasource(this._dio);

  /// GET /fase/phases-list
  /// Mendapatkan semua fase pertumbuhan dari semua jenis tanaman
  Future<List<PhaseModel>> getAllPhases() async {
    final response = await _dio.get('/fase/phases-list');
    final data = response.data['data'] as List? ?? [];
    return data
        .map((json) => PhaseModel.fromApiJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /fase/phases-list/:cropType
  /// Mendapatkan fase pertumbuhan berdasarkan jenis tanaman (PADI, JAGUNG, KEDELAI)
  Future<List<PhaseModel>> getPhasesByCropType(String cropType) async {
    final response = await _dio.get('/fase/phases-list/$cropType');
    final data = response.data['data'] as List? ?? [];
    return data
        .map((json) => PhaseModel.fromApiJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /fase/phases-by-hst/:siteId
  /// Mendapatkan fase pertumbuhan saat ini berdasarkan HST di site
  Future<CurrentPhaseData?> getCurrentPhaseByHst(String siteId) async {
    try {
      final response = await _dio.get('/fase/phases-by-hst/$siteId');
      final data = response.data['data'];
      if (data == null) return null;
      return CurrentPhaseData.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      // 404 = tidak ada data tanam aktif — bukan error fatal
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// GET /fase/gdd-standards
  /// Mendapatkan standar GDD untuk setiap jenis tanaman
  Future<Map<String, GddStandardData>> getGddStandards() async {
    final response = await _dio.get('/fase/gdd-standards');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return data.map(
      (key, value) => MapEntry(
        key,
        GddStandardData.fromJson(value as Map<String, dynamic>),
      ),
    );
  }

  /// Mendapatkan fase-fase untuk plant tertentu berdasarkan cropType
  /// Menggabungkan data dari phases-list dan phases-by-hst
  Future<List<PhaseModel>> getPhasesByPlant(String plantId) async {
    // plantId di sini digunakan sebagai siteId untuk phases-by-hst
    // karena API tidak memiliki endpoint per-plant, melainkan per-site
    final currentPhaseData = await getCurrentPhaseByHst(plantId);

    if (currentPhaseData == null) {
      // Tidak ada tanaman aktif di site ini — kembalikan list kosong
      // (bukan error, ini kondisi valid)
      return [];
    }

    // Ambil semua fase untuk crop type yang aktif
    final phases = await getPhasesByCropType(currentPhaseData.plantType);

    if (phases.isEmpty) {
      // Fallback: coba ambil semua fase tanpa filter crop type
      final allPhases = await getAllPhases();
      return allPhases.map((phase) {
        return phase.enrichWithHst(
          currentHst: currentPhaseData.hst,
          currentPhaseId: currentPhaseData.currentPhase?.id,
        );
      }).toList();
    }

    // Enrich setiap fase dengan data HST saat ini
    return phases.map((phase) {
      return phase.enrichWithHst(
        currentHst: currentPhaseData.hst,
        currentPhaseId: currentPhaseData.currentPhase?.id,
      );
    }).toList();
  }

  /// Mendapatkan fase saat ini untuk plant/site
  Future<PhaseModel?> getCurrentPhase(String siteId) async {
    final currentData = await getCurrentPhaseByHst(siteId);
    if (currentData == null || currentData.currentPhase == null) return null;

    return currentData.currentPhase!.enrichWithHst(
      currentHst: currentData.hst,
      currentPhaseId: currentData.currentPhase?.id,
    );
  }

  /// Mendapatkan fase berdasarkan ID
  Future<PhaseModel?> getPhaseById(String phaseId) async {
    try {
      final allPhases = await getAllPhases();
      return allPhases.where((p) => p.id == phaseId).firstOrNull;
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan riwayat fase yang sudah selesai
  Future<List<PhaseModel>> getPhaseHistory(String siteId) async {
    final phases = await getPhasesByPlant(siteId);
    return phases.where((p) => p.status == 'completed').toList();
  }
}

/// Data fase saat ini dari API /fase/phases-by-hst/:siteId
class CurrentPhaseData {
  final String plantType;
  final int hst;
  final PhaseModel? currentPhase;

  const CurrentPhaseData({
    required this.plantType,
    required this.hst,
    this.currentPhase,
  });

  factory CurrentPhaseData.fromJson(Map<String, dynamic> json) {
    return CurrentPhaseData(
      plantType: (json['plant_type'] as String?) ?? '',
      hst: (json['hst'] as int?) ?? 0,
      currentPhase: json['current_phase'] != null
          ? PhaseModel.fromApiJson(
              json['current_phase'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Standar GDD per jenis tanaman
class GddStandardData {
  final double baseTemp;
  final double upperTemp;
  final Map<String, double> phaseThresholds;

  const GddStandardData({
    required this.baseTemp,
    required this.upperTemp,
    required this.phaseThresholds,
  });

  factory GddStandardData.fromJson(Map<String, dynamic> json) {
    final thresholds = (json['phase_thresholds'] as Map<String, dynamic>? ?? {})
        .map((k, v) => MapEntry(k, (v as num).toDouble()));
    return GddStandardData(
      baseTemp: (json['base_temp'] as num?)?.toDouble() ?? 10.0,
      upperTemp: (json['upper_temp'] as num?)?.toDouble() ?? 30.0,
      phaseThresholds: thresholds,
    );
  }
}
