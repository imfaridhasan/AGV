#include "interrupt.h"
#include "motor.h"
#include "calculate.h"

int kecepatan,majumundur,kirikanan,data1,data2;

const int numReadings = 20;
 
//steering things
int mapAngle, desiredAngle, error, pSteering, pwmSteering,startEngine;

int readings[numReadings];
int readIndex = 0;
int total = 0;
int average = 0;

int inputPin = A2;

void setup() {
  Serial.begin(115200);
  Serial3.begin(57600);
  setupMotor();
  setupInterrupt(); 
  pinMode(inputPin, INPUT);
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }
}

void loop() {
  if (Serial.available() > 0) {
    if (Serial.find('*')) {
        data1 = Serial.parseInt();
        data2 = Serial.parseInt();
        if (desiredAngle!=data1){
          desiredAngle=data1;
        }
        if (startEngine!=data2){
          startEngine=data2;
        }
    }
  }
  
  total = total - readings[readIndex];
  int mydata = analogRead(inputPin);
  readings[readIndex] = mydata;
  total = total + readings[readIndex];
  readIndex = readIndex + 1;
  if (readIndex >= numReadings) {
    readIndex = 0;
  }
  average = total / numReadings;
  mapAngle = map(average, 430, 1010, -30, 30);

  error=desiredAngle-mapAngle;
  pSteering=10;
  pwmSteering=error*pSteering;
  pwmSteering=constrain(pwmSteering, -255, 255);
  setSteering(pwmSteering);

  Serial.print("Data 1 : ");
  Serial.print(data1); Serial.print("\t");
  Serial.print("Data 2 : ");
  Serial.print(data2); Serial.print("\t");
  Serial.print("mapAngle : ");
  Serial.print(mapAngle); Serial.print("\t");
  Serial.print("desiredAngle : ");
  Serial.print(desiredAngle); Serial.print("\t");
  Serial.print("error : ");
  Serial.print(error); Serial.print("\t");
  Serial.print("p : ");
  Serial.print(pSteering); Serial.print("\t");
  Serial.print("pwmSteering : ");
  Serial.print(pwmSteering); Serial.print("\t");
  
  Serial.print("\n");
  
  if(startEngine==1){
    setMotor(150,150);
  }
  else{
    setMotor(0,0);
  }
}


