float minx = -2.5;
float maxx = 2;
float miny = -1.5;
float maxy = 1.5;
float midx = (maxx+minx)/2;
float midy = (maxy+miny)/2;
float toScreenScale = 1;

void setup() {
  //fullScreen();
  size(1600, 900);
  background(255);
  noLoop(); // only execute the draw function once
  colorMode(HSB);
}

void draw() {
  float density = 0.1;
  float xscale = width/(maxx-minx); //<>//
  float yscale = height/(maxy-miny);
  int maxiter=30;
  
  float x = minx;
  float y = miny;
  float ydir = 0;
  float xdir = density;
  
  toScreenScale = min(xscale,yscale) * 0.9;

  //Take copy of limits because we will change them
  float xmin = minx;
  float xmax = maxx;
  float ymin = miny;
  float ymax = maxy;
   //<>//
  while ((xmax-xmin)>density && (xmax-xmin)>density){
    ArrayList<Point> p = makePoints(x, y, 500, maxiter);
    color c = color(0,0,0);
    if (p.size()<maxiter){
      c=color((p.size()*(255/maxiter)), (p.size()*(255/maxiter)), 255);
      //c=color((p.size()*(255/maxiter)), 127, 255);
    }
    drawCurve(p, c);

    p = makePoints(x, -y, 500, maxiter);
    c = color(0,0,0);
    if (p.size()<maxiter){
      c=color((p.size()*(255/maxiter)), (p.size()*(255/maxiter)), 255);
      //c=color((p.size()*(255/maxiter)), 127, 255);
    }
    drawCurve(p, c);

    x=((float)round((x+xdir)*100))/100;
    y=((float)round((y+ydir)*100))/100;
    
    if(xdir>0 && x>xmax){
      x = xmax;
      xdir = 0;
      ydir = density;
      xmax -= density;
    }
    if (ydir>0 && y>ymax){
      y = ymax;
      ydir = 0;
      xdir = -density;
      ymax -= density;
    }
    if(xdir<0 && x<xmin){
      x = xmin;
      xdir = 0;
      ydir = -density;
      xmin += density;
    }
    if (ydir<0 && y<ymin){
      y = ymin;
      ydir = 0;
      xdir = density;
      ymin += density;
    }
  }
  //save("D:\\Mandlebrot_Lines_" + maxiter + "_" + density +".tif");
}

void drawCurve(ArrayList<Point> points, color c){
  
  //draw blob at line start
  stroke(127);
  fill(c);
  circle(xToScreen(points.get(0).x), yToScreen(points.get(0).y), 0.025*toScreenScale);

  //Do line
  stroke(c);
  noFill();
  beginShape();
    
  // the first control point
  curveVertex(xToScreen(points.get(0).x), yToScreen(points.get(0).y));
  
  //the curve points
  for (Point p : points){
    curveVertex(xToScreen(p.x), yToScreen(p.y));
  }
  
  // the last control point
  curveVertex(xToScreen(points.get(points.size()-1).x), yToScreen(points.get(points.size()-1).y)); 
  endShape();

}

float xToScreen(float x){
  float c = width/2;
  return (toScreenScale*(x-midx)) + c;
}

float yToScreen(float y){
  float m = height/(maxy-miny);
  float c = height/2;
  return (toScreenScale*(y-midy)) + c;
}

ArrayList<Point> makePoints(float x, float y, float radlimit, int iterlimit){
  ArrayList<Point> points = new ArrayList<Point>();
  Complex initp = new Complex(x,y);
  Complex p=initp;
  int c=0;
  
  points.add(new Point(p.real, p.imag));

  while (p.mag()<radlimit && c<=iterlimit)
  {
    c++;
    //Calculate next point
    Complex p2=p.square();
    p=p2.add(initp);
    points.add(new Point(p.real, p.imag));
  }
  
  return points;
}

class Point
{
  float x;
  float y;
  
  Point(float x, float y)
  {
    this.x=x;
    this.y=y;
  }
}

class Complex {
    float real;   // the real part
    float imag;   // the imaginary part

    public Complex(float real, float imag) {
      this.real = real;
      this.imag = imag;
    }

    public Complex square() {
      float real = this.real * this.real - this.imag * this.imag;
      float imag = this.real * this.imag + this.imag * this.real;
      return new Complex(real, imag);
    }

    public Complex multi(Complex b) {
      float real = this.real * b.real - this.imag * b.imag;
      float imag = this.real * b.imag + this.imag * b.real;
      return new Complex(real, imag);
    }
    
    public Complex add(Complex b) {
      return new Complex(this.real + b.real, this.imag+b.imag);
    }
    
    public float mag() {
      return sqrt(sq(real) + sq(imag));
    }
}
