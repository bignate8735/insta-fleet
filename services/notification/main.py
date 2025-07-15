from fastapi import FastAPI
from routers import notification
from dotenv import load_dotenv
import os

load_dotenv()

app = FastAPI(title="Notification Service", version="1.0")

@app.get("/health", tags=["Health"])
def health_check():
    return {"status": "ok"}

app.include_router(notification.router, prefix="/notify", tags=["Notification"])