from fastapi import APIRouter, Depends

from app.auth import require_api_key
from app.services.esp32_client import start_servo, stop_servo

router = APIRouter(dependencies=[Depends(require_api_key)])


@router.post("/start_servo")
async def start_servo_route():
    esp32 = await start_servo()
    return {"message": "Commande start_servo envoyée", "esp32": esp32}


@router.post("/stop_servo")
async def stop_servo_route():
    esp32 = await stop_servo()
    return {"message": "Commande stop_servo envoyée", "esp32": esp32}
