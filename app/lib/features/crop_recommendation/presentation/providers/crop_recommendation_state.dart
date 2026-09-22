import '../../data/crop_recommendation_model.dart';

enum ProfileLoadStatus {
  initial,
  loading,
  loaded,
  incomplete,
}

enum WeatherLoadStatus {
  initial,
  loading,
  loaded,
  unavailable,
}

enum RecommendationProcessStatus {
  idle,
  loading,
  success,
  error,
}

class CropRecommendationState {
  // Loading & Lifecycle Statuses
  final ProfileLoadStatus profileStatus;
  final WeatherLoadStatus weatherStatus;
  final RecommendationProcessStatus recommendationStatus;

  // Saved Profile Farm Context
  final String userId;
  final String state;
  final String district;
  final String village;
  final double landArea;
  final String areaUnit;
  final String irrigationType;
  final String? profileSoilType;
  final bool hasSoilReport;
  final double? profileNitrogen;
  final double? profilePhosphorus;
  final double? profilePotassium;
  final double? profilePh;

  // Active Recommendation Inputs (Separated from Profile Data)
  final double? nitrogen;
  final double? phosphorus;
  final double? potassium;
  final double? ph;
  final String? soilType;
  final bool isSoilOverridden;

  // Environmental / Dynamic Conditions
  final double? temperature;
  final double? humidity;
  final double? rainfall;
  final String weatherSource; // "Current weather", "Manually entered", "Unavailable"
  final bool isWeatherOverridden;

  // Recommendation Output
  final CropRecommendationResult? result;
  final String? errorMessage;

  const CropRecommendationState({
    this.profileStatus = ProfileLoadStatus.initial,
    this.weatherStatus = WeatherLoadStatus.initial,
    this.recommendationStatus = RecommendationProcessStatus.idle,
    this.userId = '',
    this.state = '',
    this.district = '',
    this.village = '',
    this.landArea = 0.0,
    this.areaUnit = 'Acres',
    this.irrigationType = 'Rainfed',
    this.profileSoilType,
    this.hasSoilReport = false,
    this.profileNitrogen,
    this.profilePhosphorus,
    this.profilePotassium,
    this.profilePh,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    this.ph,
    this.soilType,
    this.isSoilOverridden = false,
    this.temperature,
    this.humidity,
    this.rainfall,
    this.weatherSource = 'Unavailable',
    this.isWeatherOverridden = false,
    this.result,
    this.errorMessage,
  });

  /// True when all 7 required ML agronomic parameters are populated.
  bool get isReadyForRecommendation =>
      nitrogen != null &&
      phosphorus != null &&
      potassium != null &&
      ph != null &&
      temperature != null &&
      humidity != null &&
      rainfall != null;

  /// Whether soil test parameters (N, P, K, pH) are present in the active recommendation inputs.
  bool get hasActiveSoilData =>
      nitrogen != null && phosphorus != null && potassium != null && ph != null;

  /// Whether profile originally had complete soil report.
  bool get isProfileSoilComplete =>
      profileNitrogen != null &&
      profilePhosphorus != null &&
      profilePotassium != null &&
      profilePh != null;

  /// True when weather/environmental parameters are present.
  bool get hasEnvironmentalData =>
      temperature != null && humidity != null && rainfall != null;

  /// Friendly list of missing components if not ready.
  List<String> get missingRequirements {
    final missing = <String>[];
    if (!hasActiveSoilData) {
      missing.add('Soil test values (N, P, K, pH)');
    }
    if (!hasEnvironmentalData) {
      missing.add('Environmental conditions (Temperature, Humidity, Rainfall)');
    }
    return missing;
  }

  CropRecommendationState copyWith({
    ProfileLoadStatus? profileStatus,
    WeatherLoadStatus? weatherStatus,
    RecommendationProcessStatus? recommendationStatus,
    String? userId,
    String? state,
    String? district,
    String? village,
    double? landArea,
    String? areaUnit,
    String? irrigationType,
    String? profileSoilType,
    bool? hasSoilReport,
    double? profileNitrogen,
    double? profilePhosphorus,
    double? profilePotassium,
    double? profilePh,
    double? nitrogen,
    double? phosphorus,
    double? potassium,
    double? ph,
    String? soilType,
    bool? isSoilOverridden,
    double? temperature,
    double? humidity,
    double? rainfall,
    String? weatherSource,
    bool? isWeatherOverridden,
    CropRecommendationResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return CropRecommendationState(
      profileStatus: profileStatus ?? this.profileStatus,
      weatherStatus: weatherStatus ?? this.weatherStatus,
      recommendationStatus: recommendationStatus ?? this.recommendationStatus,
      userId: userId ?? this.userId,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      landArea: landArea ?? this.landArea,
      areaUnit: areaUnit ?? this.areaUnit,
      irrigationType: irrigationType ?? this.irrigationType,
      profileSoilType: profileSoilType ?? this.profileSoilType,
      hasSoilReport: hasSoilReport ?? this.hasSoilReport,
      profileNitrogen: profileNitrogen ?? this.profileNitrogen,
      profilePhosphorus: profilePhosphorus ?? this.profilePhosphorus,
      profilePotassium: profilePotassium ?? this.profilePotassium,
      profilePh: profilePh ?? this.profilePh,
      nitrogen: nitrogen ?? this.nitrogen,
      phosphorus: phosphorus ?? this.phosphorus,
      potassium: potassium ?? this.potassium,
      ph: ph ?? this.ph,
      soilType: soilType ?? this.soilType,
      isSoilOverridden: isSoilOverridden ?? this.isSoilOverridden,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      rainfall: rainfall ?? this.rainfall,
      weatherSource: weatherSource ?? this.weatherSource,
      isWeatherOverridden: isWeatherOverridden ?? this.isWeatherOverridden,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
