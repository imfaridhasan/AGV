/*=================
  AGV MERCY MERAH
  last modified : 4 April 2019
  note :
  - sudah uji coba tapi masih belak belok sendiri gabisa lurus dan ini masih
  - penambahan loop pada steering agar supaya yang ini belom dicoba (sudah diganti dengan PID)
  - ada sedikit masalah kemarin di bagian headingdegrees kurang penambahan 360 jika kurang dari nol
=================*/
#include <SG_PID.h>
#include <movingAvg.h>
#include "variable.h"
#include "calculate.h"
#include "gps.h"
#include "serial.h"
#include "compass.h"
#include "interrupt.h"
#include "motor.h"
#include "led.h"
#include "battery.h"


pid steering;
movingAvg avgBat1(100),avgBat2(100),avgSteering(20);  

void setup() {
  avgBat1.begin();
  avgBat2.begin();
  avgSteering.begin();
  
  setupSerial();
  setupMotor();
  setupInterrupt();
  setupCompass();
  
  setupLED();
  setupBattery();

  pinMode(A2,INPUT); //steering feedback
  //steering.param(6, 4, 3.75, NORMAL);

  steering.param(6, 2.4, 3.75, NORMAL);
  steering.constraint(-200, 200);
  steering.setPoint(0);
  steering.readSensor(0);
  steering.timeSampling(1);

}

void loop() {
  rawbatteryOne= avgBat1.reading(analogRead(A8));
  rawbatteryTwo= avgBat2.reading(analogRead(A9));
  batteryOne=avgBat1.getAvg();
  batteryTwo=avgBat2.getAvg();
  avgSteering.reading(analogRead(A2));
  
  timestamp = millis();
  millisLed();
  updateCompass();
  updateGPS();
  readSerial();
  sendSerialProcessing();

  updateSteering();

  calcDistance(latitude,longitude,readLat[1],readLon[1]);
  calcAngle(latitude,longitude,readLat[1],readLon[1]);

  turnAngle2=angleDeg;
  
  errorSteering=headingDegrees-turnAngle2;  //pembacaan asli - arah tujuan yang di itung dari kalkulasi
  if (errorSteering<0) {
    errorSteering=errorSteering+360;
  }
  if(errorSteering<180){
   errorSteeringMap=map(errorSteering,0,180,0,-180);
  }
  if(errorSteering>180){
   errorSteeringMap=map(errorSteering,180,360,180,0);
  }

  desiredAngle=errorSteeringMap/1.2;

  desiredAngle=constrain(desiredAngle,-20,20);

  if(readLat[2]!=0 && readLon[2]!=0){
    calcAngle(readLat[1],readLon[1],readLat[2],readLon[2]);
    
    turnAngle3=turnAngle2-angleDeg;
    if (turnAngle3<0) {
      turnAngle3=turnAngle3+360;
    }
    
    if(turnAngle3>60 && turnAngle3<180 && distance<5 && readLat[1]!=0 && readLon[1]!=0){
      blinkLED(33,1);
    }
    else if(turnAngle3>180 && turnAngle3<300 && distance<5 && readLat[1]!=0 && readLon[1]!=0){
      blinkLED(31,1);
    }
    else {
      blinkLED(31,0);
      blinkLED(33,0);
    }
  }

//  if(errorSteeringMap<30 && errorSteeringMap>-30){
//    desiredAngle=map(errorSteeringMap, -90,90,-5, 5);
//  }
//
//  if(errorSteeringMap>30 || errorSteeringMap<-30){
//    desiredAngle=map(errorSteeringMap, -90,90,-20, 20);
//  }
//  else{
//    desiredAngle=0;
//  }

  if(distance>2 && readLat[1]!=0 && readLon[1]!=0 && startMission==1){
    setMotor(130,130);
    onLED(41,0);
  }
  else{
    setMotor(0,0);
    onLED(41,1);
    blinkLED(33,1);
    blinkLED(31,1);
  }

  if(distance<2 && distance!=0){
      for (int t=0; t<totalPoint; t++) {
       readLat[t]=readLat[t+1];
      }
      for (int t=0; t<totalPoint; t++) {
       readLon[t]=readLon[t+1];
      }
      totalPoint=totalPoint-1;
  }

//  if(totalPoint==0){
//    for(int t=0; t<=99; t++) {
//      readLat[t]=0;
//      readLon[t]=0;
//    }
//  }

}

void updateSteering(){
  steeringAvg=avgSteering.getAvg();
  
  //mapAngle = map(average, 430, 1010, -30, 30);  //mapping sensor potensio steering disini DUE
  mapAngle = map(steeringAvg, 260, 620, -30, 30);  //mapping sensor potensio steering disini MEGA

  steering.readSensor(mapAngle);
  steering.setPoint(desiredAngle);
  steering.calc();

  pwmSteering=steering.showPID();

  setSteering(pwmSteering);
}
