import json

from app import state as state_mod


def test_load_state_forces_auto_mode_off(tmp_path, monkeypatch):
    data_dir = tmp_path / "data"
    data_dir.mkdir()
    state_file = data_dir / "rover_state.json"
    state_file.write_text(
        json.dumps(
            {
                "auto_mode": True,
                "movement": {"direction": "forward"},
                "mine_status": "Aucune mine",
            }
        ),
        encoding="utf-8",
    )
    monkeypatch.setattr(state_mod, "DATA_DIR", data_dir)
    monkeypatch.setattr(state_mod, "STATE_FILE", state_file)
    state_mod.rover_state["auto_mode"] = True
    state_mod.rover_state["movement"] = {"direction": "forward"}
    state_mod.load_state()
    assert state_mod.rover_state["auto_mode"] is False
    assert state_mod.rover_state["movement"]["direction"] == "stop"
