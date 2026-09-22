import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherConditionServiceProvider = Provider<WeatherConditionService>((ref) {
  return WeatherConditionService();
});

class WeatherConditionData {
  final double? temperature;
  final double? humidity;
  final double? rainfall;
  final bool isAvailable;
  final String source; // 'Current weather' or 'Manually entered'
  final String? statusMessage;

  const WeatherConditionData({
    this.temperature,
    this.humidity,
    this.rainfall,
    required this.isAvailable,
    required this.source,
    this.statusMessage,
  });

  bool get isComplete =>
      temperature != null && humidity != null && rainfall != null;

  WeatherConditionData copyWith({
    double? temperature,
    double? humidity,
    double? rainfall,
    bool? isAvailable,
    String? source,
    String? statusMessage,
  }) {
    return WeatherConditionData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      rainfall: rainfall ?? this.rainfall,
      isAvailable: isAvailable ?? this.isAvailable,
      source: source ?? this.source,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}

/// Weather service providing live agromet environmental conditions when available,
/// or cleanly reporting unconfigured/unavailable state without fabricating data.
class WeatherConditionService {
  /// Fetches real-time environmental data for the specified farm location.
  ///
  /// Strictly complies with the agronomist zero-fabrication principle:
  /// When no real live weather provider is configured, returns [isAvailable: false]
  /// so the farmer is prompted to provide accurate local conditions manually.
  Future<WeatherConditionData> fetchCurrentConditions({
    String? district,
    String? state,
  }) async {
    // In current version, live weather backend API is not yet connected.
    // We intentionally return unavailable rather than fabricating mock values.
    return const WeatherConditionData(
      isAvailable: false,
      source: 'Unavailable',
      statusMessage: 'Current weather unavailable',
    );
  }
}
