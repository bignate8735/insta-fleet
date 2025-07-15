from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from models.driver import Driver
from database.database import get_db
from schemas.driver import DriverCreate, DriverResponse

router = APIRouter(
    prefix="/drivers",
    tags=["Drivers"],
    responses={404: {"description": "Not found"}}
)

@router.post("/register", response_model=DriverResponse, status_code=201, summary="Register a new driver")
def register_driver(driver: DriverCreate, db: Session = Depends(get_db)):
    """
    Register a new driver in the system.

    - **name**: Driver's full name
    - **license_number**: Unique driver's license ID
    """
    # Check for existing license number (optional enhancement)
    existing = db.query(Driver).filter(Driver.license_number == driver.license_number).first()
    if existing:
        raise HTTPException(status_code=400, detail="License number already registered")

    new_driver = Driver(
        name=driver.name,
        license_number=driver.license_number
    )
    db.add(new_driver)
    db.commit()
    db.refresh(new_driver)
    return new_driver

@router.get("/all", response_model=List[DriverResponse], summary="Get all drivers")
def get_all_drivers(db: Session = Depends(get_db)):
    """
    Retrieve a list of all registered drivers.
    """
    return db.query(Driver).all()

@router.get("/{driver_id}/availability", response_model=dict, summary="Check driver availability")
def check_driver_availability(driver_id: int, db: Session = Depends(get_db)):
    """
    Check if a specific driver is currently available.

    - **driver_id**: Unique ID of the driver
    """
    driver = db.query(Driver).filter(Driver.id == driver_id).first()
    if not driver:
        raise HTTPException(status_code=404, detail="Driver not found")
    
    return {
        "driver_id": driver.id,
        "is_available": driver.is_available
    }