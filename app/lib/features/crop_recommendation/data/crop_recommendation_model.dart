/// Data transfer models matching the live deployed ML Crop Recommendation API.
class CropRecommendationInput {
  final double nitrogen; // N
  final double phosphorus; // P
  final double potassium; // K
  final double temperature; // °C
  final double humidity; // %
  final double ph; // 0 - 14
  final double rainfall; // mm

  const CropRecommendationInput({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,
  });

  Map<String, dynamic> toJson() => {
        'N': nitrogen,
        'P': phosphorus,
        'K': potassium,
        'temperature': temperature,
        'humidity': humidity,
        'ph': ph,
        'rainfall': rainfall,
      };
}

class CropAlternative {
  final String crop;
  final double confidence;

  const CropAlternative({
    required this.crop,
    required this.confidence,
  });

  factory CropAlternative.fromJson(Map<String, dynamic> json) {
    return CropAlternative(
      crop: json['crop']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CropRecommendationResult {
  final String recommendedCrop;
  final List<CropAlternative> recommendations;

  const CropRecommendationResult({
    required this.recommendedCrop,
    required this.recommendations,
  });

  factory CropRecommendationResult.fromJson(Map<String, dynamic> json) {
    var rawList = json['recommendations'];
    List<CropAlternative> alternatives = [];
    if (rawList is List) {
      alternatives = rawList
          .map((item) => CropAlternative.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return CropRecommendationResult(
      recommendedCrop: json['recommended_crop']?.toString() ?? '',
      recommendations: alternatives,
    );
  }
}
