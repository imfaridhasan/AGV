void infoData() {
  noStroke();
  image(gradientbk, 0, height-200, width, 200);
  image(gradientbkflip, 0, 0 ,width, 150);
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
    scale(0.55);
    translate(800, -90);
    Level_Graph();
    popMatrix();
    popMatrix();
  }
}
void infoCopyright() {
  //text copyright bawah
  pushMatrix();
  textFont(font, 32);
  translate(width-305, height-18);
  fill(255, 200);
  rect(0, 0, 305, 18);
  fill(0);
  textSize(11);
  text("Maps GUI for AGV v0.6 Copyright ©2018 Farid Hasan DTE 16", 5, 12);
  popMatrix();
}
void infoTopbar() {
  pushMatrix();
  translate(25,25);
  noStroke();
  fill(255,200);
  rect(0, 0, width-50, 50,5,5,0,0);
  image(logougm, 13, 8, 35, 35);

  textAlign(LEFT);
  textFont(font1);
  textSize(13);
  fill(0);
  text("DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA", 58, 19);
  text("LABORATORIUM INSTRUMENTASI DAN KENDALI", 58, 30);
  text("SEKOLAH VOKASI UNIVERSITAS GADJAH MADA", 58, 41);

  textSize(20);
  if (jmlsatelit>0) {
    fill(255);
    image(greengps, 385, 0, 380, 50);
    text("Ready to Go (GPS Mode)", 403, 32);
  }

  if (jmlsatelit==0) {
    fill(255);
    image(redgps, 385, 0, 380, 50);
    text("No Signal (No GPS)", 403, 32);
  }
  pushMatrix();
  translate(-220, 0);
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
  fill(0);
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
  text("1: "+int(baterai)+"%", 1078, 24);
  text("2: "+int(baterai1)+"%", 1078, 36);
  fill(0, 210, 137);
  rect(1141, 11, 60, 28, 2);
  fill(0);
  textSize(12);
  text("1: "+baterai1raw+"V", 1146, 23);
  text("2: "+baterai2raw+"V", 1146, 35);
  popMatrix();
  textFont(font);
  fill(204,204,204);
  rect(0, 50, width-50, 5,0,0,5,5);
  float bateraibar=map(baterai, 0, 100, 0, width-50);
  if (baterai>=30) {
    fill(24, 179, 113);
  }
  if (baterai<30) {
    fill(248, 25, 7);
  }
  rect(0, 50, bateraibar, 5,0,0,5,5);

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
void infoLegenda() {
  pushMatrix();
  translate(-20, 55);
  compass.draw();
  //textSize(30);
  popMatrix();
  barScale.draw();
}

void infoCamera() {

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

void Level_Graph()
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

