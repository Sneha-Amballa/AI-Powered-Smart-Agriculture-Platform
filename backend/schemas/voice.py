from typing import Optional
from pydantic import BaseModel, Field


class VoiceQueryRequest(BaseModel):
    """Schema for voice query or audio transcription request."""

    language: str = Field("hi", description="Source audio language ISO code (hi, te, ta, mr, kn, en, etc.)")
    transcribed_text: Optional[str] = Field(None, description="Transcribed query text if speech-to-text is client-side")


class VoiceQueryResponse(BaseModel):
    """Schema for multilingual voice response."""

    transcribed_text: str = Field(..., description="Recognized speech text")
    answer_text: str = Field(..., description="Response text in the farmer's language")
    audio_url: Optional[str] = Field(None, description="Generated Text-To-Speech audio stream/URL")
    detected_language: str = Field(..., description="Language detected or processed")
