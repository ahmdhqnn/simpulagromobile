import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/recommendation_model.dart';

/// Recommendation remote datasource
abstract class RecommendationRemoteDatasource {
  Future<List<RecommendationModel>> getRecommendations();
  Future<List<RecommendationModel>> getRecommendationsBySite(String siteId);
  Future<List<RecommendationModel>> getRecommendationsByPlant(String plantId);
  Future<List<RecommendationModel>> getRecommendationsByType(String type);
  Future<RecommendationModel> getRecommendationById(String recommendationId);
  Future<RecommendationModel> applyRecommendation(String recommendationId);
  Future<RecommendationModel> dismissRecommendation(String recommendationId);
  Future<List<RecommendationModel>> generateRecommendations(String siteId);
}

/// Recommendation remote datasource implementation
class RecommendationRemoteDatasourceImpl
    implements RecommendationRemoteDatasource {
  final Dio _dio;

  RecommendationRemoteDatasourceImpl(this._dio);

  /// GET /api/sites/:siteId/recommendations
  /// Mendapatkan rekomendasi NPK dan pH berdasarkan data sensor terkini
  /// Karena endpoint ini site-scoped, kita perlu siteId.
  /// Untuk getRecommendations() tanpa siteId, kita kembalikan list kosong.
  @override
  Future<List<RecommendationModel>> getRecommendations() async {
    // Endpoint ini memerlukan siteId — gunakan getRecommendationsBySite
    return [];
  }

  /// GET /api/sites/:siteId/recommendations
  @override
  Future<List<RecommendationModel>> getRecommendationsBySite(
    String siteId,
  ) async {
    final response = await _dio.get('/sites/$siteId/recommendations');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return _parseRecommendationResponse(data, siteId);
  }

  /// GET /api/sites/:siteId/recommendations/history
  @override
  Future<List<RecommendationModel>> getRecommendationsByPlant(
    String plantId,
  ) async {
    // API tidak memiliki endpoint per-plant, gunakan history
    final response = await _dio.get('/sites/$plantId/recommendations/history');
    final data = response.data['data'] as List? ?? [];
    return data
        .map((json) => _parseHistoryItem(json as Map<String, dynamic>, plantId))
        .toList();
  }

  @override
  Future<List<RecommendationModel>> getRecommendationsByType(
    String type,
  ) async {
    // Filter dilakukan di client side karena API tidak support filter by type
    return [];
  }

  @override
  Future<RecommendationModel> getRecommendationById(
    String recommendationId,
  ) async {
    // API tidak memiliki endpoint get-by-id untuk rekomendasi
    // Coba ambil dari history dengan parsing rec_id
    // Format recommendationId: "siteId_recId" atau hanya recId
    throw Exception('Endpoint get recommendation by ID tidak tersedia');
  }

  @override
  Future<RecommendationModel> applyRecommendation(
    String recommendationId,
  ) async {
    // API tidak memiliki endpoint apply recommendation
    // Return model yang sama dengan status 'applied'
    throw Exception('Endpoint apply recommendation tidak tersedia di backend');
  }

  @override
  Future<RecommendationModel> dismissRecommendation(
    String recommendationId,
  ) async {
    // API tidak memiliki endpoint dismiss recommendation
    throw Exception(
      'Endpoint dismiss recommendation tidak tersedia di backend',
    );
  }

  /// GET /api/sites/:siteId/recommendations?refresh=true
  @override
  Future<List<RecommendationModel>> generateRecommendations(
    String siteId,
  ) async {
    final response = await _dio.get(
      '/sites/$siteId/recommendations',
      queryParameters: {'refresh': 'true'},
    );
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return _parseRecommendationResponse(data, siteId);
  }

  /// Parse response dari GET /recommendations menjadi list RecommendationModel
  /// Response: { sensor_data: {...}, recommendations: { npk: {...}, ph: {...} }, cached: bool }
  List<RecommendationModel> _parseRecommendationResponse(
    Map<String, dynamic> data,
    String siteId,
  ) {
    final recommendations = data['recommendations'] as Map<String, dynamic>?;
    if (recommendations == null) return [];

    final result = <RecommendationModel>[];
    final now = DateTime.now();

    // Parse NPK recommendation
    final npk = recommendations['npk'] as Map<String, dynamic>?;
    if (npk != null && !npk.containsKey('error')) {
      result.add(
        RecommendationModel(
          recommendationId: 'npk_${siteId}_${now.millisecondsSinceEpoch}',
          type: 'npk',
          title: _buildNpkTitle(npk),
          description: _buildNpkDescription(npk),
          priority: _mapNpkPriority(npk['priority'] as String?),
          status: 'pending',
          siteId: siteId,
          parameters: npk,
          actionItems: _buildNpkActionItems(npk),
          createdAt: now,
          reason: npk['notes'] as String?,
        ),
      );
    }

    // Parse pH recommendation
    final ph = recommendations['ph'] as Map<String, dynamic>?;
    if (ph != null && !ph.containsKey('error')) {
      result.add(
        RecommendationModel(
          recommendationId: 'ph_${siteId}_${now.millisecondsSinceEpoch}',
          type: 'ph',
          title: 'Penyesuaian pH Tanah',
          description:
              ph['recommendation'] as String? ??
              'Lakukan penyesuaian pH tanah sesuai rekomendasi.',
          priority: 'medium',
          status: 'pending',
          siteId: siteId,
          parameters: ph,
          actionItems: _buildPhActionItems(ph),
          createdAt: now,
          reason: ph['notes'] as String?,
        ),
      );
    }

    return result;
  }

  /// Parse item dari history endpoint
  RecommendationModel _parseHistoryItem(
    Map<String, dynamic> json,
    String siteId,
  ) {
    Map<String, dynamic>? parseJsonString(String? jsonStr) {
      if (jsonStr == null) return null;
      try {
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      } catch (_) {
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
      parameters: {
        'nitrogen': json['nitrogen'],
        'phosphorus': json['phosphorus'],
        'potassium': json['potassium'],
        'ph_value': json['ph_value'],
        'npk': npkRec,
        'ph': phRec,
      },
      createdAt: json['rec_created'] != null
          ? DateTime.tryParse(json['rec_created'] as String)
          : null,
    );
  }

  String _buildNpkTitle(Map<String, dynamic> npk) {
    final status = npk['status'] as String?;
    switch (status) {
      case 'deficient':
        return 'Pemupukan NPK Diperlukan';
      case 'excess':
        return 'Kelebihan Nutrisi NPK';
      case 'optimal':
        return 'Kondisi NPK Optimal';
      default:
        return 'Rekomendasi Pemupukan NPK';
    }
  }

  String _buildNpkDescription(Map<String, dynamic> npk) {
    final parts = <String>[];
    if (npk['nitrogen_recommendation'] != null) {
      parts.add('N: ${npk['nitrogen_recommendation']}');
    }
    if (npk['phosphorus_recommendation'] != null) {
      parts.add('P: ${npk['phosphorus_recommendation']}');
    }
    if (npk['potassium_recommendation'] != null) {
      parts.add('K: ${npk['potassium_recommendation']}');
    }
    if (parts.isEmpty && npk['notes'] != null) {
      return npk['notes'] as String;
    }
    return parts.isNotEmpty ? parts.join('\n') : 'Lihat detail rekomendasi.';
  }

  List<String> _buildNpkActionItems(Map<String, dynamic> npk) {
    final items = <String>[];
    if (npk['nitrogen_recommendation'] != null) {
      items.add('Nitrogen: ${npk['nitrogen_recommendation']}');
    }
    if (npk['phosphorus_recommendation'] != null) {
      items.add('Fosfor: ${npk['phosphorus_recommendation']}');
    }
    if (npk['potassium_recommendation'] != null) {
      items.add('Kalium: ${npk['potassium_recommendation']}');
    }
    if (npk['notes'] != null) items.add('Catatan: ${npk['notes']}');
    return items;
  }

  List<String> _buildPhActionItems(Map<String, dynamic> ph) {
    final items = <String>[];
    if (ph['recommendation'] != null) {
      items.add(ph['recommendation'] as String);
    }
    if (ph['target_ph'] != null) {
      items.add('Target pH: ${ph['target_ph']}');
    }
    if (ph['notes'] != null) items.add('Catatan: ${ph['notes']}');
    return items;
  }

  String _mapNpkPriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return 'high';
      case 'medium':
        return 'medium';
      case 'low':
        return 'low';
      default:
        return 'medium';
    }
  }
}
