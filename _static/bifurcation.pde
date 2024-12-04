
class KVector
{
  float x;
  float r;
  KVector(float r, float x){
    this.x = x;
    this.r = r;
  }
}

KVector win2coord(KVector v){
  return new KVector(rmin + (rmax-rmin) / (width - 0) * (v.r - 0),
                     xmin + (xmax-xmin) / (height - 0) * ((height-v.x) - 0));
}

KVector coord2win(KVector p){
  return new KVector(  0 + (p.r - rmin) * (width-0)/ (rmax-rmin),
                     height-(0 + (p.x - xmin) * (height-0) / (xmax-xmin)));
}

// returns a string representation of input, rounded to 2 decimal places, with leading +/-
String format(float f) {
  return (f >= 0? "+" : "-") + abs(int(f)) + "." + int(100*abs(f%1));
}


float rmin;
float rmax;
float xmin;
float xmax;
int bin_width = 1;
int bin_display_width = 3;
var xdot;

void updateParameters(){
  xdot = math.eval("xdot(r,x) = " + document.getElementById("xdot").value);
  rmin = math.eval(document.getElementById('rmin').value);
  rmax = math.eval(document.getElementById('rmax').value);
  xmin = math.eval(document.getElementById('xmin').value);
  xmax = math.eval(document.getElementById('xmax').value);
}


void plot(){
  background(255);
  int Nr = width/bin_width;
  int Nx = height/bin_width;
  float[][] vals = new float[Nx][Nr];
  for(int i = 0; i < Nr; i++){
    for(int j = 0; j < Nx; j++){
      KVector v = win2coord(new KVector(i*bin_width,j*bin_width));
      vals[j][i] = xdot(v.r,v.x);
    }
  }
  noStroke();
  //background colors:
  for(int i = 1; i < Nr-1; i++){
    for(int j = 1; j < Nx-1; j++){
      if(vals[j][i] > 0){
        fill(255,0,0);
      } else if(vals[j][i] < 0){
        fill(0,0,255);
      } else {
        fill(0,255,0);
      }
      rect(i*bin_width, j*bin_width, bin_width, bin_width);
    }        
  }
  // fixed point, but not sure if stable
  for(int i = 1; i < Nr-1; i++){
    for(int j = 1; j < Nx-1; j++){
      if(vals[j][i-1] * vals[j][i+1] < 0){
        fill(128);
        ellipse(i*bin_width, j*bin_width, bin_display_width, bin_display_width);
      }
    }
  }
  // fixed point with known stability
  for(int i = 1; i < Nr-1; i++){
    for(int j = 1; j < Nx-1; j++){
      if(vals[j-1][i] < 0 && vals[j+1][i] > 0){
        fill(0);
        ellipse(i*bin_width, j*bin_width, bin_display_width, bin_display_width);
      } else if(vals[j-1][i] > 0 && vals[j+1][i] < 0){
        fill(255);
        ellipse(i*bin_width, j*bin_width, bin_display_width, bin_display_width);
      } 
    }
  }
}

void plotInit(){
  updateParameters();
  plot();
}

void setup(){
  size(400,400);
  cursor(CROSS);
  plotInit();
}

void draw(){
  if(update){
    update = false;
    plotInit();
  }
  if(saveImage){
    saveImage = false;
    saveFrame();
  }
  // display mouse coordinates in upper left corner:
  stroke(0);
  fill(255);
  rect(0, 0, 95, 23);
  KVector k = new KVector(mouseX, mouseY);
  k = win2coord(k);
  fill(0);
  text("(" + format(k.r) + "," + format(k.x) + ")", 5, 15);
}
