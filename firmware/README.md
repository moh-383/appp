# Firmware ESP32 — Rover

## Libs Arduino

- ArduinoJson, TinyGPSPlus, ESP32Servo
- Adafruit ADS1X15, Adafruit VL53L0X
- **Adafruit AHTX0** (+ Adafruit Unified Sensor) — temp/humidité CAM
- DHT sensor library — DevKit seulement

## Config

`esp32_rover/config.h` : Wi‑Fi, `BACKEND_URL`, `API_KEY`, `BOARD_ESP32CAM`.

## ESP32-CAM

| Fonction | GPIO / bus | Note |
| --- | --- | --- |
| Moteurs | 13, 15, 14, 2 | |
| Servo | 12 | pull-down 10k |
| ADS1115 + VL53 + **AHT20** | I2C 26/27 | |
| PIR | 4 | ne pas utiliser flash LED |
| GPS | RX3 TX1 | détacher pour flash |
| Stream MJPEG | FreeRTOS core 0 | loop/télémétrie sur core 1 |

## Auth

`X-API-Key` ou `?api_key=` sur `/move`, servos, `/stream`.
