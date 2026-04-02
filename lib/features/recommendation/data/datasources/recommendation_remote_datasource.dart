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
  // ignore: unused_field
  final Dio _dio;

  RecommendationRemoteDatasourceImpl(this._dio);

  @override
  Future<List<RecommendationModel>> getRecommendations() async {
    // TODO: Replace with real API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRecommendations;
  }

  @override
  Future<List<RecommendationModel>> getRecommendationsBySite(
    String siteId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRecommendations.where((r) => r.siteId == siteId).toList();
  }

  @override
  Future<List<RecommendationModel>> getRecommendationsByPlant(
    String plantId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRecommendations.where((r) => r.plantId == plantId).toList();
  }

  @override
  Future<List<RecommendationModel>> getRecommendationsByType(
    String type,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRecommendations.where((r) => r.type == type).toList();
  }

  @override
  Future<RecommendationModel> getRecommendationById(
    String recommendationId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockRecommendations.firstWhere(
      (r) => r.recommendationId == recommendationId,
    );
  }

  @override
  Future<RecommendationModel> applyRecommendation(
    String recommendationId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockRecommendations.indexWhere(
      (r) => r.recommendationId == recommendationId,
    );
    if (index != -1) {
      final updated = _mockRecommendations[index].copyWith(
        status: 'applied',
        appliedAt: DateTime.now(),
        appliedBy: 'current_user',
      );
      _mockRecommendations[index] = updated;
      return updated;
    }
    throw Exception('Recommendation not found');
  }

  @override
  Future<RecommendationModel> dismissRecommendation(
    String recommendationId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockRecommendations.indexWhere(
      (r) => r.recommendationId == recommendationId,
    );
    if (index != -1) {
      final updated = _mockRecommendations[index].copyWith(status: 'dismissed');
      _mockRecommendations[index] = updated;
      return updated;
    }
    throw Exception('Recommendation not found');
  }

  @override
  Future<List<RecommendationModel>> generateRecommendations(
    String siteId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Simulate AI/ML recommendation generation
    return _mockRecommendations.where((r) => r.siteId == siteId).toList();
  }
}

// Mock data
final List<RecommendationModel> _mockRecommendations = [
  RecommendationModel(
    recommendationId: 'rec_001',
    type: 'npk',
    title: 'Pemupukan NPK Tahap Vegetatif',
    description:
        'Berdasarkan analisis data sensor, tanaman membutuhkan pemupukan NPK dengan dosis 200kg/ha. Kadar nitrogen dalam tanah saat ini 45 mg/kg, di bawah optimal untuk fase vegetatif (60-80 mg/kg).',
    priority: 'high',
    status: 'pending',
    plantId: 'plant_001',
    plantName: 'Padi IR64',
    siteId: 'site_001',
    siteName: 'Lahan Sawah A',
    parameters: {
      'current_n': 45,
      'optimal_n_min': 60,
      'optimal_n_max': 80,
      'recommended_dose': 200,
      'unit': 'kg/ha',
    },
    actionItems: [
      'Siapkan pupuk NPK 15-15-15 sebanyak 200kg',
      'Aplikasikan pada pagi hari (06:00-09:00)',
      'Pastikan tanah dalam kondisi lembab',
      'Lakukan penyiraman setelah pemupukan',
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    confidenceScore: 0.85,
    reason: 'Kadar nitrogen rendah, fase vegetatif membutuhkan nitrogen tinggi',
  ),
  RecommendationModel(
    recommendationId: 'rec_002',
    type: 'ph',
    title: 'Penyesuaian pH Tanah',
    description:
        'pH tanah saat ini 5.2, di bawah rentang optimal untuk padi (5.5-6.5). Disarankan untuk menambahkan kapur pertanian untuk menaikkan pH.',
    priority: 'medium',
    status: 'pending',
    plantId: 'plant_001',
    plantName: 'Padi IR64',
    siteId: 'site_001',
    siteName: 'Lahan Sawah A',
    parameters: {
      'current_ph': 5.2,
      'optimal_ph_min': 5.5,
      'optimal_ph_max': 6.5,
      'recommended_lime': 150,
      'unit': 'kg/ha',
    },
    actionItems: [
      'Siapkan kapur pertanian (CaCO3) 150kg/ha',
      'Aplikasikan 2 minggu sebelum tanam atau pemupukan',
      'Ratakan secara merata',
      'Lakukan pengolahan tanah setelah aplikasi',
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    confidenceScore: 0.78,
    reason: 'pH tanah asam dapat menghambat penyerapan nutrisi',
  ),
  RecommendationModel(
    recommendationId: 'rec_003',
    type: 'watering',
    title: 'Penyiraman Tambahan Diperlukan',
    description:
        'Kelembaban tanah 45%, di bawah optimal (60-70%). Suhu udara tinggi (32°C) meningkatkan evapotranspirasi. Disarankan penyiraman tambahan.',
    priority: 'high',
    status: 'pending',
    plantId: 'plant_002',
    plantName: 'Jagung Hibrida',
    siteId: 'site_002',
    siteName: 'Lahan Jagung B',
    parameters: {
      'current_moisture': 45,
      'optimal_moisture_min': 60,
      'optimal_moisture_max': 70,
      'temperature': 32,
      'etc': 5.2,
    },
    actionItems: [
      'Lakukan penyiraman 20-25mm',
      'Waktu optimal: pagi (06:00-08:00) atau sore (16:00-18:00)',
      'Pastikan distribusi air merata',
      'Monitor kelembaban setelah 24 jam',
    ],
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    confidenceScore: 0.92,
    reason: 'Kelembaban rendah + suhu tinggi = stress air pada tanaman',
  ),
  RecommendationModel(
    recommendationId: 'rec_004',
    type: 'pestControl',
    title: 'Pengendalian Hama Preventif',
    description:
        'Kondisi lingkungan (suhu 28°C, kelembaban 80%) kondusif untuk perkembangan hama. Disarankan aplikasi pestisida organik sebagai tindakan preventif.',
    priority: 'medium',
    status: 'pending',
    plantId: 'plant_001',
    plantName: 'Padi IR64',
    siteId: 'site_001',
    siteName: 'Lahan Sawah A',
    parameters: {'temperature': 28, 'humidity': 80, 'risk_level': 'medium'},
    actionItems: [
      'Gunakan pestisida organik (neem oil atau ekstrak bawang putih)',
      'Aplikasi pada sore hari',
      'Lakukan monitoring rutin setiap 3 hari',
      'Catat jenis dan jumlah hama yang ditemukan',
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    confidenceScore: 0.65,
    reason: 'Kondisi lingkungan mendukung perkembangan hama',
  ),
  RecommendationModel(
    recommendationId: 'rec_005',
    type: 'harvesting',
    title: 'Persiapan Panen',
    description:
        'Tanaman telah mencapai HST 110 hari, mendekati masa panen optimal (115-120 hari). Mulai persiapan panen dalam 5-10 hari.',
    priority: 'low',
    status: 'pending',
    plantId: 'plant_003',
    plantName: 'Kedelai Grobogan',
    siteId: 'site_003',
    siteName: 'Lahan Kedelai C',
    parameters: {
      'current_hst': 110,
      'optimal_harvest_min': 115,
      'optimal_harvest_max': 120,
      'days_remaining': 5,
    },
    actionItems: [
      'Hentikan penyiraman 7 hari sebelum panen',
      'Siapkan alat panen dan tempat penjemuran',
      'Cek kadar air biji (optimal 14-16%)',
      'Rencanakan waktu panen pada cuaca cerah',
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    confidenceScore: 0.88,
    reason: 'HST mendekati masa panen optimal',
  ),
  RecommendationModel(
    recommendationId: 'rec_006',
    type: 'npk',
    title: 'Pemupukan Fosfor Fase Generatif',
    description:
        'Tanaman memasuki fase generatif. Kadar fosfor 12 mg/kg, perlu ditingkatkan untuk pembentukan bunga dan buah optimal (20-30 mg/kg).',
    priority: 'high',
    status: 'applied',
    plantId: 'plant_002',
    plantName: 'Jagung Hibrida',
    siteId: 'site_002',
    siteName: 'Lahan Jagung B',
    parameters: {
      'current_p': 12,
      'optimal_p_min': 20,
      'optimal_p_max': 30,
      'recommended_dose': 100,
      'unit': 'kg/ha',
    },
    actionItems: [
      'Gunakan pupuk SP-36 100kg/ha',
      'Aplikasi dengan cara tugal di sekitar tanaman',
      'Jarak aplikasi 10cm dari batang',
      'Tutup kembali dengan tanah',
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    appliedAt: DateTime.now().subtract(const Duration(days: 2)),
    appliedBy: 'Budi Santoso',
    confidenceScore: 0.82,
    reason:
        'Fase generatif membutuhkan fosfor tinggi untuk pembentukan tongkol',
  ),
];
