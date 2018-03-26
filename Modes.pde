/////////////////////
// VISUAL MODES
int V_NONE, 
  V_PULSING, 
  V_ROTATE_ANGLE_COUNT, 
  V_ROTATE_ANGLE, 
  V_PULSE_LINE_BACK, 
  V_PULSE_LINE_RIGHT, 
  V_PULSE_LINE_LEFT, 
  V_PULSE_LINE_UP, 
  V_PULSE_LINE_DOWN, 
  V_CYCLE_CONST, 
  V_SHOW_ONE, 
  V_ROTATE_ANGLE_BEATS, 
  V_PULSING_ON_LINE, 
  V_SEGMENT_SHIFT, 
  V_FADE, 
  V_TRANSIT;

/////////////////////
// KINECT MODES
int K_NONE = -1;
int K_AIR_Z = 0;
int K_TRANSIT_X = 1;
int K_AIR_BRIGHT = 2;
int K_AIR_LINE = 3;
int K_SPOTLIGHT = 4;
int K_CONSTELLATION = 5;
int K_PAINT = 6;
int kinectHues[] = { 0, 50, 100, 150, 200, 250 };

///////////////////////
// OTHER VARIABLES
int pulseIndex = 0;
int lastCheckedPulse = 0;
int pointDirection = 4;
int seesawVals[] = {0, 0};

void initModes() {
  int temp = -1;
  V_NONE = temp++; 
  V_PULSING = temp++; 
  V_ROTATE_ANGLE_COUNT = temp++;
  V_ROTATE_ANGLE = temp++; 
  V_PULSE_LINE_BACK = temp++;
  V_PULSE_LINE_RIGHT = temp++;
  V_PULSE_LINE_LEFT = temp++;
  V_PULSE_LINE_UP = temp++;
  V_PULSE_LINE_DOWN = temp++;
  V_CYCLE_CONST = temp++; 
  V_SHOW_ONE = temp++; 
  V_ROTATE_ANGLE_BEATS = temp++; 
  V_PULSING_ON_LINE = temp++; 
  V_SEGMENT_SHIFT = temp++; 
  V_FADE = temp++;
  V_TRANSIT = temp++;
}
void playMode() {
  if (visualMode == V_ROTATE_ANGLE_COUNT) rotateAngleCounter(100, 20);
  else if (visualMode == V_PULSE_LINE_BACK) pulseLineBack(500);
  else if (visualMode == V_PULSE_LINE_RIGHT) pulseLineRight(90, 80);
  else if (visualMode == V_PULSE_LINE_LEFT)  pulseLineLeft(90, 80);
  else if (visualMode == V_PULSE_LINE_UP) pulseLineUp(90, 80);
  else if (visualMode == V_PULSE_LINE_DOWN) pulseLineDown(90, 80);
  else if (visualMode == V_CYCLE_CONST) cycleConstellation(150);
  else if (visualMode == V_PULSING) pulsing(9);
  else if (visualMode == V_SHOW_ONE) showOne(100);
  else if (visualMode == V_PULSING_ON_LINE) pulseLinesCenter(1);
  else if (visualMode == V_SEGMENT_SHIFT) segmentShift(10);
  else if (visualMode == V_TRANSIT) transit(30);
}

//////////////////////////////////////////////////////////////////
void handLight(float x, float y, int rad, color c) {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).handLight(x, y, rad, c);
  }
}
void transit(int rate) {

  if (millis() - lastCheckedPulse > rate) {
    pulseIndex++;
    if (pulseIndex > 100) pulseIndex = 0;
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displaySegment(pulseIndex / 100.0, .2);
  }
}

void transitHand(float per, color c) {
  stroke(c);
  per = constrain(per, 0, 1.0);
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displaySegment(per, .2);
  }
}


void rainbowRandom() {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayRainbowRandom();
  }
}

void rainbowCycle(int amt) {
  colorMode(HSB, 255);
  pulseIndex+= amt;
  if (pulseIndex > 255) pulseIndex = 0;
  for (int i=0; i< lines.size(); i++) {
    //color c =  color(((i * 256 / lines.size()) + pulseIndex) % 255, 255, 255);
    lines.get(i).displayRainbowCycle(pulseIndex);
  }
  colorMode(RGB, 255);
}

void rainbow() {
  pulseIndex++;
  if (pulseIndex > 255) pulseIndex = 0;
  colorMode(HSB, 255);
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).display(color(pulseIndex, 255, 255));
  }
  colorMode(RGB, 255);
}

void segmentShift(int jump) {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displaySegment(pulseIndex / 100.0, .5);
  }
}

void rotateAngle(int rate, int angleGap) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex+= angleGap;
    if (pulseIndex > -70 ) {
      pulseIndex = -280;
    }
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayAngle(pulseIndex, pulseIndex+angleGap, color(255));
  }
}



void displayLines(color c) {
  for (int i = 0; i < lines.size(); i++) {
    stroke(c);
    fill(c);
    lines.get(i).display(c);
  }
}

void displayLines() {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).display();
  }
}

void wipeRight(int amt, int w) {
  stroke(255);
  displayLines();
  fill(0);
  noStroke();
  pulseIndex += amt;
  if (pulseIndex > width) pulseIndex = 0;
  rect(pulseIndex, 0, w, height);
}

void rotateAngleCounter(int rate, int angleGap) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex-= angleGap;
    if (pulseIndex < -280 ) {
      pulseIndex = -70;
    }
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayAngle(pulseIndex, pulseIndex+angleGap, color(255));
  }
}

void displayYPoints(int y, color c) {
  fill(c);
  stroke(c);
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayPointY(y);
  }
}

void displayXPoints(int x, color c) {
  fill(c);
  stroke(c);
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayPointX(x);
  }
}

void displayYPoints(int rate, int bottom, int top) {
  pulseIndex += pointDirection * rate;
  if (pulseIndex > top) {
    pulseIndex = top;
    pointDirection = -1;
  } else if (pulseIndex < bottom) {
    pulseIndex = bottom;
    pointDirection = 1;
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayPointY(pulseIndex);
  }
}

void displayXPoints(int rate, int left, int right) {
  pulseIndex += pointDirection * rate;
  if (pulseIndex > right) {
    pulseIndex = right;
    pointDirection = -1;
  } else if (pulseIndex < left) {
    pulseIndex = left;
    pointDirection = 1;
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayPointX(pulseIndex);
    lines.get(i).displayPointX(pulseIndex+100);
  }
}

void randomLines(int rate) {
  if (millis() - lastCheckedPulse > rate) {
    background(0);
    lastCheckedPulse = millis();
    for (int i = 0; i < 20; i++) {
      line(random(50, width - 100), random(50, height - 100), random(50, width - 100), random(50, height - 100));
    }
  }
}


void pulseLinesCenter(int rate) {
  pulseIndex += pointDirection * rate;
  if (pulseIndex > 100) {
    pulseIndex = 100;
    pointDirection = -1;
  } else if (pulseIndex < 0) {
    pulseIndex = 0;
    pointDirection = 1;
  }
  float per = pulseIndex / 100.0;
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayCenterPulse(per);
  }
}

void randomSegments(int rate) {
}

void twinkleLines() {
  for (int i = 0; i < lines.size(); i++) {
    fill(255);
    lines.get(i).twinkle(50);
  }
}

void pulseLineRight(int rate, int bandSize) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex+= bandSize;
    if (pulseIndex > width) {
      pulseIndex = -bandSize;
    }
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayBandX(pulseIndex, pulseIndex+bandSize);
  }
}

void pulseLineLeft(int rate, int bandSize) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex-=bandSize;
    if (pulseIndex < -bandSize) {
      pulseIndex = width;
    }
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayBandX(pulseIndex, pulseIndex+bandSize);
  }
}

void pulseLineUp(int rate, int bandSize) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex-=bandSize;
    if (pulseIndex < -bandSize) {
      pulseIndex = height;
    }
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayBandY(pulseIndex, pulseIndex+bandSize, color(255));
  }
}


void pulseLineDown(int rate, int bandSize) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex+=bandSize;
    if (pulseIndex > height) {
      pulseIndex = -bandSize;
    }
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayBandY(pulseIndex, pulseIndex+bandSize, color(255));
  }
}

void pulseLineBack(int rate) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex++;
    if (pulseIndex > 9) {
      pulseIndex = -1;
    }
    lastCheckedPulse = millis();
  }
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayBandZ(pulseIndex, color(255));
  }
}

void cycleConstellation(int rate) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex++;
    if (pulseIndex > 9) {
      pulseIndex = 1;
    }
    lastCheckedPulse = millis();
  }
  showConstellationLine(pulseIndex);
}

void showOne(int rate) {
  if (millis() - lastCheckedPulse > rate) {
    pulseIndex++;
    lastCheckedPulse = millis();
  }
  if (pulseIndex >= lines.size()) pulseIndex = 0;
  else if (pulseIndex < 0) pulseIndex = 0;
  lines.get(pulseIndex).display();
}

void pulsing(int rate) {
  pulseIndex += rate;
  pulseIndex %= 510;
  int b = pulseIndex;
  if (pulseIndex > 255) b = int(map(pulseIndex, 255, 510, 255, 0));
  for (int i = 0; i < lines.size(); i++) {
    stroke(b);
    fill(b);
    lines.get(i).display();
  }
}

void showConstellationLine(int l) {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayConstellation(l, color(255));
  }
}

void linePercentW(int per) {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).displayPercentWid(per);
  }
}



void cycleModes(int rate) {
  if (millis() - stringChecked > rate) {
    visualMode = int(random(1, 11));
    stringChecked = millis();
  }
  playMode();
}



void resetZIndex() {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).setZIndex(0);
  }
}

void resetConstellationG() {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).setConstellationG(0);
  }
}



///////////////////////////////////////////////////////////////////////////////////////////
// KINECT MODES


void playKinectModes(color c) {
  if (kinectMode == K_SPOTLIGHT) drawSpotlightLR(50, c);
  else if (kinectMode == K_CONSTELLATION) {
    checkConstellations();
    if (triggered >= 0) playConstellations(2000);
    else drawOrganicConstellation(19, c);
  } else if (kinectMode == K_AIR_Z) airBenderZ(c);
  else if (kinectMode == K_TRANSIT_X) airBenderX(c);
  else if (kinectMode == K_AIR_BRIGHT) brightnessAirBenderY(c);
  else if (kinectMode == K_AIR_LINE) linesXY(c);
  else if (kinectMode == K_PAINT) paint(50, c);
}


void airBenderZ(color c) {
  int band = constrain(int(map(handRDZ, -0.5, 0.5, 6, -1)), 0, 5);
  int start = lines.size() / 6 * band;
  int end = lines.size() / 6 * (band + 1);
  if (end > lines.size()) end = lines.size();
  for (int i = start; i < lines.size(); i++) {
    // assumes lines are sorted closest to farthest
    // we draw closest last (at end of lines)

    // if hand is positive and big when far back
    // so map inverse so that when hand is big, we draw first items in lines array (corresponding to farthest back items)
    if (i >= start && i < end) lines.get(i).display(c);
    //else lines.get(i).displayNone();
  }
}

void airBenderX(color c) {
  float x = map(handRDX, -2, 2, 0, 1);
  transitHand(x, c);
}

void brightnessAirBenderY(color c) {
  int brightR = constrain(int(map(handRDY, -.6, 0, 0, 255)), 0, 255);
  int brightL = constrain(int(map(handLDY, -.6, 0, 0, 255)), 0, 255);
  int bright = max(brightR, brightL);
  float hue = hue(c);
  colorMode(HSB, 255);
  displayLines(color(hue, 255, bright));
  colorMode(RGB, 255);
}

void linesXY(color c) {
  int r = constrain(int(map(handRDY, -.5, 0.3, height, 0)), 0, height);
  int l = constrain(int(map(handLDX, -.5, .7, 0, width)), 0, width);
  displayYPoints(r, c);
  displayXPoints(l, c);
}

void paint(int r, color c) {
  //pulseIndex += pointDirection * rate;
  //if(pulseIndex > 255) pointDirection = -1;
  //else if (pulseIndex < 50) pointDirection = 1;
  //stroke(pulseIndex);
  drawSpotlightLR(r, c);
}


void checkConstellations() {
  if (triggered < 0) {
    if (checkWhale(20)) {
      triggered = 0;
      triggeredTime = millis();
    } else if (checkHand(20)) {
      triggered = 1;
      triggeredTime = millis();
    } else if (checkOwl(20)) {
      triggered = 2;
      triggeredTime = millis();
    } else if (checkMoth(20)) {
      triggered = 3;
      triggeredTime = millis();
    } else if (checkOrchid(20)) {
      triggered = 4;
      triggeredTime = millis();
    }
  }
}

void playConstellations(int t) {
  if (millis() - triggeredTime > t) {
    triggered = -1;
    triggeredTime = millis();
  } else {
    if (triggered == 0) drawWhale();
    else if (triggered == 1) drawHand();
    else if (triggered == 2) drawOwl();
    else if (triggered == 3) drawMoth();
    else if (triggered == 4) drawOrchid();
  }
}

void drawWhale() {
  rainbowCycle(20);
  println("whale!!");
}

void drawHand() {
  rainbowCycle(20);
  println("hand!!");
}

void drawOwl() {
  rainbowCycle(20);
  println("owl!!");
}

void drawMoth() {
  rainbowCycle(20);
  println("moth!!");
}

void drawOrchid() {
  rainbowCycle(20);
  println("orchid!!");
}

void drawOrganicConstellation(int index, color c) {
  stroke(c);
  graphL.drawOrganicPath3D(index, getHandMapped());
}

void drawSpotlightLR(int rad, color c) {
  int y1 = constrain(int(map(handRDY, -.5, 0.3, height, 0)), 0, height);
  int x1 = constrain(int(map(handRDX, -.5, .7, 0, width)), 0, width);

  int y2 = constrain(int(map(handLDY, -.5, 0.3, height, 0)), 0, height);
  int x2 = constrain(int(map(handLDX, -.5, .7, 0, width)), 0, width);

  handLight(x1, y1, rad, c);
  handLight(x2, y2, rad, c);
}


// good
boolean checkMoth(int range) {
  //float deg = map(degrees(handRAngle), -180, 180, 0, 360);
  //println("moth HR: " + ( deg) + " should be 45");
  return (withinRange(degrees(handRAngle), 55, range) && withinRange(degrees(handLAngle), 145, range));
}

//
boolean checkOrchid(int range) {
  //float deg = map(degrees(handRAngle), -180, 180, 0, 360);
  //float deg2 = map(degrees(elbowRAngle), -180, 180, 0, 360);
  //print("hand: " + deg + " " + withinRange(degrees(handLAngle), 250, range) + "|||| elbow: " + deg2 + " " + withinRange(degrees(elbowLAngle), 340, range));
  //println("---" + "hand: " + deg + " " + withinRange(degrees(handRAngle), 300, range) + "|||| elbow: " + deg2 + " " + withinRange(degrees(elbowRAngle), 150, range));
  return (withinRange(degrees(handRAngle), 300, range) && withinRange(degrees(elbowRAngle), 180, range)
    && withinRange(degrees(handLAngle), 250, range) && withinRange(degrees(elbowLAngle), 340, range));
}

// good
boolean checkHand(int range) {
  return (withinRange(degrees(handRAngle), 260, range) && withinRange(degrees(handLAngle), 180, range));
}

// good
boolean checkOwl(int range) {
  return (withinRange(degrees(handRAngle), 250, range) && withinRange(degrees(handLAngle), 290, range));
}

// good
boolean checkWhale(int range) {
  //float deg = map(degrees(handRAngle), -180, 180, 0, 360);
  //float deg2 = map(degrees(elbowRAngle), -180, 180, 0, 360);
  //println("handR: " + deg + " " + withinRange(degrees(handRAngle), 90, range) + "|||| handL: " + deg2 + " " + withinRange(degrees(handLAngle), 180, range));

  return (withinRange(degrees(handRAngle), 300, range) && withinRange(degrees(handLAngle), 315, range));
}

boolean withinRange(float actual, float ideal, float range) {
  actual = map(actual, -180, 180, 0, 360);
  if (ideal - range/2 < 0) {
    if (actual < ideal + range/2 || actual > ideal + 360 - range/2) return true;
    return false;
  } else if (ideal + range/2 > 360) {
    if (actual > ideal - range/2 || actual < ideal + range/2 - 360) return true;
    return false;
  } else {
    if (actual > ideal - range/2 && actual < ideal + range/2) return true;
    return false;
  }
}


//void airBenderZ() {
//  int band = constrain(int(map(handRZ, 0, 50, 0, 8)), 0, 8);

//  for (int i = 0; i < lines.size(); i++) {
//    lines.get(i).displayBandZ(band, color(255));
//  }
//}

// old?
void airBenderY() {
  float rhBrightness = 0;
  if (handRAngle > -90 && handRAngle < 90) {
    rhBrightness = map(handRAngle, -90, 90, 0, 255);
  } else if (handRAngle > 90) {
    rhBrightness = map(handRAngle, 90, 180, 255, 255/2.0);
  } else if (handRAngle < -90) {
    rhBrightness = map(handRAngle, -180, -90, 255/2.0, 0);
  }

  displayLines(int(rhBrightness));
}

void testConstellations() {
  if (triggered > -1) {
    if (millis() - triggeredTime > 1000) {
      triggered = -1;
      triggeredTime = millis();
    } else {
      if (triggered == 0) {
        image(owl, 0, 0);
        println("whale!!");
      } else if (triggered == 1) {
        image(hand, 0, 0);
        println("hand!");
      } else if (triggered == 2) {
        image(owl, 0, 0);
        println("owl");
      } else if (triggered == 3) {
        image(moth, 0, 0);
        println ("moth");
      } else if (triggered == 4) {
        image(orchid, 0, 0);
        println("orchid");
      }
    }
  } else {
    if (checkWhale(20)) {
      triggered = 0;
      triggeredTime = millis();
    } else if (checkHand(20)) {
      triggered = 1;
      triggeredTime = millis();
    } else if (checkOwl(20)) {
      triggered = 2;
      triggeredTime = millis();
    } else if (checkMoth(20)) {
      triggered = 3;
      triggeredTime = millis();
    } else if (checkOrchid(20)) {
      triggered = 4;
      triggeredTime = millis();
    }
  }
}