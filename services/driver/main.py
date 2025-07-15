from fastapi import FastAPI
from routers import driver
from database.database import engine, Base

app = FastAPI(
    title="Driver Service",
    version="1.0",
    description="Handles driver registration, listing, and availability checks."
)

@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)

@app.get("/health", tags=["Health"], summary="Health Check")
def health_check():
    """
    Simple health check endpoint.
    Returns OK if the service is running.
    """
    return {"status": "ok"}

# Register the driver routes
app.include_router(driver.router)