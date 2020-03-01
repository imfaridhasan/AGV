#include <Arduino.h>
#include <Wire.h>
#include <HMC5883L_Simple.h>

HMC5883L_Simple Compass;

void setupCompass() {
  Wire.begin();
  Compass.SetDeclination(0, 50, 'E');  //Yogyakarta
  Compass.SetSamplingMode(COMPASS_SINGLE);
  Compass.SetScale(COMPASS_SCALE_130);
  Compass.SetOrientation(COMPASS_HORIZONTAL_X_NORTH);
}

void updateCompass() {
  headingDegrees = Compass.GetHeadingDegrees(); 
  headingDegrees=map(headingDegrees,0,359,359,0);
  headingDegrees=headingDegrees-80;
  if(headingDegrees<0){
    headingDegrees=headingDegrees+360;
  }
  //heading = map(heading, north, 359 + north, 0, 359);
}
