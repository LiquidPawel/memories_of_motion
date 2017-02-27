float debug_mx = 0.00f;
float debug_my = 0.00f;

void debug() {
  debug_mx = lerp(debug_mx, map(mouseX, 0, width, -width/2, width/2), 0.2);
  debug_my = lerp(debug_my, map(mouseY, 0, height, -width/2, width/2), 0.2);
  
  


  textAlign(LEFT);
  textSize(16);
  text("FPS "+frameRate, 90, 96);
  for (int i = 0; i < move_no; i++) {
    if (i!=1 && i!=10 && i!= 11) {
      b_move[i].place();
    }
  }
}

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

void kinectSetup() {
  kinect = new KinectPV2(this);
  kinect.enableSkeleton3DMap(true);
  kinect.init();
}


class Button {
  boolean hover;
  boolean clicked;
  String content;
  float fsize;
  float dist;
  float xpos;
  float ypos;
  float xwidth;
  float ylength;

  Button(String tempContent, float tempFsize, 
    float tempXpos, float tempYpos, 
    float tempXwidth, float tempYlength) {
    content = tempContent;
    fsize = tempFsize;
    xpos = tempXpos;
    ypos = tempYpos;
    xwidth = tempXwidth;
    ylength = tempYlength;
  }

  void place() {
    rectMode(CENTER);
    textAlign(CENTER);
    textSize(fsize);
    noStroke();

    dist = dist(xpos, ypos, xpos+xwidth/2, ypos+ylength/2);
    if (hover == true) {
      fill(130, 255, 120);
      rect(xpos, ypos, xwidth, ylength);
      fill(255);
      text(content, xpos, ypos+ylength*0.05);
    } else {
      fill(150, 255, 70);
      rect(xpos, ypos, xwidth, ylength);
      fill(255);
      text(content, xpos, ypos+ylength*0.05);
    }
    if (clicked == true) {
      fill(80, 255, 150);
      rect(xpos, ypos, xwidth, ylength);
      fill(255);
      text(content, xpos, ypos+ylength*0.05);
    }

    if (dist >= dist(mouseX, mouseY, xpos, ypos)) {
      hover = true;
      clicked = false;
      if (hover == true && mousePressed) {
        clicked = true;
      }
    } else {
      hover = false;
      clicked = false;
    }
  }
}