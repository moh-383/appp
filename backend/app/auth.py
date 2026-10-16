import secrets
from typing import Optional

from fastapi import Header, HTTPException

from app import config


async def require_api_key(x_api_key: Optional[str] = Header(default=None)) -> None:
    if not config.API_KEY:
        return
    if x_api_key is None or not secrets.compare_digest(x_api_key, config.API_KEY):
        raise HTTPException(status_code=401, detail="Invalid or missing X-API-Key")
