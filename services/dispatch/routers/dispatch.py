from fastapi import APIRouter, HTTPException
from uuid import uuid4
import httpx

from database.redis_client import redis_client
from schemas.dispatch import DispatchRequest, DispatchResponse, DispatchStatusResponse

router = APIRouter(prefix="/dispatch", tags=["Dispatch"])

# External driver service URL (internal Docker service name if containerized)
DRIVER_SERVICE_URL = "http://driver-service:3002"

@router.post("/assign", response_model=DispatchResponse, summary="Assign Driver to Booking")
def assign_driver(req: DispatchRequest):
    """
    Assign an available driver to a booking and store the dispatch info in Redis.
    """
    # Step 1: Call the driver service to retrieve drivers
    try:
        response = httpx.get(f"{DRIVER_SERVICE_URL}/drivers/all")
        response.raise_for_status()
        drivers = response.json()
    except httpx.RequestError as e:
        raise HTTPException(status_code=503, detail=f"Driver service unreachable: {e}")
    except httpx.HTTPStatusError as e:
        raise HTTPException(status_code=e.response.status_code, detail="Failed to fetch drivers")

    # Step 2: Pick the first available driver
    available_driver = next((d for d in drivers if d.get("is_available")), None)
    if not available_driver:
        raise HTTPException(status_code=404, detail="No available drivers at the moment")

    # Step 3: Generate a dispatch ID and prepare data
    dispatch_id = str(uuid4())
    dispatch_data = {
        "dispatch_id": dispatch_id,
        "booking_id": req.booking_id,
        "driver_id": str(available_driver["id"]),
        "status": "assigned"
    }

    # Step 4: Store dispatch in Redis
    try:
        redis_key = f"dispatch:{dispatch_id}"
        redis_client.hset(redis_key, mapping=dispatch_data)
        print(f"[Redis] Stored dispatch: {dispatch_data}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save dispatch to Redis: {e}")

    # Step 5: Return response
    return DispatchResponse(dispatch_id=dispatch_id, status="assigned")

@router.get("/{dispatch_id}", response_model=DispatchStatusResponse, summary="Get Dispatch Status")
def get_dispatch_status(dispatch_id: str):
    """
    Get the current status of a dispatch by its ID.
    """
    redis_key = f"dispatch:{dispatch_id}"

    try:
        data = redis_client.hgetall(redis_key)
        print(f"[Redis] Fetched data for: {redis_key}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Redis error: {e}")

    if not data:
        raise HTTPException(status_code=404, detail="Dispatch not found")

    try:
        return DispatchStatusResponse(
            dispatch_id=dispatch_id,
            booking_id=data[b"booking_id"].decode("utf-8"),
            driver_id=data[b"driver_id"].decode("utf-8"),
            status=data[b"status"].decode("utf-8")
        )
    except KeyError as e:
        raise HTTPException(status_code=500, detail=f"Missing field in Redis data: {e}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to decode Redis data: {e}")