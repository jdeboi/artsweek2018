
void initGrid() {
  rectMode(CENTER);
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), cameraZ/20.0, -5000);

  numRectZ = 6;
  zSpacing = 300;
  rectW = int(width*.75);
  rectH = int(height*.75);
  //numLinesY = int(rectH*1.0/zSpacing);
  //numLinesX = int(rectW*1.0/zSpacing);
  numLinesY = 4;
  numLinesX = 4;

  balls = new ArrayList<Ball>();
  //balls.add(new Ball(200, 200, -300));
  //balls.add(new Ball(300, 200, -600));
  //balls.add(new Ball(200, 300, -500));
}

void drawGrid() {
  


  for (int z = 0; z < numRectZ; z++) {
    noFill();
    stroke(255);
    strokeWeight(6);
    pushMatrix();
    translate(0, 0, z * -zSpacing);
    rect(0, 0, rectW, rectH);
    popMatrix();
  }

  // lines
  for (int y = 0; y < numLinesY; y++) {
    float ysp = rectH * 1.0/(numLinesY -1);
    // left
    line(-rectW/2, -rectH/2 + ysp*y, 0, -rectW/2, -rectH/2+ysp*y, (numRectZ-1)*-zSpacing);
    // right
    line(rectW/2, -rectH/2 + ysp*y, 0, rectW/2, -rectH/2+ysp*y, (numRectZ-1)*-zSpacing);
  }
  for (int x = 0; x < numLinesX; x++) {
    float xsp = rectW * 1.0/(numLinesX -1);
    // top
    line(-rectW/2+xsp*x, -rectH/2, 0, -rectW/2+xsp*x, -rectH/2, (numRectZ-1)*-zSpacing);
    // bottom
    line(-rectW/2+xsp*x, rectH/2, 0, -rectW/2+xsp*x, rectH/2, (numRectZ-1)*-zSpacing);
  }

  // back wall lines
  for (int x = 0; x < numLinesX; x++) {
    float xsp = rectW * 1.0/(numLinesX -1);
    // up down
    line(-rectW/2+xsp*x, -rectH/2, (numRectZ-1)*-zSpacing, -rectW/2+xsp*x, rectH/2, (numRectZ-1)*-zSpacing);
  }
  for (int y = 0; y < numLinesY; y++) {
    float ysp = rectH * 1.0/(numLinesY -1);
    // left right
    line(-rectW/2, -rectH/2 + ysp*y, (numRectZ-1)*-zSpacing, rectW/2, -rectH/2+ysp*y, (numRectZ-1)*-zSpacing);
  }
  for (Ball ball : balls) {
    ball.run();
  }
  //drawSideRects();

  //drawTopRects();

}

void drawTopRects() {
  for (int x = 0; x < numLinesX-1; x++) {
    for (int z = 0; z < numRectZ-1; z++) {
      float xsp = rectW * 1.0/(numLinesX -1);
      fill(10, 255, 255);

      // top
      pushMatrix();
      rotateX(radians(90));
      translate(xsp*x-rectW/2+xsp/2, -zSpacing/2-zSpacing*z, rectH/2);
      rect(0, 0, xsp, zSpacing); 
      popMatrix();

      // bottom
      pushMatrix();
      rotateX(radians(90));
      translate(xsp*x-rectW/2+xsp/2, -zSpacing/2-zSpacing*z, -rectH/2);
      rect(0, 0, xsp, zSpacing); 
      popMatrix();
    }
  }
}

void setRects() {
  int i = 0;

  // topRects()
  for (int x = 0; x < numLinesX-1; x++) {
    for (int z = 0; z < numRectZ-1; z++) {
      float xsp = rectW * 1.0/(numLinesX -1);
      shapes.add(new MoveableShape(i++, TOP_S, x, -1, z, xsp*x-rectW/2+xsp/2, -zSpacing/2-zSpacing*z, rectH/2, xsp, zSpacing, radians(90), 0, 0));
      shapes.add(new MoveableShape(i++, BOTTOM_S, x, -1, z, xsp*x-rectW/2+xsp/2, -zSpacing/2-zSpacing*z, -rectH/2, xsp, zSpacing, radians(90), 0, 0));
    }
  }
  // sideRects
  for (int z = 0; z < numRectZ-1; z++) {
    for (int y = 0; y < numLinesY-1; y++) {
      float ysp = rectH * 1.0/(numLinesY -1);
      shapes.add(new MoveableShape(i++, LEFT_S, -1, y, z, zSpacing/2 + z*zSpacing, -rectH/2+ysp/2+y*ysp, -rectW/2, zSpacing, ysp, 0, radians(90), 0));
      shapes.add(new MoveableShape(i++, RIGHT_S, -1, y, z, zSpacing/2 + z*zSpacing, -rectH/2+ysp/2+y*ysp, rectW/2, zSpacing, ysp, 0, radians(90), 0));
    }
  }
  // backRects
  for (int x = 0; x < numLinesX -1; x++) {
    for (int y = 0; y < numLinesY-1; y++) {
      float ysp = rectH * 1.0/(numLinesY -1);
      float xsp = rectW * 1.0/(numLinesX -1);
      shapes.add(new MoveableShape(i++, BACK_S, x, y, -1, xsp*x-rectW/2+xsp/2, -rectH/2+ysp/2+y*ysp, -zSpacing*(numRectZ-1), xsp, ysp, 0, 0, 0));
    }
  }
}

void drawSideRects() {
  for (int z = 0; z < numRectZ-1; z++) {
    for (int y = 0; y < numLinesY-1; y++) {
      float ysp = rectH * 1.0/(numLinesY -1);
      fill(10, 255, 255);

      // left
      pushMatrix();
      rotateY(radians(90));
      translate(zSpacing/2 + z*zSpacing, -rectH/2+ysp/2+y*ysp, -rectW/2);
      rect(0, 0, zSpacing, ysp); 
      popMatrix();

      // right
      pushMatrix();
      rotateY(radians(90));
      translate(zSpacing/2 + z*zSpacing, -rectH/2+ysp/2+y*ysp, rectW/2);
      rect(0, 0, zSpacing, ysp); 
      popMatrix();
    }
  }
}

void wallHit(PVector p) {
}