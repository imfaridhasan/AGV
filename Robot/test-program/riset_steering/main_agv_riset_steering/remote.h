#define RC_NUM_CHANNELS  4

#define RUDDER  3
#define THROTTLE  2
#define ELEVATOR  1
#define AILERON  0

const int remote_pin[RC_NUM_CHANNELS] = {31, 33, 35, 37};

uint16_t rc_values[RC_NUM_CHANNELS];
uint32_t rc_start[RC_NUM_CHANNELS];
volatile uint16_t rc_shared[RC_NUM_CHANNELS];

int mapping[4][RC_NUM_CHANNELS] = {{1098, 1923, 1090, 1080},
  /*                            */{1927, 1094, 1908, 1900},
  /*                            */{ -170, -100, 50, -100},
  /*                            */{ 170,  100, 255, 100}
};

int aileron_data, throttle_data, elevator_data;

void calcInput(uint8_t channel, uint8_t input_pin) {
  if (digitalRead(input_pin) == HIGH) {
    rc_start[channel] = micros();
  } else {
    uint16_t rc_compare = (uint16_t)(micros() - rc_start[channel]);
    rc_shared[channel] = rc_compare;
  }
}

void calcRudder() {
  calcInput(RUDDER, remote_pin[RUDDER]);
}
void calcThrottle() {
  calcInput(THROTTLE, remote_pin[THROTTLE]);
}
void calcElevator() {
  calcInput(ELEVATOR, remote_pin[ELEVATOR]);
}
void calcAileron() {
  calcInput(AILERON, remote_pin[AILERON]);
}

void remoteSetup() {
  for (int i = 0; i < RC_NUM_CHANNELS; i++) {
    pinMode(remote_pin[i], INPUT);
  }

  enableInterrupt(remote_pin[RUDDER], calcRudder, CHANGE);
  enableInterrupt(remote_pin[THROTTLE], calcThrottle, CHANGE);
  enableInterrupt(remote_pin[ELEVATOR], calcElevator, CHANGE);
  enableInterrupt(remote_pin[AILERON], calcAileron, CHANGE);
}

void rcReadValues() {
  noInterrupts();
  memcpy(rc_values, (const void *)rc_shared, sizeof(rc_shared));
  interrupts();
}

void remoteMapping() {
  aileron_data = map(rc_values[AILERON], mapping[0][AILERON], mapping[1][AILERON], mapping[2][AILERON], mapping[3][AILERON]);
  throttle_data = map(rc_values[THROTTLE], mapping[0][THROTTLE], mapping[1][THROTTLE], mapping[2][THROTTLE], mapping[3][THROTTLE]);
  elevator_data = map(rc_values[ELEVATOR], mapping[0][ELEVATOR], mapping[1][ELEVATOR], mapping[2][ELEVATOR], mapping[3][ELEVATOR]);
}

