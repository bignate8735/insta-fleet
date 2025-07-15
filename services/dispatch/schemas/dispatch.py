from pydantic import BaseModel

class DispatchRequest(BaseModel):
    booking_id: str

class DispatchResponse(BaseModel):
    dispatch_id: str
    status: str

class DispatchStatusResponse(BaseModel):
    dispatch_id: str
    booking_id: str
    driver_id: str
    status: str