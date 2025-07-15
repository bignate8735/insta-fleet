from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from database.database import get_db
from models.booking import Booking
from schemas.booking import BookingRequest, BookingResponse

router = APIRouter(
    prefix="/bookings",
    tags=["Booking"]
)

# -------------------------------
# Create Booking
# -------------------------------
@router.post("/create", response_model=BookingResponse, status_code=status.HTTP_201_CREATED,
             summary="Create a new booking",
             description="Creates a new booking for a user with pickup and dropoff locations.")
def create_booking(request: BookingRequest, db: Session = Depends(get_db)):
    """
    Create a new booking with user ID, pickup, and dropoff locations.
    """
    booking = Booking(
        user_id=request.user_id,
        pickup_location=request.pickup_location,
        dropoff_location=request.dropoff_location,
    )
    db.add(booking)
    db.commit()
    db.refresh(booking)

    return BookingResponse(
        booking_id=booking.id,
        user_id=booking.user_id,
        pickup_location=booking.pickup_location,
        dropoff_location=booking.dropoff_location,
        status=booking.status
    )

# -------------------------------
# Retrieve Booking by ID
# -------------------------------
@router.get("/{booking_id}", response_model=BookingResponse,
            summary="Get booking by ID",
            description="Retrieve a single booking using its unique ID.")
def retrieve_booking_by_id(booking_id: int, db: Session = Depends(get_db)):
    """
    Retrieve a booking by its ID.
    """
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    return BookingResponse(
        booking_id=booking.id,
        user_id=booking.user_id,
        pickup_location=booking.pickup_location,
        dropoff_location=booking.dropoff_location,
        status=booking.status
    )