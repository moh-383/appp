/*
 * Firmware rover — ESP32-CAM / DevKit
 * Libs: ArduinoJson, DHT (DevKit), Adafruit AHTX0 (CAM), TinyGPSPlus,
 *       ESP32Servo, Adafruit ADS1X15, Adafruit_VL53L0X
 */

#include "config.h"
#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include <TinyGPSPlus.h>
#include <ESP32Servo.h>

#if DHT_ENABLED
#include <DHT.h>
DHT dht(PIN_DHT, DHT_TYPE);
#endif

#if AHT20_ENABLED
#include <Adafruit_AHTX0.h>
Adafruit_AHTX0 aht;
bool ahtOk = false;
#endif

#if ADS1115_ENABLED
#include <Adafruit_ADS1X15.h>
Adafruit_ADS1115 ads;
bool adsOk = false;
#endif

#if VL53_ENABLED
#include <Adafruit_VL53L0X.h>
Adafruit_VL53L0X vl53;
bool vl53Ok = false;
#endif

#if CAMERA_ENABLED
#include "esp_camera.h"
#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27
#define Y9_GPIO_NUM       35
#define Y8_GPIO_NUM       34
#define Y7_GPIO_NUM       39
#define Y6_GPIO_NUM       36
#define Y5_GPIO_NUM       21
#define Y4_GPIO_NUM       19
#define Y3_GPIO_NUM       18
#define Y2_GPIO_NUM        5
#define VSYNC_GPIO_NUM    25
#define HREF_GPIO_NUM     23
#define PCLK_GPIO_NUM     22

struct StreamJob {
  WiFiClient client;
  SemaphoreHandle_t done;
};
#endif

WebServer server(HTTP_PORT);
TinyGPSPlus gps;
HardwareSerial GPSSerial(1);
Servo armServo;

String lastDirection = "stop";
bool armRunning = false;
bool cameraOk = false;
unsigned long lastTelemetryMs = 0;
unsigned long lastCommandMs = 0;
unsigned long lastWifiAttemptMs = 0;

float lastLat = 0, lastLon = 0;
int lastAngle = 0;

bool isAuthorized() {
#if !REQUIRE_API_KEY
  return true;
#else
  if (server.hasHeader("X-API-Key") && server.header("X-API-Key") == String(API_KEY)) {
    return true;
  }
  if (server.hasArg("api_key") && server.arg("api_key") == String(API_KEY)) {
    return true;
  }
  return false;
#endif
}

void rejectUnauthorized() {
  server.send(401, "application/json", "{\"error\":\"unauthorized\"}");
}

void applyMove(const String& dir) {
  lastDirection = dir;
  lastCommandMs = millis();
  if (dir == "forward") {
    digitalWrite(PIN_IN1, HIGH); digitalWrite(PIN_IN2, LOW);
    digitalWrite(PIN_IN3, HIGH); digitalWrite(PIN_IN4, LOW);
  } else if (dir == "backward") {
    digitalWrite(PIN_IN1, LOW); digitalWrite(PIN_IN2, HIGH);
    digitalWrite(PIN_IN3, LOW); digitalWrite(PIN_IN4, HIGH);
  } else if (dir == "left") {
    digitalWrite(PIN_IN1, LOW); digitalWrite(PIN_IN2, HIGH);
    digitalWrite(PIN_IN3, HIGH); digitalWrite(PIN_IN4, LOW);
  } else if (dir == "right") {
    digitalWrite(PIN_IN1, HIGH); digitalWrite(PIN_IN2, LOW);
    digitalWrite(PIN_IN3, LOW); digitalWrite(PIN_IN4, HIGH);
  } else {
    digitalWrite(PIN_IN1, LOW); digitalWrite(PIN_IN2, LOW);
    digitalWrite(PIN_IN3, LOW); digitalWrite(PIN_IN4, LOW);
  }
}

void serviceWatchdog() {
  if (lastDirection != "stop" && (millis() - lastCommandMs) > CMD_WATCHDOG_MS) {
    applyMove("stop");
  }
}

int scaleAdsTo4095(int16_t raw) {
  if (raw < 0) raw = 0;
  long scaled = (long)raw * 4095L / (long)ADS_FULL_SCALE_RAW;
  if (scaled > 4095) scaled = 4095;
  return (int)scaled;
}

float readDistanceCm() {
#if VL53_ENABLED
  if (vl53Ok) {
    VL53L0X_RangingMeasurementData_t m;
    vl53.rangingTest(&m, false);
    if (m.RangeStatus != 4) {
      return m.RangeMilliMeter / 10.0;
    }
  }
#endif
#if ULTRASONIC_ENABLED
  digitalWrite(PIN_TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(PIN_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG, LOW);
  long duration = pulseIn(PIN_ECHO, HIGH, 30000);
  if (duration == 0) return -1;
  return duration * 0.0343 / 2.0;
#endif
  return -1;
}

void readAnalogSensors(int& gas, int& magnetic, int& metal) {
  gas = 0; magnetic = 0; metal = 0;
#if ADS1115_ENABLED
  if (adsOk) {
    gas = scaleAdsTo4095(ads.readADC_SingleEnded(0));
    magnetic = scaleAdsTo4095(ads.readADC_SingleEnded(1));
    metal = scaleAdsTo4095(ads.readADC_SingleEnded(2));
    return;
  }
#endif
#if NATIVE_ADC_ENABLED
  gas = analogRead(PIN_GAS);
  magnetic = analogRead(PIN_MAGNETIC);
  metal = analogRead(PIN_METAL);
#endif
}

void pollGps() {
#if GPS_ENABLED
  while (GPSSerial.available() > 0) {
    if (gps.encode(GPSSerial.read())) {
      if (gps.location.isValid()) {
        lastLat = gps.location.lat();
        lastLon = gps.location.lng();
      }
      if (gps.course.isValid()) {
        lastAngle = (int)gps.course.deg();
      }
    }
  }
#endif
}

void ensureWifi() {
  if (WiFi.status() == WL_CONNECTED) return;
  unsigned long now = millis();
  if (now - lastWifiAttemptMs < WIFI_RETRY_MS) return;
  lastWifiAttemptMs = now;
  Serial.println("WiFi reconnect...");
  WiFi.disconnect();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}

#if CAMERA_ENABLED
bool initCamera() {
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.frame_size = FRAMESIZE_VGA;
  config.pixel_format = PIXFORMAT_JPEG;
  config.grab_mode = CAMERA_GRAB_WHEN_EMPTY;
  config.fb_location = CAMERA_FB_IN_PSRAM;
  config.jpeg_quality = 12;
  config.fb_count = psramFound() ? 2 : 1;
  if (psramFound()) config.grab_mode = CAMERA_GRAB_LATEST;
  return esp_camera_init(&config) == ESP_OK;
}

void streamTask(void* pv) {
  StreamJob* job = static_cast<StreamJob*>(pv);
  WiFiClient client = job->client;
  client.print(
    "HTTP/1.1 200 OK\r\n"
    "Content-Type: multipart/x-mixed-replace; boundary=frame\r\n\r\n");
  while (client.connected()) {
    camera_fb_t* fb = esp_camera_fb_get();
    if (!fb) {
      vTaskDelay(pdMS_TO_TICKS(10));
      continue;
    }
    client.printf(
      "--frame\r\nContent-Type: image/jpeg\r\nContent-Length: %u\r\n\r\n",
      fb->len);
    client.write(fb->buf, fb->len);
    client.print("\r\n");
    esp_camera_fb_return(fb);
    vTaskDelay(pdMS_TO_TICKS(40)); // laisse loop() (core 1) tourner
  }
  xSemaphoreGive(job->done);
  vTaskDelete(NULL);
}

void handleStream() {
  if (!isAuthorized()) { rejectUnauthorized(); return; }
  if (!cameraOk) {
    server.send(503, "text/plain", "camera unavailable");
    return;
  }
  // Stream sur core 0 ; handler attend (yield) → loop/télémétrie/watchdog continuent
  StreamJob* job = new StreamJob();
  job->client = server.client();
  job->done = xSemaphoreCreateBinary();
  BaseType_t ok = xTaskCreatePinnedToCore(
    streamTask, "mjpeg", STREAM_STACK_SIZE, job, 2, NULL, 0);
  if (ok != pdPASS) {
    delete job;
    server.send(503, "text/plain", "stream task failed");
    return;
  }
  xSemaphoreTake(job->done, portMAX_DELAY);
  vSemaphoreDelete(job->done);
  delete job;
}
#endif

void handleStatus() {
  StaticJsonDocument<384> doc;
  doc["ok"] = true;
  doc["ip"] = WiFi.localIP().toString();
  doc["wifi"] = WiFi.status() == WL_CONNECTED;
  doc["direction"] = lastDirection;
  doc["arm"] = armRunning;
  doc["camera"] = cameraOk;
  doc["lat"] = lastLat;
  doc["lon"] = lastLon;
  String body;
  serializeJson(doc, body);
  server.send(200, "application/json", body);
}

void handleMove() {
  if (!isAuthorized()) { rejectUnauthorized(); return; }
  if (!server.hasArg("dir")) {
    server.send(400, "application/json", "{\"error\":\"missing dir\"}");
    return;
  }
  String dir = server.arg("dir");
  if (dir != "forward" && dir != "backward" && dir != "left" && dir != "right" && dir != "stop") {
    server.send(400, "application/json", "{\"error\":\"invalid dir\"}");
    return;
  }
  applyMove(dir);
  server.send(200, "application/json", "{\"ok\":true,\"direction\":\"" + dir + "\"}");
}

void handleStartServo() {
  if (!isAuthorized()) { rejectUnauthorized(); return; }
  armRunning = true;
  armServo.write(SERVO_ANGLE_ACTIVE);
  server.send(200, "application/json", "{\"ok\":true,\"arm\":\"start\"}");
}

void handleStopServo() {
  if (!isAuthorized()) { rejectUnauthorized(); return; }
  armRunning = false;
  armServo.write(SERVO_ANGLE_REST);
  server.send(200, "application/json", "{\"ok\":true,\"arm\":\"stop\"}");
}

void postJson(const String& path, const String& payload) {
  if (WiFi.status() != WL_CONNECTED) return;
  HTTPClient http;
  http.begin(String(BACKEND_URL) + path);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("X-API-Key", API_KEY);
  int code = http.POST(payload);
  Serial.printf("POST %s -> %d\n", path.c_str(), code);
  http.end();
}

void readTempHumidity(float& temperature, float& humidity) {
  temperature = 0;
  humidity = 0;
#if AHT20_ENABLED
  if (ahtOk) {
    sensors_event_t humidityEvent, tempEvent;
    aht.getEvent(&humidityEvent, &tempEvent);
    temperature = tempEvent.temperature;
    humidity = humidityEvent.relative_humidity;
    return;
  }
#endif
#if DHT_ENABLED
  temperature = dht.readTemperature();
  humidity = dht.readHumidity();
  if (isnan(temperature) || isnan(humidity)) {
    temperature = 0;
    humidity = 0;
  }
#endif
}

void pushTelemetry() {
  pollGps();

  float temperature = 0, humidity = 0;
  readTempHumidity(temperature, humidity);

  float distance = readDistanceCm();
  int gas = 0, magnetic = 0, metal = 0;
  readAnalogSensors(gas, magnetic, metal);
  int motion = 0;
#if PIR_ENABLED
  motion = digitalRead(PIN_PIR);
#endif

  StaticJsonDocument<512> sensors;
  sensors["temperature"] = temperature;
  sensors["humidity"] = humidity;
  sensors["gas"] = gas;
  sensors["distance"] = distance;
  sensors["motion"] = motion;
  sensors["magnetic_field"] = magnetic;
  sensors["metal"] = metal;
  sensors["ir_detected"] = false;
  String sensorsBody;
  serializeJson(sensors, sensorsBody);
  postJson("/sensors/", sensorsBody);

  StaticJsonDocument<256> mapDoc;
  mapDoc["latitude"] = lastLat;
  mapDoc["longitude"] = lastLon;
  mapDoc["angle"] = lastAngle;
  mapDoc["obstacles"] = (distance > 0 && distance < 25) ? 1 : 0;
  String mapBody;
  serializeJson(mapDoc, mapBody);
  postJson("/map/", mapBody);
}

bool wifiCredentialsConfigured() {
  return String(WIFI_SSID) != "VOTRE_WIFI" && String(WIFI_PASSWORD) != "VOTRE_MOT_DE_PASSE";
}

void setup() {
  Serial.begin(115200);
  delay(200);

  if (!wifiCredentialsConfigured()) {
    Serial.println("!!! Configurez WIFI_SSID / WIFI_PASSWORD dans config.h puis re-flashez !!!");
  }

  pinMode(PIN_IN1, OUTPUT);
  pinMode(PIN_IN2, OUTPUT);
  pinMode(PIN_IN3, OUTPUT);
  pinMode(PIN_IN4, OUTPUT);
#if ULTRASONIC_ENABLED
  pinMode(PIN_TRIG, OUTPUT);
  pinMode(PIN_ECHO, INPUT);
#endif
#if PIR_ENABLED
  pinMode(PIN_PIR, INPUT);
  Serial.println("PIR GPIO4 (CAM: ne pas utiliser flash LED)");
#endif

  Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);

#if ADS1115_ENABLED
  adsOk = ads.begin(0x48);
  if (adsOk) ads.setGain(GAIN_ONE);
  Serial.printf("ADS1115: %s\n", adsOk ? "OK" : "FAIL");
#endif

#if VL53_ENABLED
  vl53Ok = vl53.begin();
  Serial.printf("VL53L0X: %s\n", vl53Ok ? "OK" : "FAIL");
#endif

#if AHT20_ENABLED
  ahtOk = aht.begin();
  Serial.printf("AHT20: %s\n", ahtOk ? "OK" : "FAIL");
#endif

  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  armServo.setPeriodHertz(50);
  armServo.attach(PIN_SERVO, 500, 2400);
  armServo.write(SERVO_ANGLE_REST);
  applyMove("stop");

#if DHT_ENABLED
  dht.begin();
#endif
#if GPS_ENABLED
  GPSSerial.begin(GPS_BAUD, SERIAL_8N1, PIN_GPS_RX, PIN_GPS_TX);
  Serial.println("GPS UART1 — détacher pour flash USB");
#endif

#if CAMERA_ENABLED
  cameraOk = initCamera();
  Serial.printf("Camera: %s\n", cameraOk ? "OK" : "FAIL");
#endif

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("WiFi");
  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED && (millis() - start) < WIFI_CONNECT_TIMEOUT_MS) {
    delay(400);
    Serial.print(".");
  }
  Serial.println();
  if (WiFi.status() == WL_CONNECTED) {
    Serial.print("ESP32 IP: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("WiFi non connecté — retry dans loop()");
  }

  const char* hdrs[] = {"X-API-Key"};
  server.collectHeaders(hdrs, 1);

  server.on("/status", HTTP_GET, handleStatus);
  server.on("/move", HTTP_GET, handleMove);
  server.on("/start_servo", HTTP_GET, handleStartServo);
  server.on("/stop_servo", HTTP_GET, handleStopServo);
  server.on("/", HTTP_GET, handleStatus);
#if CAMERA_ENABLED
  server.on("/stream", HTTP_GET, handleStream);
#endif
  server.begin();
}

void loop() {
  ensureWifi();
  server.handleClient();
  pollGps();
  serviceWatchdog();

  unsigned long now = millis();
  if (now - lastTelemetryMs >= TELEMETRY_INTERVAL_MS) {
    lastTelemetryMs = now;
    pushTelemetry();
  }
}
