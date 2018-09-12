void setupBattery(){
  pinMode(A4,INPUT);
  pinMode(A5,INPUT);
  }

void checkBattery(){
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;
    counterBattery = counterBattery + 1;
    if (counterBattery == 2) {
      counterBattery = 0;
    }
  }
  if (counterBattery == 1) {
      rawbatteryOne=analogRead(A4); //Arduino
      rawbatteryTwo=analogRead(A5); //Motor
    }
    batteryOne=map(rawbatteryOne, 0, 908, 0, 11); 
    batteryTwo=map(rawbatteryTwo, 0, 938, 0, 11.4); 
}
