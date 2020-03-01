#define dir1A   9
#define dir2A   10
#define pwmA    11

#define dir1B   6
#define dir2B   7
#define pwmB    8

#define dir1C   3
#define dir2C   4
#define pwmC    5

void setupMotor() {
  pinMode(pwmA, OUTPUT);
  pinMode(pwmB, OUTPUT);
  pinMode(pwmC, OUTPUT);

  pinMode(dir1A, OUTPUT);
  pinMode(dir1B, OUTPUT);
  pinMode(dir1C, OUTPUT);

  pinMode(dir2A, OUTPUT);
  pinMode(dir2B, OUTPUT);
  pinMode(dir2C, OUTPUT);
}

void setMotor(float L, float R) {
  if (L >= 0) {
    digitalWrite(dir1A, 0);
    digitalWrite(dir2A, 1);
    analogWrite(pwmA, L);
  } else {
    digitalWrite(dir1A, 1);
    digitalWrite(dir2A, 0);
    analogWrite(pwmA, -1 * L);
  }
  if (R >= 0) {
    digitalWrite(dir1B, 0);
    digitalWrite(dir2B, 1);
    analogWrite(pwmB, R);
  } else {
    digitalWrite(dir1B, 1);
    digitalWrite(dir2B, 0);

    analogWrite(pwmB, -1 * R);
  }
}

void setSteering(float L) {
  if (L >= 0) {
    digitalWrite(dir1C, 0);
    digitalWrite(dir2C, 1);
    analogWrite(pwmC, L);
  } else {
    digitalWrite(dir1C, 1);
    digitalWrite(dir2C, 0);
    analogWrite(pwmC, -1 * L);
  }
}
