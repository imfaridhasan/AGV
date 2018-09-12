#define dir1A   9
#define dir2A   10
#define pwmA    11
#define dir1B   6
#define dir2B   7
#define pwmB    8

void setupMotor() {
  pinMode(pwmA, OUTPUT);
  pinMode(pwmB, OUTPUT);
  pinMode(dir1A, OUTPUT);
  pinMode(dir1B, OUTPUT);
  pinMode(dir2A, OUTPUT);
  pinMode(dir2B, OUTPUT);
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


void checkHeading() {
  if (headingDegrees > 180) {
    targetDegree = map(headingDegrees, 180, 360, -180, 0);
  }
  else if (headingDegrees < 180) {
    targetDegree = headingDegrees;
  }
  if (targetDegree >= 10) {

check1:
    displayCheckOne();
    readNano();
    sendSerialProcessing();
    receiveSerialProcessing();

    if (headingDegrees > 180) {
      targetDegree = map(headingDegrees, 180, 360, -180, 0);
    }
    else if (headingDegrees < 180) {
      targetDegree = headingDegrees;
    }
    if (point >= 1) {
      steeringMotorPWM(1);
    }
    if (point == 0) {
      setMotor(0, 0);
    }
    if (targetDegree >= 5 || targetDegree <= -5 ) {
      goto out1;
    }

    else goto check1;

out1:
    delay(1);

  }

  if (targetDegree <= -10) {
check2:
    displayCheckTwo();
    readNano();
    sendSerialProcessing();
    receiveSerialProcessing();

    if (headingDegrees > 180) {
      targetDegree = map(headingDegrees, 180, 360, -180, 0);
    }
    else if (headingDegrees < 180) {
      targetDegree = headingDegrees;
    }
    if (point >= 1) {
      steeringMotorPWM(2);
    }
    if (point == 0) {
      setMotor(0, 0);
    }
    if (targetDegree >= 5 || targetDegree <= -5 ) {
      goto out2;
    }

    else goto check2;

out2:
    delay(1);
  }

}

void steeringMotorPWM(int arah) {
  if (arah == 1) {
    setMotor(headingCorrectionPID, -1 * (headingCorrectionPID));
  }
  else if (arah == 2) {
    setMotor(headingCorrectionPID, -1 * (headingCorrectionPID));
  }
}
