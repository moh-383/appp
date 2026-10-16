# Rover Data & Mine Detection App

## Lancer

```powershell
# Backend
cd backend
.\start.ps1

# App
cd ..\frontend
flutter pub get
flutter run
```

## Points clés

- **ESP32-CAM** : AHT20 (I2C) + PIR GPIO4, ADS/VL53, stream FreeRTOS
- Détection **calibrable terrain** (`POST /sensors/calibrate` ou bouton app)
- Auto **lawnmower GPS** (+ fallback temporel) + évitement ; off au reboot
- Auth `X-API-Key` ; health minimal ; TLS via reverse proxy

## Firmware

Configurer `WIFI_SSID` / `WIFI_PASSWORD` dans `firmware/esp32_rover/config.h` puis flasher.
