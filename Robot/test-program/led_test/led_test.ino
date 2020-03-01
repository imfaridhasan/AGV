#define L_SIGN 0
#define R_SIGN 1
#define REVERSE 2
#define BREAK 3
#define LOW_BEAM 4
#define HIGH_BEAM 5

const int pinLed[6] = {A2, A3, A4, A5, A6, A7};

void setup() {
  for (int i = 0; i < 6; i++) {
    pinMode(pinLed[i], OUTPUT);
  }
}

void loop() {
  // Hazard Mode
  for (int i = 0; i < 5; i++) {
    digitalWrite(pinLed[L_SIGN], HIGH);
    digitalWrite(pinLed[R_SIGN], HIGH);
    delay(500);
    digitalWrite(pinLed[L_SIGN], LOW);
    digitalWrite(pinLed[R_SIGN], LOW);
    delay(500);
  }
//
//  // L_SIGN Mode
//  for (int i = 0; i < 6; i++) {
//    digitalWrite(pinLed[L_SIGN], HIGH);
//    delay(600);
//    digitalWrite(pinLed[L_SIGN], LOW);
//    delay(600);
//  }
//
//  // R_SIGN Mode
//  for (int i = 0; i < 6; i++) {
//    digitalWrite(pinLed[R_SIGN], HIGH);
//    delay(600);
//    digitalWrite(pinLed[R_SIGN], LOW);
//    delay(600);
//  }
//
//  // Reverse Mode
//  digitalWrite(pinLed[REVERSE], HIGH);
//  delay(5000);
//  digitalWrite(pinLed[REVERSE], LOW);
//
//  // Break Mode
//  digitalWrite(pinLed[BREAK], HIGH);
//  delay(5000);
//  digitalWrite(pinLed[BREAK], LOW);
//
//  // Low Beam Mode
//  digitalWrite(pinLed[LOW_BEAM], HIGH);
//  delay(5000);
//  digitalWrite(pinLed[LOW_BEAM], LOW);
//
//  // High Beam Mode
//  digitalWrite(pinLed[HIGH_BEAM], HIGH);
//  delay(5000);
//  digitalWrite(pinLed[HIGH_BEAM], LOW);
}
