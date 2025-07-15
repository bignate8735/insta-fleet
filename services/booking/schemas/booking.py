from pydantic import BaseModel, Field

class BookingRequest(BaseModel):
    user_id: int = Field(..., example=1)
    pickup_location: str = Field(..., example="Accra Mall")
    dropoff_location: str = Field(..., example="Kotoka Airport")

class BookingResponse(BaseModel):
    booking_id: int
    user_id: int
    pickup_location: str
    dropoff_location: str
    status: str

    class Config:
        orm_mode = True