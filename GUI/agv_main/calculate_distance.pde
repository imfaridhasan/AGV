class Haversine {
  int earth = 6371;
  double startLat, startLong, endLat, endLong;

  Haversine() {    
  }
  
  void setCoord(double TstartLat, double TstartLong, double TendLat, double TendLong) {
    startLat = TstartLat;
    startLong = TstartLong;
    endLat = TendLat;
    endLong = TendLong;
  }
  
  void setStart(double TstartLat, double TstartLong) {
    startLat = TstartLat;
    startLong = TstartLong;    
  }
  
  void setEnd(double TendLat, double TendLong) {    
    endLat = TendLat;
    endLong = TendLong;
  }

  double count() {
    double dLat  = radians((float)(endLat - startLat));
    double dLong = radians((float)(endLong - startLong));
    startLat = radians((float)startLat);
    endLat   = radians((float)endLat);
    double a = haversin(dLat) + cos((float)startLat) * cos((float)endLat) * haversin(dLong);
    double c = 2 * atan2(sqrt((float)a), sqrt((float)(1 - a)));
    return earth * c * 1000;
  }

  double haversin(double val) {
    return pow(sin((float)(val/2)), 2);
  }
}
