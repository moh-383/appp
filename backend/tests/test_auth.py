import asyncio

from fastapi import HTTPException

from app.auth import require_api_key
from app import config


def test_api_key_rejects_missing(monkeypatch):
    monkeypatch.setattr(config, "API_KEY", "secret")

    async def run():
        try:
            await require_api_key(None)
            raise AssertionError("should raise")
        except HTTPException as exc:
            assert exc.status_code == 401

    asyncio.run(run())


def test_api_key_accepts_valid(monkeypatch):
    monkeypatch.setattr(config, "API_KEY", "secret")

    async def run():
        await require_api_key("secret")

    asyncio.run(run())
