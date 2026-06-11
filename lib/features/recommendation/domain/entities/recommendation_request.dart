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
