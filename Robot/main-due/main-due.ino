#include "variable.h"
//#include "compass.h" //sudah di nano soalnya
#include "gps.h"

void setup() {
  setupLcd();
  delay(5000);
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
  displaySerial();


  if (headingDegrees > 180) {
    targetDegree = map(headingDegrees, 180, 360, -180, 0);
  }
  else if (headingDegrees < 180) {
    targetDegree = headingDegrees;
  }
  if (point >= 1 && targetDegree >= 15 || point >= 1 && targetDegree <= -15 ) {

    headingCorrectionPID = targetDegree * 1.5;
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
