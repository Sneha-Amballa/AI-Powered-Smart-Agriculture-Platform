from fastapi import APIRouter, status
from backend.schemas.voice import VoiceQueryRequest, VoiceQueryResponse
from backend.services.voice_service import voice_service

router = APIRouter(prefix="/voice", tags=["Multilingual & Voice Interface"])


@router.post(
    "/query",
    response_model=VoiceQueryResponse,
    status_code=status.HTTP_200_OK,
    summary="Process multilingual voice queries from farmers",
)
async def process_voice(request: VoiceQueryRequest) -> VoiceQueryResponse:
    """Handle speech queries in vernacular languages and provide spoken/text advisories."""
    return await voice_service.process_voice_query(request)
