import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/response_parser.dart';
import '../models/phase_model.dart';

void _debugLog(String message) {
  assert(() {
    developer.log(message, name: 'PhaseRemoteDatasource');
    return true;
  }());
}

/// Remote datasource untuk Fase Pertumbuhan & GDD
/// API: /fase/phases-list, /fase/phases-by-hst/:siteId
class PhaseRemoteDatasource {
  final Dio _dio;

  PhaseRemoteDatasource(this._dio);

  /// GET /fase/phases-list
  Future<List<PhaseModel>> getAllPhases() async {
    try {
      final response = await _dio.get(ApiEndpoints.phasesList);
      final data = ResponseParser.extractDataList(response.data);
      return data
          .whereType<Map>()
          .map(
            (json) => PhaseModel.fromApiJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } on DioException catch (e) {
      _debugLog('❌ Phase datasource error (getAllPhases): ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog('❌ Unexpected error in phase datasource (getAllPhases): $e');
      rethrow;
    }
  }

  /// GET /fase/phases-list/{cropType}
  Future<List<PhaseModel>> getPhasesByCropType(String cropType) async {
    try {
      final response = await _dio.get(ApiEndpoints.phasesByType(cropType));
      final data = ResponseParser.extractDataList(response.data);
      return data
          .whereType<Map>()
          .map(
            (json) => PhaseModel.fromApiJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } on DioException catch (e) {
      _debugLog('❌ Phase datasource error (getPhasesByCropType): ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog(
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
      final data = ResponseParser.extractDataMap(response.data);
      if (data.isEmpty) return null;

      // API bisa mengembalikan PhaseModel langsung atau wrapper CurrentPhaseData
      if (data.containsKey('phase_id') || data.containsKey('phase_name')) {
        final phase = PhaseModel.fromApiJson(data);
        final hstValue = _findIntByKeys(data, _hstKeys);
        final base = CurrentPhaseData(
          plantType: phase.cropType,
          hst: hstValue ?? 0,
          hasExplicitHst: hstValue != null,
          currentPhase: phase,
          currentPhaseName: phase.phaseName,
          plantDate: _findDateByKeys(data, _plantDateKeys),
          referenceDate: _findDateByKeys(data, _referenceDateKeys),
        );
        return await _withResolvedHst(siteId, base);
      }
      return await _withResolvedHst(siteId, CurrentPhaseData.fromJson(data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _debugLog('⚠️ No active plant found at site $siteId');
        return null;
      }
      _debugLog(
        '❌ Phase datasource error (getCurrentPhaseByHst): ${e.message}',
      );
      rethrow;
    } catch (e) {
      _debugLog(
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

      return await _loadEnrichedPhases(currentPhaseData);
    } on DioException catch (e) {
      _debugLog('❌ Phase datasource error (getPhasesByPlant): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _debugLog(
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
      final phases = await _loadEnrichedPhases(currentData);
      final active = phases
          .where((phase) => phase.status == 'active')
          .firstOrNull;
      if (active != null) return active;
      return currentData.currentPhase!.enrichWithHst(
        currentHst: currentData.hst,
        currentPhaseId: currentData.currentPhase?.id,
        currentPhaseName: currentData.currentPhaseName,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      _debugLog('❌ Unexpected error in phase datasource (getCurrentPhase): $e');
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
      _debugLog('❌ Unexpected error in phase datasource (getPhaseById): $e');
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
      _debugLog('❌ Unexpected error in phase datasource (getPhaseHistory): $e');
      rethrow;
    }
  }

  Future<List<PhaseModel>> _loadEnrichedPhases(
    CurrentPhaseData currentPhaseData,
  ) async {
    final cropType = currentPhaseData.plantType.trim().toUpperCase();
    final phases = cropType.isEmpty
        ? await getAllPhases()
        : await getPhasesByCropType(cropType);
    final source = phases.isEmpty ? await getAllPhases() : phases;

    return source
        .map(
          (phase) => phase.enrichWithHst(
            currentHst: currentPhaseData.hst,
            currentPhaseId: currentPhaseData.currentPhase?.id,
            currentPhaseName: currentPhaseData.currentPhaseName,
          ),
        )
        .toList();
  }

  Future<CurrentPhaseData> _withResolvedHst(
    String siteId,
    CurrentPhaseData data,
  ) async {
    if (data.hasExplicitHst && data.hst > 0) return data;

    final hstFromResponsePlantDate = _calculateHst(
      data.plantDate,
      referenceDate: data.referenceDate,
    );
    if (hstFromResponsePlantDate != null &&
        (!data.hasExplicitHst || hstFromResponsePlantDate > data.hst)) {
      return data.copyWith(hst: hstFromResponsePlantDate);
    }

    final activePlant = await _loadActivePlantPhaseContext(siteId);
    if (activePlant == null) return data;

    return data.copyWith(
      hst: activePlant.hst != null && activePlant.hst! > data.hst
          ? activePlant.hst
          : data.hst,
      plantType: data.plantType.trim().isNotEmpty
          ? data.plantType
          : activePlant.plantType,
      plantDate: activePlant.plantDate ?? data.plantDate,
    );
  }

  Future<_ActivePlantPhaseContext?> _loadActivePlantPhaseContext(
    String siteId,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.plants(siteId),
        queryParameters: const {'isOnGoingPlant': true},
      );
      final rows = ResponseParser.extractDataList(
        response.data,
      ).whereType<Map>().map((row) => Map<String, dynamic>.from(row)).toList();
      if (rows.isEmpty) return null;

      final active = rows.firstWhere(
        (row) => _isActivePlantRow(row),
        orElse: () => rows.first,
      );
      final plantDate = _findDateByKeys(active, _plantDateKeys);
      return _ActivePlantPhaseContext(
        plantType: _stringFromKeys(active, _plantTypeKeys),
        plantDate: plantDate,
        hst: _calculateHst(plantDate),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}

// ─── Helper Classes ───────────────────────────────────────

/// Data fase aktif dari API /fase/phases-by-hst/{siteId}
class CurrentPhaseData {
  final String plantType;
  final int hst;
  final bool hasExplicitHst;
  final PhaseModel? currentPhase;
  final String? currentPhaseName;
  final DateTime? plantDate;
  final DateTime? referenceDate;

  const CurrentPhaseData({
    required this.plantType,
    required this.hst,
    this.hasExplicitHst = false,
    this.currentPhase,
    this.currentPhaseName,
    this.plantDate,
    this.referenceDate,
  });

  factory CurrentPhaseData.fromJson(Map<String, dynamic> json) {
    final currentPhaseRaw =
        json['current_phase'] ??
        json['currentPhase'] ??
        json['active_phase'] ??
        json['activePhase'] ??
        json['phase'];
    final currentPhase = currentPhaseRaw is Map
        ? PhaseModel.fromApiJson(Map<String, dynamic>.from(currentPhaseRaw))
        : null;
    final hstValue = _findIntByKeys(json, _hstKeys);
    final currentPhaseName =
        currentPhase?.phaseName ??
        (currentPhaseRaw is String ? currentPhaseRaw.trim() : null) ??
        _stringFromKeys(json, _phaseNameKeys);
    final plantType = _stringFromKeys(json, _plantTypeKeys).isNotEmpty
        ? _stringFromKeys(json, _plantTypeKeys)
        : currentPhase?.cropType ?? '';

    return CurrentPhaseData(
      plantType: plantType,
      hst: hstValue ?? 0,
      hasExplicitHst: hstValue != null,
      currentPhase: currentPhase,
      currentPhaseName: currentPhaseName,
      plantDate: _findDateByKeys(json, _plantDateKeys),
      referenceDate: _findDateByKeys(json, _referenceDateKeys),
    );
  }

  CurrentPhaseData copyWith({
    String? plantType,
    int? hst,
    bool? hasExplicitHst,
    PhaseModel? currentPhase,
    String? currentPhaseName,
    DateTime? plantDate,
    DateTime? referenceDate,
  }) {
    return CurrentPhaseData(
      plantType: plantType ?? this.plantType,
      hst: hst ?? this.hst,
      hasExplicitHst: hasExplicitHst ?? this.hasExplicitHst,
      currentPhase: currentPhase ?? this.currentPhase,
      currentPhaseName: currentPhaseName ?? this.currentPhaseName,
      plantDate: plantDate ?? this.plantDate,
      referenceDate: referenceDate ?? this.referenceDate,
    );
  }
}

class _ActivePlantPhaseContext {
  const _ActivePlantPhaseContext({
    required this.plantType,
    required this.plantDate,
    required this.hst,
  });

  final String plantType;
  final DateTime? plantDate;
  final int? hst;
}

const _hstKeys = {
  'current_hst',
  'currentHst',
  'current_hst_value',
  'hst',
  'HST',
  'days_after_planting',
  'daysAfterPlanting',
  'hari_setelah_tanam',
  'hariSetelahTanam',
  'plant_age',
  'plantAge',
  'umur_tanaman',
  'usia_tanaman',
};

const _plantDateKeys = {
  'plant_date',
  'plantDate',
  'planting_date',
  'plantingDate',
  'tanam_date',
  'tanggal_tanam',
};

const _referenceDateKeys = {
  'current_date',
  'currentDate',
  'server_date',
  'serverDate',
  'today',
  'as_of',
  'asOf',
};

const _plantTypeKeys = {
  'plant_type',
  'plantType',
  'crop_type',
  'cropType',
  'chrop_type',
  'chropType',
};

const _phaseNameKeys = {
  'phase_name',
  'phaseName',
  'current_phase_name',
  'currentPhaseName',
  'phase',
  'current_phase',
  'currentPhase',
};

int? _findIntByKeys(Map<String, dynamic> json, Set<String> keys) {
  final direct = _intFromKeys(json, keys);
  if (direct != null) return direct;

  for (final value in json.values) {
    if (value is Map) {
      final nested = _findIntByKeys(Map<String, dynamic>.from(value), keys);
      if (nested != null) return nested;
    }
  }
  return null;
}

int? _intFromKeys(Map<String, dynamic> json, Set<String> keys) {
  for (final key in keys) {
    if (!json.containsKey(key)) continue;
    final value = json[key];
    if (value is num) return value.toInt();
    final parsed = int.tryParse(value?.toString().trim() ?? '');
    if (parsed != null) return parsed;
  }
  return null;
}

DateTime? _findDateByKeys(Map<String, dynamic> json, Set<String> keys) {
  final direct = _dateFromKeys(json, keys);
  if (direct != null) return direct;

  for (final value in json.values) {
    if (value is Map) {
      final nested = _findDateByKeys(Map<String, dynamic>.from(value), keys);
      if (nested != null) return nested;
    }
  }
  return null;
}

DateTime? _dateFromKeys(Map<String, dynamic> json, Set<String> keys) {
  for (final key in keys) {
    if (!json.containsKey(key)) continue;
    final parsed = DateTime.tryParse(json[key]?.toString().trim() ?? '');
    if (parsed != null) return parsed;
  }
  return null;
}

String _stringFromKeys(Map<String, dynamic> json, Set<String> keys) {
  for (final key in keys) {
    if (!json.containsKey(key)) continue;
    final value = json[key];
    if (value is Map || value is List) continue;
    final text = value?.toString().trim() ?? '';
    if (text.isNotEmpty) return text;
  }

  for (final value in json.values) {
    if (value is Map) {
      final nested = _stringFromKeys(Map<String, dynamic>.from(value), keys);
      if (nested.isNotEmpty) return nested;
    }
  }
  return '';
}

int? _calculateHst(DateTime? plantDate, {DateTime? referenceDate}) {
  if (plantDate == null) return null;
  final start = DateTime(plantDate.year, plantDate.month, plantDate.day);
  final reference = referenceDate ?? DateTime.now();
  final end = DateTime(reference.year, reference.month, reference.day);
  return end.difference(start).inDays.clamp(0, 100000).toInt();
}

bool _isActivePlantRow(Map<String, dynamic> row) {
  final harvest = _findDateByKeys(row, {'plant_harvest', 'plantHarvest'});
  if (harvest != null) return false;
  final status = row['plant_sts'] ?? row['plantSts'] ?? row['status'];
  if (status == null) return true;
  if (status is num) return status.toInt() == 1;
  final text = status.toString().trim().toLowerCase();
  return text == '1' ||
      text == 'active' ||
      text == 'aktif' ||
      text == 'ongoing' ||
      text == 'on_going';
}
