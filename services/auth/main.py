from fastapi import FastAPI
from routers import auth
from database.database import engine, Base
from dotenv import load_dotenv
import uvicorn
import os

# Load environment variables from .env
load_dotenv()

# Initialize FastAPI app with metadata for Swagger
app = FastAPI(
    title="Auth Service",
    version="1.0.0",
    description="""
Authentication microservice for registering and logging in users.

### Features
- 🧾 Register user
- 🔐 Login with credentials
- 🔑 JWT authentication
"""
)

# Auto-create tables at startup
@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)

# Simple health check route
@app.get("/health", tags=["Health"])
def health_check():
    """Health check endpoint to verify the service is up."""
    return {"status": "ok"}

# Include authentication router
app.include_router(auth.router)

# Uvicorn dev server entry point
if __name__ == "__main__":
    port = int(os.getenv("AUTH_PORT", 3000))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)