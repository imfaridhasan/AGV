#include <DueTimer.h>

/*FYI aja timer due bakalan ganggu si servo
cek aja disini beb, https://github.com/ivanseidel/DueTimer */


void setupInterrupt() {
Timer5.getAvailable().attachInterrupt(interruptNano).start(30000); 
Timer.getAvailable().attachInterrupt(interruptSerial).start(20000); 
}

void interruptNano() {
  //readNano();
}

void interruptSerial() {
  //sendSerialProcessing();
  //sendSerialProcessing();
  //receiveSerialProcessing();
}

