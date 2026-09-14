from fastapi import APIRouter, File, UploadFile, status
from backend.schemas.disease import DiseaseDetectionResponse
from backend.services.disease_service import disease_service

router = APIRouter(prefix="/disease", tags=["Plant Disease Detection"])


@router.post(
    "/detect",
    response_model=DiseaseDetectionResponse,
    status_code=status.HTTP_200_OK,
    summary="Detect disease from crop leaf photograph",
)
async def detect_crop_disease(
    file: UploadFile = File(..., description="Crop leaf image file (JPEG/PNG)")
) -> DiseaseDetectionResponse:
    """Classify plant diseases and provide curative/preventive measures."""
    content = await file.read()
    return await disease_service.detect_disease_from_bytes(content, file.filename or "leaf.jpg")
