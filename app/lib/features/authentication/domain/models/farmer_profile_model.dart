/// Location details for a farmer's operational region.
class FarmerLocation {
  final String state;
  final String district;
  final String village;
  final String? pincode;
  final double? latitude;
  final double? longitude;

  const FarmerLocation({
    required this.state,
    required this.district,
    required this.village,
    this.pincode,
    this.latitude,
    this.longitude,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  FarmerLocation copyWith({
    String? state,
    String? district,
    String? village,
    String? pincode,
    double? latitude,
    double? longitude,
  }) {
    return FarmerLocation(
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'district': district,
      'village': village,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory FarmerLocation.fromJson(Map<String, dynamic> json) {
    return FarmerLocation(
      state: json['state'] as String? ?? '',
      district: json['district'] as String? ?? '',
      village: json['village'] as String? ?? '',
      pincode: json['pincode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  String get summary {
    final parts = [village, district, state].where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'Location not specified';
    return parts.join(', ');
  }
}


/// Farm land and soil parameters.
class FarmDetails {
  final double landArea;
  final String areaUnit; // 'Acres' or 'Hectares'
  final bool hasSoilReport;
  final String? soilType; // Used when hasSoilReport == false
  final double? nitrogen; // N (kg/ha)
  final double? phosphorus; // P (kg/ha)
  final double? potassium; // K (kg/ha)
  final double? ph; // Soil pH (e.g. 6.5)
  final String irrigationType; // Borewell, Canal, Drip Irrigation, Sprinkler, Rainfed
  final String? primaryCrop;
  final int? farmingExperienceYears;

  const FarmDetails({
    required this.landArea,
    this.areaUnit = 'Acres',
    this.hasSoilReport = false,
    this.soilType,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    this.ph,
    required this.irrigationType,
    this.primaryCrop,
    this.farmingExperienceYears,
  });

  FarmDetails copyWith({
    double? landArea,
    String? areaUnit,
    bool? hasSoilReport,
    String? soilType,
    double? nitrogen,
    double? phosphorus,
    double? potassium,
    double? ph,
    String? irrigationType,
    String? primaryCrop,
    int? farmingExperienceYears,
  }) {
    return FarmDetails(
      landArea: landArea ?? this.landArea,
      areaUnit: areaUnit ?? this.areaUnit,
      hasSoilReport: hasSoilReport ?? this.hasSoilReport,
      soilType: soilType ?? this.soilType,
      nitrogen: nitrogen ?? this.nitrogen,
      phosphorus: phosphorus ?? this.phosphorus,
      potassium: potassium ?? this.potassium,
      ph: ph ?? this.ph,
      irrigationType: irrigationType ?? this.irrigationType,
      primaryCrop: primaryCrop ?? this.primaryCrop,
      farmingExperienceYears:
          farmingExperienceYears ?? this.farmingExperienceYears,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'land_area': landArea,
      'area_unit': areaUnit,
      'has_soil_report': hasSoilReport,
      'soil_type': soilType,
      'nitrogen_n': nitrogen,
      'phosphorus_p': phosphorus,
      'potassium_k': potassium,
      'ph_level': ph,
      'irrigation_type': irrigationType,
      'primary_crop': primaryCrop,
      'farming_experience_years': farmingExperienceYears,
    };
  }

  factory FarmDetails.fromJson(Map<String, dynamic> json) {
    return FarmDetails(
      landArea: (json['land_area'] as num?)?.toDouble() ?? 0.0,
      areaUnit: json['area_unit'] as String? ?? 'Acres',
      hasSoilReport: json['has_soil_report'] as bool? ?? false,
      soilType: json['soil_type'] as String?,
      nitrogen: (json['nitrogen_n'] as num?)?.toDouble() ??
          (json['nitrogen'] as num?)?.toDouble(),
      phosphorus: (json['phosphorus_p'] as num?)?.toDouble() ??
          (json['phosphorus'] as num?)?.toDouble(),
      potassium: (json['potassium_k'] as num?)?.toDouble() ??
          (json['potassium'] as num?)?.toDouble(),
      ph: (json['ph_level'] as num?)?.toDouble() ??
          (json['ph'] as num?)?.toDouble(),
      irrigationType: json['irrigation_type'] as String? ?? 'Rainfed',
      primaryCrop: json['primary_crop'] as String?,
      farmingExperienceYears:
          (json['farming_experience_years'] as num?)?.toInt(),
    );
  }

  /// User-facing soil description.
  String get soilSummary {
    if (hasSoilReport && ph != null) {
      final n = nitrogen != null ? 'N:${nitrogen!.toStringAsFixed(0)} ' : '';
      final p = phosphorus != null ? 'P:${phosphorus!.toStringAsFixed(0)} ' : '';
      final k = potassium != null ? 'K:${potassium!.toStringAsFixed(0)}' : '';
      final npk = '$n$p$k'.trim();
      return 'Tested Soil (pH ${ph!.toStringAsFixed(1)}${npk.isNotEmpty ? ' • $npk' : ''})';
    }
    return soilType ?? 'General Agricultural Soil';
  }

  /// User-facing land area description.
  String get landAreaSummary {
    return '${landArea.toStringAsFixed(1)} $areaUnit';
  }
}

/// Comprehensive Farmer Profile entity linking location and farm details.
class FarmerProfile {
  final String userId;
  final String preferredLanguage;
  final FarmerLocation location;
  final FarmDetails farmDetails;
  final DateTime? updatedAt;

  const FarmerProfile({
    required this.userId,
    this.preferredLanguage = 'en',
    required this.location,
    required this.farmDetails,
    this.updatedAt,
  });

  bool get isComplete =>
      location.district.isNotEmpty &&
      location.state.isNotEmpty &&
      farmDetails.landArea > 0;

  FarmerProfile copyWith({
    String? userId,
    String? preferredLanguage,
    FarmerLocation? location,
    FarmDetails? farmDetails,
    DateTime? updatedAt,
  }) {
    return FarmerProfile(
      userId: userId ?? this.userId,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      location: location ?? this.location,
      farmDetails: farmDetails ?? this.farmDetails,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'preferred_language': preferredLanguage,
      'location': location.toJson(),
      'farm_details': farmDetails.toJson(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FarmerProfile.fromJson(Map<String, dynamic> json) {
    return FarmerProfile(
      userId: json['user_id']?.toString() ?? '',
      preferredLanguage: json['preferred_language'] as String? ?? 'en',
      location: json['location'] != null
          ? FarmerLocation.fromJson(json['location'] as Map<String, dynamic>)
          : FarmerLocation(
              state: json['state'] as String? ?? '',
              district: json['district'] as String? ?? '',
              village: json['village'] as String? ?? '',
              pincode: json['pincode'] as String?,
              latitude: (json['latitude'] as num?)?.toDouble(),
              longitude: (json['longitude'] as num?)?.toDouble(),
            ),

      farmDetails: json['farm_details'] != null
          ? FarmDetails.fromJson(json['farm_details'] as Map<String, dynamic>)
          : FarmDetails.fromJson(json),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}

