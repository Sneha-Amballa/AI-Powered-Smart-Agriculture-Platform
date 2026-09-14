from fastapi import APIRouter, Depends, status
from backend.schemas.crop_recommendation import CropRequest, CropResponse
from backend.services.crop_service import crop_service

router = APIRouter(prefix="/crop", tags=["Crop Recommendation"])


@router.post(
    "/recommend",
    response_model=CropResponse,
    status_code=status.HTTP_200_OK,
    summary="Predict optimal crop for given soil & climate parameters",
    description="Forwards input parameters to the completed and deployed ML Crop Recommendation service.",
)
async def recommend_crop(request: CropRequest) -> CropResponse:
    """Predict top recommended crops based on N, P, K, temperature, humidity, pH, and rainfall."""
    return await crop_service.predict_crop(request)


@router.post(
    "/predict-crop",
    response_model=CropResponse,
    status_code=status.HTTP_200_OK,
    summary="Alias matching the deployed API /predict-crop route",
    include_in_schema=True,
)
async def predict_crop_alias(request: CropRequest) -> CropResponse:
    """Direct alias to ensure compatibility with deployed model contract."""
    return await crop_service.predict_crop(request)


@router.get(
    "/status",
    summary="Check status of the deployed Crop Recommendation ML service",
)
def crop_service_status():
    """Returns endpoint URL and integration status of the ML Crop model."""
    return {
        "status": "connected",
        "deployed_api_url": crop_service.base_url,
        "swagger_docs": f"{crop_service.base_url}/docs",
    }
