/*
 PIN INFORMATION 
 31 Sen Kanan
 33 Sen Kiri
 39 Mundur
 41 Stop
*/

int ledState = LOW;

unsigned long previousMillis = 0;

const long interval = 500;  

void millisLed() {
  if (timestamp - previousMillis >= interval) {
    previousMillis = timestamp;

    if (ledState == LOW) {
      ledState = HIGH;
    } 
    else {
      ledState = LOW;
    }
    
  }
}

void setupLED(){
  pinMode(31, OUTPUT);
  pinMode(33, OUTPUT);
  pinMode(35, OUTPUT);
  pinMode(37, OUTPUT);
  pinMode(39, OUTPUT);
  pinMode(41, OUTPUT);
  digitalWrite(31, LOW);
  digitalWrite(33, LOW);
  digitalWrite(35, LOW);
  digitalWrite(37, LOW);
  digitalWrite(39, LOW);
  digitalWrite(41, LOW);
}

void blinkLED(int PIN, int CONDITION){
  if(CONDITION==1){
    digitalWrite(PIN, ledState);
  }
  else{
    digitalWrite(31, LOW);
    digitalWrite(33, LOW);
    digitalWrite(35, LOW);
    digitalWrite(37, LOW);
    digitalWrite(39, LOW);
  //  digitalWrite(41, LOW);
  }
}

void onLED(int PIN, int CONDITION){
  if(CONDITION==1){
    digitalWrite(PIN, HIGH);
  }
  else{
    digitalWrite(35, LOW);
    digitalWrite(37, LOW);
    digitalWrite(39, LOW);
    digitalWrite(41, LOW);
  }
}
