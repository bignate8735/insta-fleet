import httpx

DRIVER_SERVICE_URL = "http://driver:3002"

async def get_driver_availability(driver_id: int):
    async with httpx.AsyncClient() as client:
        response = await client.get(f"{DRIVER_SERVICE_URL}/drivers/{driver_id}/availability")
        response.raise_for_status()
        return response.json()