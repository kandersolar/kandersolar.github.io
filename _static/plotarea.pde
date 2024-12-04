class PlotArea
{
  int anchorX, anchorY;
  int wide, high;
  float xmin, xmax, ymin, ymax;
  PGraphics canvas;
  int coordinate;
  String xlabel, ylabel, title;
  
  PlotArea(int AX, int AY, int W, int H, float xm, float XM, float ym, float YM, int C){
    anchorX = AX;
    anchorY = AY;
    wide = W;
    high = H;
    float xpad = (XM-xm)/10;
    float ypad = (YM-ym)/10;
    xmin = xm - xpad;
    xmax = XM + xpad;
    ymin = ym - ypad;
    ymax = YM + ypad;
    coordinate = C;
    canvas = createGraphics(wide,high);
    xlabel = "";
    ylabel = "";
    title = "";
  }
  
  void coord2pixel(float[] input){
    input[0] = wide * (input[0] - xmin) / (xmax-xmin);
    input[1] = high - high * (input[1] - ymin) / (ymax-ymin);
  }
  
  void point(float x, float y){
    float[] vec = new float[]{x,y};
    coord2pixel(vec);
    canvas.beginDraw();
    canvas.ellipse(vec[0],vec[1],5,5);
    canvas.endDraw();
  }
 
  void points(float[] x, float[] y){
    int N = Math.min(x.length, y.length);
    canvas.beginDraw();
    canvas.stroke(0,100);
    for(int i = 0; i < N; i++){
      float[] vec = new float[]{x[i],y[i]};
      coord2pixel(vec);
      canvas.point(vec[0],vec[1]);
    }
    canvas.endDraw();
  }

  void scatter(float[] x, float[] y, float size){
    int N = Math.min(x.length, y.length);
    canvas.beginDraw();
    for(int i = 0; i < N; i++){
      float[] vec = new float[]{x[i],y[i]};
      coord2pixel(vec);
      canvas.ellipse(vec[0],vec[1],size,size);
    }
    canvas.endDraw();
  }

  void scatter(float[] x, float[] y){
    scatter(x,y,5);
  }

  void lines(float[] y){
    float[] x = new float[y.length];
    for(int i = 0; i < x.length; i++) x[i] = i;
    lines(x,y);
  }

  void lines(float[] x, float[] y){
    stroke(0);
    if(x.length < 2 || y.length < 2){
      console.log("arrays are too short to draw lines");
      console.log(x);
      console.log(y);
      return;
    }
    canvas.beginDraw();
    int L = min(x.length, y.length);
    float[] u = new float[2];
    float[] v = new float[2];
    for(int i = 1; i < L; i++){
      u[0] = x[i-1];
      u[1] = y[i-1];
      v[0] = x[i];
      v[1] = y[i];
      coord2pixel(u);
      coord2pixel(v);
      canvas.line(u[0],u[1],v[0],v[1]);
    }
    canvas.endDraw();
  }

  void xlabel(String s){ xlabel = s; }
  void ylabel(String s){ ylabel = s; }
  void title(String s){ title = s; }
  
  void clear(){
    canvas = createGraphics(wide,high);
    xlabel = "";
    ylabel = "";
    title = "";
  }
  void draw(){
    drawAxes();
    image(canvas, anchorX, anchorY); 
  }
  void drawAxes(){
    float[] zeros = new float[]{0,0};
    float[] mins = new float[]{xmin,ymin};
    float[] maxs = new float[]{xmax,ymax};
    coord2pixel(zeros);
    coord2pixel(mins);
    coord2pixel(maxs);
    canvas.beginDraw();
    canvas.line(zeros[0],mins[1],zeros[0],maxs[1]);
    canvas.line(mins[0],zeros[1],maxs[0],zeros[1]);
    canvas.fill(0);
    canvas.textSize(16);
    String label;
    if(getCoordinateSystem() == "Cartesian"){
      if(coordinate == 1)
        label = "x";
      else 
        label = "y";
    } else if(getCoordinateSystem() == "Polar"){
      if(coordinate == 1) 
        label = "r";
      else
        label = "Î¸";
    }
    canvas.text("t",wide-10,zeros[1]-15);
    canvas.text(label,zeros[0]+5,15);
    canvas.endDraw();
  }
  
}

