import 'crop_recommendation_model.dart';
import 'crop_recommendation_service.dart';

abstract class CropRecommendationRepository {
  Future<CropRecommendationResult> getRecommendation(CropRecommendationInput input);
}

class CropRecommendationRepositoryImpl implements CropRecommendationRepository {
  final CropRecommendationService _service;

  CropRecommendationRepositoryImpl({CropRecommendationService? service})
      : _service = service ?? CropRecommendationService();

  @override
  Future<CropRecommendationResult> getRecommendation(
    CropRecommendationInput input,
  ) async {
    return await _service.fetchRecommendation(input);
  }
}
