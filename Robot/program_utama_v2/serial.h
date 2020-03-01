void setupSerial() {
  Serial.begin(57600);   //USB
  Serial1.begin(9600);   //ARDUINO NANO
  Serial2.begin(9600);   //GPS
  Serial3.begin(57600);  //TELEMETRY
}

void readSerial() {
//    if (Serial.available() > 0) {
//      if (Serial.find('*')) {   
//          startMission=Serial.parseInt(); 
//          startMission=Serial.parseInt(); 
//          totalPoint = Serial.parseInt();
//          for(int i=1;i<=totalPoint;i++){
//          readLat[i] = Serial.parseFloat();
//          readLon[i] = Serial.parseFloat();
//          }  
//      }
//    }

  if (Serial3.available() > 0) {
    if (Serial3.find('*')) {   
          startMission=Serial3.parseInt(); 
          totalPoint = Serial3.parseInt();
          for(int i=1;i<=totalPoint;i++){
          readLat[i] = Serial3.parseFloat();
          readLon[i] = Serial3.parseFloat();
          }
    }
  }
}

void sendSerialProcessing() {

//  Serial.print("Data 1 : ");
//  Serial.print(data1); Serial.print("\t");
//  Serial.print("Data 2 : ");
//  Serial.print(data2); Serial.print("\t");
//  Serial.print("mapAngle : ");
//  Serial.print(mapAngle); Serial.print("\t");
//  Serial.print("desiredAngle : ");
//  Serial.print(desiredAngle); Serial.print("\t");
//  Serial.print("error : ");
//  Serial.print(error); Serial.print("\t");
//  Serial.print("p : ");
//  Serial.print(pSteering); Serial.print("\t");
//  Serial.print("pwmSteering : ");
//  Serial.print(pwmSteering); Serial.print("\t");
//  Serial.print("\n");

//  Serial.print('*');
//  Serial.print(satellite);
//  Serial.print(",");
//  Serial.print(satellite);
//  Serial.print(",");
//  Serial.print(latitude, 6);
//  Serial.print(",");
//  Serial.print(longitude, 6);
//  Serial.print(",");
//  Serial.print(headingDegrees);
//  Serial.print(",");
//  Serial.print(roll);
//  Serial.print(",");
//  Serial.print(pitch);
//  Serial.print(",");
//  Serial.print(batteryOne,2);
//  Serial.print(",");
//  Serial.print(batteryTwo,2);
//  Serial.print(",");
//  Serial.print(mydata);
//  Serial.print(",");
//  Serial.print(angleDeg);
//  Serial.print(",");
//  Serial.print(errorSteering);
//  Serial.print(",");
//  Serial.print(startMission);
//  Serial.print(",");
//  Serial.print(totalPoint);
//  Serial.print(",");
//  Serial.print(readLat[1]);
//  Serial.print(",");
//  Serial.print(readLon[1]);
//  Serial.print(",");
//  Serial.print(distance);
//  Serial.print(",");
//  Serial.print(timestamp);
//  Serial.println();

  Serial3.print('*');
  Serial3.print(satellite);
  Serial3.print(",");
  Serial3.print(satellite);
  Serial3.print(",");
  Serial3.print(latitude, 6);
  Serial3.print(",");
  Serial3.print(longitude, 6);
  Serial3.print(",");
  Serial3.print(headingDegrees);
  Serial3.print(",");
  Serial3.print(roll);
  Serial3.print(",");
  Serial3.print(pitch);
  Serial3.print(",");
  Serial3.print(batteryOne,2);
  Serial3.print(",");
  Serial3.print(batteryTwo,2);
  Serial3.print(",");
  Serial3.print(steeringAvg);
  Serial3.print(",");
  Serial3.print(angleDeg);
  Serial3.print(",");
  Serial3.print(errorSteering);
  Serial3.print(",");
  Serial3.print(startMission);
  Serial3.print(",");
  Serial3.print(totalPoint);
  Serial3.print(",");
  Serial3.print(readLat[1]);
  Serial3.print(",");
  Serial3.print(readLon[1]);
  Serial3.print(",");
  Serial3.print(distance);
  Serial3.print(",");
  Serial3.print(desiredAngle);
  Serial3.print(",");
  Serial3.print(turnAngle3);
  Serial3.print(",");
  Serial3.print(timestamp);
  Serial3.println();

}
