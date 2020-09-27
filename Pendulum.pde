import java.util.Queue;
import java.util.LinkedList;

// A class to create pendulum objects. Each pendulum takes an anchor position,
// an initial theta (relative to the vertical axis), an initial angular velocity, 
// the radius of the bob, the colors of the cString and bob, the length of the 
// fadeout buffer, and an inv parameter to set the direction of gravity. 
// When update is called on a pendulum, that pendulum's position is updated and
// then drawn to the canvas with a trail of previous positions.
class Pendulum { 
  PVector anchor, pos; 
  float len, theta, aVel, aAcc, radBob;
  color cString, cBob;
  float g = -0.05; // magnitude and direction of the acceleration
  int bufferLen;
  color[] fade;
  Queue<PVector> buffer = new LinkedList();
  
  Pendulum (PVector anchor_, float len_, float theta_, float aVel_, float radBob_, color cString_, color cBob_, int bufferLen_, boolean inv_) {  
    anchor = new PVector(anchor_.x, anchor_.y); // location of the anchor
    len = len_; // length of the string
    theta = theta_; // initial angular displacement
    pos = new PVector(anchor.x+len*sin(theta), anchor.y+len*cos(theta)); // initial position of the bob
    aVel = aVel_; // initial angular velocity
    if (inv_) g *= -1; // set direction of gravity based on inv_
    radBob = radBob_; // set the radius of the bob
    
    cString = cString_; // color of the string
    cBob = cBob_; // color of the bob
    
    bufferLen = bufferLen_; // length of the trails buffer
    fade = new color[bufferLen_];
    // preload the trails buffer with the initial position of the bob and set the fade color for the trails
    for (int i=0; i < bufferLen; i++) {
      buffer.add(pos);
      float lerpFactor = map(i, 0, bufferLen-1, 0, 1);
      fade[i] = lerpColor(color(red(cBob), blue(cBob), green(cBob), 0), cBob, lerpFactor);
    }
  }
  
  void update() { 
    // update the angular acceleration, velocity, theta, and position at each time step
    aAcc = g/len * sin(theta);
    aVel += aAcc; 
    theta += aVel;
    pos = new PVector(anchor.x+len*sin(theta), anchor.y+len*cos(theta));
    
    // add the updated position to the buffer queue and remove the last
    buffer.add(pos);
    buffer.remove();
    
    // draw a gradient line from the position to the anchor
    gradientLine(anchor.x, anchor.y, pos.x, pos.y, color(0), cBob);
    
    // draw the trails using the buffer queue with colors taken from the fade array
    int i = 0;
    for(PVector pos : buffer) {
      noStroke(); fill(fade[i]);
      ellipse(pos.x, pos.y, radBob, radBob);
      i++;
    }
  } 
}

// Draw a line from p1 to p2 that changes color from a to b
void gradientLine(float x1, float y1, float x2, float y2, color a, color b) {
  float deltaX = x2-x1;
  float deltaY = y2-y1;
  float tStep = 1.0/dist(x1, y1, x2, y2);
  for (float t = 0.0; t < 1.0; t += tStep) {
    fill(lerpColor(a, b, t));
    ellipse(x1+t*deltaX,  y1+t*deltaY, 2, 2);
  }
}
