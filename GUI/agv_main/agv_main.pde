import processing.serial.Serial;
import processing.video.*;
import controlP5.*;
PFont font, font1, font2;
PImage headingcm, L, R, L45, R45, LTAJAM, RTAJAM, S, U, redgps, greengps, yellowgps, logougm, gps0, gps1, gps2, gps3, gps4, gps5, sensor, sensorred, bateraiimg, bateraiimgmerah, gradientbk,gradientbkflip;
ControlP5 cp5;
Serial serial;
Capture cam;

import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;

UnfoldingMap currentMap;
UnfoldingMap map1;
UnfoldingMap map2;
UnfoldingMap map3;

CompassUI compass;
BarScaleUI barScale;
Haversine hv = new Haversine();

//PImage compassImg = loadImage("compass_white.png");

Location labDTE = new Location(-7.765806, 110.374816);
Location location = new Location(-7.765806, 110.374816);
Location klikpoint = new Location(-7.765806, 110.374816);
Location klikpointmin = new Location(-7.765806, 110.374816);
Location derloc1 = new Location(0, 0);
Location derloc2 = new Location(0, 0);

//UART Variable
int serial_conect = 0;
int commListMax;
int[] data = null;

Textlabel txtlblWhichcom; 
ListBox commListbox;
ListBox portlist;

// coded by Eberhard Rensch
// Truncates a long port name for better (readable) display in the GUI
String shortifyPortName(String portName, int maxlen)  
{
  String shortName = portName;
  if (shortName.startsWith("/dev/")) shortName = shortName.substring(5);  
  if (shortName.startsWith("tty.")) shortName = shortName.substring(4); // get rid off leading tty. part of device name
  if (portName.length()>maxlen) shortName = shortName.substring(0, (maxlen-1)/2) + "~" +shortName.substring(shortName.length()-(maxlen-(maxlen-1)/2));
  if (shortName.startsWith("cu.")) shortName = "";// only collect the corresponding tty. devices
  return shortName;
}



//data-data
int switchbuttonvar;
float baterai1raw=7.45,baterai2raw=7.45;
float baterai=map(baterai1raw,0,14.7,0,100);
float baterai1=map(baterai2raw,0,14.7,0,100);
int jmlsatelit=10;
float[] datamasuk;
float  jarak, jarakpertama, roll, pitch;
float tklatnow, tklonnow,lat=-7.765806, lng=110.374816;
double[] tklat = new double[100];
double[] tklon = new double[100];
int i=0, l=0, derajatselisih=0, derajatbelok, heading, headingraw, sudutbelokbulat, camtoggle, toggleinfo, zoomrightnow;
float totaljarak, p1x, p1y, p2x, p2y, p3x, p3y;
double angleDeg, p12, p13, p23, sudutbelok, derajatarahbelok;
String kirim;

public void setup() {
  background(255);
  //  fullscreen();
  cp5 = new ControlP5(this);


  font = loadFont("SegoeUI.vlw");
  font1 = loadFont("SegoeUI-Semibold.vlw");
  font2 = createFont("Arial bold", 9, false);

  headingcm = loadImage("heading.png");
  L = loadImage("L.png");
  R = loadImage("R.png");
  L45 = loadImage("L45.png");
  R45 = loadImage("R45.png");
  LTAJAM = loadImage("LTAJAM.png");
  RTAJAM = loadImage("RTAJAM.png");
  S = loadImage("S.png");
  U = loadImage("U.png");
  redgps = loadImage("redgps.png");
  greengps = loadImage("greengps.png");
  yellowgps = loadImage("yellowgps.png");
  logougm = loadImage("logougm.png");
  gps0 = loadImage("gps0.png");
  gps1 = loadImage("gps1.png");
  gps2 = loadImage("gps2.png");
  gps3 = loadImage("gps3.png");
  gps4 = loadImage("gps4.png");
  gps5 = loadImage("gps5.png");
  sensor = loadImage("sensor.png");
  sensorred = loadImage("sensorred.png");
  bateraiimg = loadImage("baterai.png");
  bateraiimgmerah = loadImage("bateraired.png");
  gradientbk = loadImage("gradientblack.png");
  gradientbkflip = loadImage("gradientblackflip.png");
  size(1280, 650, P2D);
  //frame.setResizable(true);
  noStroke();



  // map = new UnfoldingMap(this, new Google.GoogleMapProvider());
  // map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  // map1 = new UnfoldingMap(this,  100, 100, 291,164,new OpenStreetMap.OpenStreetMapProvider());
  map1 = new UnfoldingMap(this, new OpenStreetMap.OpenStreetMapProvider());
  map2 = new UnfoldingMap(this, new Google.GoogleMapProvider());
  map3 = new UnfoldingMap(this, new Microsoft.AerialProvider());
  currentMap = map1;

  map1.setTweening(true);
  map2.setTweening(true);
  map3.setTweening(true);
  map1.setZoomRange(3, 19);
  map2.setZoomRange(3, 19);
  map3.setZoomRange(3, 19);
  currentMap.zoomAndPanTo(new Location(-7.765806, 110.374816), 6);
  MapUtils.createDefaultEventDispatcher(this, map1, map2, map3);

  compass = new CompassUI(this, currentMap);
  barScale = new BarScaleUI(this, currentMap, width-160, height-60);
  barScale.setStyle(color(60, 120), 5, 5, font1);
  smooth(4);

  //camera
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[1]);//36
    cam.start();
  } 
  cp5.addToggle("togglecam")
    .setPosition(1082, 38)
      .setSize(40, 15)
        .setValue(true)
          .setMode(ControlP5.SWITCH)
            .setColorBackground(0) 
              .setCaptionLabel("camera") 
                .setColorActive( color( 24, 179, 113 ) )
                .setColorCaptionLabel(0)
                  ;  

  cp5.addToggle("toggleinfo")
    .setPosition(1025, 38)
      .setSize(40, 15)
        .setValue(true)
          .setMode(ControlP5.SWITCH)
            .setColorBackground(0) 
              .setCaptionLabel("info") 
                .setColorActive( color( 24, 179, 113 ) )
                  .setColorCaptionLabel(0)
                  ; 

  cp5.addButton("switchbutton")
    .setPosition(255, height-188)
      .setSize(60, 20)
        .setColorBackground(0) 
          .setColorForeground(color( 24, 179, 113 ) )
            .setCaptionLabel("Switch view") 
              .setColorActive( color( 24, 179, 113 ) )
                .hide()
                  ;


  //serial things
  // new Serial(this, "COM14", 57600).bufferUntil(ENTER);
  setup_UART();
  
}

public void draw() {
  
  if (cam.available() == true) {
      cam.read();
    }
//  println(mouseX, mouseY);
  background(0);

  if( switchbuttonvar==1){
    image(cam, 0, 0, width, 720);
  infoCamera();
  }
  loadmap();
  if( switchbuttonvar==0){
  infoCamera();
  }

  infoLegenda();
  infoData();
  infoCopyright();
  infoTopbar();
 

  kirimSerial();
  
}//void draw abis disini


public void keyPressed() {
  if (key == '+')
    currentMap.zoomIn();
  if (key == '-')
    currentMap.zoomOut();
  if (key == 'r')
    currentMap.rotate(0.1f);
  if (key == 'l')
    currentMap.rotate(-0.1f);
  if (key == '1') {
    zoomrightnow=currentMap.getZoomLevel();
    currentMap = map1;
    if (jmlsatelit>0 && lat!=0 && lng!=0) {
     currentMap.zoomAndPanTo(new Location(lat, lng), zoomrightnow);
     }
     else{
     currentMap.zoomAndPanTo(new Location(-7.765806, 110.374816), zoomrightnow);}
    compass = new CompassUI(this, currentMap);
    barScale = new BarScaleUI(this, currentMap, width-160, height-60);
    barScale.setStyle(color(60, 120), 5, 5, font1);
  } else if (key == '2') {
    zoomrightnow=currentMap.getZoomLevel();
    currentMap = map2;
    if (jmlsatelit>0 && lat!=0 && lng!=0) {
     currentMap.zoomAndPanTo(new Location(lat, lng), zoomrightnow);
     }
     else{
     currentMap.zoomAndPanTo(new Location(-7.765806, 110.374816), zoomrightnow);}
    compass = new CompassUI(this, currentMap);
    barScale = new BarScaleUI(this, currentMap, width-160, height-60);
    barScale.setStyle(color(60, 120), 5, 5, font1);
  } else if (key == '3') {
    zoomrightnow=currentMap.getZoomLevel();
    currentMap = map3;
    if (jmlsatelit>0 && lat!=0 && lng!=0) {
     currentMap.zoomAndPanTo(new Location(lat, lng), zoomrightnow);
     }
     else{
     currentMap.zoomAndPanTo(new Location(-7.765806, 110.374816), zoomrightnow);}
    compass = new CompassUI(this, currentMap);
    barScale = new BarScaleUI(this, currentMap, width-160, height-60);
    barScale.setStyle(color(60, 120), 5, 5, font1);
  }
}

void mouseClicked() {
  //  if(mouseY>100 || mouseX<width-150 && mouseY<100 && mouseY>55){
  //  if (mouseButton == LEFT) {
  //    i=i+1;
  //    tklatnow=location.getLat();
  //    tklonnow=location.getLon(); 
  //    tklat[i]=tklatnow;
  //    tklon[i]=tklonnow;
  //  }
  //  if (mouseButton == RIGHT) {
  //    i=i-1;
  //    if (i<=0) {
  //      i=0;
  //    }
  //  }
  //  }
  boolean region = true;
  if (mouseY < 80) {
    region = false;
  }
  else if((mouseX > 1140)&&(mouseY < 125)){
    if(commListbox.isOpen()==true){
    region = false;}
  }
  else if((mouseX < 328)&&(mouseY > 447)){
    if (camtoggle==0 && toggleinfo==1) {
    region = false;}
  }
  if((mouseX < 328)&&(mouseY > 328)){
    if (camtoggle==0 && toggleinfo==0) {
    region = false;}
  }
  if((mouseX < 587)&&(mouseY > 508)){
    if ((camtoggle==0 && toggleinfo==0) || (camtoggle==1) ) {
    region = false;}
  }
  if(camtoggle==0 && switchbuttonvar==1 ){
    region = false;
  }
  
  
  

  if (region) {
    if (mouseButton == LEFT) {
      i=i+1;
      tklatnow=location.getLat();
      tklonnow=location.getLon(); 
      //String ya=location.getLat();
      tklat[i]=tklatnow;
      tklon[i]=tklonnow;
    }
    if (mouseButton == RIGHT) {
      i=i-1;
      if (i<=0) {
        i=0;
      }
    }
  }
}

void togglecam(boolean theFlag) {
  if (theFlag==true) {
    camtoggle=1;
  } else {
    camtoggle=0;
 
  }
  println("camera toggle");
}
void toggleinfo(boolean theFlag) {
  if (theFlag==true) {
    toggleinfo=1;
  } else {
    toggleinfo=0;
  
  }
  println("info toggle");
}

void switchbutton(boolean theFlag) {
  switchbuttonvar=switchbuttonvar+1;
  if (switchbuttonvar>=2) {
    switchbuttonvar=0;
  }
  if (switchbuttonvar==1) {
   
    map1.setTweening(false);
    currentMap.mapDisplay.resize(291, 164);
     zoomrightnow=currentMap.getZoomLevel();
     if (jmlsatelit>0 && lat!=0 && lng!=0) {
     currentMap.zoomAndPanTo(new Location(lat, lng), zoomrightnow);
     }
     else{
     currentMap.zoomAndPanTo(new Location(-7.765806, 110.374816), zoomrightnow);}
    map1.setTweening(true);
     cp5.getController("togglecam").lock();
  }if (switchbuttonvar==0) {
    
    map1.setTweening(false);
    currentMap.mapDisplay.resize(width, height);
    zoomrightnow=currentMap.getZoomLevel();
    if (jmlsatelit>0 && lat!=0 && lng!=0) {
     currentMap.zoomAndPanTo(new Location(lat, lng), zoomrightnow);
     }
     else{
     currentMap.zoomAndPanTo(new Location(-7.765806, 110.374816), zoomrightnow);}
    map1.setTweening(true);
    cp5.getController("togglecam").unlock();
  }
  println("nilai i:"+switchbuttonvar);
}

