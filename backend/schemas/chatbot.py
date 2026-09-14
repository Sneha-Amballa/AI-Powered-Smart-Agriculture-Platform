from typing import List, Optional
from pydantic import BaseModel, Field


class ChatMessage(BaseModel):
    role: str = Field(..., description="'user' or 'assistant'")
    content: str = Field(..., description="Message text")


class ChatRequest(BaseModel):
    message: str = Field(..., description="Farmer's question or prompt")
    conversation_history: List[ChatMessage] = Field(
        default_factory=list, description="Recent conversation turns for context"
    )
    language: Optional[str] = Field("en", description="Preferred response language code (e.g., 'en', 'hi', 'te')")
    farmer_context: Optional[dict] = Field(
        default=None, description="Optional profile context (state, soil, crops grown)"
    )


class ChatResponse(BaseModel):
    reply: str = Field(..., description="AI Agronomist answer")
    suggested_followups: List[str] = Field(
        default_factory=list, description="Helpful follow-up questions"
    )
