from typing import Optional

import httpx
from fastapi import HTTPException

from app.config import ESP32_API_KEY, ESP32_BASE_URL, ESP32_TIMEOUT
from app.state import update_state


def _headers() -> dict:
    if not ESP32_API_KEY:
        return {}
    return {"X-API-Key": ESP32_API_KEY}


async def esp32_get(path: str, params: Optional[dict] = None) -> dict:
    url = f"{ESP32_BASE_URL}{path if path.startswith('/') else '/' + path}"
    try:
        async with httpx.AsyncClient(timeout=ESP32_TIMEOUT) as client:
            response = await client.get(url, params=params, headers=_headers())
        if not response.is_success:
            update_state(esp32_last_error=f"HTTP {response.status_code}: {response.text}")
            raise HTTPException(
                status_code=502,
                detail=f"ESP32 erreur {response.status_code} ({url})",
            )
        update_state(esp32_last_error=None)
        return {
            "ok": True,
            "status_code": response.status_code,
            "body": response.text,
            "url": url,
        }
    except HTTPException:
        raise
    except Exception as exc:
        update_state(esp32_last_error=str(exc))
        raise HTTPException(
            status_code=502,
            detail=f"ESP32 injoignable ({url}): {exc}",
        ) from exc


async def send_move(direction: str) -> dict:
    return await esp32_get("/move", params={"dir": direction})


async def start_servo() -> dict:
    return await esp32_get("/start_servo")


async def stop_servo() -> dict:
    return await esp32_get("/stop_servo")


async def ping_esp32() -> dict:
    # /status est public côté firmware
    url = f"{ESP32_BASE_URL}/status"
    try:
        async with httpx.AsyncClient(timeout=ESP32_TIMEOUT) as client:
            response = await client.get(url)
        if not response.is_success:
            return {
                "reachable": False,
                "esp32_base_url": ESP32_BASE_URL,
                "error": f"HTTP {response.status_code}",
            }
        return {"reachable": True, "status_code": response.status_code, "body": response.text}
    except Exception as exc:
        return {
            "reachable": False,
            "esp32_base_url": ESP32_BASE_URL,
            "error": str(exc),
        }
