PlotArea plotOne, plotTwo;

void setup(){
  size(500,300);
  frameRate(5);
}

void draw(){
  if(updateWaveforms){
    updateWaveforms = false;
    update();
  }
}

String getCoordinateSystem(){
  return document.getElementById('coordinateSelect').value;
}

void update(){
  background(255);
  float[] x_arr = new float[0];
  float[] y_arr = new float[0];
  if(getCoordinateSystem() == "Cartesian"){
    x_arr = x_waveform;
    y_arr = y_waveform;
  } else if(getCoordinateSystem() == "Polar"){
    x_arr = r_waveform;
    y_arr = theta_waveform;
    for(int i = 0; i < x_arr.length; i++){
      y_arr[i] = math.mod(y_arr[i],2*PI);
    }
  }
  max_iter = math.eval(document.getElementById('max_iter').value);
  plotOne = new PlotArea(0,0,       width,height/2,0,max_iter,Math.min(...x_arr),Math.max(...x_arr),1);
  plotTwo = new PlotArea(0,height/2,width,height/2,0,max_iter,Math.min(...y_arr),Math.max(...y_arr),2);
  plotOne.lines(x_arr);
  plotTwo.lines(y_arr);
  plotOne.draw();
  plotTwo.draw();
  stroke(0);
  strokeWeight(3);
  line(0,height/2,width,height/2);
  strokeWeight(1);
}


