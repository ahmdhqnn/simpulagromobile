class PlantRecommendationInput {
  const PlantRecommendationInput({
    required this.soilNitro,
    required this.soilPhos,
    required this.soilPot,
    required this.envTemp,
    required this.envHum,
    required this.soilPh,
  });

  final double soilNitro;
  final double soilPhos;
  final double soilPot;
  final double envTemp;
  final double envHum;
  final double soilPh;
}

class RecommendationLabInput {
  const RecommendationLabInput({
    required this.phase,
    required this.soilNitro,
    required this.soilPhos,
    required this.soilPot,
    required this.envTemp,
    required this.envHum,
    required this.soilTemp,
    required this.soilHum,
    required this.soilPh,
  });

  final String phase;
  final double soilNitro;
  final double soilPhos;
  final double soilPot;
  final double envTemp;
  final double envHum;
  final double soilTemp;
  final double soilHum;
  final double soilPh;
}

class RecommendationPreviewResult {
  const RecommendationPreviewResult(this.data);

  final Map<String, dynamic> data;

  String? get errorMessage {
    final raw = data['error'];
    if (raw == null) return null;
    final text = raw.toString().trim();
    return text.isEmpty ? null : text;
  }
}
