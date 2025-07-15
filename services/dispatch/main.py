from fastapi import FastAPI
from routers import dispatch

app = FastAPI(
    title="Dispatch Service",
    version="1.0",
    description="Handles driver assignment and dispatch tracking using Redis."
)

@app.get("/health", tags=["Health"], summary="Health Check")
def health_check():
    return {"status": "ok"}

# Include dispatch router
app.include_router(dispatch.router)