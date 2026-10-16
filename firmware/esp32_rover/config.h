#pragma once

// ============ RÉSEAU ============
#define WIFI_SSID        "VOTRE_WIFI"
#define WIFI_PASSWORD    "VOTRE_MOT_DE_PASSE"
#define BACKEND_URL      "http://192.168.100.12:8000"
#define API_KEY          "rover-secret-key"

// ============ CARTE ============
#define BOARD_ESP32CAM   1

#if BOARD_ESP32CAM
  #define CAMERA_ENABLED        1
  #define ADS1115_ENABLED       1
  #define VL53_ENABLED          1
  #define ULTRASONIC_ENABLED    0
  #define GPS_ENABLED           1
  #define NATIVE_ADC_ENABLED    0
  // DHT22 GPIO16 = PSRAM → remplacé par AHT20 I2C
  #define DHT_ENABLED           0
  #define AHT20_ENABLED         1
  // PIR sur GPIO4 (partage flash LED — ne pas utiliser le flash pendant la mission)
  #define PIR_ENABLED           1
  #define PIN_IN1   13
  #define PIN_IN2   15
  #define PIN_IN3   14
  #define PIN_IN4   2
  #define PIN_SERVO 12
  #define PIN_DHT   -1
  #define PIN_PIR   4
  #define PIN_GPS_RX 3
  #define PIN_GPS_TX 1
#else
  #define CAMERA_ENABLED        0
  #define ADS1115_ENABLED       0
  #define VL53_ENABLED          0
  #define ULTRASONIC_ENABLED    1
  #define GPS_ENABLED           1
  #define NATIVE_ADC_ENABLED    1
  #define DHT_ENABLED           1
  #define AHT20_ENABLED         0
  #define PIR_ENABLED           1
  #define PIN_IN1   12
  #define PIN_IN2   13
  #define PIN_IN3   14
  #define PIN_IN4   15
  #define PIN_SERVO 2
  #define PIN_DHT   16
  #define PIN_PIR   4
  #define PIN_GPS_RX 3
  #define PIN_GPS_TX 1
#endif

#define ALLOW_SENSOR_FALLBACK   0
#define REQUIRE_API_KEY         1

#define SERVO_ANGLE_ACTIVE    90
#define SERVO_ANGLE_REST      0
#define DHT_TYPE   DHT22

#define PIN_TRIG       25
#define PIN_ECHO       26
#define PIN_GAS        34
#define PIN_MAGNETIC   35
#define PIN_METAL      39
#define GPS_BAUD       9600

#define PIN_I2C_SDA    26
#define PIN_I2C_SCL    27

#define ADS_FULL_SCALE_RAW  26400

#define TELEMETRY_INTERVAL_MS  2000
#define HTTP_PORT              80
#define CMD_WATCHDOG_MS        1500
#define WIFI_CONNECT_TIMEOUT_MS 20000
#define WIFI_RETRY_MS          5000
#define STREAM_STACK_SIZE      10240
