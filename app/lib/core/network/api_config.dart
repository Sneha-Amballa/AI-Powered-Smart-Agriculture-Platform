import '../constants/api_endpoints.dart';

/// Centralized API configuration to control base URLs, timeouts, and headers dynamically.
class ApiConfig {
  final String baseUrl;
  final String cropServiceUrl;
  final Duration timeout;

  const ApiConfig({
    this.baseUrl = ApiEndpoints.defaultLocalBaseUrl,
    this.cropServiceUrl = ApiEndpoints.cropRecommendationProductionUrl,
    this.timeout = const Duration(seconds: 30),
  });

  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
