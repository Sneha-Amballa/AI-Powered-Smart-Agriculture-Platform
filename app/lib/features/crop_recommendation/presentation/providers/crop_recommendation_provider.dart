import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../weather/data/weather_condition_service.dart';
import '../../data/crop_history_model.dart';
import '../../data/crop_history_repository.dart';
import '../../data/crop_recommendation_model.dart';
import '../../data/crop_recommendation_repository.dart';
import 'crop_history_provider.dart';
import 'crop_recommendation_state.dart';

final cropRecommendationNotifierProvider =
    NotifierProvider<CropRecommendationNotifier, CropRecommendationState>(
  CropRecommendationNotifier.new,
);

class CropRecommendationNotifier extends Notifier<CropRecommendationState> {
  late CropRecommendationRepository _repository;
  late WeatherConditionService _weatherService;

  @override
  CropRecommendationState build() {
    _repository = ref.watch(cropRecommendationRepositoryProvider);
    _weatherService = ref.watch(weatherConditionServiceProvider);

    final authState = ref.watch(authNotifierProvider);
    final profile = authState.profile;
    final user = authState.user;

    final initialState = CropRecommendationState(
      profileStatus: profile == null
          ? ProfileLoadStatus.incomplete
          : (profile.isComplete ? ProfileLoadStatus.loaded : ProfileLoadStatus.incomplete),
      weatherStatus: WeatherLoadStatus.initial,
      recommendationStatus: RecommendationProcessStatus.idle,
      userId: user?.id ?? profile?.userId ?? '',
      state: profile?.location.state ?? '',
      district: profile?.location.district ?? '',
      village: profile?.location.village ?? '',
      landArea: profile?.farmDetails.landArea ?? 0.0,
      areaUnit: profile?.farmDetails.areaUnit ?? 'Acres',
      irrigationType: profile?.farmDetails.irrigationType ?? 'Rainfed',
      profileSoilType: profile?.farmDetails.soilType,
      soilType: profile?.farmDetails.soilType ?? 'Agricultural Soil',
      hasSoilReport: profile?.farmDetails.hasSoilReport ?? false,
      profileNitrogen: profile?.farmDetails.nitrogen,
      profilePhosphorus: profile?.farmDetails.phosphorus,
      profilePotassium: profile?.farmDetails.potassium,
      profilePh: profile?.farmDetails.ph,
      // Pre-fill recommendation values automatically (ZERO RE-ENTRY)
      nitrogen: profile?.farmDetails.nitrogen,
      phosphorus: profile?.farmDetails.phosphorus,
      potassium: profile?.farmDetails.potassium,
      ph: profile?.farmDetails.ph,
      isSoilOverridden: false,
    );

    // Fetch dynamic weather in background automatically
    Future.microtask(() => checkWeather(
          latitude: profile?.location.latitude,
          longitude: profile?.location.longitude,
          district: profile?.location.district,
          stateName: profile?.location.state,
        ));

    return initialState;
  }

  /// Checks the weather service for real-time agromet conditions.
  Future<void> checkWeather({
    double? latitude,
    double? longitude,
    String? district,
    String? stateName,
  }) async {
    // Preserve manual weather if farmer already entered it in this session
    if (state.isWeatherOverridden && state.hasEnvironmentalData) {
      return;
    }

    state = state.copyWith(weatherStatus: WeatherLoadStatus.loading);
    try {
      final weather = await _weatherService.fetchCurrentConditions(
        latitude: latitude,
        longitude: longitude,
        district: district ?? state.district,
        state: stateName ?? state.state,
      );

      if (weather.isAvailable) {
        state = state.copyWith(
          weatherStatus: WeatherLoadStatus.loaded,
          temperature: weather.temperature,
          humidity: weather.humidity,
          rainfall: weather.seasonalRainfall ?? weather.rainfall,
          rainfallProbability: weather.rainfallProbability,
          rawPrecipitation: weather.rainfall,
          weatherLastUpdated: weather.lastUpdated,
          weatherCondition: weather.weatherCondition,
          weatherSource: weather.source,
          isWeatherOverridden: false,
        );
      } else {
        state = state.copyWith(
          weatherStatus: WeatherLoadStatus.unavailable,
          weatherSource: 'Unavailable',
        );
      }
    } catch (_) {
      state = state.copyWith(
        weatherStatus: WeatherLoadStatus.unavailable,
        weatherSource: 'Unavailable',
      );
    }
  }


  /// Sets manually provided environmental parameters (Temperature, Humidity, Rainfall).
  void setManualWeather({
    required double temperature,
    required double humidity,
    required double rainfall,
  }) {
    state = state.copyWith(
      weatherStatus: WeatherLoadStatus.loaded,
      temperature: temperature,
      humidity: humidity,
      rainfall: rainfall,
      weatherSource: 'Manually entered',
      isWeatherOverridden: true,
      clearError: true,
    );
  }

  /// Updates soil parameters for recommendation with explicit choice
  /// whether to save to permanent farm profile or use for this run only.
  Future<void> updateSoilInputs({
    required double n,
    required double p,
    required double k,
    required double ph,
    String? soilType,
    bool updateProfile = false,
  }) async {
    final chosenSoilType = soilType ?? state.soilType ?? 'Agricultural Soil';

    if (updateProfile) {
      final authState = ref.read(authNotifierProvider);
      final currentProfile = authState.profile;
      if (currentProfile != null) {
        final updatedFarmDetails = currentProfile.farmDetails.copyWith(
          nitrogen: n,
          phosphorus: p,
          potassium: k,
          ph: ph,
          soilType: chosenSoilType,
          hasSoilReport: true,
        );
        final updatedProfile = currentProfile.copyWith(
          farmDetails: updatedFarmDetails,
          updatedAt: DateTime.now(),
        );

        await ref.read(authNotifierProvider.notifier).updateProfile(updatedProfile);
      }

      state = state.copyWith(
        profileNitrogen: n,
        profilePhosphorus: p,
        profilePotassium: k,
        profilePh: ph,
        profileSoilType: chosenSoilType,
        hasSoilReport: true,
        nitrogen: n,
        phosphorus: p,
        potassium: k,
        ph: ph,
        soilType: chosenSoilType,
        isSoilOverridden: false, // matches updated profile
        clearError: true,
      );
    } else {
      // One-time edit: use ONLY for this recommendation without altering saved profile
      state = state.copyWith(
        nitrogen: n,
        phosphorus: p,
        potassium: k,
        ph: ph,
        soilType: chosenSoilType,
        isSoilOverridden: true,
        clearError: true,
      );
    }
  }

  /// Submits the exact verified parameters to the ML recommendation API.
  Future<CropRecommendationResult?> getRecommendation() async {
    if (!state.isReadyForRecommendation) {
      final missing = state.missingRequirements.join(' and ');
      state = state.copyWith(
        recommendationStatus: RecommendationProcessStatus.error,
        errorMessage: 'Some information is required before we can generate a recommendation: $missing.',
      );
      return null;
    }

    state = state.copyWith(
      recommendationStatus: RecommendationProcessStatus.loading,
      clearError: true,
      clearResult: true,
    );

    final input = CropRecommendationInput(
      nitrogen: state.nitrogen!,
      phosphorus: state.phosphorus!,
      potassium: state.potassium!,
      temperature: state.temperature!,
      humidity: state.humidity!,
      ph: state.ph!,
      rainfall: state.rainfall!,
    );

    try {
      final result = await _repository.getRecommendation(input);

      // Create immutable historical record with EXACT inputs and farm context snapshot
      final historyItem = CropHistoryItem(
        id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
        userId: state.userId.isNotEmpty
            ? state.userId
            : 'farmer_${DateTime.now().millisecondsSinceEpoch}',
        recommendedCrop: result.recommendedCrop,
        createdAt: DateTime.now(),
        state: state.state.isNotEmpty ? state.state : 'Not specified',
        district: state.district.isNotEmpty ? state.district : 'Not specified',
        village: state.village.isNotEmpty ? state.village : 'Not specified',
        soilType: state.soilType ?? 'Agricultural Soil',
        irrigationType: state.irrigationType,
        landArea: state.landArea,
        landUnit: state.areaUnit,
        nitrogen: input.nitrogen,
        phosphorus: input.phosphorus,
        potassium: input.potassium,
        ph: input.ph,
        temperature: input.temperature,
        humidity: input.humidity,
        rainfall: input.rainfall,
        dataSource: '${state.isSoilOverridden ? "Custom Soil" : "Farm Profile"} + ${state.weatherSource}',
        confidence: result.recommendations.isNotEmpty ? result.recommendations.first.confidence : null,
        alternatives: result.recommendations,
      );

      // Persist to local Crop History
      await ref.read(cropHistoryRepositoryProvider).saveHistoryItem(historyItem);
      // Notify history provider to reload
      ref.read(cropHistoryNotifierProvider.notifier).loadHistory(historyItem.userId);

      state = state.copyWith(
        recommendationStatus: RecommendationProcessStatus.success,
        result: result,
      );

      return result;
    } catch (e) {
      String friendlyError = "We couldn't generate your recommendation right now.";

      if (e is ApiException) {
        if (e.statusCode == 422 || (e.statusCode != null && e.statusCode! >= 400 && e.statusCode! < 500)) {
          friendlyError = 'Please verify that the soil and environmental values are within standard ranges.';
        } else if (e.statusCode == 408 || e.userMessage.toLowerCase().contains('time') || e.userMessage.toLowerCase().contains('timed out')) {
          friendlyError = 'The ML recommendation service took too long to respond. Please try again in a moment.';
        } else {
          friendlyError = 'Unable to connect to the recommendation service. Check your internet connection and try again.';
        }
      } else if (e is SocketException) {
        friendlyError = 'Unable to connect. Check your internet connection and try again.';
      } else {
        friendlyError = e.toString().replaceFirst('Exception: ', '');
      }

      state = state.copyWith(
        recommendationStatus: RecommendationProcessStatus.error,
        errorMessage: friendlyError,
      );
      return null;
    }
  }

  void resetResult() {
    state = state.copyWith(
      recommendationStatus: RecommendationProcessStatus.idle,
      clearResult: true,
      clearError: true,
    );
  }
}
