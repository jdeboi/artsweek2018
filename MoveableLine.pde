class MoveableLine {

  PVector p1;
  PVector p2;
  float ang;
  int constellationG = 0;
  long lastChecked = 0;

  MoveableLine(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    initLine();
  }


  void initLine() {
    leftToRight();
    ang = atan2(this.p1.y - this.p2.y, this.p1.x - this.p2.x);
    if (ang > PI/2) ang -= 2*PI;
  }

  void display(color c) {
    stroke(c);
    fill(c);
    display();
  }

  void display() {
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }

  void displayCenterPulse(float per) {
    per = constrain(per, 0, 1.0);
    float midX = (p1.x + p2.x)/2;
    float midY = (p1.y + p2.y)/2;
    float midZ = (p1.z + p2.z)/2;
    float x1 = map(per, 0, 1.0, midX, p1.x);
    float x2 = map(per, 0, 1.0, midX, p2.x);
    float y1 = map(per, 0, 1.0, midY, p1.y);
    float y2 = map(per, 0, 1.0, midY, p2.y);
    float z1 = map(per, 0, 1.0, midZ, p1.z);
    float z2 = map(per, 0, 1.0, midZ, p2.z);
    line(x1, y1, z1, x2, y2, z2);
  }


  void moveP1(int x, int y) {
    p1.x += x;
    p1.y += y;
  }

  void moveP2(int x, int y) {
    p2.x += x;
    p2.y += y;
  }

  void leftToRight() {
    if (p1.x > p2.x) {
      PVector temp = p1;
      p1.set(p2);
      p2.set(temp);
    }
  }

  void rightToLeft() {
    if (p1.x < p2.x) {
      PVector temp = p1;
      p1.set(p2);
      p2.set(temp);
    }
  }

  void displayPercent(float per) {
    per*= 2;
    float p = constrain(per, 0, 1.0);
    PVector pTemp = PVector.lerp(p1, p2, p);
    line(p1.x, p1.y, p1.z, pTemp.x, pTemp.y, pTemp.z);
  }

  void displayPercentWid(float per) {
    per = constrain(per, 0, 1.0);
    int sw = int(map(per, 0, 1.0, 0, 5));
    strokeWeight(sw);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }

  

  void displayNone() {
    //strokeWeight(18);
    display(color(0));
    //strokeWeight(2);
  }

  void displayConstellation(int num, color c) {
    if (constellationG == num) {
      display(c);
    } else {
      displayNone();
    }
  }

  void displayAngle(int start, int end, color c) {
    if (end < -360) {
      if (ang >= radians(start) || ang < end + 360) {
        display(c);
      }
    } else if (ang >= radians(start) && ang < radians(end)) {
      display(c);
    } else {
      displayNone();
    }
  }

  void displayPointX(int x) {
    float ym;

    if (x > p1.x && x < p2.x) {
      ym = map(x, p1.x, p2.x, p1.y, p2.y);
      ellipse(x, ym, 10, 10);
    } else if (x > p2.x && x < p1.x) {
      ym = map(x, p2.x, p1.x, p2.y, p1.y);
      ellipse(x, ym, 10, 10);
    }
  }

  void displayPointY(int y) {
    float xm;
    if ( (y > p1.y && y < p2.y) ) {
      xm = map(y, p1.y, p2.y, p1.x, p2.x);
      ellipse(xm, y, 10, 10);
      //println(y + " " + xm);
    } else if (y > p2.y && y < p1.y) {
      xm = map(y, p2.y, p1.y, p2.x, p1.x);
      ellipse(xm, y, 10, 10);
      //println(y + " " + xm);
    }
  }

  // www.jeffreythompson.org/collision-detection/line-point.php
  boolean mouseOver() {
    float x1 = screenX(p1.x, p1.y, p1.z);
    float y1 = screenY(p1.x, p1.y, p1.z);
    float x2 = screenX(p2.x, p2.y, p2.z);
    float y2 = screenY(p2.x, p2.y, p2.z);
    float px = mouseX;
    float py = mouseY;
    float d1 = dist(px, py, x1, y1);
    float d2 = dist(px, py, x2, y2);
    float lineLen = dist(x1, y1, x2, y2);
    float buffer = 0.2;    // higher # = less accurate
    if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
      return true;
    }
    return false;
  }

  void setConstellationG(int k) {
    constellationG = k;
  }


  //void displayRainbowCycle(int pulse) {
  //  //color c =  color(((i * 256 / lines.size()) + pulseIndex) % 255, 255, 255);
  //  colorMode(HSB, 255);
  //  for (float i = 0; i < 50; i++) {
  //    if (z1 <= z2) {
  //      float z = map(i, 0, 50, z1, z2);
  //      float s = map(z, 0, 9, 0, 255);
  //      stroke((s+pulse)%255, 255, 255);

  //      PVector pTemp = PVector.lerp(p1, p2, i/50.0);
  //      PVector pTempEnd = PVector.lerp(pTemp, p2, (i+1)/50.0);
  //      line(pTemp.x, pTemp.y, pTemp.z, pTempEnd.x, pTempEnd.y, pTempEnd.z);
  //    }
  //  }
  //  colorMode(RGB, 255);
  //}

  //void displayRainbowRandom() {
  //  rainbowIndex++;
  //  if (rainbowIndex > 255) rainbowIndex = 0;
  //  colorMode(HSB, 255);
  //  display(color(rainbowIndex, 255, 255));
  //  colorMode(RGB, 255);
  //}

  void handLight(float x, float y, int rad, color c) {
    float i = 0.0;
    float startX = p1.x;
    float startY = p1.y;
    boolean started = false;
    while (i < 1.0) {
      i+= .1;
      if (!started) {
        float dx = map(i, 0, 1.0, p1.x, p2.x);
        float dy = map(i, 0, 1.0, p1.y, p2.y);
        float dis = dist(x, y, dx, dy);
        if (dis < rad) {
          startX = dx;
          startY = dy;
          started = true;
        }
      } else {
        float dx = map(i, 0, 1.0, p1.x, p2.x);
        float dy = map(i, 0, 1.0, p1.y, p2.y);
        float dis = dist(x, y, dx, dy);
        if (dis > rad) {
          stroke(c);
          line(startX, startY, dx, dy);
          break;
        }
      }
    }
  }

  void displaySegment(float startPer, float sizePer) {
    PVector pTemp = PVector.lerp(p1, p2, startPer);
    PVector pTempEnd = PVector.lerp(pTemp, p2, startPer + sizePer);
    line(pTemp.x, pTemp.y, pTempEnd.x, pTempEnd.y);
  }

  int getX1() {
    return int(p1.x);
  }

  int getX2() {
    return int(p2.x);
  }

  int getY1() {
    return int(p1.y);
  }

  int getY2() {
    return int(p2.y);
  }
}