void setup_UART()
{
  //Comport List Selection                   
  commListbox = cp5.addListBox("portComList", 1140, 65, 100, 240) ; // make a listbox and populate it with the available comm ports

  commListbox.captionLabel().set("PORT COM");
  commListbox.setColorBackground(0); 
  commListbox.setColorActive( color( 24, 179, 113 ) ); 
  commListbox.setColorForeground( color( 24, 179, 113 ) );
  commListbox.setBarHeight(15) ; 
  commListbox.close();
  for (int i=0; i<Serial.list ().length; i++) 
  {

    String pn = shortifyPortName(Serial.list()[i], 13);
    if (pn.length() >0 ) commListbox.addItem(pn, i); // addItem(name,value)
    commListMax = i;
  }

  commListbox.addItem("Close Comm", ++commListMax); // addItem(name,value)
  // text label for which comm port selected
  txtlblWhichcom = cp5.addTextlabel("txtlblWhichcom", "No Port Selected", 1137, 37).setColor(0); // textlabel(name,text,x,y)
}

//initialize the serial port selected in the listBox
void InitSerial(float portValue) 
{
  if (portValue < commListMax) {
    String portPos = Serial.list()[int(portValue)];
    txtlblWhichcom.setValue("Connected = " + shortifyPortName(portPos, 8));
    serial = new Serial(this, portPos, 57600);
    serial.bufferUntil('\n');
    serial_conect=1;
  } else 
  {
    txtlblWhichcom.setValue("Not Connected");
    serial.clear();
    serial.stop();
    serial_conect=0;
  }
}

void controlEvent(ControlEvent theControlEvent)
{
  if (theControlEvent.isGroup()) if (theControlEvent.name()=="portComList") InitSerial(theControlEvent.group().value()); // initialize the serial port selected
}



void serialEvent(Serial s) {
  try {
    String usbString = s.readStringUntil ('\n');
    println(usbString);

    if (usbString != null) 
    {
      usbString = trim(usbString);
      //println(usbString); //--> buat ngecek bor
    }

    datamasuk = float(split(usbString, ','));
    jmlsatelit = int(datamasuk[0]);
    lat = datamasuk[1];
    lng = datamasuk[2];
    headingraw = (int)datamasuk[3];
    roll = (float)datamasuk[4];
    pitch = (float)datamasuk[5];
  }
  catch(RuntimeException e)
  {
    println("Serial event is not null");
    jmlsatelit = 0;
    lat = 0;
    lng = 0;
    heading = 0;
  }
}

void kirimSerial() {
  //kirim = "*"+","+derajatbelok+","+i+","+666+"\n \r";

  if (serial_conect==1) {  
    int depanlat= int(tklat[1]);
    int depanlon= int(tklon[1]);
    float belakanglat= tklat[1]-depanlat;
    float belakanglon= tklon[1]-depanlon;
    kirim = "*" + "," + tklat[1] + "," + tklon[1] + "," +"#" + "\n \r";
    serial.write(kirim);
    println(kirim + "  "+ depanlat+belakanglat+ "  "+depanlon+belakanglon);
  }
}

