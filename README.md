# AI-Powered Smart Agriculture Platform

A modular, scalable, and intelligent agricultural decision-support ecosystem built for smallholder and commercial farmers. The platform integrates **FastAPI**, **Flutter**, **PostgreSQL/Supabase**, and machine learning microservices to deliver hyper-local agronomic advisory.

---

## System Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                 Flutter Mobile Client (app/)                │
│    • Material 3 UI  • Feature-First  • Vernacular Voice     │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTPS / REST
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                  FastAPI Backend (backend/)                 │
│         • API Gateway (/api/v1)  • JWT Auth  • CORS         │
│  ├── Auth & Farmer Profile      ├── Weather Advisory        │
│  ├── Crop Recommendation Bridge ├── Market Mandi Forecast   │
│  ├── Disease Detection (Vision) ├── Government Schemes      │
│  ├── Pest Detection (YOLO/CNN)  ├── AI Chatbot (LLM)        │
│  └── Voice & Multilingual STT/TTS                           │
└───────────────┬──────────────────────────────┬──────────────┘
                │                              │
                ▼                              ▼
┌─────────────────────────────┐  ┌─────────────────────────────┐
│    PostgreSQL / Supabase    │  │   Deployed ML Microservices │
│    • Farmer Profiles        │  │   • Crop Recommendation     │
│    • Farm Telemetry & Logs  │  │     (Live on Render)        │
│    • Scheme & Mandi Records │  │   • Disease & Pest Models   │
└─────────────────────────────┘  └─────────────────────────────┘
```

---

## Core Modules & Status

| Module | Status | Technology / Details |
|---|---|---|
| **Crop Recommendation** | **COMPLETED & DEPLOYED** | XGBoost/RandomForest ML API live on [Render](https://crop-recommendation-system-0c1p.onrender.com) |
| **Backend API Gateway** | **Foundation Ready** | FastAPI + Uvicorn with modular `/api/v1` routers |
| **Mobile Application** | **Foundation Ready** | Flutter (Material 3) with feature-first screens and routes |
| **Database** | **Configured** | PostgreSQL / Supabase with SQLAlchemy ORM + SQLite dev fallback |
| **Authentication & Profile** | Foundation Ready | JWT token generation, bcrypt password hashing, farmer profile model |
| **Plant Disease Detection** | Foundation Ready | Leaf scan route and vision service abstraction |
| **Pest Detection** | Foundation Ready | Pest scan route and treatment advisory abstraction |
| **Weather Advisory** | Foundation Ready | Agromet route configured for OpenWeatherMap / IMD |
| **Market Mandi Prices** | Foundation Ready | APMC rate lookup and 7-day price forecasting router |
| **Government Schemes** | Foundation Ready | Subsidies (PM-KISAN, PMFBY, PMKSY) and eligibility engine |
| **AI Farm Advisory Chatbot**| Foundation Ready | Conversational agronomist endpoint ready for Gemini/LLM |
| **Multilingual Voice** | Foundation Ready | Vernacular voice query interface (Hindi, Telugu, Tamil, etc.) |

---

## Project Directory Structure

```text
Smart Agriculture App/
├── .env.example                     # Root environment configuration template
├── .gitignore                       # Clean Git ignore rules (Python, Flutter, OS, DB)
├── README.md                        # Project architecture & setup documentation
│
├── app/                             # Flutter Mobile Application
│   ├── .env.example                 # Mobile environment configuration template
│   ├── analysis_options.yaml        # Flutter static analysis rules
│   ├── pubspec.yaml                 # Dependencies (http, cupertino_icons)
│   ├── lib/
│   │   ├── main.dart                # App entrypoint (Material 3 & route setup)
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   │   ├── api_endpoints.dart  # Centralized API URLs & Render ML link
│   │   │   │   └── app_colors.dart     # Agricultural green & earth palette
│   │   │   ├── network/
│   │   │   │   └── api_client.dart     # Robust HTTP client with error handling
│   │   │   ├── routes/
│   │   │   │   └── app_routes.dart     # Route generator for all 9 modules
│   │   │   └── theme/
│   │   │       └── app_theme.dart      # Material 3 light theme
│   │   └── features/
│   │       ├── home/screens/home_screen.dart                     # 9-module dashboard
│   │       ├── auth/screens/auth_screen.dart                     # Farmer login/profile UI
│   │       ├── crop_recommendation/screens/crop_recommendation_screen.dart # Live ML form
│   │       ├── disease_detection/screens/disease_detection_screen.dart     # Leaf scanner
│   │       ├── pest_detection/screens/pest_detection_screen.dart           # Pest scanner
│   │       ├── weather/screens/weather_screen.dart                         # Farm weather
│   │       ├── market_prices/screens/market_prices_screen.dart             # Mandi rates
│   │       ├── schemes/screens/schemes_screen.dart                         # PM-KISAN, PMFBY
│   │       ├── chatbot/screens/chatbot_screen.dart                         # AI Agronomist
│   │       └── voice_assistant/screens/voice_assistant_screen.dart         # Speech UI
│   └── test/
│       └── widget_test.dart         # Flutter smoke test
│
└── backend/                         # FastAPI Backend
    ├── .env.example                 # Backend environment variable template
    ├── main.py                      # FastAPI application, CORS & startup
    ├── requirements.txt             # Python dependencies
    ├── core/
    │   ├── __init__.py
    │   ├── config.py                # Pydantic Settings & environment loader
    │   ├── database.py              # PostgreSQL / Supabase SQLAlchemy engine
    │   └── security.py              # JWT & bcrypt authentication utilities
    ├── models/
    │   ├── __init__.py
    │   └── user.py                  # Farmer profile ORM model
    ├── schemas/
    │   ├── __init__.py
    │   ├── auth.py                  # User register/login & profile schemas
    │   ├── crop_recommendation.py   # Schemas matching deployed ML service
    │   ├── disease.py               # Plant disease diagnosis schemas
    │   ├── pest.py                  # Pest detection schemas
    │   ├── weather.py               # Agromet forecast schemas
    │   ├── market.py                # Mandi price & forecast schemas
    │   ├── scheme.py                # Government scheme schemas
    │   ├── chatbot.py               # Chatbot message & response schemas
    │   └── voice.py                 # Voice & STT/TTS schemas
    ├── services/
    │   ├── __init__.py
    │   ├── crop_service.py          # Bridges to deployed ML API on Render
    │   ├── auth_service.py          # User management & authentication
    │   ├── disease_service.py       # Disease model service stub
    │   ├── pest_service.py          # Pest model service stub
    │   ├── weather_service.py       # Weather API client stub
    │   ├── market_service.py        # Mandi pricing & forecast stub
    │   ├── scheme_service.py        # Scheme catalog & matching stub
    │   ├── chatbot_service.py       # AI chat service stub
    │   └── voice_service.py         # Vernacular speech service stub
    └── routes/
        ├── __init__.py
        ├── api.py                   # Master API router (/api/v1)
        ├── auth.py                  # /auth endpoints
        ├── crop.py                  # /crop/recommend & /predict-crop
        ├── disease.py               # /disease/detect
        ├── pest.py                  # /pest/detect
        ├── weather.py               # /weather/forecast
        ├── market.py                # /market/prices & /predict-trend
        ├── schemes.py               # /schemes/list
        ├── chatbot.py               # /chatbot/message
        └── voice.py                 # /voice/query
```

---

## Live Deployed Crop Recommendation Service

* **Endpoint**: `POST https://crop-recommendation-system-0c1p.onrender.com/predict-crop`
* **Swagger UI**: `https://crop-recommendation-system-0c1p.onrender.com/docs`
* **Input Schema**:
  ```json
  {
    "N": 90.0,
    "P": 42.0,
    "K": 43.0,
    "temperature": 20.87,
    "humidity": 82.0,
    "ph": 6.5,
    "rainfall": 202.93
  }
  ```
* **Output Schema**:
  ```json
  {
    "recommended_crop": "rice",
    "recommendations": [
      {"crop": "rice", "confidence": 93.5},
      {"crop": "jute", "confidence": 6.5},
      {"crop": "apple", "confidence": 0.0}
    ]
  }
  ```

---

## Quick Start & Verification

### 1. Backend Setup (FastAPI)

```bash
# Navigate to backend directory
cd backend

# Install dependencies (if needed)
pip install -r requirements.txt

# Run the FastAPI backend server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

* **API Root**: [http://localhost:8000](http://localhost:8000)
* **Health Check**: [http://localhost:8000/health](http://localhost:8000/health)
* **Interactive Swagger UI**: [http://localhost:8000/docs](http://localhost:8000/docs)
* **Crop ML Test**:
  ```bash
  curl -X POST "http://localhost:8000/api/v1/crop/recommend" \
       -H "Content-Type: application/json" \
       -d "{\"N\": 90, \"P\": 42, \"K\": 43, \"temperature\": 20.87, \"humidity\": 82.0, \"ph\": 6.5, \"rainfall\": 202.93}"
  ```

### 2. Mobile App Setup (Flutter)

```bash
# Navigate to app directory
cd app

# Fetch dependencies
flutter pub get

# Verify Dart code analysis
dart analyze lib

# Run automated smoke tests
flutter test

# Launch mobile application (Chrome, Android emulator, or connected phone)
flutter run -d chrome
# or: flutter run
```

---

## Database Configuration (PostgreSQL / Supabase)

To connect your Supabase or local PostgreSQL instance:
1. Copy `backend/.env.example` to `backend/.env`
2. Update the `DATABASE_URL`:
   ```env
   DATABASE_URL=postgresql://postgres:[PASSWORD]@[HOST]:[PORT]/[DATABASE]
   ```
   *For Supabase, use the Connection String from Project Settings > Database > Connection Pooling.*
3. By default, if `DATABASE_URL` is omitted, the backend falls back to SQLite (`sqlite:///./smart_agriculture.db`) for zero-configuration local development.
