"""Parcours E2E API (ESP32 mocké) : auth → calibrate → sensors → map → auto."""

from unittest.mock import AsyncMock, patch

import pytest
from fastapi.testclient import TestClient

from app.state import rover_state, update_state


@pytest.fixture()
def client():
    update_state(
        sensor_data=None,
        gps={"latitude": 12.37, "longitude": -1.52, "angle": 0, "obstacles": 0, "mines": 0},
        mine_status="Aucune mine",
        mine_events=[],
        path=[],
        auto_mode=False,
        calibration={"calibrated": False},
        calibration_buffer=[
            {"metal": 100, "magnetic_field": 40},
            {"metal": 110, "magnetic_field": 45},
            {"metal": 105, "magnetic_field": 42},
            {"metal": 108, "magnetic_field": 44},
            {"metal": 102, "magnetic_field": 41},
            {"metal": 106, "magnetic_field": 43},
            {"metal": 104, "magnetic_field": 40},
            {"metal": 109, "magnetic_field": 46},
        ],
        movement={"direction": "stop"},
        coverage={"phase": "leg", "pattern": "lawnmower"},
    )
    with patch(
        "app.services.esp32_client.send_move",
        new_callable=AsyncMock,
        return_value={"ok": True},
    ), patch(
        "app.services.esp32_client.ping_esp32",
        new_callable=AsyncMock,
        return_value={"reachable": True},
    ), patch(
        "app.main.send_move",
        new_callable=AsyncMock,
        return_value={"ok": True},
    ):
        from app.main import app

        with TestClient(app) as c:
            yield c


HEADERS = {"X-API-Key": "rover-secret-key"}


def test_e2e_calibrate_detect_map_auto(client: TestClient):
    # Auth
    assert client.get("/sensors/", headers=HEADERS).status_code == 200
    assert client.get("/sensors/").status_code == 401

    # Calibrate
    cal = client.post("/sensors/calibrate", headers=HEADERS)
    assert cal.status_code == 200
    assert cal.json()["ok"] is True
    assert cal.json()["calibration"]["calibrated"] is True

    # Clean reading — no mine
    r = client.post(
        "/sensors/",
        headers=HEADERS,
        json={
            "metal": 110,
            "magnetic_field": 45,
            "distance": 15,
            "temperature": 28,
            "humidity": 40,
        },
    )
    assert r.json()["mine_detected"] is False

    # Hot reading above baseline+delta → mine once
    hot = {
        "metal": 250,
        "magnetic_field": 120,
        "distance": 12,
        "temperature": 28,
        "humidity": 40,
    }
    r1 = client.post("/sensors/", headers=HEADERS, json=hot)
    assert r1.json()["mine_detected"] is True
    assert r1.json()["mine_event_recorded"] is True

    r2 = client.post("/sensors/", headers=HEADERS, json=hot)
    assert r2.json()["mine_event_recorded"] is False

    m = client.get("/map/", headers=HEADERS)
    assert m.status_code == 200
    assert m.json()["mines"] >= 1
    assert len(m.json()["mine_events"]) >= 1

    # Auto refused while mine active
    auto = client.post(
        "/control/auto", headers=HEADERS, json={"enabled": True}
    )
    assert auto.json()["auto_mode"] is False

    # Clear mine status then enable auto → coverage present
    update_state(mine_status="Aucune mine")
    auto2 = client.post(
        "/control/auto", headers=HEADERS, json={"enabled": True}
    )
    assert auto2.json()["auto_mode"] is True
    assert auto2.json().get("coverage", {}).get("pattern") == "lawnmower"

    health = client.get("/health", headers=HEADERS)
    assert health.json()["backend"] == "ok"
