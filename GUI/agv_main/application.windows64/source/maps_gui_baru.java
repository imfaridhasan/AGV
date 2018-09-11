import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.Serial; 
import processing.video.*; 
import controlP5.*; 
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

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class maps_gui_baru extends PApplet {




PFont font, font1, font2;
PImage headingcm, L, R, L45, R45, LTAJAM, RTAJAM, S, U, redgps, greengps, yellowgps, logougm, gps0, gps1, gps2, gps3, gps4, gps5, sensor, sensorred, bateraiimg, bateraiimgmerah, gradientbk;
ControlP5 cp5;
Serial serial;
Capture cam;

















UnfoldingMap currentMap;
UnfoldingMap map1;
UnfoldingMap map2;
UnfoldingMap map3;

CompassUI compass;
BarScaleUI barScale;
Haversine hv = new Haversine();

//PImage compassImg = loadImage("compass_white.png");

Location labDTE = new Location(-7.765806f, 110.374816f);
Location location = new Location(-7.765806f, 110.374816f);
Location klikpoint = new Location(-7.765806f, 110.374816f);
Location klikpointmin = new Location(-7.765806f, 110.374816f);
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
public String shortifyPortName(String portName, int maxlen)  
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
float baterai=25;
float baterai1=50;
int jmlsatelit=10;
float[] datamasuk;
float lat, lng, tklatnow, tklonnow, jarak, jarakpertama, roll, pitch;
float[] tklat = new float[100];
float[] tklon = new float[100];
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
  currentMap.zoomAndPanTo(new Location(-7.765806f, 110.374816f), 6);
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
    .setPosition(1110, 13)
      .setSize(40, 15)
        .setValue(true)
          .setMode(ControlP5.SWITCH)
            .setColorBackground(0) 
              .setCaptionLabel("camera") 
                .setColorActive( color( 24, 179, 113 ) )
                  ;  

  cp5.addToggle("toggleinfo")
    .setPosition(1052, 13)
      .setSize(40, 15)
        .setValue(true)
          .setMode(ControlP5.SWITCH)
            .setColorBackground(0) 
              .setCaptionLabel("info") 
                .setColorActive( color( 24, 179, 113 ) )
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
  if (key == 'i')
 
    if (key == 'o')
  currentMap.mapDisplay.resize(width, height);
  
   zoomrightnow=currentMap.getZoomLevel();
  currentMap.setTweening(false);
    currentMap.zoomAndPanTo(new Location(-7.765806f, 110.374816f), zoomrightnow);
    currentMap.setTweening(true);
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
    currentMap.zoomAndPanTo(new Location(-7.765806f, 110.374816f), zoomrightnow);
    compass = new CompassUI(this, currentMap);
    barScale = new BarScaleUI(this, currentMap, width-160, height-60);
    barScale.setStyle(color(60, 120), 5, 5, font1);
  } else if (key == '2') {
    zoomrightnow=currentMap.getZoomLevel();
    currentMap = map2;
    currentMap.zoomAndPanTo(new Location(-7.765806f, 110.374816f), zoomrightnow);
    compass = new CompassUI(this, currentMap);
    barScale = new BarScaleUI(this, currentMap, width-160, height-60);
    barScale.setStyle(color(60, 120), 5, 5, font1);
  } else if (key == '3') {
    zoomrightnow=currentMap.getZoomLevel();
    currentMap = map3;
    currentMap.zoomAndPanTo(new Location(-7.765806f, 110.374816f), zoomrightnow);
    compass = new CompassUI(this, currentMap);
    barScale = new BarScaleUI(this, currentMap, width-160, height-60);
    barScale.setStyle(color(60, 120), 5, 5, font1);
  }
}

public void mouseClicked() {
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
  if (mouseY < 55) {
    region = false;
  }
  else if((mouseX > 1165)&&(mouseY < 111)){
    region = false;
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

public void togglecam(boolean theFlag) {
  if (theFlag==true) {
    camtoggle=1;
  } else {
    camtoggle=0;
 
  }
  println("camera toggle");
}
public void toggleinfo(boolean theFlag) {
  if (theFlag==true) {
    toggleinfo=1;
  } else {
    toggleinfo=0;
  
  }
  println("info toggle");
}

public void switchbutton(boolean theFlag) {
  switchbuttonvar=switchbuttonvar+1;
  if (switchbuttonvar>=2) {
    switchbuttonvar=0;
  }
  if (switchbuttonvar==1) {
   
    map1.setTweening(false);
    currentMap.mapDisplay.resize(291, 164);
     zoomrightnow=currentMap.getZoomLevel();
    currentMap.zoomAndPanTo(new Location(-7.765806f, 110.374816f), zoomrightnow);
    map1.setTweening(true);
     cp5.getController("togglecam").lock();
  }if (switchbuttonvar==0) {
    
    map1.setTweening(false);
    currentMap.mapDisplay.resize(width, height);
    zoomrightnow=currentMap.getZoomLevel();
    currentMap.zoomAndPanTo(new Location(-7.765806f, 110.374816f), zoomrightnow);
    map1.setTweening(true);
    cp5.getController("togglecam").unlock();
  }
  println("nilai i:"+switchbuttonvar);
}

class Haversine {
  int earth = 6371;
  float startLat, startLong, endLat, endLong;

  Haversine() {    
  }
  
  public void setCoord(float TstartLat, float TstartLong, float TendLat, float TendLong) {
    startLat = TstartLat;
    startLong = TstartLong;
    endLat = TendLat;
    endLong = TendLong;
  }
  
  public void setStart(float TstartLat, float TstartLong) {
    startLat = TstartLat;
    startLong = TstartLong;    
  }
  
  public void setEnd(float TendLat, float TendLong) {    
    endLat = TendLat;
    endLong = TendLong;
  }

  public float count() {
    float dLat  = radians((endLat - startLat));
    float dLong = radians((endLong - startLong));
    startLat = radians(startLat);
    endLat   = radians(endLat);
    float a = haversin(dLat) + cos(startLat) * cos(endLat) * haversin(dLong);
    float c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earth * c * 1000;
  }

  public float haversin(float val) {
    return pow(sin(val/2), 2);
  }
}
public void infoData() {
  noStroke();
  image(gradientbk, 0, height-200, width, 200);
  if (toggleinfo==0) {
    textAlign(LEFT);
    pushMatrix();
    translate(25, height-25-100);
    fill(255, 200);
    rect(0, 0, 555, 100, 5);
    fill(0);
    textFont(font, 32);
    textSize(13);
    text("Cursor Position :", 13, 23);
    textSize(15);
    text(location.getLat() + ", " + location.getLon(), 13, 43);
    textSize(13);
    text("Your Current Position :", 13, 63);
    textSize(15);
    text(lat +","+ lng, 13, 83);
    textSize(13);
    text("Map Provider :", 190, 23);
    textSize(15);
    if (currentMap==map1) {
      text("OpenStreetMap", 190, 43);
    }
    if (currentMap==map2) {
      text("Google Maps", 190, 43);
    }
    if (currentMap==map3) {
      text("Microsoft Aerial", 190, 43);
    }
    fill(0, 0, 215);
    //text("Microsoft", 90, 265);
    fill(0);
    textSize(13);
    text("Points :", 190, 63);
    textSize(15);
    text(i, 190, 83);
    textSize(13);
    text("Roll:", 320, 23);
    textSize(15);
    text(roll, 320, 43);
    textSize(13);
    text("Pitch:", 385, 23);
    textSize(15);
    text(pitch, 385, 43);
    textSize(13);
    text("Heading :", 320, 63);
    textSize(15);
    text(heading+" | "+derajatselisih+" | "+derajatbelok, 320, 83);


    //   text("Total Distance :", 20, 340);
    //   if(lat==0 && lng==0){
    //   textSize(18);
    //   fill(255,0,0);
    //   text("No Data", 20, 365);
    //   }
    //   else{
    //   fill(0);
    //   textSize(18);
    //   int tidakkoma;
    //   tidakkoma=int(totaljarak);
    //   text(tidakkoma+" m", 20, 365);}
    pushMatrix();
    scale(0.55f);
    translate(800, -90);
    Level_Graph();
    popMatrix();
    popMatrix();
  }
}
public void infoCopyright() {
  //text copyright bawah
  pushMatrix();
  textFont(font, 32);
  translate(width-305, height-18);
  fill(255, 200);
  rect(0, 0, 305, 18);
  fill(0);
  textSize(11);
  text("Maps GUI for AGV v0.6 Copyright \u00a92018 Farid Hasan DTE 16", 5, 12);
  popMatrix();
}
public void infoTopbar() {
  pushMatrix();
  noStroke();
  fill(0, 200);
  rect(0, 0, width, 50);
  fill(0);
  rect(0, 0, 400, 50);
  image(logougm, 22, 8, 35, 35);

  textAlign(LEFT);
  textFont(font1);
  textSize(13);
  fill(255);
  text("DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA", 70, 19);
  text("LABORATORIUM INSTRUMENTASI DAN KENDALI", 70, 30);
  text("SEKOLAH VOKASI UNIVERSITAS GADJAH MADA", 70, 41);

  textSize(20);
  if (jmlsatelit>0) {
    fill(255);
    image(greengps, 400, 0, 350, 50);
    text("Ready to Go (GPS Mode)", 415, 32);
  }

  if (jmlsatelit==0) {
    fill(255);
    image(redgps, 400, 0, 350, 50);
    text("No Signal (No GPS)", 415, 32);
  }
  pushMatrix();
  translate(-170, 0);
  //GPS icon + signal
  if (jmlsatelit==0) {
    image(gps0, 900, 0, 65, 50);
  }
  if (jmlsatelit==1) {
    image(gps1, 900, 0, 65, 50);
  }
  if (jmlsatelit==2) {
    image(gps2, 900, 0, 65, 50);
  }
  if (jmlsatelit==3) {
    image(gps3, 900, 0, 65, 50);
  }
  if (jmlsatelit==4) {
    image(gps4, 900, 0, 65, 50);
  }
  if (jmlsatelit>=5) {
    image(gps5, 900, 0, 65, 50);
  }
  fill(255);
  textSize(13);
  text(jmlsatelit, 930, 22);
  textSize(15);
  text("45", 1010, 25);
  text("cm", 1010, 35);

  //Sensor icon
  image(sensor, 960, 0, 65, 50);
  //Baterai icon
  if (baterai>=30) {
    image(bateraiimg, 1030, 0, 65, 50);
  }
  if (baterai<30) {
    image(bateraiimgmerah, 1030, 0, 65, 50);
  }
  textSize(14);
  //text(int(baterai)+"%", 1078, 31);
  text("1: "+PApplet.parseInt(baterai)+"%", 1078, 24);
  text("2: "+PApplet.parseInt(baterai1)+"%", 1078, 36);
  fill(0, 210, 137);
  rect(1141, 11, 60, 28, 2);
  fill(0);
  textSize(12);
  text("1: "+"10.50"+"V", 1146, 23);
  text("2: "+"7.50"+"V", 1146, 35);
  popMatrix();
  textFont(font);
  float bateraibar=map(baterai, 0, 100, 0, width);
  if (baterai>=30) {
    fill(24, 179, 113);
  }
  if (baterai<30) {
    fill(248, 25, 7);
  }
  rect(0, 50, bateraibar, 2.5f);

  pushMatrix();
  stroke(0, 30);
  strokeWeight(2);
  translate(bateraibar-55, 50-5);
  fill(255);
  rect(0, 0, 55, 15, 10);
  noStroke();
  fill(0);
  textSize(11);
  textAlign(CENTER);
  text("--:--", 25, 10);
  // text(int(baterai)+"%",12, 10);
  textAlign(LEFT);
  popMatrix();





  popMatrix();
}
public void infoLegenda() {
  pushMatrix();
  translate(-20, 30);
  compass.draw();
  //textSize(30);
  popMatrix();
  barScale.draw();
}

public void infoCamera() {

  if (camtoggle==0) {
    
  
    pushMatrix();
    if (toggleinfo==0) {
      translate(25, 335);
      cp5.getController("switchbutton").setPosition(255, height-188-117);
    }

    if (toggleinfo==1) {
      translate(25, height-25-174);
      cp5.getController("switchbutton").setPosition(255, height-188);
    }


    cp5.getController("switchbutton").show();
    fill(255, 200);
    rect(0, 0, 301, 174, 5);
    if(switchbuttonvar==0){
    image(cam, 5, 5, 291, 164);}
    popMatrix();
      

  }
  if (camtoggle==1) {
    cp5.getController("switchbutton").hide();

  }

}

public void Level_Graph()
{
  textSize(11);
  float a, b, h, head, angx, angy, angCalc;
  int xLevelObj   = 100;              
  int yLevelObj   = 180; 
  int xCompass    = xLevelObj;        
  int yCompass    = yLevelObj+240;
  int j, y;
  angx=roll;
  angy=pitch;
  a=radians(angx);
  if (angy<-90) {
    b=radians(-180 - angy);
  } else if (angy>90) {
    b=radians(+180 - angy);
  } else { 
    b=radians(angy);
  }
  float horizonInstrSize;
  float angyLevelControl;

  // ---------------------------------------------------------------------------------------------
  // Magnetron Combi Fly Level Control
  // ---------------------------------------------------------------------------------------------
  horizonInstrSize=68;
  angyLevelControl=((angy<-horizonInstrSize) ? -horizonInstrSize : (angy>horizonInstrSize) ? horizonInstrSize : angy);
  pushMatrix();
  translate(xLevelObj, yLevelObj);
  noStroke();
  // instrument background
  fill(50, 50, 50);
  ellipse(0, 0, 150, 150);
  // full instrument
  rotate(a);                    //////////////
  rectMode(CORNER);
  // outer border
  strokeWeight(1);
  stroke(90, 90, 90);
  //border ext
  arc(0, 0, 140, 140, 0, TWO_PI);
  stroke(190, 190, 190);
  //border int
  arc(0, 0, 138, 138, 0, TWO_PI);
  // inner quadrant
  strokeWeight(1);
  stroke(255, 255, 255);
  fill(124, 73, 31);
  //earth
  float angle = acos(angyLevelControl/horizonInstrSize);
  arc(0, 0, 136, 136, 0, TWO_PI);
  fill(38, 139, 224); 
  //sky 
  arc(0, 0, 136, 136, HALF_PI-angle+PI, HALF_PI+angle+PI);
  float x = sin(angle)*horizonInstrSize;
  if (angy>0) 
    fill(124, 73, 31);
  noStroke();   
  triangle(0, 0, x, -angyLevelControl, -x, -angyLevelControl);
  // inner lines
  strokeWeight(1);
  for (y=0; y<8; y++) {
    j=y*15;
    if (angy<=(35-j) && angy>=(-65-j)) {
      stroke(255, 255, 255); 
      line(-30, -15-j-angy, 30, -15-j-angy); // up line
      fill(255, 255, 255);
      textFont(font2);
      text("+" + (y+1) + "0", 34, -12-j-angy); //  up value
      text("+" + (y+1) + "0", -48, -12-j-angy); //  up value
    }
    if (angy<=(42-j) && angy>=(-58-j)) {
      stroke(167, 167, 167); 
      line(-20, -7-j-angy, 20, -7-j-angy); // up semi-line
    }
    if (angy<=(65+j) && angy>=(-35+j)) {
      stroke(255, 255, 255); 
      line(-30, 15+j-angy, 30, 15+j-angy); // down line
      fill(255, 255, 255);
      textFont(font2);
      text("-" + (y+1) + "0", 34, 17+j-angy); //  down value
      text("-" + (y+1) + "0", -48, 17+j-angy); //  down value
    }
    if (angy<=(58+j) && angy>=(-42+j)) {
      stroke(127, 127, 127); 
      line(-20, 7+j-angy, 20, 7+j-angy); // down semi-line
    }
  }
  strokeWeight(2);
  stroke(255, 255, 255);
  if (angy<=50 && angy>=-50) {
    line(-40, -angy, 40, -angy); //center line
    fill(255, 255, 255);
    textFont(font2);
    text("0", 34, 4-angy); // center
    text("0", -39, 4-angy); // center
  }

  // lateral arrows
  strokeWeight(1);
  // down fixed triangle
  stroke(60, 60, 60);
  fill(180, 180, 180, 255);

  triangle(-horizonInstrSize, -8, -horizonInstrSize, 8, -55, 0);
  triangle(horizonInstrSize, -8, horizonInstrSize, 8, 55, 0);

  // center
  strokeWeight(1);
  stroke(255, 0, 0);
  line(-20, 0, -5, 0); 
  line(-5, 0, -5, 5);
  line(5, 0, 20, 0); 
  line(5, 0, 5, 5);
  line(0, -5, 0, 5);
  noStroke();
  popMatrix();
}

public void loadmap() {

  pushMatrix();

  if (switchbuttonvar==1) {

    if ( toggleinfo==0) {
      translate(25+5, 340);
    }
    if (toggleinfo==1) {
      translate(25+5, height-20-174);
    }
  }
  if (switchbuttonvar==0) {

    translate(0, 0);
  }



  currentMap.draw();

  noStroke();

  derloc1 = new Location(tklat[1], tklon[1]);
  ScreenPosition posderloc1 = currentMap.getScreenPosition(derloc1);

  derloc2 = new Location(tklat[2], tklon[2]);
  ScreenPosition posderloc2 = currentMap.getScreenPosition(derloc2);


  location = currentMap.getLocation(mouseX, mouseY);

  //update loc from arduino
  if (jmlsatelit>0 && lat!=0 && lng!=0) {
    labDTE = new Location(lat, lng);
  }
  ScreenPosition posDTE = currentMap.getScreenPosition(labDTE);

  p1x =posDTE.x;
  p1y =posDTE.y;

  p2x =posderloc1.x;
  p2y =posderloc1.y;

  p3x =posderloc2.x;
  p3y =posderloc2.y;

  //update heading dari arduino
  if (headingraw!=0) {
    heading=headingraw;
  }

  float s = currentMap.getZoom();
  if (switchbuttonvar==0) {
    fill(66, 133, 244, 70);
    if (jmlsatelit==0) {
      ellipse(posDTE.x, posDTE.y, s/50, s/50);
    }
    if (jmlsatelit==1) {
      ellipse(posDTE.x, posDTE.y, s/100, s/100);
    }
    if (jmlsatelit==2) {
      ellipse(posDTE.x, posDTE.y, s/200, s/200);
    }
    if (jmlsatelit==3) {
      ellipse(posDTE.x, posDTE.y, s/500, s/500);
    }
    if (jmlsatelit>=4) {
      ellipse(posDTE.x, posDTE.y, s/800, s/800);
    }
  }
  //mulaine for kene
  for ( int k=1; k<=i; k++ ) {

    klikpoint = new Location(tklat[k], tklon[k]); 
    ScreenPosition posklikpoint = currentMap.getScreenPosition(klikpoint);
    posklikpoint = currentMap.getScreenPosition(klikpoint);

    l=k-1;
    if (l<1) {
      l=1;
    }
    klikpointmin = new Location(tklat[l], tklon[l]); 
    ScreenPosition posklikpointmin = currentMap.getScreenPosition(klikpointmin);
    posklikpointmin = currentMap.getScreenPosition(klikpointmin);
    if (switchbuttonvar==0) {
      strokeWeight(5);
      stroke(186, 33, 33);
      line(posklikpoint.x, posklikpoint.y, posklikpointmin.x, posklikpointmin.y);
      if (k==1) {
        line(posDTE.x, posDTE.y, posklikpoint.x, posklikpoint.y );
      }
      noStroke();
      //if (k==i){ // agar titik point kelihatan di akhir saja
      fill(255);
      ellipse(posklikpoint.x, posklikpoint.y, 20.5f, 20.5f);
      fill(186, 33, 33);
      ellipse(posklikpoint.x, posklikpoint.y, 15, 15);
      //}
    }
    if (k==1) {
      hv.setCoord(lat, lng, tklat[1], tklon[1]);
      totaljarak=hv.count();
    }
    if (k>1) {
      hv.setCoord(tklat[k], tklon[k], tklat[k-1], tklon[k-1]);
      totaljarak=totaljarak+hv.count();
    }

    hv.setCoord(lat, lng, tklat[1], tklon[1]);
    jarakpertama=hv.count();

    //geser array disini ketika kurang dari 2 meter
    if (jarakpertama<=2) {
      for (int t=0; t<i; t++) { 
        tklat[t]=tklat[t+1];
      }
      for (int t=0; t<i; t++) { 
        tklon[t]=tklon[t+1];
      }
      i=i-1;
    }
  }//for e mandek ng kene

  if (i==0) {
    totaljarak=0;
  }

  //gambar headingcm
  pushMatrix();
  imageMode(CENTER);
  translate(posDTE.x, posDTE.y);
  rotate(radians(heading));
  image(headingcm, 0, 0);
  imageMode(CORNER);
  popMatrix();

  //gambar bunder biru
  stroke(0, 30);
  strokeWeight(3);
  fill(255);
  ellipse(posDTE.x, posDTE.y, 20.5f, 20.5f);
  noStroke();
  fill(66, 133, 244);
  ellipse(posDTE.x, posDTE.y, 15, 15);

  //mencari derajat antar 2 titik 
  //dan kalkulasi selisih derajat dengan sensor
  if (tklat[1]!=0 && tklon[1]!=0) {
    angleDeg = atan2(p2y - p1y, p2x - p1x) * 180 / PI;
    derajatselisih = (int)angleDeg;
  }
  if (derajatselisih<0) {
    derajatselisih = derajatselisih + 360;
  }
  derajatselisih=derajatselisih+90;
  if (derajatselisih>360) {
    derajatselisih=derajatselisih-360;
  }
  derajatbelok=derajatselisih-heading;
  if (derajatbelok<0) {
    derajatbelok=derajatbelok+360;
  }
  if (i==0 && i==0) {
    derajatselisih=0;
    derajatbelok=0;
    derajatarahbelok=0;
  }
  //mencari derajat antar
  //tiga titik untuk menentukan belok
  if (i>=2) {
    derajatarahbelok= (atan2(p3y - p2y, p3x - p2x) * 180 / PI)-derajatselisih;
    derajatarahbelok=(int)derajatarahbelok;

    derajatarahbelok=derajatarahbelok+90;
    if (derajatarahbelok<0) {
      derajatarahbelok=derajatarahbelok+360;
    }
    if (derajatarahbelok>360) {
      derajatarahbelok=derajatarahbelok-360;
    }
    if (derajatarahbelok<0) {
      derajatarahbelok=derajatarahbelok+360;
    }
  }
  if (switchbuttonvar==0) {

    //tambah gambar
    println(i);
    if (i==1) {
      image(S, 1160, 75, 90, 90);
    }
    if (i>1) {
    if (derajatarahbelok>=0 && derajatarahbelok<=22.5f) {
      image(S, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=337.5f && derajatarahbelok<=360) {
      image(S, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=67.5f && derajatarahbelok<112.5f) {
      image(R, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>22.5f && derajatarahbelok<67.5f) {
      image(R45, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>247.5f && derajatarahbelok<292.5f) {
      image(L, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=292.5f && derajatarahbelok<337.5f) {
      image(L45, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>190 && derajatarahbelok<=247.5f) {
      image(LTAJAM, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=112.5f && derajatarahbelok<170) {
      image(RTAJAM, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=170 && derajatarahbelok<=190) {
      image(U, 1160, 75, 90, 90);
    }
    }
  }

  if (switchbuttonvar==1) {
    translate(-(25+5), -(height-20-174));
    if (toggleinfo==0) {
      translate(0, height-20-174-340);
    }
    //tambah gambar

    if (i==1) {
      image(S, 1160, 75, 90, 90);
    }
    if (i>1) {
    if (derajatarahbelok>=0 && derajatarahbelok<=22.5f) {
      image(S, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=337.5f && derajatarahbelok<=360) {
      image(S, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=67.5f && derajatarahbelok<112.5f) {
      image(R, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>22.5f && derajatarahbelok<67.5f) {
      image(R45, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>247.5f && derajatarahbelok<292.5f) {
      image(L, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=292.5f && derajatarahbelok<337.5f) {
      image(L45, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>190 && derajatarahbelok<=247.5f) {
      image(LTAJAM, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=112.5f && derajatarahbelok<170) {
      image(RTAJAM, 1160, 75, 90, 90);
    }
    if (derajatarahbelok>=170 && derajatarahbelok<=190) {
      image(U, 1160, 75, 90, 90);
    }
    }
  }





  //text berapa meter
  textFont(font1);
  textSize(14);
  if (i>0) {
    textAlign(CENTER);
    fill(0, 0, 0, 90);
    //text("100m", 195, 495);
    text((int)jarakpertama+" m", 1205, 170);
    textAlign(LEFT);
  }
  popMatrix();
}

public void setup_UART()
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
 public void InitSerial(float portValue) 
 {
  if (portValue < commListMax) {
    String portPos = Serial.list()[PApplet.parseInt(portValue)];
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
 
 public void controlEvent(ControlEvent theControlEvent)
{
  if (theControlEvent.isGroup()) if (theControlEvent.name()=="portComList") InitSerial(theControlEvent.group().value()); // initialize the serial port selected
  
}



public void serialEvent(Serial s) {
  try {
    String usbString = s.readStringUntil ('\n');
    println(usbString);

    if (usbString != null) 
    {
      usbString = trim(usbString);
      //println(usbString); //--> buat ngecek bor
    }

    datamasuk = PApplet.parseFloat(split(usbString, ','));
    jmlsatelit = PApplet.parseInt(datamasuk[1]);
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

public void kirimSerial() {
  kirim = "#"+derajatbelok+","+i+"\n \r";
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "maps_gui_baru" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
