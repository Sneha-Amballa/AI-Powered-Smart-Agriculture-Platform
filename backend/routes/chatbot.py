from fastapi import APIRouter, status
from backend.schemas.chatbot import ChatRequest, ChatResponse
from backend.services.chatbot_service import chatbot_service

router = APIRouter(prefix="/chatbot", tags=["AI Agronomist Chatbot"])


@router.post(
    "/message",
    response_model=ChatResponse,
    status_code=status.HTTP_200_OK,
    summary="Chat with the AI Agronomist",
)
async def chat_message(request: ChatRequest) -> ChatResponse:
    """Ask agronomy questions on crops, soil, pest management, and farming best practices."""
    return await chatbot_service.generate_response(request)
