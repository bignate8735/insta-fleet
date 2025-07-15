from pydantic import BaseModel
from typing import Optional

class DriverCreate(BaseModel):
    name: str
    license_number: str

class DriverResponse(DriverCreate):
    id: int
    is_available: Optional[bool] = True

    class Config:
        orm_mode = True