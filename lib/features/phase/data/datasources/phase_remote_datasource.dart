import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../models/phase_model.dart';

/// Remote datasource untuk Fase Pertumbuhan & GDD
/// API: /fase/phases-list, /fase/phases-by-hst/:siteId
class PhaseRemoteDatasource {
  final Dio _dio;

  PhaseRemoteDatasource(this._dio);

  /// GET /fase/phases-list
  Future<List<PhaseModel>> getAllPhases() async {
    try {
      final response = await _dio.get(ApiEndpoints.phasesList);
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

  /// GET /fase/phases-list/{cropType}
  Future<List<PhaseModel>> getPhasesByCropType(String cropType) async {
    try {
      final response = await _dio.get(ApiEndpoints.phasesByType(cropType));
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

  /// GET /fase/phases-by-hst/{siteId}
  /// Returns null jika 404 (tidak ada tanaman aktif).
  Future<CurrentPhaseData?> getCurrentPhaseByHst(String siteId) async {
    try {
      final response = await _dio.get(ApiEndpoints.phasesByHst(siteId));
      final data = response.data['data'];
      if (data == null || data is! Map<String, dynamic>) return null;

      // API bisa mengembalikan PhaseModel langsung atau wrapper CurrentPhaseData
      if (data.containsKey('phase_id') || data.containsKey('phase_name')) {
        final phase = PhaseModel.fromApiJson(data);
        final hst =
            (data['current_hst'] as num?)?.toInt() ??
            (data['hst'] as num?)?.toInt() ??
            0;
        return CurrentPhaseData(
          plantType: phase.cropType,
          hst: hst,
          currentPhase: phase,
        );
      }
      return CurrentPhaseData.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint('⚠️ No active plant found at site $siteId');
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

  /// Mengambil semua fase untuk site tertentu.
  /// Menggabungkan /phases-by-hst (untuk HST aktif) + /phases-list/{cropType}.
  Future<List<PhaseModel>> getPhasesByPlant(String siteId) async {
    try {
      final currentPhaseData = await getCurrentPhaseByHst(siteId);

      if (currentPhaseData == null) {
        // Tidak ada tanaman aktif — kondisi valid, bukan error
        return [];
      }

      final phases = await getPhasesByCropType(currentPhaseData.plantType);

      if (phases.isEmpty) {
        // Fallback: ambil semua fase tanpa filter crop type
        final allPhases = await getAllPhases();
        return allPhases
            .map(
              (phase) => phase.enrichWithHst(
                currentHst: currentPhaseData.hst,
                currentPhaseId: currentPhaseData.currentPhase?.id,
              ),
            )
            .toList();
      }

      return phases
          .map(
            (phase) => phase.enrichWithHst(
              currentHst: currentPhaseData.hst,
              currentPhaseId: currentPhaseData.currentPhase?.id,
            ),
          )
          .toList();
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

  /// Mengambil fase aktif saat ini untuk site.
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

  /// Mencari fase berdasarkan ID dari semua fase yang tersedia.
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

  /// Mengambil riwayat fase yang sudah selesai.
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

// ─── Helper Classes ───────────────────────────────────────

/// Data fase aktif dari API /fase/phases-by-hst/{siteId}
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
      hst: (json['hst'] as num?)?.toInt() ?? 0,
      currentPhase: json['current_phase'] != null
          ? PhaseModel.fromApiJson(
              json['current_phase'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
