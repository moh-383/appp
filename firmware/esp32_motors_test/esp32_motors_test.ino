/*
 * TEST MOTEURS SEUL — ESP32-CAM + L298N + 2 moteurs DC
 * Pas de Wi‑Fi, pas de GPS, pas de backend.
 *
 * Dans le Moniteur série (115200), tapez puis Entrée :
 *   f = avancer
 *   b = reculer
 *   g = gauche
 *   d = droite
 *   s = stop
 */

// Broches L298N (comme le rover)
#define IN1 13
#define IN2 15
#define IN3 14
#define IN4 2

void stopMotors() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);
}

void forward() {
  digitalWrite(IN1, HIGH); digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH); digitalWrite(IN4, LOW);
}

void backward() {
  digitalWrite(IN1, LOW); digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW); digitalWrite(IN4, HIGH);
}

void left() {
  digitalWrite(IN1, LOW); digitalWrite(IN2, HIGH);
  digitalWrite(IN3, HIGH); digitalWrite(IN4, LOW);
}

void right() {
  digitalWrite(IN1, HIGH); digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW); digitalWrite(IN4, HIGH);
}

void setup() {
  Serial.begin(115200);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
  stopMotors();
  Serial.println();
  Serial.println("=== TEST MOTEURS ESP32-CAM ===");
  Serial.println("f=avance  b=recule  g=gauche  d=droite  s=stop");
}

void loop() {
  if (!Serial.available()) return;
  char c = Serial.read();
  if (c == 'f' || c == 'F') { forward();  Serial.println("AVANCE"); }
  if (c == 'b' || c == 'B') { backward(); Serial.println("RECULE"); }
  if (c == 'g' || c == 'G') { left();     Serial.println("GAUCHE"); }
  if (c == 'd' || c == 'D') { right();    Serial.println("DROITE"); }
  if (c == 's' || c == 'S') { stopMotors(); Serial.println("STOP"); }
}
