#include <Wire.h>
#include <TimerOne.h>
#include <Kalman.h> // Source: https://github.com/TKJElectronics/KalmanFilter
#include <HMC5883L_Simple.h>
#define RESTRICT_PITCH // Comment out to restrict roll to ±90deg instead - please read: http://www.freescale.com/files/sensors/doc/app_note/AN3461.pdf

char START_BYTE = '*'; //three characters used for Serial communication
char DELIMITER = ',';
char END_BYTE = '#';

Kalman kalmanX; // Create the Kalman instances
Kalman kalmanY;

HMC5883L_Simple Compass;

/*compass data */
float heading;

float parameterLowpass=0;
float filter_low_pass=0;
float roll=0;

/* IMU Data */
double accX, accY, accZ;
double gyroX, gyroY, gyroZ;
int16_t tempRaw;

double gyroXangle, gyroYangle; // Angle calculate using the gyro only
double compAngleX, compAngleY; // Calculated angle using a complementary filter
double kalAngleX, kalAngleY; // Calculated angle using a Kalman filter

float raw_pitch = 0;
float lowpass_pitch =0;
float complementary_pitch=0;
float kalman_pitch=0;

float raw_roll = 0;
float lowpass_roll=0;
float complementary_roll=0;
float kalman_roll=0;

uint32_t timer;
uint8_t i2cData[14]; // Buffer for I2C data

void setup() {
  Serial.begin(9600);
  setup_imu();
  setup_kalman();
  Timer1.initialize(30000); // set a timer of length 100000 microseconds (or 0.1 sec - or 10Hz => the led will blink 5 times, 5 cycles of on-and-off, per second)
  Timer1.attachInterrupt( Send_to_Processing ); // attach the service routine here
  
}

void loop() 
{
  Read_Sensor_IMU();
  Read_Sensor_Compass();
  //Serial.println(kalman_pitch);
  //Send_to_Processing();
  //delay(50);
}
  




