float distance,angleDeg;

void calcDistance(float gpsLat1, float gpsLong1, float gpsLat2, float gpsLong2) {
  float distLat = abs(gpsLat1 - gpsLat2) * 111194.9;
  float distLong = 111194.9 * abs(gpsLong1 - gpsLong2) * cos(radians((gpsLat1 + gpsLat2) / 2));
  distance = sqrt(pow(distLat, 2) + pow(distLong, 2));
}

void calcAngle(float lat,float lon,float lat2,float lon2){
  float teta1 = radians(lat);
  float teta2 = radians(lat2);
  float delta1 = radians(lat2-lat);
  float delta2 = radians(lon2-lon);

  //==================Heading Formula Calculation================//

  float y = sin(delta2) * cos(teta2);
  float x = cos(teta1)*sin(teta2) - sin(teta1)*cos(teta2)*cos(delta2);
  float brng = atan2(y,x);
  brng = degrees(brng);// radians to degrees
  brng = ( ((int)brng + 360) % 360 ); 
  angleDeg=brng;
}
