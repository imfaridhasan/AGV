void setup_UART()
{
  //Comport List Selection                   
  commListbox = cp5.addListBox("portComList",1170,38,80,240); // make a listbox and populate it with the available comm ports

  commListbox.captionLabel().set("PORT COM");commListbox.setColorBackground(0); commListbox.setColorActive( color( 24,179,113 ) ); commListbox.setColorForeground( color( 24,179,113 ) );
  commListbox.close();
  for(int i=0;i<Serial.list().length;i++) 
  {
    
    String pn = shortifyPortName(Serial.list()[i], 13);
    if (pn.length() >0 ) commListbox.addItem(pn,i); // addItem(name,value)
    commListMax = i;
  }
  
  commListbox.addItem("Close Comm",++commListMax); // addItem(name,value)
  // text label for which comm port selected
  txtlblWhichcom = cp5.addTextlabel("txtlblWhichcom","No Port Selected",1168,15); // textlabel(name,text,x,y)
  
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
    jmlsatelit = int(datamasuk[1]);
    lat = datamasuk[2];
    lng = datamasuk[3];
    headingraw = (int)datamasuk[4];
    roll = (float)datamasuk[5];
    pitch = (float)datamasuk[6];

    //kirim ke arduino
    s.write(kirim);
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
  kirim = "#"+derajatbelok+","+i+"\n \r";
}

