class MoveableShape extends Shape {

  int side, xSide, ySide, zSide;
  float x, y, z, w, h, rx, ry, rz;


  MoveableShape(int i, int side, int xSide, int ySide, int zSide, float x, float y, float z, float w, float h, float rx, float ry, float rz) {
    super(i);

    this.side = side;
    this.xSide = xSide;
    this.ySide = ySide;
    this.zSide = zSide;
    this.x = x;
    this.y = y;
    this.z = z;
    this.rx = rx;
    this.ry = ry;
    this.rz = rz;

    addPoint(new PVector(-w/2, -h/2, 0));
    addPoint(new PVector(w/2, -h/2, 0));
    addPoint(new PVector(w/2, h/2, 0));
    addPoint(new PVector(-w/2, h/2, 0));
  }

  void display() {
    //fill(c);
    //noFill();
    noStroke();

    pushMatrix();

    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);

    translate(x, y, z);
    //pulse(-1, 200);
    //pulseRainbow();
    //if (side == BACK_S) fill(0);
    fill(c);
    super.display();

    //stroke(255);
    noStroke();
    //sidesToRects(10);
    //drawMoveable();
    popMatrix();

    //checkMouseOver();
  }

  void pulse(int direction, int speed) {
    if (millis() - lastChecked > speed) {
      visualIndex+=direction;
      if (visualIndex < 0) visualIndex = numRectZ -1;
      else if (visualIndex > numRectZ -1) visualIndex = 0;

      lastChecked = millis();
    }
    if (this.zSide == visualIndex) {
      fill(255);
    } else fill(100);
  }


  void setGradientZ(color c1, color c2, int jump) {
    colorMode(HSB, 255);
    int colhue = (frameCount%255) + zSide*jump;
    if (colhue < 0) colhue += 255;
    else if (colhue > 255) colhue -= 255;
    colorMode(RGB, 255);
    float m;
    if (colhue < 127) {
      m = constrain(map(colhue, 0, 127, 0, 1), 0, 1);
      c = lerpColor(c1, c2, m);
    }
    else {
      m = constrain(map(colhue, 127, 255, 0, 1), 0, 1);
      c = lerpColor(c2, c1, m);
    }
  }



  void setRainbow(int jump) {
    colorMode(HSB, 255);
    int colhue = (frameCount%255) + zSide*jump;
    if (colhue < 0) colhue += 255;
    else if (colhue > 255) colhue -= 255;
    if (zSide == numRectZ-1) c = 0;
    else c = color(colhue, 255, 255);
  }

  void sideColor(color[] cols) {
    if (side == BACK_S) {
      fill(cols[5]);
    } else if (side == LEFT_S) {
      fill(cols[0]);
    } else if (side == TOP_S) {
      fill(cols[1]);
    } else if (side == BOTTOM_S) {
      fill(cols[3]);
    } else if (side == RIGHT_S) {
      fill(cols[2]);
    }
  }

  void sidesToRects(int s) {
    int jump = 1;
    pushMatrix();
    if (side == BACK_S) translate(0, 0, jump);
    else if (side == LEFT_S)translate(0, 0, jump);
    else if (side == TOP_S) translate(0, 0, -jump);
    else if (side == BOTTOM_S) translate(0, 0, jump);
    else if (side == RIGHT_S) translate(0, 0, -jump);
    super.sidesToRects(s);
    popMatrix();
  }

  PVector checkMouseOver() {
    for (PVector p : pts) {
      PVector temp = new PVector(screenX(p.x, p.y, p.z), screenY(p.x, p.y, p.z));
      float d = temp.dist(new PVector(mouseX, mouseY));
      println(d);
      if (d < 10) {
        println("found one");
        return p;
      }
    }
    return null;
  }
}
