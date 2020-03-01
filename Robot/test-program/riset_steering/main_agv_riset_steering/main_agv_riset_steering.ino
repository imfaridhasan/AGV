#include <EnableInterrupt.h>
#include "remote.h"
#include "motor.h"

#define SERIAL_PORT_SPEED 115200

const int numReadings = 20;

int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

int inputPin = A7;

void setup() {
  Serial.begin(SERIAL_PORT_SPEED);
  remoteSetup();
  pinMode(inputPin, INPUT);
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }
}

void loop() {
  // subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
  int mydata = analogRead(inputPin);
  readings[readIndex] = mydata;
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  }

  // calculate the average:
  average = total / numReadings;
  // send it to the computer as ASCII digits
  //  Serial.print(mydata);
  //  Serial.print("\t");
  int mapAngle = map(average, 444, 784, -30, 30);
  Serial.print(mapAngle);
  Serial.print("\t");
  Serial.println(average);
  rcReadValues();
  remoteMapping();
  float f_elevator_data = float(elevator_data) / 100;
  float pwm_base = throttle_data * f_elevator_data;
  int i_pwm_base = constrain(pwm_base, -255, 255);
//  Serial.print(rc_values[THROTTLE]); Serial.print("\t");
//  Serial.print(rc_values[ELEVATOR]); Serial.print("\t");
//  Serial.print(rc_values[AILERON]); Serial.print("\t");
//
//  Serial.print(throttle_data); Serial.print("\t");
//  Serial.print(elevator_data); Serial.print("\t");
//  Serial.print(f_elevator_data); Serial.print("\t");
//  Serial.print(pwm_base); Serial.print("\t");
//  Serial.print(i_pwm_base); Serial.print("\t");
//  Serial.print(aileron_data); Serial.print("\t");
//  Serial.print("\n");
  setMotor(i_pwm_base, i_pwm_base);
  //  testSteering();
  setSteering(aileron_data);
}
