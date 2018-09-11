void loadmap() {

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
      ellipse(posklikpoint.x, posklikpoint.y, 20.5, 20.5);
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
  ellipse(posDTE.x, posDTE.y, 20.5, 20.5);
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
    //println(i);
    if (i==1) {
      image(S, 1160, 100, 90, 90);
    }
    if (i>1) {
    if (derajatarahbelok>=0 && derajatarahbelok<=22.5) {
      image(S, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=337.5 && derajatarahbelok<=360) {
      image(S, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=67.5 && derajatarahbelok<112.5) {
      image(R, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>22.5 && derajatarahbelok<67.5) {
      image(R45, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>247.5 && derajatarahbelok<292.5) {
      image(L, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=292.5 && derajatarahbelok<337.5) {
      image(L45, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>190 && derajatarahbelok<=247.5) {
      image(LTAJAM, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=112.5 && derajatarahbelok<170) {
      image(RTAJAM, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=170 && derajatarahbelok<=190) {
      image(U, 1160, 100, 90, 90);
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
      image(S, 1160, 100, 90, 90);
    }
    if (i>1) {
    if (derajatarahbelok>=0 && derajatarahbelok<=22.5) {
      image(S, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=337.5 && derajatarahbelok<=360) {
      image(S, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=67.5 && derajatarahbelok<112.5) {
      image(R, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>22.5 && derajatarahbelok<67.5) {
      image(R45, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>247.5 && derajatarahbelok<292.5) {
      image(L, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=292.5 && derajatarahbelok<337.5) {
      image(L45, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>190 && derajatarahbelok<=247.5) {
      image(LTAJAM, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=112.5 && derajatarahbelok<170) {
      image(RTAJAM, 1160, 100, 90, 90);
    }
    if (derajatarahbelok>=170 && derajatarahbelok<=190) {
      image(U, 1160, 100, 90, 90);
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
    text((int)jarakpertama+" m", 1205, 195);
    textAlign(LEFT);
  }
  popMatrix();
  
  //println(tklat[1] +"  "+ tklon[1]);
  println(commListbox.isOpen() );
}

