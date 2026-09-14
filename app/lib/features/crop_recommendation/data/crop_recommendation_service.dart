import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/network_client.dart';
import 'crop_recommendation_model.dart';

/// Network service interfacing with the deployed Machine Learning Crop Recommendation API.
class CropRecommendationService {
  final NetworkClient _networkClient;
  final String _baseUrl;

  CropRecommendationService({
    NetworkClient? networkClient,
    String? baseUrl,
  })  : _networkClient = networkClient ?? NetworkClient(),
        _baseUrl = baseUrl ?? ApiEndpoints.cropRecommendationProductionUrl;

  /// Sends soil parameters to POST /predict-crop on the deployed Render service.
  Future<CropRecommendationResult> fetchRecommendation(
    CropRecommendationInput input,
  ) async {
    final endpoint = '$_baseUrl${ApiEndpoints.predictCrop}';

    final response = await _networkClient.post(
      endpoint,
      body: input.toJson(),
    );

    if (response is Map<String, dynamic>) {
      return CropRecommendationResult.fromJson(response);
    } else if (response is Map) {
      return CropRecommendationResult.fromJson(Map<String, dynamic>.from(response));
    } else {
      throw FormatException('Unexpected response format: $response');
    }
  }
}
