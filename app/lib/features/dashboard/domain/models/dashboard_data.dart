import 'package:flutter/material.dart';

/// Advisory urgency levels for contextual color-coding and prioritization.
enum AdvisorySeverity {
  favorable,
  advisory,
  warning,
  critical,
}

/// Contextual farm advisory representing the primary agricultural decision support insight.
class FarmAdvisory {
  final String id;
  final String headline;
  final String description;
  final AdvisorySeverity severity;
  final String actionLabel;
  final String actionRoute;
  final DateTime timestamp;

  const FarmAdvisory({
    required this.id,
    required this.headline,
    required this.description,
    required this.severity,
    required this.actionLabel,
    required this.actionRoute,
    required this.timestamp,
  });

  String get severityLabel {
    switch (severity) {
      case AdvisorySeverity.critical:
        return 'CRITICAL ALERT';
      case AdvisorySeverity.warning:
        return 'WEATHER WARNING';
      case AdvisorySeverity.advisory:
        return 'FARM ADVISORY';
      case AdvisorySeverity.favorable:
        return 'FAVORABLE CONDITIONS';
    }
  }
}

/// Weather summary paired with actionable agricultural impact guidance.
class WeatherSummary {
  final String locationName;
  final double temperature;
  final String condition;
  final double feelsLike;
  final int humidity;
  final int rainProbability;
  final double windSpeed;
  final String farmingImpact;

  const WeatherSummary({
    required this.locationName,
    required this.temperature,
    required this.condition,
    required this.feelsLike,
    required this.humidity,
    required this.rainProbability,
    required this.windSpeed,
    required this.farmingImpact,
  });
}

/// Concise crop recommendation summary based on soil health and climate.
class CropRecommendationSummary {
  final String cropName;
  final double confidencePercentage;
  final String subtitle;
  final String soilMatchDetails;
  final String actionRoute;

  const CropRecommendationSummary({
    required this.cropName,
    required this.confidencePercentage,
    required this.subtitle,
    required this.soilMatchDetails,
    this.actionRoute = '/crop-recommendation',
  });
}

/// Market snapshot tracking commodity modal prices and nearby mandi comparisons.
class MarketPriceSummary {
  final String cropName;
  final double currentPrice;
  final String priceUnit;
  final double changePercent;
  final bool isUp;
  final double nearbyBestPrice;
  final String nearbyMandiName;
  final String localMandiName;

  const MarketPriceSummary({
    required this.cropName,
    required this.currentPrice,
    this.priceUnit = '₹ / quintal',
    required this.changePercent,
    required this.isUp,
    required this.nearbyBestPrice,
    required this.nearbyMandiName,
    required this.localMandiName,
  });

  String get formattedCurrentPrice => '₹${currentPrice.toInt()} $priceUnit';
  String get formattedBestPrice => '₹${nearbyBestPrice.toInt()}';
  String get changeFormatted => '${isUp ? "+" : "-"}${changePercent.toStringAsFixed(1)}%';
}

/// Personalized summary of eligible government schemes for the farmer.
class GovernmentSchemeSummary {
  final int eligibleCount;
  final List<String> highlightSchemes;
  final String note;

  const GovernmentSchemeSummary({
    required this.eligibleCount,
    required this.highlightSchemes,
    required this.note,
  });
}

/// Activity timeline item for farmer audit log.
class RecentActivityItem {
  final String id;
  final String title;
  final String description;
  final String timestampText;
  final IconData icon;
  final Color accentColor;
  final String? route;
  final String? badgeLabel;

  const RecentActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestampText,
    required this.icon,
    required this.accentColor,
    this.route,
    this.badgeLabel,
  });
}

/// Aggregate dashboard payload encapsulating all decision-support domains.
class DashboardData {
  final FarmAdvisory advisory;
  final WeatherSummary weather;
  final CropRecommendationSummary crop;
  final MarketPriceSummary market;
  final GovernmentSchemeSummary schemes;
  final List<RecentActivityItem> recentActivity;
  final DateTime lastUpdated;
  final bool isProfileComplete;

  const DashboardData({
    required this.advisory,
    required this.weather,
    required this.crop,
    required this.market,
    required this.schemes,
    required this.recentActivity,
    required this.lastUpdated,
    required this.isProfileComplete,
  });
}
