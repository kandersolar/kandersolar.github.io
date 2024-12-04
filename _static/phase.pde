// This program displays a phase portrait for a first order 2-variable system.
// Click to start an integration path

// convert window pixel coordinates to mathematical coordinates
// functional inverse of coord2win
void win2coord(float[] input) {
  input[0] =  2*xscale * (input[0]-width/2) / width;
  input[1] = -2*yscale * (input[1]-height/2) / height;
}

// convert math coordinates to window coordinates
// inverse of win2coord
void coord2win(float[] input) {
  input[0] =  input[0] * width/2 / xscale + width/2;
  input[1] = -input[1] * height/2 / yscale + height/2;
}

//convert cartesian to polar
void cart2pol(float[] input) {
  PVector p = new PVector(input[0], input[1]);
  input[0] = p.mag();
  input[1] = p.heading();
}

//convert polar to cartesian
void pol2cart(float[] input){
  float x = input[0] * cos(input[1]);
  float y = input[0] * sin(input[1]);
  input[0] = x;
  input[1] = y;
}

// returns a string representation of input, rounded to 2 decimal places, with leading +/-
String format(float f) {
  return (f >= 0? "+" : "-") + abs(int(f)) + "." + int(100*abs(f%1));
}

String getCoordinateSystem(){
  return document.getElementById('coordinateSelect').value;
}

var f;
var g;
float xscale;
float yscale;
int max_iter;
float step_size;
float null_tol;
void updateParameters(){
  document.getElementById('errorMessage').innerHTML = "";
  if(getCoordinateSystem() == "Cartesian"){
    try {
      f = math.eval("f(x,y) = " + document.getElementById('xdot').value);
      g = math.eval("g(x,y) = " + document.getElementById('ydot').value);
    } catch(e) {
      f = math.eval("f(x,y) = 0");
      g = math.eval("g(x,y) = 0");
      document.getElementById('errorMessage').innerHTML = e;
    }
  } else if(getCoordinateSystem() == "Polar"){
    try {
      f = math.eval("f(r,theta) = " + document.getElementById('rdot').value);
      g = math.eval("g(r,theta) = " + document.getElementById('thetadot').value);
    } catch(e) {
      f = math.eval("f(r,theta) = 0");
      g = math.eval("g(r,theta) = 0");
      document.getElementById('errorMessage').innerHTML = e;
    }
  }
  console.log("here");
  xscale = math.eval("abs("+document.getElementById('xlim').value+")");
  yscale = math.eval("abs("+document.getElementById('ylim').value+")");
  max_iter = math.eval(document.getElementById('max_iter').value);
  step_size = math.eval(document.getElementById('step_size').value);
  null_tol = math.eval(document.getElementById('null_tol').value);
}

void drawNullclines(){
  stroke(100);
  fill(100);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float[] coord = new float[] {
        i, j
      };
      if(getCoordinateSystem() == "Cartesian"){
        win2coord(coord);
        float dx = f(coord[0], coord[1]);
        float dy = -1*g(coord[0], coord[1]);
        if (abs(dx) < null_tol || abs(dy) < null_tol) {
          ellipse(i, j, 2, 2);
        }
      } else if(getCoordinateSystem() == "Polar"){
        win2coord(coord);
        cart2pol(coord);
        float dr = f(coord[0], coord[1]);
        float dO = g(coord[0], coord[1]);
        if(abs(dr) < null_tol || abs(dO) < null_tol) {
          ellipse(i,j,2,2);
        }
      }
    }
  }
}

void drawVectorField(){
  stroke(200);
  fill(200);
  for (int i = 0; i < width; i += 15) {
    for (int j = 0; j < height; j+=15) {
      float[] coord = new float[] {
        i, j
      };
      if(getCoordinateSystem() == "Cartesian"){
        win2coord(coord);
        float dx = f(coord[0], coord[1]);
        float dy = -1*g(coord[0], coord[1]);
        PVector p = new PVector(dx, dy);
        p.normalize();
        p.mult(8);
        ellipse(i+p.x/2, j+p.y/2, 2, 2);
        line(i-p.x/2, j-p.y/2, i+p.x/2, j+p.y/2);
      } else if(getCoordinateSystem() == "Polar"){
        win2coord(coord);
        cart2pol(coord);
        float dr = f(coord[0], coord[1])*step_size;
        float dO = g(coord[0], coord[1])*step_size;
//        PVector p = new PVector(dr*cos(coord[1]) - dO*sin(coord[1]),
//                                dr*sin(coord[1]) + dO*cos(coord[1]));
        float dx = (coord[0] + dr) * cos(coord[1] + dO) - coord[0]*cos(coord[1]);
        float dy = (coord[0] + dr) * sin(coord[1] + dO) - coord[0]*sin(coord[1]);
        PVector p = new PVector(dx, dy);
        p.normalize();
        p.y = p.y * -1;
        p.mult(8);
        ellipse(i+p.x/2,j+p.y/2,2,2);
        line(i-p.x/2,j-p.y/2,i+p.x/2,j+p.y/2);
      }
    }
  }
}

void drawAxisLines(){
  stroke(0);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  int num_ticks = 5;
  float x_interval = xscale / num_ticks;
  float y_interval = yscale / num_ticks;
  stroke(0);
  fill(0);
  for(int i = -num_ticks; i <= num_ticks; i++){
    if(i == 0) continue;
    float x = width/2 + i*(width/2)/num_ticks;
    float y = height/2;
    line(x, y + 3, x, y - 3);
    float[] pos = new float[]{x, y};
    win2coord(pos);
    text(pos[0].toExponential(1),x-20,y+15);

    float y = height/2 + i*(height/2)/num_ticks;
    float x = width/2;
    line(x - 3, y, x + 3, y);
    float[] pos = new float[]{x, y};
    win2coord(pos);
    text(pos[1].toExponential(1),x-50,y+5);
  }
}

void redraw(){
  background(255);
  updateParameters();
  try {
    drawVectorField();
    if(document.getElementById('drawNullclines').checked){
      drawNullclines();
    }
  } catch(e) {
    document.getElementById('errorMessage').innerHTML = e;
  } 
  drawAxisLines();
}

void setup() {
  size(500, 500);
  cursor(CROSS);
  frameRate(5);
}

void draw() {
  if(update){
    update = false;
    redraw();
    x_waveform = [];
    y_waveform = [];
    r_waveform = [];
    theta_waveform = [];
    updateWaveforms = true;
  }
  if(saveImage){
    saveImage = false;
    saveFrame();
  }
}
void mouseMoved(){
  // display mouse coordinates in upper left corner:
  stroke(0);
  fill(255);
  rect(0, 0, 95, 23);
  float[] p = new float[2];
  p[0] = mouseX;
  p[1] = mouseY;
  win2coord(p);
  fill(0);
  text("(" + format(p[0]) + "," + format(p[1]) + ")", 5, 15);
}
void mousePressed() {
  try {
    drawTrajectory();
  } catch(e) {
    document.getElementById('errorMessage').innerHTML = e;
  }
}

void drawTrajectory(){
  boolean canGoOutside = document.getElementById('trajectoriesOutside').checked;
  boolean rainbow = document.getElementById('rainbow').checked;
  if(rainbow){
    color c = color(random(255), random(255), random(255));
    stroke(c);
    fill(c);
  } else {
    stroke(0);
    fill(0);
  }
  if(getCoordinateSystem() == "Cartesian"){
    // global variables for waveform plot:
    x_waveform = new float[max_iter];
    y_waveform = new float[max_iter];

    float[] x = new float[2];
    x[0] = mouseX;
    x[1] = mouseY;
    win2coord(x);
    // abort after 1000 iterations, or if outside the window
    for (int i = 0; i < max_iter; i++) {
      x_waveform[i] = x[0];
      y_waveform[i] = x[1];
      float[] dx = new float[2];
      dx[0] = f(x[0], x[1]);
      dx[1] = g(x[0], x[1]);
      x[0] = x[0] + dx[0] * step_size;
      x[1] = x[1] + dx[1] * step_size;
      float[] p = new float[2];
      arrayCopy(x, p);
      coord2win(p);
      if (!canGoOutside && (p[0] > width || p[1] > height
        || p[0] < 0 || p[1] < 0)){
        break;
      }
      if(isNaN(p[0]) || isNaN(p[1])
        || !isFinite(p[0]) || !isFinite(p[1])) {
        break;
      }
      point(p[0], p[1]);
    }
  } else if(getCoordinateSystem() == "Polar"){
    // global variables for waveform plots:
    r_waveform = new float[max_iter];
    theta_waveform = new float[max_iter];

    float[] x = new float[2];
    x[0] = mouseX;
    x[1] = mouseY;
    win2coord(x);
    cart2pol(x);
    // abort after 1000 iterations, or if outside the window
    for (int i = 0; i < max_iter; i++) {
      r_waveform[i] = x[0];
      theta_waveform[i] = x[1];
      float[] dx = new float[2];
      dx[0] = f(x[0], x[1]);
      dx[1] = g(x[0], x[1]);
      x[0] = x[0] + dx[0] * step_size;
      x[1] = x[1] + dx[1] * step_size;
      float[] p = new float[2];
      arrayCopy(x, p);
      pol2cart(p);
      coord2win(p);
      if (!canGoOutside && (p[0] > width || p[1] > height
                         || p[0] < 0     || p[1] < 0)){
        break;
      }
      if(isNaN(p[0]) || isNaN(p[1])
        || !isFinite(p[0]) || !isFinite(p[1])) {
        break;
      }
      point(p[0], p[1]);
    }
  }
  // global variable
  updateWaveforms = true;
}

