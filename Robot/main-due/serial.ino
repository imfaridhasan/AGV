void setupSerial() {
  Serial.begin(115200); //USB
  Serial1.begin(9600);  //ARDUINO NANO
  Serial2.begin(9600);  //GPS
  Serial3.begin(57600); //TELEMETRY
}

void sendSerialProcessing() {
  Serial.write('*');
  Serial.print(satellite);
  Serial.print(",");
  Serial.print(latitude, 6);
  Serial.print(",");
  Serial.print(longitude, 6);
  Serial.print(",");
  Serial.print(headingDegrees);
  Serial.print(",");
  Serial.print(roll);
  Serial.print(",");
  Serial.print(pitch);
  Serial.print(",");
  Serial.print(batteryOne,2);
  Serial.print(",");
  Serial.print(batteryTwo,2);
  Serial.print(",");
  Serial.write('#');
  Serial.println();
}

void receiveSerialProcessing() {
  static unsigned char data[255]={0}; 
  static unsigned char recivedData[255]={0}; 
       int i,msg;
            msg = Serial.available();
            
            if (msg>255) msg=0; //protection buffer
            if(msg > 0){for(i = 0; i < msg; i++){data[i] = Serial.read();}}
          
            if(data[0] == 255 && data[5] == 254) //packet data
            {
              recivedData[0] = data[1];
              recivedData[1]= data[2];
              recivedData[2]= data[3];
              recivedData[3]= data[4];
              headingDegrees=data[1]+data[2];
              point=data[3];
            }       
   //Serial.flush();
}

void readNano() {
  if (Serial1.available() > 0) {
    if (Serial1.find('*')) {
      roll = Serial1.parseFloat();
      pitch = Serial1.parseFloat();
      headingDegrees = Serial1.parseFloat();
//      Serial.print(roll);
//      Serial.print('\t');
//      Serial.print(pitch);
//      Serial.print('\t');
//      Serial.print(headingDegrees);
//      Serial.print('\n');
    }
  }
  else {
    Serial1.flush();
  }
}

