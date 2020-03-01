class Haversine {
  int earth = 6371;
  float startLat, startLong, endLat, endLong;

  Haversine() {    
  }
  
  void setCoord(float TstartLat, float TstartLong, float TendLat, float TendLong) {
    startLat = TstartLat;
    startLong = TstartLong;
    endLat = TendLat;
    endLong = TendLong;
  }
  
  void setStart(float TstartLat, float TstartLong) {
    startLat = TstartLat;
    startLong = TstartLong;    
  }
  
  void setEnd(float TendLat, float TendLong) {    
    endLat = TendLat;
    endLong = TendLong;
  }

  float count() {
    float dLat  = radians(endLat - startLat);
    float dLong = radians(endLong - startLong);
    startLat = radians(startLat);
    endLat   = radians(endLat);
    float a = haversin(dLat) + cos(startLat) * cos(endLat) * haversin(dLong);
    float c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earth * c * 1000;
  }

  float haversin(float val) {
    return pow(sin(val/2), 2);
  }
}
