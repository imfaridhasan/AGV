const int numReadings = 100;

int readings1[numReadings];      // the readings from the analog input
int readings2[numReadings];  
int readIndex = 0;              // the index of the current reading
int total1 = 0;                  // the running total
int average1 = 0;                // the average
int total2 = 0;                  // the running total
int average2 = 0;  

double mapf(double val, double in_min, double in_max, double out_min, double out_max) {
    return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void setupBattery(){
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings1[thisReading] = 0;
  }
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings2[thisReading] = 0;
  }
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
      total1 = total1 - readings1[readIndex];
      readings1[readIndex] = analogRead(A4);
      total1 = total1 + readings1[readIndex];

      total2 = total2 - readings2[readIndex];
      readings2[readIndex] = analogRead(A5);
      total2 = total2 + readings2[readIndex];
      
      readIndex = readIndex + 1;

      average1 = total1 / numReadings;
      average2 = total2 / numReadings;


      if (readIndex >= numReadings) {
        readIndex = 0;
      }

      rawbatteryOne=average1; //Arduino
      rawbatteryTwo=average2; //Motor
    }
    batteryOne=mapf(rawbatteryOne, 0, 908, 0, 11); 
    batteryTwo=mapf(rawbatteryTwo, 0, 938, 0, 11.4); 
}

// Define the number of samples to keep track of. The higher the number, the
// more the readings will be smoothed, but the slower the output will respond to
// the input. Using a constant rather than a normal variable lets us use this
// value to determine the size of the readings array.



