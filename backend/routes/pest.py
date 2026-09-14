from fastapi import APIRouter, File, UploadFile, status
from backend.schemas.pest import PestDetectionResponse
from backend.services.pest_service import pest_service

router = APIRouter(prefix="/pest", tags=["Pest Detection"])


@router.post(
    "/detect",
    response_model=PestDetectionResponse,
    status_code=status.HTTP_200_OK,
    summary="Identify agricultural pests from image",
)
async def detect_pest(
    file: UploadFile = File(..., description="Pest or affected plant photo (JPEG/PNG)")
) -> PestDetectionResponse:
    """Identify insects, worms, and crop pests with severity and control recommendations."""
    content = await file.read()
    return await pest_service.detect_pest_from_bytes(content, file.filename or "pest.jpg")
