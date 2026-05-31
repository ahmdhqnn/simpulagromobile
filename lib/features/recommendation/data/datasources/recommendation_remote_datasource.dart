import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
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
  Future<List<RecommendationModel>> getRecommendations();
  Future<List<RecommendationModel>> getRecommendationsBySite(String siteId);
  Future<List<RecommendationModel>> getRecommendationsByPlant(
    String siteId,
    String plantId,
  );
  Future<List<RecommendationModel>> getRecommendationsByType(String type);
  Future<RecommendationModel> getRecommendationById(String recommendationId);
  Future<RecommendationModel> applyRecommendation(String recommendationId);
  Future<RecommendationModel> dismissRecommendation(String recommendationId);
  Future<List<RecommendationModel>> generateRecommendations(String siteId);
  Future<List<RecommendationModel>> getRecommendationHistory(String siteId);
  Future<List<RecommendationModel>> getRecommendationsByPhase(
    String siteId,
    String phaseId,
  );
  Future<List<RecommendationModel>> postPlantRecommendation(
    String siteId,
    Map<String, dynamic> payload,
  );
  Future<Map<String, dynamic>> previewDummyRecommendation(
    String siteId,
    Map<String, dynamic> payload,
  );
  Future<Map<String, dynamic>> saveDummyRecommendation(
    String siteId,
    Map<String, dynamic> payload,
  );
}

/// Recommendation remote datasource implementation
class RecommendationRemoteDatasourceImpl
    implements RecommendationRemoteDatasource {
  final Dio _dio;

  /// Feature flag untuk endpoint yang belum diimplementasi di backend
  /// Set ke true ketika endpoint tersedia
  static const _supportsGetById = false;
  static const _supportsApply = false;
  static const _supportsDismiss = false;

  RecommendationRemoteDatasourceImpl(this._dio);

  /// GET /api/sites/:siteId/recommendations
  /// Mendapatkan rekomendasi NPK dan pH berdasarkan data sensor terkini
  /// Karena endpoint ini site-scoped, kita perlu siteId.
  /// Untuk getRecommendations() tanpa siteId, kita kembalikan list kosong.
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  @override
  Future<List<RecommendationModel>> getRecommendations() async {
    // Endpoint ini memerlukan siteId — gunakan getRecommendationsBySite
    // TODO: Implement global recommendations endpoint jika backend menyediakannya
    return [];
  }

  /// GET /api/sites/:siteId/recommendations
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  @override
  Future<List<RecommendationModel>> getRecommendationsBySite(
    String siteId,
  ) async {
    try {
      final response = await _dio.get(ApiEndpoints.recommendations(siteId));
      final data = ResponseParser.extractDataMap(response.data);
      return _parseRecommendationResponse(data, siteId);
    } on DioException catch (e) {
      if (_isExpectedEmptyRecommendationError(e)) {
        _debugLog(
          '⚠️ Recommendation datasource (getBySite) returned ${e.response?.statusCode}: Returning empty list',
        );
        return [];
      }
      _debugLog('❌ Recommendation datasource error (getBySite): ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog(
        '❌ Unexpected error in recommendation datasource (getBySite): $e',
      );
      rethrow;
    }
  }

  /// GET /api/sites/:siteId/recommendations/history
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  @override
  Future<List<RecommendationModel>> getRecommendationsByPlant(
    String siteId,
    String plantId,
  ) async {
    try {
      // API tidak memiliki endpoint per-plant, gunakan history
      final response = await _dio.get(ApiEndpoints.recHistory(siteId));
      final data = ResponseParser.extractDataList(response.data);
      return data
          .whereType<Map>()
          .expand((json) => _parseHistoryEntry(json, siteId))
          .toList();
    } on DioException catch (e) {
      if (_isExpectedEmptyRecommendationError(e)) return [];
      _debugLog('❌ Recommendation datasource error (getByPlant): ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog(
        '❌ Unexpected error in recommendation datasource (getByPlant): $e',
      );
      rethrow;
    }
  }

  /// Mendapatkan rekomendasi berdasarkan type (client-side filtering)
  /// API tidak support filter by type
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  @override
  Future<List<RecommendationModel>> getRecommendationsByType(
    String type,
  ) async {
    // Filter dilakukan di client side karena API tidak support filter by type
    // TODO: Coordinate with backend to implement server-side filtering
    return [];
  }

  /// Mendapatkan rekomendasi berdasarkan ID
  /// ⚠️ Endpoint belum diimplementasi di backend
  /// Feature flag: [_supportsGetById]
  ///
  /// Throws: [ServerFailure] (not supported), atau [NetworkFailure], [UnknownFailure]
  @override
  Future<RecommendationModel> getRecommendationById(
    String recommendationId,
  ) async {
    if (!_supportsGetById) {
      throw const ServerFailure(
        'Endpoint "get recommendation by ID" belum diimplementasi di backend. '
        'Gunakan getRecommendationsBySite() lalu filter di client-side.',
      );
    }

    try {
      // TODO: Update path ketika backend mengimplementasikan endpoint
      final response = await _dio.get('/recommendations/$recommendationId');
      final data = response.data['data'] as Map<String, dynamic>?;

      if (data == null) {
        throw const NotFoundFailure('Recommendation not found');
      }

      return RecommendationModel.fromJson(data);
    } on DioException catch (e) {
      _debugLog('❌ Recommendation datasource error (getById): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _debugLog(
        '❌ Unexpected error in recommendation datasource (getById): $e',
      );
      rethrow;
    }
  }

  /// Menerapkan rekomendasi
  /// ⚠️ Endpoint belum diimplementasi di backend
  /// Feature flag: [_supportsApply]
  ///
  /// Throws: [ServerFailure] (not supported), atau [NetworkFailure], [UnknownFailure]
  @override
  Future<RecommendationModel> applyRecommendation(
    String recommendationId,
  ) async {
    if (!_supportsApply) {
      throw const ServerFailure(
        'Endpoint "apply recommendation" belum diimplementasi di backend. '
        'Hubungi backend team untuk koordinasi implementasi.',
      );
    }

    try {
      // TODO: Update path dan method ketika backend mengimplementasikan endpoint
      final response = await _dio.post(
        '/recommendations/$recommendationId/apply',
      );
      final data = response.data['data'] as Map<String, dynamic>?;

      if (data == null) {
        throw const ServerFailure('No data returned from apply recommendation');
      }

      return RecommendationModel.fromJson(data);
    } on DioException catch (e) {
      _debugLog('❌ Recommendation datasource error (apply): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _debugLog('❌ Unexpected error in recommendation datasource (apply): $e');
      rethrow;
    }
  }

  /// Menolak/membatalkan rekomendasi
  /// ⚠️ Endpoint belum diimplementasi di backend
  /// Feature flag: [_supportsDismiss]
  ///
  /// Throws: [ServerFailure] (not supported), atau [NetworkFailure], [UnknownFailure]
  @override
  Future<RecommendationModel> dismissRecommendation(
    String recommendationId,
  ) async {
    if (!_supportsDismiss) {
      throw const ServerFailure(
        'Endpoint "dismiss recommendation" belum diimplementasi di backend. '
        'Hubungi backend team untuk koordinasi implementasi.',
      );
    }

    try {
      // TODO: Update path dan method ketika backend mengimplementasikan endpoint
      final response = await _dio.post(
        '/recommendations/$recommendationId/dismiss',
      );
      final data = response.data['data'] as Map<String, dynamic>?;

      if (data == null) {
        throw const ServerFailure(
          'No data returned from dismiss recommendation',
        );
      }

      return RecommendationModel.fromJson(data);
    } on DioException catch (e) {
      _debugLog('❌ Recommendation datasource error (dismiss): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      _debugLog(
        '❌ Unexpected error in recommendation datasource (dismiss): $e',
      );
      rethrow;
    }
  }

  /// GET /api/sites/:siteId/recommendations?refresh=true
  /// Menghasilkan/refresh rekomendasi terbaru
  ///
  /// Throws: [ServerFailure], [NetworkFailure], [UnknownFailure]
  @override
  Future<List<RecommendationModel>> generateRecommendations(
    String siteId,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.recommendations(siteId),
        queryParameters: {'refresh': 'true'},
      );
      final data = ResponseParser.extractDataMap(response.data);
      return _parseRecommendationResponse(data, siteId);
    } on DioException catch (e) {
      if (_isExpectedEmptyRecommendationError(e)) return [];
      _debugLog('❌ Recommendation datasource error (generate): ${e.message}');
      rethrow;
    } catch (e) {
      _debugLog(
        '❌ Unexpected error in recommendation datasource (generate): $e',
      );
      rethrow;
    }
  }

  @override
  Future<List<RecommendationModel>> getRecommendationHistory(
    String siteId,
  ) async {
    try {
      final response = await _dio.get(ApiEndpoints.recHistory(siteId));
      final data = ResponseParser.extractDataList(response.data);
      return data
          .whereType<Map>()
          .expand((json) => _parseHistoryEntry(json, siteId))
          .toList();
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
    final rows = ResponseParser.extractDataList(response.data);
    if (rows.isNotEmpty) {
      return rows
          .whereType<Map>()
          .expand((e) => _parseHistoryEntry(e, siteId))
          .toList();
    }
    final data = ResponseParser.extractDataMap(response.data);
    return _parseRecommendationResponse(data, siteId);
  }

  @override
  Future<Map<String, dynamic>> previewDummyRecommendation(
    String siteId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.recPreviewDummy(siteId),
      data: payload,
    );
    final data = response.data['data'];
    if (data is Map<String, dynamic>) return data;
    return response.data as Map<String, dynamic>? ?? {};
  }

  @override
  Future<Map<String, dynamic>> saveDummyRecommendation(
    String siteId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.recSaveDummy(siteId),
      data: payload,
    );
    final data = response.data['data'];
    if (data is Map<String, dynamic>) return data;
    return response.data as Map<String, dynamic>? ?? {};
  }

  /// Parse response dari GET /recommendations menjadi list RecommendationModel
  /// Response: { sensor_data: {...}, recommendations: { npk: {...}, ph: {...} }, cached: bool }
  ///
  /// ⚠️ Catatan: ID dihasilkan dengan timestamp karena backend tidak mengembalikan ID
  /// TODO: Minta backend untuk menambahkan ID field di response
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
    final timestamp = createdAt ?? DateTime.now();

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
      json['created_at'] ??
          json['rec_created'] ??
          json['date'] ??
          json['rec_date'],
    );
    final idSeed = _stringOrNull(json['rec_id'] ?? json['date']);

    final liveBundle = _asStringMap(json['recommendations']);
    if (liveBundle != null && liveBundle.isNotEmpty) {
      return _parseRecommendationResponse(
        json,
        siteId,
        createdAt: createdAt,
        idSeed: idSeed,
      );
    }

    final npkRec = _parseJsonMap(json['npk_recommendation']);
    final phRec = _parseJsonMap(json['ph_recommendation']);
    if (npkRec != null || phRec != null) {
      return _parseRecommendationResponse(
        {
          'recommendations': {
            if (npkRec != null) 'npk': npkRec,
            if (phRec != null) 'ph': phRec,
          },
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

  RecommendationModel? _buildRecommendationFromRaw({
    required dynamic raw,
    required String key,
    required String typeStr,
    required String defaultTitle,
    required String siteId,
    required DateTime createdAt,
    String? idSeed,
  }) {
    if (raw == null) return null;

    final itemMap = _asStringMap(raw);
    if (itemMap != null && itemMap.isEmpty) return null;
    if (itemMap != null &&
        itemMap.containsKey('error') &&
        !_hasDisplayableMessage(itemMap)) {
      return null;
    }

    final rawText = raw is String ? raw.trim() : null;
    if (itemMap == null && (rawText == null || rawText.isEmpty)) {
      return null;
    }

    final title = itemMap == null
        ? defaultTitle
        : _titleFromMap(itemMap, typeStr, defaultTitle);
    final description =
        (itemMap == null ? rawText : _messageFromMap(itemMap)) ??
        'Rekomendasi tersedia berdasarkan data sensor terbaru.';
    final priority = itemMap == null
        ? 'medium'
        : _mapNpkPriority(
            _stringOrNull(
              itemMap['priority'] ?? itemMap['status'] ?? itemMap['level'],
            ),
          );
    final actionModel = itemMap == null ? null : _actionModel(itemMap);

    return RecommendationModel(
      recommendationId: _generatedId(key, siteId, createdAt, idSeed),
      type: typeStr,
      title: title,
      description: description,
      priority: priority,
      status: 'pending',
      siteId: siteId,
      parameters: RecommendationBundleModel(
        npk: typeStr == 'npk' ? actionModel : null,
        ph: typeStr == 'ph' ? actionModel : null,
      ),
      actionItems: itemMap == null
          ? [description]
          : _buildActionItems(itemMap, fallback: description),
      createdAt: createdAt,
      confidenceScore: itemMap == null
          ? null
          : _toConfidence(itemMap['confidence'] ?? itemMap['confidence_score']),
      reason: description,
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
      status: _mapRecommendationStatus(
        _stringOrNull(json['recommendation_status'] ?? json['status']),
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

  /// Parse item dari history endpoint
  // ignore: unused_element
  RecommendationModel _parseHistoryItem(
    Map<String, dynamic> json,
    String siteId,
  ) {
    Map<String, dynamic>? parseJsonString(String? jsonStr) {
      if (jsonStr == null) return null;
      try {
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      } catch (e) {
        _debugLog('⚠️ Failed to parse JSON string: $e');
        return null;
      }
    }

    final npkRec = parseJsonString(json['npk_recommendation'] as String?);
    final phRec = parseJsonString(json['ph_recommendation'] as String?);

    return RecommendationModel(
      recommendationId: (json['rec_id'] as String?) ?? '',
      type: 'npk',
      title: 'Rekomendasi ${json['rec_date'] ?? ''}',
      description: npkRec != null
          ? _buildNpkDescription(npkRec)
          : 'Data rekomendasi tersedia',
      priority: npkRec != null
          ? _mapNpkPriority(npkRec['priority'] as String?)
          : 'medium',
      status: json['npk_status'] == 'success' ? 'applied' : 'pending',
      siteId: siteId,
      parameters: RecommendationBundleModel(
        npk: npkRec != null
            ? RecommendationActionResultModel.fromJson(npkRec)
            : null,
        ph: phRec != null
            ? RecommendationActionResultModel.fromJson(phRec)
            : null,
      ),
      createdAt: json['rec_created'] != null
          ? DateTime.tryParse(json['rec_created'] as String)
          : null,
    );
  }

  Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  Map<String, dynamic>? _parseJsonMap(dynamic value) {
    if (value == null) return null;
    final map = _asStringMap(value);
    if (map != null) return map;
    if (value is! String || value.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(value);
      return _asStringMap(decoded);
    } catch (e) {
      _debugLog('Failed to parse recommendation JSON string: $e');
      return null;
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
        : double.tryParse(value.toString().replaceAll(',', '.'));
    if (raw == null) return null;
    return raw > 1 ? raw / 100 : raw;
  }

  num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString().replaceAll(',', '.') ?? '') ?? 0;
  }

  bool _hasDisplayableMessage(Map<String, dynamic> item) {
    return _messageFromMap(item) != null ||
        _stringOrNull(item['title'] ?? item['description']) != null;
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
    final message = _messageFromMap(item);
    return message ?? fallback;
  }

  RecommendationActionResultModel _actionModel(Map<String, dynamic> item) {
    return RecommendationActionResultModel(
      status: _stringOrNull(item['status'] ?? item['priority']) ?? 'normal',
      pesan: _messageFromMap(item) ?? 'Tidak ada tindakan khusus.',
      dosisKgHa: _toNum(
        item['dosis_kg_ha'] ??
            item['dose_kg_ha'] ??
            item['dose'] ??
            item['dosis'],
      ),
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
    final dose = _toNum(
      item['dosis_kg_ha'] ??
          item['dose_kg_ha'] ??
          item['dose'] ??
          item['dosis'],
    );
    if (dose > 0) items.add('Dosis: $dose kg/ha');
    final message = _messageFromMap(item);
    if (message != null) items.add(message);
    return items.isEmpty ? [fallback] : items;
  }

  String _mapRecommendationType(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('npk') ||
        normalized.contains('nitrogen') ||
        normalized.contains('phos') ||
        normalized.contains('pot')) {
      return 'npk';
    }
    if (normalized == 'ph' || normalized.contains('soil_ph')) return 'ph';
    if (normalized.contains('water') ||
        normalized.contains('hum') ||
        normalized.contains('siram')) {
      return 'watering';
    }
    if (normalized.contains('plant')) return 'planting';
    return 'general';
  }

  String _mapRecommendationStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'applied':
      case 'success':
      case 'done':
        return 'applied';
      case 'dismissed':
      case 'ignored':
        return 'dismissed';
      case 'expired':
        return 'expired';
      default:
        return 'pending';
    }
  }

  String _environmentType(String key) {
    final normalized = key.toLowerCase();
    if (normalized.contains('hum') || normalized.contains('moisture')) {
      return 'watering';
    }
    return 'general';
  }

  String _environmentTitle(String key) {
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
    String? seed,
  ) {
    final normalizedSeed = seed?.replaceAll(RegExp(r'[^A-Za-z0-9_]+'), '_');
    final suffix = normalizedSeed?.isNotEmpty == true
        ? normalizedSeed
        : createdAt.millisecondsSinceEpoch.toString();
    return '${key}_${siteId}_$suffix';
  }

  String _buildNpkTitle(Map<String, dynamic> npk) {
    final status = npk['status'] as String?;
    switch (status) {
      case 'deficient':
      case 'kurang':
        return 'Pemupukan NPK Diperlukan';
      case 'excess':
      case 'berlebih':
        return 'Kelebihan Nutrisi NPK';
      case 'optimal':
      case 'normal':
        return 'Kondisi NPK Normal';
      default:
        return 'Rekomendasi Pemupukan NPK';
    }
  }

  String _buildNpkDescription(Map<String, dynamic> npk) {
    if (npk['pesan'] != null) {
      return npk['pesan'] as String;
    }
    return 'Lihat detail rekomendasi.';
  }

  // ignore: unused_element
  List<String> _buildNpkActionItems(Map<String, dynamic> npk) {
    final items = <String>[];
    if (npk['dosis_kg_ha'] != null && npk['dosis_kg_ha'] > 0) {
      items.add('Dosis: ${npk['dosis_kg_ha']} kg/ha');
    }
    if (npk['pesan'] != null) items.add('Catatan: ${npk['pesan']}');
    return items;
  }

  // ignore: unused_element
  List<String> _buildPhActionItems(Map<String, dynamic> ph) {
    final items = <String>[];
    if (ph['dosis_kg_ha'] != null && ph['dosis_kg_ha'] > 0) {
      items.add('Dosis: ${ph['dosis_kg_ha']} kg/ha');
    }
    if (ph['pesan'] != null) items.add('Catatan: ${ph['pesan']}');
    return items;
  }

  String _mapNpkPriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
      case 'tinggi':
      case 'rendah':
        return 'high';
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
