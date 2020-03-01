float distance,brng;

void calcDistance(float gpsLat1, float gpsLong1, float gpsLat2, float gpsLong2) {
  float distLat = abs(gpsLat1 - gpsLat2) * 111194.9;
  float distLong = 111194.9 * abs(gpsLong1 - gpsLong2) * cos(radians((gpsLat1 + gpsLat2) / 2));
  distance = sqrt(pow(distLat, 2) + pow(distLong, 2));
}

void calcAngle(double lat1, double long1, double lat2,double long2){

    double dLon = (long2 - long1);
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double brng = atan2(y, x);

//    brng = toDegree(brng);
//    brng = (brng + 360) % 360;
//    brng = 360 - brng; // count degrees counter-clockwise - remove to make clockwise
}

