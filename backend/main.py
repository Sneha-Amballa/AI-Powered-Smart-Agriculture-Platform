from fastapi import FastAPI

app = FastAPI(
    title="Smart Agriculture API",
    description="Backend API for Smart Agriculture App",
    version="0.1.0"
)

@app.get("/")
def read_root():
    return {"message": "Welcome to Smart Agriculture API"}

@app.get("/health")
def health_check():
    return {"status": "ok"}
