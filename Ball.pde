// thanks, Daniel, for the inspiration
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Ball {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxspeed;
  float maxforce;

  Ball(int x, int y, int z) {
    acceleration = new PVector(0, 0, 0);
    velocity = new PVector(random(-4, 5), random(-3,3), 0);
    velocity.mult(5);
    position = new PVector(x, y, z);
    r = 10;
    maxspeed = 3;
    maxforce = 0.15;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    
    pointLight(255, 255, 255, 0, 0, 0);
    fill(255);
    stroke(255);
    sphere(r);
    popMatrix();
  }
  
  void run() {
    update();
     checkBoundaries();
    display();
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void checkBoundaries() {
    // check x
    if (position.x < -rectW/2 || position.x > rectW/2) {
      velocity.x = -velocity.x;
      acceleration.x = -acceleration.x;
      wallHit(position);
    }
    
    // check y
    if (position.y < -rectH/2 || position.y > rectH/2) {
      velocity.y = -velocity.y;
      acceleration.y = -acceleration.y;
      wallHit(position);
    }
  }
}