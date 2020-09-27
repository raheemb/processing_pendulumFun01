int frame = 0; // frame counter
int nPendulums = 30; // set the number of pendulums
Pendulum[] pendulums = new Pendulum[nPendulums]; // array of lower pendulums
Pendulum[] pendulumsInv = new Pendulum[nPendulums]; // array of upper pendulums


void setup() { 
  size(800, 800); // set canvas size
  
  // set initial conditions of pendulum array
  PVector anchor = new PVector(0,0);
  float theta = PI/2;
  float aVel = 0;
  float radBob = 10;
  
  // set color palette
  color c1 = color(254, 218, 106, 255);
  color c2 = color(9, 188, 138, 255);
  color cString = color(255, 255, 255);
  
  // create
  for (int i=0; i < nPendulums; i++) {
    // evenly space out pendulums from the edge to the center
    float len = map(i, 0, nPendulums-1, 390, 20);
    
    // determine the length of the trail based on the length of the pendulum arm
    int bufferLen = round(map(i, 0, nPendulums-1, 200, 20));
    
    // set color of pendulum based on length
    float lerpFactor = map(i, 0, nPendulums-1, 0, 1);
    color cBob = lerpColor(c1, c2, lerpFactor);

    // initialize the downwards swinging and upwards swinging pendulums
    pendulums[i] = new Pendulum(anchor, len, theta, aVel, radBob, cString, cBob, bufferLen, true);
    pendulumsInv[i] = new Pendulum(anchor, len, theta, aVel, radBob, cString, cBob, bufferLen, false);
  }
}


void draw() {  
  translate(width/2, height/2); // translate to center the sketch in the frame
  background(0); // clear the canvas each frame 
  
  // Iterate through all pendulums and update their positions
  for (Pendulum p : pendulums) p.update();
  for (Pendulum p : pendulumsInv) p.update();
  
  //// Save the frames as png files
  //saveFrame("frames/#######.png");
  //frame++;
  //if (frame >= 3*1800) exit();
}  
