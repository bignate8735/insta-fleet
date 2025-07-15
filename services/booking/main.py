from fastapi import FastAPI
from routers import booking
from utils.driver import get_driver_availability
from database.database import Base, engine

app = FastAPI(
    title="Booking Service",
    version="1.0",
    description="Handles ride bookings between users and drivers."
)

@app.on_event("startup")
def on_startup():
    # Create database tables on startup
    Base.metadata.create_all(bind=engine)

@app.get("/health", tags=["Health"], summary="Health check")
def health_check():
    """
    Simple health check endpoint to confirm the booking service is running.
    """
    return {"status": "ok"}

# Include main booking endpoints
app.include_router(booking.router)

# Check driver availability via external driver service
@app.get("/booking/check-driver/{driver_id}", tags=["Driver"],
         summary="Check driver availability",
         description="Checks if a driver is available by querying the Driver Service.")
async def check_driver(driver_id: int):
    return await get_driver_availability(driver_id)