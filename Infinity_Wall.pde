boolean NEW_GRAPH = true;
boolean SEND_PANEL = false;
boolean FFT_ON = false;
boolean KINECT_ON = false;
//////////////////////////////////////////////////////////
import java.nio.ByteBuffer;
import processing.net.*;
Server myServer;
import java.util.ArrayList;
GraphList graphL;

///////////////////////////////////////
// MODES
int VISUALIZE = 0;
int ADD_NODES = 1;
int ADD_EDGES = 2;
int MOVE_NODES = 3;
int MOVE_LINES = 4;
int DELETE_NODES = 8;
int SET_NODES_Z = 7;
int SET_LINEZ = 5;
int SET_CONST = 6;
int MOVEABLE_LINES = 9;
int mode = ADD_NODES;

int currentScene = -1;
int visualMode = -1;
int kinectMode = -1; 
long sendTime = 0;
///////////////////////////////////////

long stringChecked = 0;
ArrayList<Line> lines;
PVector offset;
PVector nodeOffset;
float sc = 1.0;
int lineIndex = 0;
int triggered = -1;
int triggeredTime = 0;
PImage whale, hand, orchid, moth, owl;
int currentString;

// grid and balls
int zSpacing, rectW, rectH, numLinesY, numLinesX, numRectZ;
ArrayList<Ball> balls;
ArrayList<Shape> shapes;
int TOP_S = 0;
int BOTTOM_S = 1;
int LEFT_S = 2;
int RIGHT_S = 3;
int BACK_S = 4;

long lastChecked = 0;
int visualIndex = 0;
int lastCheckedMode = 0;
color c1, c2;

void setup() {
  fullScreen(P3D);

  //size(400, 400);
  lines = new ArrayList<Line>();
  shapes = new ArrayList<Shape>();
  graphL = new GraphList(100);
  if (!NEW_GRAPH) graphL.loadGraph();
  initModes();
  initGrid();
  setRects();

  colorMode(HSB, 255);
  c1 = color(random(255), 255, 255);
  c2 = color(random(255), 255, 255);
}


//--------------------------------------------------------------
void draw() {
  background(0);
  pointLight(205, 205, 205, mouseX, mouseY, -100);
  if (mode == VISUALIZE) {
    noCursor();
    pushMatrix();
    translate(width/2, height/2, 0);
    //setRainbowPulse(20);
    setGradientZs();
    displayShapes();

    popMatrix();

    stroke(255);
    fill(255);
    strokeWeight(3);
    changeMode();
    playMode();
    //for (Line l : lines) {
    //  l.display(255);
    //}
  } else {
    settingFunctions();
  }
}

void changeMode() {
  if (millis() - lastCheckedMode > 8000) {
    if (int(random(2)) == 0) visualMode = V_DISPLAY;
    else visualMode = int(random(15));
    lastCheckedMode = millis();
  }
}

//--------------------------------------------------------------
void keyPressed() {
  if (key == 's') {
    graphL.saveGraph();
    graphL.printGraph();
  } else if (key == 'r') graphL.loadGraph();
  else if (key == 'a') mode = ADD_NODES;
  else if (key == 'e') mode = ADD_EDGES;
  else if (key == 'm') mode = MOVE_LINES;
  else if (key == 't') mode = MOVEABLE_LINES;
  else if (key == 'n') mode = MOVE_NODES;
  else if (key == 'd') mode = DELETE_NODES;
  else if (key == 'z') mode = SET_LINEZ;
  else if (key == 'c') {
    mode = SET_CONST;
  } else if (key == 'v') {
    mode = VISUALIZE;
  } else if (key == 'p') {
    graphL.printGraph();
  } else if (mode == MOVE_LINES) {
    if (lineIndex >= 0) {
      Line l = lines.get(lineIndex);
      if (keyCode == UP) l.moveP1(0, -1);
      else if (keyCode == DOWN) l.moveP1(0, 1);
      else if (keyCode == RIGHT) l.moveP1(1, 0);
      else if (keyCode == LEFT) l.moveP1(-1, 0);
      else if (key == 'i') l.moveP2(0, -1);     
      else if (key == 'k') l.moveP2(0, 1);     
      else if (key == 'l') l.moveP2(1, 0);
      else if (key == 'j') l.moveP2(-1, 0);
    }
  } else if (mode == MOVE_NODES) {
    if (graphL.hasCurrentNode()) {
      if (keyCode == UP) graphL.moveCurrentNode(0, -1);
      else if (keyCode == DOWN) graphL.moveCurrentNode(0, 1);
      else if (keyCode == RIGHT) graphL.moveCurrentNode(1, 0);
      else if (keyCode == LEFT) graphL.moveCurrentNode(-1, 0);
    }
  } else if (mode == SET_LINEZ) {
    println(parseInt(key));
    int k = parseInt(key) - 48;
    if (k > 0 && k < 9) {
      lines.get(lineIndex).setZIndex(k);
    }
  } else if (mode == SET_NODES_Z) {
    if (graphL.hasCurrentNode()) {
      println(parseInt(key));
      int k = parseInt(key) - 48;
      if (k > 0 && k < 9) {
        graphL.setCurrentNodeZ(k);
      }
    }
  } else if (mode == SET_CONST) {
    int k = parseInt(key) - 48;
    if (k > 0 && k < 9) {
      lines.get(lineIndex).setConstellationG(k);
    }
  } else if (mode == VISUALIZE) {
  }
  return;
}

// get a string
// up, down, left, right -> p1
// i, k, j, l -> p2
boolean hasCurrentStringPoint() {
  return true;
}

//--------------------------------------------------------------
void keyReleased() {
}

//--------------------------------------------------------------
void mousePressed() {
}

//--------------------------------------------------------------
void mouseReleased() {
  if (mode == ADD_NODES) {
    graphL.display();
    graphL.addNode(mouseX, mouseY);
  } else if (mode == MOVE_NODES) {
    graphL.display();
    graphL.checkNodeClick(mouseX, mouseY);
  } else if (mode == ADD_EDGES) {
    graphL.checkEdgeClick(mouseX, mouseY);
  } else if (mode == DELETE_NODES) {
    graphL.checkDeleteNodeClick(mouseX, mouseY);
  } else if (mode == SET_LINEZ || mode == SET_CONST || mode == MOVE_LINES) {
    for (int i = 0; i < lines.size(); i++) {
      if (lines.get(i).mouseOver()) {
        lineIndex = i;
        println("l index " + lineIndex);
        break;
      }
    }
  } else if (mode == SET_NODES_Z) {
    graphL.checkNodeClick(mouseX, mouseY);
    updateLineZs();
  }
}

void setLines() {
  for (int i = 0; i < lines.size(); i++) {
    Line l = lines.get(i);
    if (l.mouseOver()) {
      stroke(255);
      fill(255);
    } else if (i == lineIndex) {
      colorMode(RGB);
      stroke(0, 255, 255);
      fill(0, 255, 255);
    } else {
      colorMode(HSB);
      stroke(map(l.zIndex, 0, 9, 0, 255), 255, 255);
      fill(map(l.zIndex, 0, 9, 0, 255), 255, 255);
    }
    l.display();
  }
}



void setConst() {
  background(50);
  for (int i = 0; i < lines.size(); i++) {
    Line l = lines.get(i);
    if (l.mouseOver()) {
      stroke(255);
      fill(255);
    } else if (i == lineIndex) {
      colorMode(RGB);
      stroke(0, 255, 255);
      fill(0, 255, 255);
    } else {
      colorMode(HSB);
      stroke(map(l.constellationG, 0, 9, 0, 255), 255, 255);
      fill(map(l.constellationG, 0, 9, 0, 255), 255, 255);
    }
    l.display();
  }
}

void updateLineZs() {
  for (int i = 0; i < lines.size(); i++) {
    lines.get(i).updateZ();
  }
}

void displayLineZDepth() {
  for (Line line : lines) {
    line.displayZDepth();
  }
}

void deleteLines(int index) {
  for (int i = lines.size() - 1; i >=0; i--) {
    if (lines.get(i).findByID(index)) {
      lines.remove(i);
    }
  }
}

void displayBox(int hue, String title) {
  if (mouseY < height - 60) {
    colorMode(HSB, 255);
    fill(hue, 255, 255);
    noStroke();
    rect(0, height-50, width, 50);
    fill(255);
    stroke(255);
    textSize(30);
    text(title, 30, height-15);
    colorMode(RGB, 255);
  }
}

void settingFunctions() {
  graphL.displayNodes();
  graphL.displayNodeLabels();

  strokeWeight(3);
  displayLines(255);

  if (mode == ADD_EDGES) {
    graphL.drawLineToCurrent(mouseX, mouseY);
    displayBox(0, "ADD EDGES");
  } else if (mode == ADD_NODES) {
    ellipse(mouseX, mouseY, 20, 20);
    displayBox(20, "ADD NODES");
  } else if (mode == DELETE_NODES) {
    graphL.display();
    displayBox(50, "DELETE NODES");
  } else if (mode == MOVE_NODES || mode == MOVE_LINES) {
    graphL.displayCurrentNode();
    displayBox(70, "MOVE");
  } else if (mode == SET_NODES_Z) {
    displayLineZDepth();
    displayBox(100, "SET NODES Z");
    graphL.displayCurrentNode();
  } else if (mode == SET_CONST) {
    setConst();
    displayBox(140, "SET CONSTELLATIONS");
  } else if (mode == SET_LINEZ) {
    displayZIndexes();
  }
}

void displayZIndexes() {
  for (Line l : lines) {
    l.displayZIndex();
  }
}
boolean blackBackground() {
  if (kinectMode == K_PAINT) return false;
  return true;
}

void saveShapes() {
  processing.data.JSONObject json;
  json = new processing.data.JSONObject();
  json.setInt("num", shapes.size());
  saveJSONObject(json, "data/shapes/numShapes.json");
  for (Shape s : shapes) {
    s.saveShape();
  }
}

void loadShapes() {
  processing.data.JSONObject graphJson;
  graphJson = loadJSONObject("data/shapes/numShapes.json");
  int numShapes = graphJson.getInt("numShapes");
  //println(numShapes);

  shapes = new ArrayList<Shape>();
  for (int i = 0; i < numShapes; i++) {
    processing.data.JSONObject shape = loadJSONObject("data/shapes/shape_" + i + ".json");
    int num = shape.getInt("num");
    shapes.add(new Shape(num));
    processing.data.JSONArray ptsArray = shape.getJSONArray("ptsArray");
    for (int j = 0; j < ptsArray.size(); j+=3) {
      float x = ptsArray.getFloat(j);
      float y = ptsArray.getFloat(j+1);
      float z = ptsArray.getFloat(j+2);
      shapes.get(shapes.size() -1).addPoint(new PVector(x, y, z));
    }
  }
}

void displayShapes() {
  for (Shape s : shapes) {
    s.display();
  }
}

void rainbowStrip() {
  colorMode(HSB, 255);
  if (millis() - lastChecked > 500) {
    lastChecked = millis();
    visualIndex++;
    visualIndex %= 7;
    println(visualIndex);
    for (Shape s : shapes) {
      if (((MoveableShape) s).zSide == visualIndex) {
        s.c = color(map(((MoveableShape) s).zSide, 0, 7, 0, 255), 255, 255);
      } else s.c = color(map(((MoveableShape) s).zSide, 0, 7, 0, 255), 55, 55);
    }
  }
}

void setGradientZs() {
  colorMode(HSB, 255);
  if (millis() - lastChecked > 8000) {
    c1 = color(random(255), 255, 255);
    c2 = color((hue(c1)+80)%255, 255, 255);
    lastChecked = millis();
  }
  for (Shape s : shapes) {
    ((MoveableShape) s).setGradientZ(c1, c2, 30);
  }
}

void setRainbowPulse(int jump) {
  for (Shape s : shapes) {
    ((MoveableShape) s).setRainbow(jump);
  }
}
