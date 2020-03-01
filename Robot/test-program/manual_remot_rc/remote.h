int dataPin[10] = { 31, 33, 35, 37};
int maping[4][10] = {{1080, 1900, 1080, 1080},
  /*               */{1900, 1080, 1890, 1900},
  /*               */{ -100, -100, 0, -100},
  /*               */{100, 100, 100, 100}
};

int ch[10];

void setupRemote() {
   for (int x = 0; x < 4; x++) {
    pinMode(dataPin[x], INPUT);
  }

  }

void getPulse() {
  for (int x = 0; x < 4; x++) {
    ch[x] = pulseIn(dataPin[x], HIGH);
    Serial.print(ch[x]);
    Serial.print("\t");
  }
  //Serial.print("\n");
}
