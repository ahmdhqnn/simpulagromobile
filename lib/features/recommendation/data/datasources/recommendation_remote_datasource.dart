import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
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
      final response = await _dio.get('/sites/$siteId/recommendations');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return _parseRecommendationResponse(data, siteId);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        debugPrint('⚠️ Recommendation datasource (getBySite) returned ${e.response?.statusCode}: Returning empty list');
        return [];
      }
      debugPrint('❌ Recommendation datasource error (getBySite): ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint(
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
    String plantId,
  ) async {
    try {
      // API tidak memiliki endpoint per-plant, gunakan history
      final response = await _dio.get(
        '/sites/$plantId/recommendations/history',
      );
      final data = response.data['data'] as List? ?? [];
      return data
          .map(
            (json) => _parseHistoryItem(json as Map<String, dynamic>, plantId),
          )
          .toList();
    } on DioException catch (e) {
      debugPrint(
        '❌ Recommendation datasource error (getByPlant): ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint(
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
      debugPrint('❌ Recommendation datasource error (getById): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint(
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
      debugPrint('❌ Recommendation datasource error (apply): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error in recommendation datasource (apply): $e');
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
      debugPrint('❌ Recommendation datasource error (dismiss): ${e.message}');
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      debugPrint(
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
        '/sites/$siteId/recommendations',
        queryParameters: {'refresh': 'true'},
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return _parseRecommendationResponse(data, siteId);
    } on DioException catch (e) {
      debugPrint('❌ Recommendation datasource error (generate): ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint(
        '❌ Unexpected error in recommendation datasource (generate): $e',
      );
      rethrow;
    }
  }

  /// Parse response dari GET /recommendations menjadi list RecommendationModel
  /// Response: { sensor_data: {...}, recommendations: { npk: {...}, ph: {...} }, cached: bool }
  ///
  /// ⚠️ Catatan: ID dihasilkan dengan timestamp karena backend tidak mengembalikan ID
  /// TODO: Minta backend untuk menambahkan ID field di response
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
          priority: _mapNpkPriority(npk['status'] as String?),
          status: 'pending',
          siteId: siteId,
          parameters: npk,
          actionItems: _buildNpkActionItems(npk),
          createdAt: now,
          reason: npk['pesan'] as String?,
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
              ph['pesan'] as String? ?? 'Lakukan penyesuaian pH tanah.',
          priority: 'medium',
          status: 'pending',
          siteId: siteId,
          parameters: ph,
          actionItems: _buildPhActionItems(ph),
          createdAt: now,
          reason: ph['pesan'] as String?,
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
      } catch (e) {
        debugPrint('⚠️ Failed to parse JSON string: $e');
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

  List<String> _buildNpkActionItems(Map<String, dynamic> npk) {
    final items = <String>[];
    if (npk['dosis_kg_ha'] != null && npk['dosis_kg_ha'] > 0) {
      items.add('Dosis: ${npk['dosis_kg_ha']} kg/ha');
    }
    if (npk['pesan'] != null) items.add('Catatan: ${npk['pesan']}');
    return items;
  }

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
        return 'high';
      case 'medium':
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
}
