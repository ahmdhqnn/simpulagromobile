import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
import '../models/recommendation_model.dart';
import '../models/recommendation_bundle_model.dart';

void _debugLog(String message) {
  assert(() {
    developer.log(message, name: 'RecommendationRemoteDatasource');
    return true;
  }());
}

/// Recommendation remote datasource
abstract class RecommendationRemoteDatasource {
  Future<List<RecommendationModel>> getRecommendationsBySite(
    String siteId, {
    bool refresh = false,
  });
  Future<List<RecommendationModel>> getLatestRecommendationsForSite(
    String siteId,
  );
  Future<List<RecommendationModel>> getRecommendationHistory(String siteId);
  Future<List<RecommendationModel>> getRecommendationsByPhase(
    String siteId,
    String phaseId,
  );
  Future<List<RecommendationModel>> postPlantRecommendation(
    String siteId,
    Map<String, dynamic> payload,
  );
}

/// Recommendation remote datasource implementation
class RecommendationRemoteDatasourceImpl
    implements RecommendationRemoteDatasource {
  final Dio _dio;

  RecommendationRemoteDatasourceImpl(this._dio);

  /// GET /api/sites/:siteId/recommendations
  @override
  Future<List<RecommendationModel>> getRecommendationsBySite(
    String siteId, {
    bool refresh = false,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.recommendations(siteId),
        queryParameters: refresh ? {'refresh': 'true'} : null,
      );
      final data = ResponseParser.extractDataMap(response.data);
      return _parseRecommendationResponse(data, siteId);
    } on DioException catch (e) {
      final partial = _parsePartialRecommendationError(e, siteId);
      if (partial.isNotEmpty) return partial;
      if (_isExpectedEmptyRecommendationError(e)) return const [];
      _debugLog('Recommendation datasource error (getBySite): ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog(
        '❌ Unexpected error in recommendation datasource (getBySite): $e',
      );
      rethrow;
    }
  }

  @override
  Future<List<RecommendationModel>> getLatestRecommendationsForSite(
    String siteId,
  ) async {
    try {
      final response = await _dio.get(ApiEndpoints.plantRecBySite(siteId));
      return _parsePlantRecommendationEnvelope(response.data, siteId);
    } on DioException catch (e) {
      if (_isExpectedEmptyPlantRecommendationError(e)) return const [];
      rethrow;
    }
  }

  @override
  Future<List<RecommendationModel>> getRecommendationHistory(
    String siteId,
  ) async {
    try {
      return await _loadRecommendationHistory(siteId);
    } on DioException catch (e) {
      if (_isExpectedEmptyRecommendationError(e)) return [];
      rethrow;
    }
  }

  @override
  Future<List<RecommendationModel>> getRecommendationsByPhase(
    String siteId,
    String phaseId,
  ) async {
    try {
      final response = await _dio.get(ApiEndpoints.recByPhase(siteId, phaseId));
      final rows = ResponseParser.extractDataList(response.data);
      if (rows.isNotEmpty) {
        return rows
            .whereType<Map>()
            .expand((e) => _parseHistoryEntry(e, siteId))
            .toList();
      }
      final data = ResponseParser.extractDataMap(response.data);
      return _parseRecommendationResponse(data, siteId);
    } on DioException catch (e) {
      if (_isExpectedEmptyRecommendationError(e)) return [];
      rethrow;
    }
  }

  @override
  Future<List<RecommendationModel>> postPlantRecommendation(
    String siteId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.plantRecommendations(siteId),
      data: payload,
    );
    final parsedPlantRecommendations = _parsePlantRecommendationEnvelope(
      response.data,
      siteId,
    );
    if (parsedPlantRecommendations.isNotEmpty) {
      return parsedPlantRecommendations;
    }

    final responseMap = _safeExtractDataMap(response.data);
    if (responseMap == null) return const [];
    final plantRecommendations = _parsePlantRecommendationResponse(
      responseMap,
      siteId,
    );
    return plantRecommendations;
  }

  /// Parse response dari GET /recommendations menjadi list RecommendationModel
  /// Response: { sensor_data: {...}, recommendations: { npk: {...}, ph: {...} }, cached: bool }
  ///
  /// ⚠️ Catatan: ID dihasilkan dengan timestamp karena backend tidak mengembalikan ID
  List<RecommendationModel> _parseRecommendationResponse(
    Map<String, dynamic> data,
    String siteId, {
    DateTime? createdAt,
    String? idSeed,
  }) {
    final recommendationsMap = _asStringMap(data['recommendations']);
    if (recommendationsMap == null || recommendationsMap.isEmpty) {
      if (_looksLikeDirectRecommendation(data)) {
        return [_parseDirectRecommendationItem(data, siteId)];
      }
      return [];
    }

    final result = <RecommendationModel>[];
    final timestamp =
        createdAt ??
        _parseDate(data['generated_at']) ??
        _parseDate(data['cached_at']) ??
        DateTime.now();
    final sensorData = _parseSensorData(data['sensor_data']);

    void parseItem(
      String key,
      String typeStr,
      String defaultTitle,
      dynamic raw,
    ) {
      final item = _buildRecommendationFromRaw(
        raw: raw,
        key: key,
        typeStr: typeStr,
        defaultTitle: defaultTitle,
        siteId: siteId,
        createdAt: timestamp,
        idSeed: idSeed,
        sensorData: sensorData,
      );
      if (item != null) result.add(item);
    }

    parseItem('npk', 'npk', 'Penyesuaian NPK', recommendationsMap['npk']);
    parseItem('ph', 'ph', 'Penyesuaian pH Tanah', recommendationsMap['ph']);

    final lingkungan = _asStringMap(recommendationsMap['lingkungan']);
    if (lingkungan != null) {
      for (final entry in lingkungan.entries) {
        parseItem(
          'lingkungan_${entry.key}',
          _environmentType(entry.key),
          _environmentTitle(entry.key),
          entry.value,
        );
      }
    }

    for (final entry in recommendationsMap.entries) {
      if (entry.key == 'npk' ||
          entry.key == 'ph' ||
          entry.key == 'lingkungan') {
        continue;
      }
      parseItem(
        entry.key,
        _mapRecommendationType(entry.key),
        _titleFromKey(entry.key),
        entry.value,
      );
    }

    return result;
  }

  /// Parse item dari history endpoint versi baru maupun format lama.
  List<RecommendationModel> _parseHistoryEntry(
    Map<dynamic, dynamic> raw,
    String siteId,
  ) {
    final json = Map<String, dynamic>.from(raw);
    final createdAt = _parseDate(
      json['generated_at'] ??
          json['created_at'] ??
          json['rec_created'] ??
          json['date'] ??
          json['rec_date'],
    );
    final idSeed = _stringOrNull(json['rec_id'] ?? json['date']);

    // Parse sensor data (both nested and flat root-level columns)
    final sensorData = <String, dynamic>{...?_asStringMap(json['sensor_data'])};
    sensorData.addAll({
      if (json['nitrogen'] != null) 'nitrogen': json['nitrogen'],
      if (json['phosphorus'] != null) 'phosphorus': json['phosphorus'],
      if (json['potassium'] != null) 'potassium': json['potassium'],
      if (json['ph_value'] != null || json['ph'] != null)
        'ph': json['ph_value'] ?? json['ph'],
      if (json['env_temp'] != null ||
          json['envTemp'] != null ||
          json['temperature'] != null)
        'env_temp': json['env_temp'] ?? json['envTemp'] ?? json['temperature'],
      if (json['env_hum'] != null ||
          json['envHum'] != null ||
          json['humidity'] != null)
        'env_hum': json['env_hum'] ?? json['envHum'] ?? json['humidity'],
      if (json['soil_temp'] != null || json['soilTemp'] != null)
        'soil_temp': json['soil_temp'] ?? json['soilTemp'],
      if (json['soil_hum'] != null || json['soilHum'] != null)
        'soil_hum': json['soil_hum'] ?? json['soilHum'],
    });

    final liveBundle = _asStringMap(json['recommendations']);
    if (liveBundle != null && liveBundle.isNotEmpty) {
      final recommendationsMap = <String, dynamic>{...liveBundle};

      // Inject lingkungan if missing from recommendations but present at root level
      if (!recommendationsMap.containsKey('lingkungan') &&
          json.containsKey('lingkungan_recommendation')) {
        final lingkunganRaw = _parseJsonRecommendation(
          json['lingkungan_recommendation'],
        );
        if (lingkunganRaw != null) {
          recommendationsMap['lingkungan'] = lingkunganRaw;
        }
      }

      return _parseRecommendationResponse(
        {
          'recommendations': recommendationsMap,
          if (sensorData.isNotEmpty) 'sensor_data': sensorData,
        },
        siteId,
        createdAt: createdAt,
        idSeed: idSeed,
      );
    }

    final npkRaw = _parseJsonRecommendation(json['npk_recommendation']);
    final phRaw = _parseJsonRecommendation(json['ph_recommendation']);
    final lingkunganRaw = _parseJsonRecommendation(
      json['lingkungan_recommendation'],
    );
    final npkMap = _asStringMap(npkRaw);
    final phFromNpk = npkMap == null ? null : npkMap['ph'];
    final normalizedNpk = npkMap == null
        ? _normalizeLegacyScalarRecommendation(npkRaw)
        : _normalizeLegacyNpkRecommendation(npkMap);
    final normalizedPh = _normalizeLegacyScalarRecommendation(
      phRaw ?? phFromNpk,
    );
    final normalizedNpkPayload = _legacyRecommendationPayload(
      normalized: normalizedNpk,
      status: json['npk_status'],
      error: json['npk_error'],
      fallbackError: 'Rekomendasi NPK gagal diproses',
    );
    final normalizedPhPayload = _legacyRecommendationPayload(
      normalized: normalizedPh,
      status: json['ph_status'],
      error: json['ph_error'],
      fallbackError: 'Rekomendasi pH gagal diproses',
    );

    if (normalizedNpkPayload != null ||
        normalizedPhPayload != null ||
        lingkunganRaw != null) {
      return _parseRecommendationResponse(
        {
          'recommendations': {
            if (normalizedNpkPayload != null) 'npk': normalizedNpkPayload,
            if (normalizedPhPayload != null) 'ph': normalizedPhPayload,
            if (lingkunganRaw != null) 'lingkungan': lingkunganRaw,
          },
          if (sensorData.isNotEmpty) 'sensor_data': sensorData,
        },
        siteId,
        createdAt: createdAt,
        idSeed: idSeed,
      );
    }

    if (_looksLikeDirectRecommendation(json)) {
      return [_parseDirectRecommendationItem(json, siteId)];
    }

    return const [];
  }

  dynamic _legacyRecommendationPayload({
    required dynamic normalized,
    required dynamic status,
    required dynamic error,
    required String fallbackError,
  }) {
    final errorMessage = _stringOrNull(error);
    if (_isFailedLegacyStatus(status) || errorMessage != null) {
      return {'error': errorMessage ?? fallbackError};
    }
    return normalized;
  }

  Future<List<RecommendationModel>> _loadRecommendationHistory(
    String siteId,
  ) async {
    final response = await _dio.get(ApiEndpoints.recHistory(siteId));
    final data = ResponseParser.extractDataList(response.data);
    final parsed = data
        .whereType<Map>()
        .expand((json) => _parseHistoryEntry(json, siteId))
        .toList();
    parsed.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return parsed;
  }

  Map<String, dynamic>? _normalizeLegacyNpkRecommendation(
    Map<String, dynamic> npk,
  ) {
    if (npk.containsKey('status') || npk.containsKey('pesan')) {
      return npk;
    }

    final parts = <String>[];
    final actionItems = <String>[];
    final statuses = <String>[];
    num totalDose = 0;

    const nutrientAliases = {
      'N': ['n', 'nitrogen', 'nitro', 'soil_nitro'],
      'P': ['p', 'phosphorus', 'fosfor', 'phos', 'soil_phos'],
      'K': ['k', 'potassium', 'kalium', 'pot', 'soil_pot'],
    };

    String normalizeSingleStatus(String? statusText) {
      if (statusText == null) return 'normal';
      final normalized = statusText.toLowerCase();
      if (normalized.contains('rendah') ||
          normalized.contains('kurang') ||
          normalized.contains('deficient') ||
          normalized.contains('low')) {
        return 'rendah';
      }
      if (normalized.contains('tinggi') ||
          normalized.contains('berlebih') ||
          normalized.contains('excess') ||
          normalized.contains('high')) {
        return 'tinggi';
      }
      return 'normal';
    }

    for (final nutrient in nutrientAliases.entries) {
      final raw = _firstValueForKeys(npk, nutrient.value);
      final label = nutrient.key;
      String? rawStatus;

      if (raw is String) {
        final message = raw.trim();
        if (message.isNotEmpty) {
          final line = '$label: $message';
          parts.add(line);
          actionItems.add(line);
          rawStatus = _statusFromText(message);
        }
      } else {
        final map = _asStringMap(raw);
        if (map != null) {
          final message = _messageFromMap(map);
          if (message != null) {
            final line = '$label: $message';
            parts.add(line);
            actionItems.add(line);
          }
          rawStatus =
              _stringOrNull(map['status']) ??
              (message != null ? _statusFromText(message) : null);

          final dose = _doseValue(map);
          if (dose > 0) {
            totalDose += dose;
            actionItems.add('Dosis $label: ${_formatNumber(dose)} kg/ha');
          }
        }
      }

      if (rawStatus != null) {
        statuses.add(normalizeSingleStatus(rawStatus));
      }
    }

    if (parts.isEmpty) return null;
    if (totalDose > 0) {
      actionItems.insert(
        0,
        'Total dosis NPK: ${_formatNumber(totalDose)} kg/ha',
      );
    }

    final hasLow = statuses.contains('rendah');
    final hasHigh = statuses.contains('tinggi');

    String overallStatus = 'normal';
    if (hasLow && hasHigh) {
      overallStatus = 'kritis';
    } else if (hasLow) {
      overallStatus = 'rendah';
    } else if (hasHigh) {
      overallStatus = 'tinggi';
    }

    return {
      'status': overallStatus,
      'pesan': parts.join(' | '),
      if (totalDose > 0) 'dosis_kg_ha': totalDose,
      if (actionItems.isNotEmpty) 'action_items': actionItems,
    };
  }

  Map<String, dynamic>? _normalizeCompoundNpkRecommendation(
    Map<String, dynamic> npk,
  ) {
    if (npk.containsKey('status') ||
        npk.containsKey('pesan') ||
        npk.containsKey('message') ||
        npk.containsKey('description')) {
      return npk;
    }
    if (!_containsCompoundNpkKeys(npk)) return null;
    return _normalizeLegacyNpkRecommendation(npk);
  }

  bool _containsCompoundNpkKeys(Map<String, dynamic> npk) {
    for (final key in npk.keys) {
      final normalized = key.toLowerCase();
      if (normalized == 'n' ||
          normalized == 'p' ||
          normalized == 'k' ||
          normalized.contains('nitrogen') ||
          normalized.contains('phosphorus') ||
          normalized.contains('fosfor') ||
          normalized.contains('potassium') ||
          normalized.contains('kalium')) {
        return true;
      }
    }
    return false;
  }

  dynamic _firstValueForKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key)) return map[key];
    }
    final normalizedKeys = keys.map((key) => key.toLowerCase()).toSet();
    for (final entry in map.entries) {
      if (normalizedKeys.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return null;
  }

  dynamic _normalizeLegacyScalarRecommendation(dynamic raw) {
    if (raw == null) return null;
    final map = _asStringMap(raw);
    if (map != null) return map.isEmpty ? null : map;
    final message = _stringOrNull(raw);
    if (message == null || message.toLowerCase() == 'null') return null;
    return {
      'status': _statusFromText(message),
      'pesan': message,
      'dosis_kg_ha': 0,
    };
  }

  RecommendationModel? _buildRecommendationFromRaw({
    required dynamic raw,
    required String key,
    required String typeStr,
    required String defaultTitle,
    required String siteId,
    required DateTime createdAt,
    String? idSeed,
    RecommendationSensorDataModel? sensorData,
  }) {
    if (raw == null) return null;

    var itemMap = _asStringMap(raw);
    if (typeStr == 'npk' && itemMap != null) {
      final embedded = _parseJsonRecommendation(
        itemMap['npk_recommendation'] ?? itemMap['recommendation_npk'],
      );
      final embeddedMap = _asStringMap(embedded);
      final normalized = _normalizeCompoundNpkRecommendation(
        embeddedMap ?? itemMap,
      );
      if (normalized != null) itemMap = normalized;
    }
    if (itemMap != null && itemMap.isEmpty) return null;
    final rawText = raw is String ? raw.trim() : null;
    if (itemMap == null && (rawText == null || rawText.isEmpty)) {
      return null;
    }

    final errorMessage = itemMap == null
        ? null
        : _stringOrNull(itemMap['error']);
    final isError = errorMessage != null;
    final title = isError
        ? '$defaultTitle tidak tersedia'
        : itemMap == null
        ? defaultTitle
        : _titleFromMap(itemMap, typeStr, defaultTitle);
    final description =
        (isError
            ? errorMessage
            : itemMap == null
            ? rawText
            : _messageFromMap(itemMap)) ??
        'Rekomendasi tersedia berdasarkan data sensor terbaru.';
    final priority = isError
        ? 'high'
        : itemMap == null
        ? _mapTextPriority(rawText)
        : _mapNpkPriority(
            _stringOrNull(
              itemMap['priority'] ?? itemMap['status'] ?? itemMap['level'],
            ),
          );
    final actionModel = itemMap == null ? null : _actionModel(itemMap);

    return RecommendationModel(
      recommendationId: _generatedId(
        key,
        siteId,
        createdAt,
        idSeed,
        message: description,
      ),
      type: typeStr,
      title: title,
      description: description,
      priority: priority,
      siteId: siteId,
      parameters: RecommendationBundleModel(
        npk: !isError && typeStr == 'npk' ? actionModel : null,
        ph: !isError && typeStr == 'ph' ? actionModel : null,
        sensorData: sensorData,
      ),
      actionItems: isError
          ? const []
          : itemMap == null
          ? [description]
          : _buildActionItems(itemMap, fallback: description),
      createdAt: createdAt,
      confidenceScore: itemMap == null
          ? null
          : _toConfidence(itemMap['confidence'] ?? itemMap['confidence_score']),
      reason: description,
      errorMessage: errorMessage,
    );
  }

  Map<String, dynamic>? _safeExtractDataMap(dynamic responseData) {
    try {
      return ResponseParser.extractDataMap(responseData);
    } catch (error) {
      _debugLog('Plant recommendation response is not a map: $error');
      return null;
    }
  }

  List<RecommendationModel> _parsePlantRecommendationEnvelope(
    dynamic responseData,
    String siteId,
  ) {
    final candidates = <dynamic>[responseData];
    final rootMap = _asStringMap(responseData);
    if (rootMap != null) {
      candidates.add(rootMap['data']);
      final nestedData = _asStringMap(rootMap['data']);
      if (nestedData != null) candidates.add(nestedData['data']);
    }

    for (final candidate in candidates) {
      if (candidate == null) continue;
      final candidateMap = _asStringMap(candidate);
      final parsed = candidateMap == null
          ? _parsePlantRecommendationList(candidate, siteId)
          : _parsePlantRecommendationResponse(candidateMap, siteId);
      if (parsed.isNotEmpty) return parsed;
    }
    return const [];
  }

  List<RecommendationModel> _parsePlantRecommendationResponse(
    Map<String, dynamic> data,
    String siteId,
  ) {
    final rawPlants = _firstValueForKeys(data, const [
      'recommended_plants',
      'recommendedPlants',
      'recommended_plant',
      'recommendedPlant',
      'plant_recommendations',
      'plantRecommendations',
      'plant_names',
      'plantNames',
      'recommendations',
      'recommendation',
      'recommended',
      'plants',
      'crops',
      'crop_recommendations',
      'cropRecommendations',
      'results',
      'result',
      'predictions',
      'prediction',
      'output',
      'outputs',
      'data',
    ]);

    final confidenceRaw = _firstValueForKeys(data, const [
      'confidence',
      'confidences',
      'scores',
      'score',
      'probabilities',
      'probability',
      'probs',
    ]);
    final confidence = confidenceRaw is List ? confidenceRaw : const [];
    final confidenceMap = _asStringMap(confidenceRaw);
    final details = _asStringMap(data['details']);
    final createdAt =
        _parseDate(data['created_at'] ?? data['createdAt']) ?? DateTime.now();

    final rawPlantMap = _asStringMap(rawPlants);
    if (rawPlantMap != null) {
      final scoreMapPlants = _plantCandidatesFromScoreMap(rawPlantMap);
      if (scoreMapPlants.isNotEmpty) {
        return _buildPlantRecommendationModels(
          scoreMapPlants,
          siteId: siteId,
          confidence: const [],
          confidenceMap: rawPlantMap,
          details: details,
          createdAt: createdAt,
        );
      }
      return _parsePlantRecommendationResponse(rawPlantMap, siteId);
    }

    if (rawPlants is! List) {
      final parsedList = _parsePlantRecommendationList(rawPlants, siteId);
      if (parsedList.isNotEmpty) return parsedList;
      if (_looksLikePlantCandidate(data)) {
        return _buildPlantRecommendationModels(
          [data],
          siteId: siteId,
          confidence: confidence,
          confidenceMap: confidenceMap,
          details: details,
          createdAt: createdAt,
        );
      }
      return const [];
    }

    return _buildPlantRecommendationModels(
      rawPlants,
      siteId: siteId,
      confidence: confidence,
      confidenceMap: confidenceMap,
      details: details,
      createdAt: createdAt,
    );
  }

  List<RecommendationModel> _parsePlantRecommendationList(
    dynamic raw,
    String siteId,
  ) {
    final createdAt = DateTime.now();
    if (raw is List) {
      return _buildPlantRecommendationModels(
        raw,
        siteId: siteId,
        confidence: const [],
        confidenceMap: null,
        details: null,
        createdAt: createdAt,
      );
    }

    final rawText = _stringOrNull(raw);
    if (rawText == null) return const [];
    if (_isNonPlantRecommendationText(rawText)) return const [];
    final plants = rawText.contains(RegExp(r'[,;\n]'))
        ? rawText.split(RegExp(r'[,;\n]')).map((item) => item.trim()).toList()
        : [rawText];
    return _buildPlantRecommendationModels(
      plants,
      siteId: siteId,
      confidence: const [],
      confidenceMap: null,
      details: null,
      createdAt: createdAt,
    );
  }

  List<RecommendationModel> _buildPlantRecommendationModels(
    List<dynamic> rawPlants, {
    required String siteId,
    required List<dynamic> confidence,
    required Map<String, dynamic>? confidenceMap,
    required Map<String, dynamic>? details,
    required DateTime createdAt,
  }) {
    final result = <RecommendationModel>[];
    for (var index = 0; index < rawPlants.length; index++) {
      final rawPlant = rawPlants[index];
      final plantMap = _asStringMap(rawPlant);
      final plantName = _stringOrNull(
        plantMap == null
            ? rawPlant
            : plantMap['name'] ??
                  plantMap['plant'] ??
                  plantMap['plant_name'] ??
                  plantMap['label'] ??
                  plantMap['crop'] ??
                  plantMap['crop_name'] ??
                  plantMap['class'] ??
                  plantMap['class_name'] ??
                  plantMap['predicted_class'] ??
                  plantMap['prediction'] ??
                  plantMap['recommended_plant'],
      );
      if (plantName == null) continue;
      if (_isNonPlantRecommendationText(plantName)) continue;

      final itemConfidence = _toConfidence(
        plantMap?['confidence'] ??
            plantMap?['score'] ??
            plantMap?['probability'] ??
            plantMap?['prob'] ??
            plantMap?['confidence_score'] ??
            plantMap?['confidence_text'] ??
            plantMap?['score_text'] ??
            plantMap?['probability_text'] ??
            confidenceMap?[plantName] ??
            confidenceMap?[plantName.toLowerCase()] ??
            (index < confidence.length ? confidence[index] : null),
      );
      final detail = details == null
          ? null
          : _plantDetailText(
              details[plantName] ??
                  details[plantName.toLowerCase()] ??
                  details[index.toString()],
            );
      String priority = 'medium';
      if (plantMap != null) {
        final level = _stringOrNull(
          plantMap['recommendation_level'] ?? plantMap['category'],
        )?.toLowerCase();
        if (level != null) {
          if (level.contains('highly_recommended') ||
              level.contains('highly recommended') ||
              level.contains('sangat cocok') ||
              level == 'high' ||
              level == 'tinggi') {
            priority = 'high';
          } else if (level.contains('less_recommended') ||
              level.contains('less recommended') ||
              level.contains('not_recommended') ||
              level.contains('not recommended') ||
              level.contains('kurang cocok') ||
              level.contains('tidak cocok') ||
              level == 'low' ||
              level == 'rendah') {
            priority = 'low';
          } else if (level.contains('recommended') ||
              level.contains('cocok') ||
              level == 'medium' ||
              level == 'sedang') {
            priority = 'medium';
          }
        }
      }

      final category = plantMap != null
          ? _stringOrNull(plantMap['category'])
          : null;
      final description =
          detail ??
          (category != null
              ? 'Tanaman $plantName memiliki tingkat kesesuaian "$category" berdasarkan hasil analisis parameter tanah.'
              : 'Tanaman $plantName direkomendasikan berdasarkan rata-rata sensor site selama 7 hari terakhir.');

      result.add(
        RecommendationModel(
          recommendationId: _generatedId('plant', siteId, createdAt, plantName),
          type: 'planting',
          title: plantName,
          description: description,
          priority: priority,
          plantName: plantName,
          siteId: siteId,
          actionItems: const [],
          createdAt: createdAt,
          confidenceScore: itemConfidence,
          reason: description,
        ),
      );
    }
    return result;
  }

  bool _looksLikePlantCandidate(Map<String, dynamic> data) {
    return _stringOrNull(
          data['name'] ??
              data['plant'] ??
              data['plant_name'] ??
              data['label'] ??
              data['crop'] ??
              data['crop_name'] ??
              data['class'] ??
              data['class_name'] ??
              data['predicted_class'] ??
              data['prediction'] ??
              data['recommended_plant'],
        ) !=
        null;
  }

  List<Map<String, dynamic>> _plantCandidatesFromScoreMap(
    Map<String, dynamic> rawPlantMap,
  ) {
    const nonPlantKeys = {
      'details',
      'sensor_data',
      'sensordata',
      'metadata',
      'meta',
      'message',
      'status',
      'cached',
      'cached_at',
      'created_at',
      'createdat',
      'success',
      'total_recommendations',
      'total_recommendation',
      'total',
      'count',
      'size',
      'top_recommendation',
      'top_recommendations',
      'toprecommendation',
      'toprecommendations',
      'input_data',
      'inputdata',
      'recommendations',
      'recommendation',
      'recommended',
      'recommended_plants',
      'recommendedPlants',
      'recommended_plant',
      'recommendedPlant',
      'plant_recommendations',
      'plantRecommendations',
      'plant_names',
      'plantNames',
      'plants',
      'crops',
      'crop_recommendations',
      'cropRecommendations',
      'results',
      'result',
      'predictions',
      'prediction',
      'output',
      'outputs',
      'data',
      'error',
      'errors',
      'code',
    };
    final result = <Map<String, dynamic>>[];
    for (final entry in rawPlantMap.entries) {
      final key = entry.key.trim();
      if (key.isEmpty || nonPlantKeys.contains(key.toLowerCase())) continue;
      final value = entry.value;
      final valueMap = _asStringMap(value);
      if (valueMap != null) {
        final hasPlantDetail =
            valueMap.containsKey('confidence') ||
            valueMap.containsKey('score') ||
            valueMap.containsKey('probability') ||
            valueMap.containsKey('prob') ||
            valueMap.containsKey('confidence_score') ||
            valueMap.containsKey('confidence_text') ||
            _plantDetailText(valueMap) != null;
        if (hasPlantDetail) result.add({'plant': key, ...valueMap});
        continue;
      }
      if (value is num || value is String) {
        final numericValue = value is num
            ? value
            : num.tryParse(value.toString().replaceAll(',', '.'));
        if (numericValue != null) {
          result.add({'plant': key, 'confidence': numericValue});
        }
      }
    }
    return result;
  }

  String? _plantDetailText(dynamic raw) {
    final map = _asStringMap(raw);
    if (map != null) {
      return _stringOrNull(
        map['description'] ??
            map['message'] ??
            map['reason'] ??
            map['detail'] ??
            map['recommendation'] ??
            map['summary'],
      );
    }
    return _stringOrNull(raw);
  }

  bool _isNonPlantRecommendationText(String text) {
    final normalized = text.toLowerCase();
    return normalized == 'null' ||
        normalized.contains('no sensor') ||
        normalized.contains('no data') ||
        normalized.contains('not found') ||
        normalized.contains('tidak ada') ||
        normalized.contains('belum ada') ||
        normalized.contains('error retrieving') ||
        normalized.contains('failed to') ||
        normalized.contains('gagal');
  }

  List<RecommendationModel> _parsePartialRecommendationError(
    DioException exception,
    String siteId,
  ) {
    if (exception.response?.statusCode != 400) return const [];
    final body = exception.response?.data;
    if (body is! Map) return const [];
    try {
      final data = ResponseParser.extractDataMap(
        Map<String, dynamic>.from(body),
      );
      return _parseRecommendationResponse(data, siteId);
    } catch (_) {
      return const [];
    }
  }

  RecommendationSensorDataModel? _parseSensorData(dynamic raw) {
    final data = _asStringMap(raw);
    if (data == null || data.isEmpty) return null;
    return RecommendationSensorDataModel(
      nitrogen: _nullableNum(data['nitrogen']),
      phosphorus: _nullableNum(data['phosphorus']),
      potassium: _nullableNum(data['potassium']),
      ph: _nullableNum(data['ph']),
      envTemp: _nullableNum(
        data['env_temp'] ?? data['envTemp'] ?? data['temperature'],
      ),
      envHum: _nullableNum(
        data['env_hum'] ?? data['envHum'] ?? data['humidity'],
      ),
      soilTemp: _nullableNum(data['soil_temp'] ?? data['soilTemp']),
      soilHum: _nullableNum(data['soil_hum'] ?? data['soilHum']),
    );
  }

  RecommendationModel _parseDirectRecommendationItem(
    Map<String, dynamic> json,
    String siteId,
  ) {
    final createdAt = _parseDate(
      json['created_at'] ??
          json['createdAt'] ??
          json['date'] ??
          json['rec_date'],
    );
    final title =
        _stringOrNull(json['title'] ?? json['name']) ??
        'Rekomendasi ${_stringOrNull(json['date'] ?? json['rec_date']) ?? ''}'
            .trim();
    final description =
        _stringOrNull(
          json['description'] ?? json['pesan'] ?? json['message'],
        ) ??
        'Data rekomendasi tersedia.';

    return RecommendationModel(
      recommendationId:
          _stringOrNull(
            json['recommendation_id'] ?? json['rec_id'] ?? json['id'],
          ) ??
          _generatedId(
            'recommendation',
            siteId,
            createdAt ?? DateTime.now(),
            null,
          ),
      type: _mapRecommendationType(
        _stringOrNull(json['type'] ?? json['category']) ?? 'general',
      ),
      title: title.isEmpty ? 'Rekomendasi' : title,
      description: description,
      priority: _mapNpkPriority(
        _stringOrNull(json['priority'] ?? json['status'] ?? json['level']),
      ),
      plantId: _stringOrNull(json['plant_id'] ?? json['plantId']),
      plantName: _stringOrNull(json['plant_name'] ?? json['plantName']),
      siteId: _stringOrNull(json['site_id'] ?? json['siteId']) ?? siteId,
      siteName: _stringOrNull(json['site_name'] ?? json['siteName']),
      actionItems: _buildActionItems(json, fallback: description),
      createdAt: createdAt,
      confidenceScore: _toConfidence(
        json['confidence_score'] ?? json['confidence'],
      ),
      reason: _stringOrNull(json['reason']),
    );
  }

  bool _looksLikeDirectRecommendation(Map<String, dynamic> json) {
    return json.containsKey('title') ||
        json.containsKey('description') ||
        json.containsKey('rec_id') ||
        json.containsKey('recommendation_id');
  }

  Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  dynamic _parseJsonRecommendation(dynamic value) {
    if (value == null) return null;
    final map = _asStringMap(value);
    if (map != null) return map;
    if (value is! String) return value;
    final text = value.trim();
    if (text.isEmpty) return null;
    try {
      final decoded = jsonDecode(text);
      final decodedMap = _asStringMap(decoded);
      if (decodedMap != null) return decodedMap;
      if (decoded is String) return _stringOrNull(decoded);
      return decoded;
    } catch (e) {
      _debugLog('Failed to parse recommendation JSON string: $e');
      return text;
    }
  }

  String? _stringOrNull(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  DateTime? _parseDate(dynamic value) {
    final text = _stringOrNull(value);
    if (text == null) return null;
    return DateTime.tryParse(text);
  }

  double? _toConfidence(dynamic value) {
    if (value == null) return null;
    final raw = value is num
        ? value.toDouble()
        : double.tryParse(
            value.toString().trim().replaceAll('%', '').replaceAll(',', '.'),
          );
    if (raw == null) return null;
    final normalized = raw > 1 ? raw / 100 : raw;
    return normalized.clamp(0.0, 1.0).toDouble();
  }

  num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString().replaceAll(',', '.') ?? '') ?? 0;
  }

  num? _nullableNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString().replaceAll(',', '.'));
  }

  num _doseValue(Map<String, dynamic> item) {
    return _toNum(
      item['dosis_kg_ha'] ??
          item['dosisKgHa'] ??
          item['dose_kg_ha'] ??
          item['doseKgHa'] ??
          item['dosis_kg_per_ha'] ??
          item['dosage_kg_ha'] ??
          item['recommended_dose'] ??
          item['recommendation_dose'] ??
          item['dose'] ??
          item['dosis'],
    );
  }

  String _formatNumber(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  }

  String? _messageFromMap(Map<String, dynamic> item) {
    return _stringOrNull(
      item['pesan'] ??
          item['message'] ??
          item['description'] ??
          item['recommendation'] ??
          item['action'],
    );
  }

  String _titleFromMap(
    Map<String, dynamic> item,
    String typeStr,
    String fallback,
  ) {
    final explicit = _stringOrNull(item['title'] ?? item['name']);
    if (explicit != null) return explicit;
    if (typeStr == 'npk') return _buildNpkTitle(item);
    if (typeStr == 'ph') return _buildPhTitle(item);
    if (fallback.startsWith('Suhu') ||
        fallback.startsWith('Kelembaban') ||
        fallback.contains('Rekomendasi')) {
      final status = item['status'] as String?;
      if (status != null) {
        return '$fallback (${status.toUpperCase()})';
      }
      return fallback;
    }
    final message = _messageFromMap(item);
    return message ?? fallback;
  }

  RecommendationActionResultModel _actionModel(Map<String, dynamic> item) {
    return RecommendationActionResultModel(
      status: _stringOrNull(item['status'] ?? item['priority']) ?? 'normal',
      pesan: _messageFromMap(item) ?? 'Tidak ada tindakan khusus.',
      dosisKgHa: _doseValue(item),
    );
  }

  List<String> _buildActionItems(
    Map<String, dynamic> item, {
    required String fallback,
  }) {
    final actionItems = item['action_items'] ?? item['actions'];
    if (actionItems is List) {
      final list = actionItems
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (list.isNotEmpty) return list;
    }

    final items = <String>[];
    final dose = _doseValue(item);
    if (dose > 0) items.add('Dosis: ${_formatNumber(dose)} kg/ha');
    final message = _messageFromMap(item);
    if (message != null) items.add(message);
    return items.isEmpty ? [fallback] : items;
  }

  String _mapRecommendationType(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('npk') ||
        normalized.contains('nitrogen') ||
        normalized.contains('phos') ||
        normalized.contains('pot') ||
        normalized.contains('pupuk') ||
        normalized.contains('fertil')) {
      return 'npk';
    }
    if (normalized == 'ph' || normalized.contains('soil_ph')) return 'ph';
    if (normalized.contains('water') ||
        normalized.contains('hum') ||
        normalized.contains('siram') ||
        normalized == 'air' ||
        normalized.contains('irigasi')) {
      return 'watering';
    }
    if (normalized.contains('hama') ||
        normalized.contains('pest') ||
        normalized.contains('penyakit') ||
        normalized.contains('gulma') ||
        normalized.contains('weed')) {
      return 'pestControl';
    }
    if (normalized.contains('panen') || normalized.contains('harvest')) {
      return 'harvesting';
    }
    if (normalized.contains('plant')) return 'planting';
    if (normalized.contains('tanam') || normalized.contains('bibit')) {
      return 'planting';
    }
    return 'general';
  }

  String _environmentType(String key) {
    final normalized = key.toLowerCase();
    if (normalized.contains('hum') || normalized.contains('moisture')) {
      return 'watering';
    }
    return 'general';
  }

  String _environmentTitle(String key) {
    final normalized = key.toLowerCase();
    if (normalized.contains('env_temp')) return 'Suhu Lingkungan';
    if (normalized.contains('env_hum')) return 'Kelembaban Lingkungan';
    if (normalized.contains('soil_temp')) return 'Suhu Tanah';
    if (normalized.contains('soil_hum')) return 'Kelembaban Tanah';
    return 'Rekomendasi ${_titleFromKey(key)}';
  }

  String _titleFromKey(String key) {
    return key
        .split(RegExp(r'[_\-\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String _generatedId(
    String key,
    String siteId,
    DateTime createdAt,
    String? seed, {
    String? message,
  }) {
    if (seed?.isNotEmpty == true) {
      final normalizedSeed = seed!.replaceAll(RegExp(r'[^A-Za-z0-9_]+'), '_');
      return '${key}_${siteId}_$normalizedSeed';
    }
    final contentSeed = message != null
        ? _stableHash(message)
        : createdAt.millisecondsSinceEpoch.toString();
    return '${key}_${siteId}_$contentSeed';
  }

  String _stableHash(String value) {
    var hash = 5381;
    for (final codeUnit in value.codeUnits) {
      hash = ((hash << 5) + hash + codeUnit) & 0x7fffffff;
    }
    return hash.toString();
  }

  String _buildNpkTitle(Map<String, dynamic> npk) {
    final status = npk['status'] as String?;
    switch (status?.toLowerCase()) {
      case 'deficient':
      case 'kurang':
      case 'rendah':
        return 'Pemupukan NPK Diperlukan (Nutrisi Rendah)';
      case 'excess':
      case 'berlebih':
      case 'tinggi':
        return 'Kelebihan Nutrisi NPK';
      case 'critical':
      case 'kritis':
      case 'campuran':
        return 'Penyesuaian Nutrisi NPK (Kondisi Kritis)';
      case 'optimal':
      case 'normal':
        return 'Kondisi NPK Normal';
      default:
        return 'Rekomendasi Pemupukan NPK';
    }
  }

  String _buildPhTitle(Map<String, dynamic> ph) {
    final status = ph['status'] as String?;
    switch (status?.toLowerCase()) {
      case 'deficient':
      case 'kurang':
      case 'rendah':
        return 'pH Tanah Rendah (Asam)';
      case 'excess':
      case 'berlebih':
      case 'tinggi':
        return 'pH Tanah Tinggi (Basa)';
      case 'optimal':
      case 'normal':
        return 'Kondisi pH Tanah Normal';
      default:
        return 'Penyesuaian pH Tanah';
    }
  }





  String _mapNpkPriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
      case 'tinggi':
      case 'rendah':
        return 'high';
      case 'critical':
      case 'kritis':
        return 'critical';
      case 'medium':
      case 'sedang':
        return 'medium';
      case 'low':
        return 'low';
      case 'normal':
      case 'optimal':
        return 'low';
      case 'kurang':
      case 'berlebih':
      case 'deficient':
      case 'excess':
        return 'high';
      default:
        return 'medium';
    }
  }

  String _mapTextPriority(String? message) {
    final normalized = message?.toLowerCase() ?? '';
    if (normalized.contains('normal') ||
        normalized.contains('aman') ||
        normalized.contains('tidak diperlukan') ||
        normalized.contains('tidak perlu')) {
      return 'low';
    }
    if (normalized.contains('kritis') ||
        normalized.contains('critical') ||
        normalized.contains('krusial') ||
        normalized.contains('rendah') ||
        normalized.contains('tinggi') ||
        normalized.contains('berlebih') ||
        normalized.contains('kurang')) {
      return 'high';
    }
    return 'medium';
  }

  String _statusFromText(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('rendah') || normalized.contains('kurang')) {
      return 'rendah';
    }
    if (normalized.contains('tinggi') || normalized.contains('berlebih')) {
      return 'tinggi';
    }
    if (normalized.contains('normal') ||
        normalized.contains('aman') ||
        normalized.contains('tidak diperlukan') ||
        normalized.contains('tidak perlu')) {
      return 'normal';
    }
    return 'sedang';
  }

  bool _isFailedLegacyStatus(dynamic status) {
    final normalized = _stringOrNull(status)?.toLowerCase();
    return normalized == 'error' ||
        normalized == 'failed' ||
        normalized == 'fail' ||
        normalized == 'gagal';
  }

  bool _isExpectedEmptyRecommendationError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 400 || status == 404 || status == 422) return true;
    if (status != 500) return false;
    final message = _errorMessage(e.response?.data).toLowerCase();
    return message.contains('no active') ||
        message.contains('no sensor') ||
        message.contains('no data') ||
        message.contains('not found') ||
        message.contains('tidak ada') ||
        message.contains('belum ada');
  }

  bool _isExpectedEmptyPlantRecommendationError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 400 || status == 404 || status == 422) return true;
    if (status != 500) return false;
    final message = _errorMessage(e.response?.data).toLowerCase();
    return message.contains('plant recommendation') ||
        message.contains('recommend-plant') ||
        message.contains('machine learning') ||
        message.contains('no sensor') ||
        message.contains('no data') ||
        message.contains('not found') ||
        message.contains('tidak ada') ||
        message.contains('belum ada');
  }

  String _errorMessage(dynamic data) {
    if (data is Map) {
      return [
        data['message'],
        data['error'],
        data['details'],
      ].whereType<Object>().map((value) => value.toString()).join(' ');
    }
    return data?.toString() ?? '';
  }
}
