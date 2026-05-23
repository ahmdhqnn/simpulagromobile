import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../models/phase_model.dart';

/// Remote datasource untuk Fase Pertumbuhan & GDD
/// API: /fase/phases-list, /fase/phases-by-hst/:siteId, /fase/gdd-standards
class PhaseRemoteDatasource {
  final Dio _dio;

  PhaseRemoteDatasource(this._dio);

  /// GET /fase/phases-list
  /// Mendapatkan semua fase pertumbuhan dari semua jenis tanaman
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<PhaseModel>> getAllPhases() async {
    try {
      final response = await _dio.get('/fase/phases-list');
      final data = response.data['data'] as List? ?? [];
      return data
          .map((json) => PhaseModel.fromApiJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ Phase datasource error (getAllPhases): ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in phase datasource (getAllPhases): $e');
      rethrow;
    }
  }

  /// GET /fase/phases-list/:cropType
  /// Mendapatkan fase pertumbuhan berdasarkan jenis tanaman (PADI, JAGUNG, KEDELAI)
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<PhaseModel>> getPhasesByCropType(String cropType) async {
    try {
      final response = await _dio.get('/fase/phases-list/$cropType');
      final data = response.data['data'] as List? ?? [];
      return data
          .map((json) => PhaseModel.fromApiJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint(
        '❌ Phase datasource error (getPhasesByCropType): ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint(
        '❌ Unexpected error in phase datasource (getPhasesByCropType): $e',
      );
      rethrow;
    }
  }

  /// GET /fase/phases-by-hst/:siteId
  /// Mendapatkan fase pertumbuhan saat ini berdasarkan HST di site
  ///
  /// Returns null if 404 (no active plant). Throws exception for other errors.
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<CurrentPhaseData?> getCurrentPhaseByHst(String siteId) async {
    try {
      final response = await _dio.get('/fase/phases-by-hst/$siteId');
      final data = response.data['data'];
      if (data == null || data is! Map<String, dynamic>) return null;

      // Deteksi apakah API mengembalikan PhaseModel secara langsung
      if (data.containsKey('phase_id') || data.containsKey('phase_name')) {
        final phase = PhaseModel.fromApiJson(data);
        final hst =
            (data['current_hst'] as num?)?.toInt() ??
            (data['hst'] as num?)?.toInt() ??
            0;
        return CurrentPhaseData(
          plantType: phase.plantId,
          hst: hst,
          currentPhase: phase,
        );
      }
      return CurrentPhaseData.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint('⚠️ No active plant found at site');
        return null;
      }
      debugPrint(
        '❌ Phase datasource error (getCurrentPhaseByHst): ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint(
        '❌ Unexpected error in phase datasource (getCurrentPhaseByHst): $e',
      );
      rethrow;
    }
  }

  /// GET /fase/gdd-standards
  /// Mendapatkan standar GDD untuk setiap jenis tanaman
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<Map<String, GddStandardData>> getGddStandards() async {
    try {
      final response = await _dio.get('/fase/gdd-standards');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return data.map(
        (key, value) => MapEntry(
          key,
          GddStandardData.fromJson(value as Map<String, dynamic>),
        ),
      );
    } on DioException catch (e) {
      debugPrint('❌ Phase datasource error (getGddStandards): ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint(
        '❌ Unexpected error in phase datasource (getGddStandards): $e',
      );
      rethrow;
    }
  }

  /// Mendapatkan fase-fase untuk plant tertentu berdasarkan cropType
  /// Menggabungkan data dari phases-list dan phases-by-hst
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<PhaseModel>> getPhasesByPlant(String plantId) async {
    try {
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
    } on DioException catch (e) {
      debugPrint('❌ Phase datasource error (getPhasesByPlant): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint(
        '❌ Unexpected error in phase datasource (getPhasesByPlant): $e',
      );
      rethrow;
    }
  }

  /// Mendapatkan fase saat ini untuk plant/site
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<PhaseModel?> getCurrentPhase(String siteId) async {
    try {
      final currentData = await getCurrentPhaseByHst(siteId);
      if (currentData == null || currentData.currentPhase == null) return null;

      return currentData.currentPhase!.enrichWithHst(
        currentHst: currentData.hst,
        currentPhaseId: currentData.currentPhase?.id,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint(
        '❌ Unexpected error in phase datasource (getCurrentPhase): $e',
      );
      rethrow;
    }
  }

  /// Mendapatkan fase berdasarkan ID
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<PhaseModel?> getPhaseById(String phaseId) async {
    try {
      final allPhases = await getAllPhases();
      return allPhases.where((p) => p.id == phaseId).firstOrNull;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in phase datasource (getPhaseById): $e');
      rethrow;
    }
  }

  /// Mendapatkan riwayat fase yang sudah selesai
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  Future<List<PhaseModel>> getPhaseHistory(String siteId) async {
    try {
      final phases = await getPhasesByPlant(siteId);
      return phases.where((p) => p.status == 'completed').toList();
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint(
        '❌ Unexpected error in phase datasource (getPhaseHistory): $e',
      );
      rethrow;
    }
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
