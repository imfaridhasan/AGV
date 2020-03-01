#include "remote.h"
#include "interrupt.h"
#include "motor.h"

float f_majumundur;
int kecepatan,majumundur,kirikanan;

void setup() {
  setupMotor();
  setupRemote();
  Serial.begin(115200);
  Serial3.begin(57600);
  setupInterrupt(); 
}

void loop() {
  //setMotor(i,i);
  //setSteering(170);
  getPulse();
 // delay(5);
  kecepatan=map(ch[2],1100,1700,50,255);
  majumundur=map(ch[1],2000,1300,-100,100);
  f_majumundur=float(majumundur)/100;
  kirikanan=map(ch[0],1000,1700,-255,255);

  Serial.print(kecepatan); Serial.print("\t");
  Serial.print(majumundur); Serial.print("\t");
  Serial.print(f_majumundur); Serial.print("\t");
  Serial.print(kirikanan); Serial.print("\t");
  Serial.print("\n");

  int actkecepatan = kecepatan*int(f_majumundur);
  actkecepatan=constrain(actkecepatan,-255,255);

  setMotor(actkecepatan,actkecepatan);
  //setSteering(170);
}


