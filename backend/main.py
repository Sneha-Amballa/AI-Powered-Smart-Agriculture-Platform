import sys
from pathlib import Path
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Ensure root and backend directory are in sys.path for both run styles
BASE_DIR = Path(__file__).resolve().parent
ROOT_DIR = BASE_DIR.parent
for p in [str(ROOT_DIR), str(BASE_DIR)]:
    if p not in sys.path:
        sys.path.insert(0, p)

from backend.core.config import settings
from backend.core.database import engine, Base
import backend.models  # Ensures models are registered with Base.metadata
from backend.routes.api import api_router

app = FastAPI(
    title=settings.PROJECT_NAME,
    description=settings.PROJECT_DESCRIPTION,
    version=settings.VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
)

# Enable CORS for Flutter mobile app and web frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def on_startup():
    """Create database tables on startup if they don't exist."""
    try:
        Base.metadata.create_all(bind=engine)
    except Exception as exc:
        print(f"[Warning] Database table creation notice: {exc}")


# Existing root endpoints preserved exactly as requested
@app.get("/")
def read_root():
    return {"message": "Welcome to Smart Agriculture API"}


@app.get("/health")
def health_check():
    return {"status": "ok"}


# Mount modular API router
app.include_router(api_router, prefix=settings.API_V1_STR)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("backend.main:app", host="0.0.0.0", port=8000, reload=True)
