# services/booking/models/booking.py
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.sql import func
from database.database import Base

class Booking(Base):
    __tablename__ = "bookings"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False)
    driver_id = Column(Integer, nullable=True)
    pickup_location = Column(String(255), nullable=False)
    dropoff_location = Column(String(255), nullable=False)
    status = Column(String(50), default="pending")
    created_at = Column(DateTime(timezone=True), server_default=func.now())