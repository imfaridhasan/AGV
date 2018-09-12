int button[]={A0,A1,A2,A3};

void setupButton() {
  for (int i = 0; i < 4; i++) {
    pinMode(button[i], INPUT);
    digitalWrite(button[i], HIGH);
  }
}
