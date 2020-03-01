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
      //println(jmlsatelit); //--> buat ngecek bor
    }

    datamasuk = float(split(usbString, ','));
    jmlsatelit = (int)datamasuk[0];
    jmlsatelit = (int)datamasuk[1];
    lat = datamasuk[2];
    lng = datamasuk[3];
    headingraw = (int)datamasuk[4];
    roll = (float)datamasuk[5];
    pitch = (float)datamasuk[6];
    baterai1raw = datamasuk[7];
    baterai1raw=map(baterai1raw,90,720,0,12.2);
    baterai1raw=constrain(baterai1raw, 0, 12.6);
    baterai2raw = datamasuk[8];
    baterai2raw=map(baterai2raw,260,555,0,11.6);
    baterai2raw=constrain(baterai2raw, 0, 12.6);
    
    //println(datamasuk);
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
  if (serial_conect==1) {  
    kirim = "*"+","+nilaiperintah + "," + i;
    for (int a=1; a<=i; a++){
      kirim+="," + tklat[a] + "," + tklon[a];
    }
    kirim+="\n \r";
    
    //kirimperintah='#'+nilaiperintah+"\n \r";
  }
}

