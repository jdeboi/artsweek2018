class Shape {

  ArrayList<PVector>pts;
  color c;
  int num;

    Shape(int num) {
    pts = new ArrayList<PVector>();
    c = color(random(255), 255, 255);
    this.num = num;
  }

  void display() {
    beginShape();
    for (int i = 0; i < pts.size(); i++) {
      vertex(pts.get(i).x, pts.get(i).y);
    }
    endShape(CLOSE);
    
    fill(255);
    
  }
  
  void drawMoveable() {
    for(PVector pt : pts) {
      pushMatrix();
      translate(pt.x, pt.y, pt.z);
      sphere(5);
      popMatrix();
    }
  }

  void sidesToRects(int s) {
    // top
    beginShape();
    vertex(pts.get(0).x-s/2, pts.get(0).y-s/2);
    vertex(pts.get(1).x+s/2, pts.get(1).y-s/2);
    vertex(pts.get(1).x+s/2, pts.get(1).y+s/2);
    vertex(pts.get(0).x-s/2, pts.get(0).y+s/2);
    endShape(CLOSE);
    
    // right
    beginShape();
    vertex(pts.get(1).x-s/2, pts.get(1).y-s/2);
    vertex(pts.get(1).x+s/2, pts.get(1).y-s/2);
    vertex(pts.get(2).x+s/2, pts.get(2).y+s/2);
    vertex(pts.get(2).x-s/2, pts.get(2).y+s/2);
    endShape(CLOSE);
    
    // left
    beginShape();
    vertex(pts.get(0).x-s/2, pts.get(0).y-s/2);
    vertex(pts.get(0).x+s/2, pts.get(0).y-s/2);
    vertex(pts.get(3).x+s/2, pts.get(3).y+s/2);
    vertex(pts.get(3).x-s/2, pts.get(3).y+s/2);
    endShape(CLOSE);
    
    // bottom
    beginShape();
    vertex(pts.get(3).x-s/2, pts.get(3).y-s/2);
    vertex(pts.get(2).x+s/2, pts.get(2).y-s/2);
    vertex(pts.get(2).x+s/2, pts.get(2).y+s/2);
    vertex(pts.get(3).x-s/2, pts.get(3).y+s/2);
    endShape(CLOSE);
  }

  void saveShape() {
    processing.data.JSONObject json2;
    json2 = new processing.data.JSONObject();

    json2.setInt("num", num);

    // adjacent node names
    processing.data.JSONArray ptsArray = new processing.data.JSONArray();      
    for (int j = 0; j < pts.size(); j+=3) 
    {
      ptsArray.setFloat(j, pts.get(j).x);
      ptsArray.setFloat(j+1, pts.get(j).y);
      ptsArray.setFloat(j+2, pts.get(j).z);
    }
    json2.setJSONArray("ptsArray", ptsArray);
    saveJSONObject(json2, "data/shapes/shape_" + num + ".json");
  }

  void addPoint() {
    pts.add(new PVector(mouseX, mouseY));
  }
  
  void addPoint(PVector p) {
    pts.add(p);
  }
  
  
}
