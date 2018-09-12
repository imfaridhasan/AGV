#include <TinyGPS++.h>

TinyGPSPlus gps;

void updateGPS() {
  if (Serial2.available() > 0) {
    if (gps.encode(Serial2.read())) {
      satellite = gps.satellites.value();
      if (gps.location.isValid()) {
        latitude = (gps.location.lat(), 6);
        longitude = (gps.location.lng(), 6);
      }
      else {
        latitude = 0;
        longitude = 0;
      }
      if (gps.time.isValid()) {
        gpsHour = gps.time.hour();
        gpsMinute = gps.time.minute();
        gpsSecond = gps.time.second();
      }
      else {
        gpsHour = 0;
        gpsMinute = 0;
        gpsSecond = 0;
      }
      if (gps.date.isValid()) {
        gpsMonth = gps.date.month();
        gpsDay = gps.date.day();
        gpsYear = gps.date.year();
      }
      else {
        gpsMonth = 0;
        gpsDay = 0;
        gpsYear = 0;
      }
    }
  }
}

