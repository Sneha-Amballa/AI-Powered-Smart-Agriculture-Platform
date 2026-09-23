"""Translation API route for KisanAI backend.

Provides a POST /translate endpoint for batch translation of dynamic content
via LibreTranslate. Flutter calls this endpoint instead of calling
LibreTranslate directly.
"""

from typing import List, Optional
from fastapi import APIRouter
from pydantic import BaseModel, Field

from backend.services.translation_service import translation_service

router = APIRouter(prefix="/translate", tags=["Translation"])


class TranslateRequest(BaseModel):
    texts: List[str] = Field(..., description="List of text strings to translate")
    target_lang: str = Field(..., description="Target language code (e.g., 'hi', 'te')")
    source_lang: str = Field(
        default="en", description="Source language code (defaults to 'en')"
    )


class TranslateResponse(BaseModel):
    translations: List[str]
    source_lang: str
    target_lang: str


@router.post("", response_model=TranslateResponse)
async def translate_texts(request: TranslateRequest):
    """Translate a batch of text strings to the target language.

    Uses LibreTranslate with caching. Returns original text on failure.
    """
    translations = await translation_service.translate_batch(
        texts=request.texts,
        target_lang=request.target_lang,
        source_lang=request.source_lang,
    )

    return TranslateResponse(
        translations=translations,
        source_lang=request.source_lang,
        target_lang=request.target_lang,
    )
