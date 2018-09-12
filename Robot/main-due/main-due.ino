#include "variable.h"
//#include "compass.h" //sudah di nano soalnya
#include "gps.h"

void setup() {
  setupLcd();
  setupBattery;
  setupButton();
  setupMotor();
  //setupCompass(); //sudah di nano soalnya
  setupSerial();
  //setupInterrupt(); //interrupt ga kepake
}

void loop() {
  //updateCompass(); //sudah di nano soalnya
  updateGPS();
  readNano();
  sendSerialProcessing();
  receiveSerialProcessing();
  //displaySerial();
  checkBattery();
  displayBattery();


  if (headingDegrees > 180) {
    targetDegree = map(headingDegrees, 180, 360, -180, 0);
  }
  else if (headingDegrees < 180) {
    targetDegree = headingDegrees;
  }

  if (headingDegrees>30 || headingDegrees<-30){
    PID=2;
    }
  else{
    PID=5;
    }
  if (point >= 1 && targetDegree >= 15 || point >= 1 && targetDegree <= -15 ) {

    headingCorrectionPID = targetDegree * PID;
    if (headingCorrectionPID > 80) {
      headingCorrectionPID = 80;
    }
    if (headingCorrectionPID < -80) {
      headingCorrectionPID = -80;
    }
    checkHeading();
  }
  else  {
    if (point > 0) {
      setMotor(-100, -100);
    }

    if (point == 0) {
      setMotor(0, 0);
    }
  }
}
