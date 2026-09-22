import 'crop_recommendation_model.dart';

/// Immutable historical record of an agronomic crop recommendation.
///
/// Stores the EXACT input parameters sent to the ML model, alongside
/// a snapshot of the farm context at the time of recommendation.
/// This guarantees the recommendation record remains historically accurate
/// even if the farmer subsequently updates their profile details.
class CropHistoryItem {
  final String id;
  final String userId;
  final String recommendedCrop;
  final DateTime createdAt;

  // Farm Context Snapshot
  final String state;
  final String district;
  final String village;
  final String soilType;
  final String irrigationType;
  final double landArea;
  final String landUnit;

  // Exact Model Conditions Used
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double ph;
  final double temperature;
  final double humidity;
  final double rainfall;

  // Metadata
  final String dataSource; // e.g. "Farm Profile + Manual Entry"
  final double? confidence;
  final List<CropAlternative> alternatives;

  const CropHistoryItem({
    required this.id,
    required this.userId,
    required this.recommendedCrop,
    required this.createdAt,
    required this.state,
    required this.district,
    required this.village,
    required this.soilType,
    required this.irrigationType,
    required this.landArea,
    required this.landUnit,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.dataSource,
    this.confidence,
    this.alternatives = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'recommended_crop': recommendedCrop,
      'created_at': createdAt.toIso8601String(),
      'state': state,
      'district': district,
      'village': village,
      'soil_type': soilType,
      'irrigation_type': irrigationType,
      'land_area': landArea,
      'land_unit': landUnit,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'ph': ph,
      'temperature': temperature,
      'humidity': humidity,
      'rainfall': rainfall,
      'data_source': dataSource,
      'confidence': confidence,
      'alternatives': alternatives.map((a) => a.toJson()).toList(),
    };
  }

  factory CropHistoryItem.fromJson(Map<String, dynamic> json) {
    var rawAlt = json['alternatives'];
    List<CropAlternative> alternatives = [];
    if (rawAlt is List) {
      alternatives = rawAlt
          .map((item) => CropAlternative.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return CropHistoryItem(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      recommendedCrop: json['recommended_crop'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      state: json['state'] as String? ?? '',
      district: json['district'] as String? ?? '',
      village: json['village'] as String? ?? '',
      soilType: json['soil_type'] as String? ?? 'Agricultural Soil',
      irrigationType: json['irrigation_type'] as String? ?? 'Rainfed',
      landArea: (json['land_area'] as num?)?.toDouble() ?? 0.0,
      landUnit: json['land_unit'] as String? ?? 'Acres',
      nitrogen: (json['nitrogen'] as num?)?.toDouble() ?? 0.0,
      phosphorus: (json['phosphorus_p'] as num?)?.toDouble() ??
          (json['phosphorus'] as num?)?.toDouble() ??
          0.0,
      potassium: (json['potassium_k'] as num?)?.toDouble() ??
          (json['potassium'] as num?)?.toDouble() ??
          0.0,
      ph: (json['ph'] as num?)?.toDouble() ?? 7.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 25.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 70.0,
      rainfall: (json['rainfall'] as num?)?.toDouble() ?? 100.0,
      dataSource: json['data_source'] as String? ?? 'Farm Profile',
      confidence: (json['confidence'] as num?)?.toDouble(),
      alternatives: alternatives,
    );
  }

  /// Compact summary of soil nutrients used
  String get npkSummary =>
      'N ${nitrogen.toStringAsFixed(0)} · P ${phosphorus.toStringAsFixed(0)} · K ${potassium.toStringAsFixed(0)}';

  /// Compact summary of climate conditions used
  String get climateSummary =>
      '${temperature.toStringAsFixed(0)}°C · ${humidity.toStringAsFixed(0)}% Hum · ${rainfall.toStringAsFixed(0)} mm';

  /// Location summary
  String get locationSummary {
    final parts = [village, district, state].where((s) => s.isNotEmpty).toList();
    return parts.isEmpty ? 'Location not specified' : parts.join(', ');
  }

  /// Land summary
  String get landSummary => '${landArea.toStringAsFixed(1)} $landUnit';
}
