void setup() {
  fullScreen();
  //size(1600, 900);
  background(255);
  noLoop(); // only execute the draw function once
  colorMode(HSB);
}

void draw() {
  float density = 0.1;
  float minx = -2;
  float maxx = 1;
  float miny = -1.5;
  float maxy = 1.5; //<>//
  float xscale = width/(maxx-minx);
  float yscale = height/(maxy-miny);
  float scale = min(xscale,yscale);
  int maxiter=20;
  
  for(float x=minx; x<=maxx; x+=density){
    for(float y=miny; y<=maxy; y+=density){
      ArrayList<Point> p = makePoints(x, y, 50, maxiter);
      color c = color(0,0,0);
      if (p.size()<maxiter){
        c=color((p.size()*(255/maxiter)), (p.size()*(255/maxiter)), 255);
      }
      drawCurve(p, c, scale);
    }
  }
  save("D:\\Mandlebrot_Lines_" + maxiter + "_" + density +".tif");
}

void drawCurve(ArrayList<Point> points, color c, float s){
  stroke(c);
  fill(c);
  
  //draw blob at line start
  circle(width/2 + s*points.get(0).x, height/2 + s*points.get(0).y, height/100);

  //Do line
  noFill();
  beginShape();
    
  // the first control point
  curveVertex(width/2 + s*points.get(0).x, height/2 + s*points.get(0).y); //<>//
  
  //the curve points
  for (Point p : points){
    curveVertex(width/2 + s*p.x, height/2 + s*p.y);
  }
  
  // the last control point
  curveVertex(width/2 + s*points.get(points.size()-1).x, height/2 + s*points.get(points.size()-1).y); 
  endShape();
 
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
    Complex p2=p.square(); //<>//
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
