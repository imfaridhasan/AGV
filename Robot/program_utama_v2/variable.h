int targetDegree,headingDegrees,point,headingCorrectionPID,counterBattery;

int kecepatan,majumundur,kirikanan,errorSteering,errorSteeringMap;

float roll,pitch;

float batteryOne,batteryTwo,rawbatteryOne,rawbatteryTwo;

float latitude,longitude;

float turnAngle2,turnAngle3;
 
//steering things
int mapAngle, desiredAngle, error, pSteering, pwmSteering,startMission, steeringAvg;

//recive serial
float readLat[100];
float readLon[100];
int totalPoint;

unsigned long timestamp;

int satellite;

//float batteryOne,batteryTwo;

//gpsMonth,gpsDay,gpsYear,gpsHour,gpsMinute,gpsSecond,
