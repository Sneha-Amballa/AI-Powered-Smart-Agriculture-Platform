from fastapi import APIRouter
from backend.routes.auth import router as auth_router
from backend.routes.crop import router as crop_router
from backend.routes.disease import router as disease_router
from backend.routes.pest import router as pest_router
from backend.routes.weather import router as weather_router
from backend.routes.market import router as market_router
from backend.routes.schemes import router as schemes_router
from backend.routes.chatbot import router as chatbot_router
from backend.routes.voice import router as voice_router

api_router = APIRouter()

# Register all modular feature routers
api_router.include_router(auth_router)
api_router.include_router(crop_router)
api_router.include_router(disease_router)
api_router.include_router(pest_router)
api_router.include_router(weather_router)
api_router.include_router(market_router)
api_router.include_router(schemes_router)
api_router.include_router(chatbot_router)
api_router.include_router(voice_router)
