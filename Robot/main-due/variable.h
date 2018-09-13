float roll,pitch,heading,latitude,longitude,PID,batteryOne,batteryTwo,rawbatteryOne,rawbatteryTwo;
int gpsMonth,gpsDay,gpsYear,gpsHour,gpsMinute,gpsSecond,targetDegree,headingDegrees,point,satellite,headingCorrectionPID,counterBattery;
unsigned long lastCommunicate;
int north=0,south=180,east=90,west=270;
unsigned long previousMillis = 0;
unsigned long interval = 10;
