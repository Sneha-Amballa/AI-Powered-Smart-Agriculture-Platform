import logging
import httpx
from fastapi import HTTPException, status
from backend.core.config import settings
from backend.schemas.crop_recommendation import CropRequest, CropResponse

logger = logging.getLogger(__name__)


class CropRecommendationService:
    """Service to communicate with the deployed Machine Learning Crop Recommendation API."""

    def __init__(self, base_url: str = settings.CROP_RECOMMENDATION_API_URL):
        self.base_url = base_url.rstrip("/")

    async def predict_crop(self, request: CropRequest) -> CropResponse:
        """Forwards soil and environmental parameters to the deployed ML Crop Recommendation API.

        Deployed endpoint: POST /predict-crop
        """
        target_url = f"{self.base_url}/predict-crop"
        payload = request.model_dump()

        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(target_url, json=payload)

                if response.status_code != 200:
                    logger.error(
                        f"Crop Recommendation API error: {response.status_code} - {response.text}"
                    )
                    raise HTTPException(
                        status_code=status.HTTP_502_BAD_GATEWAY,
                        detail=f"Error from crop recommendation ML service: {response.text}",
                    )

                data = response.json()
                return CropResponse(**data)

        except httpx.RequestError as exc:
            logger.error(f"Failed to connect to Crop Recommendation ML API at {target_url}: {exc}")
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="Crop Recommendation ML service is temporarily unreachable or starting up. Please try again shortly.",
            )


crop_service = CropRecommendationService()
