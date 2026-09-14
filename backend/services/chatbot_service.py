import logging
from typing import Optional
from backend.core.config import settings
from backend.schemas.chatbot import ChatRequest, ChatResponse

logger = logging.getLogger(__name__)


class ChatbotService:
    """Service foundation for Agricultural AI Chatbot (LLM / RAG)."""

    def __init__(self, api_key: str = settings.GEMINI_API_KEY):
        self.api_key = api_key

    async def generate_response(self, request: ChatRequest) -> ChatResponse:
        """Generate contextual agronomy advice based on farmer query."""
        user_text = request.message.strip().lower()

        # Architectural foundation response (can be powered by Google Gemini / OpenAI)
        if "fertilizer" in user_text or "npk" in user_text:
            reply = (
                "For balanced soil nutrition, test your soil every 2 seasons. "
                "Generally, split application of Nitrogen (50% basal, 25% vegetative, 25% flowering) "
                "along with full basal doses of Phosphorus and Potassium delivers optimal yield."
            )
            followups = [
                "How do I test my soil pH?",
                "What is the recommended NPK for paddy/rice?",
                "Are biofertilizers like Azotobacter effective?",
            ]
        elif "water" in user_text or "irrigation" in user_text:
            reply = (
                "Irrigation requirements vary by growth stage. Critical moisture sensitive stages include "
                "tillering and panicle initiation for cereals, and flowering/pod development for pulses. "
                "Drip irrigation saves 40-60% water while improving fertilizer use efficiency."
            )
            followups = [
                "What government subsidies exist for drip irrigation?",
                "How does high humidity affect watering?",
            ]
        else:
            reply = (
                f"Hello! I am your AI Smart Agriculture Agronomist. Regarding '{request.message}', "
                "I can assist you with crop planning, disease diagnostics, weather advisories, "
                "mandi price trends, and government subsidies. How can I help your farm today?"
            )
            followups = [
                "Recommend best crops for my soil",
                "Check latest mandi prices",
                "Diagnose leaf spots on my crops",
            ]

        return ChatResponse(
            reply=reply,
            suggested_followups=followups,
        )


chatbot_service = ChatbotService()
