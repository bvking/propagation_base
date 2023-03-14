  void drawBallGeneral(int n, float phase) 
  { 
        pushMatrix();
        translate(-w2, -h2, -1000);
        noStroke();
        float side = height*0.15*1/this.nbBalls;
        float rayon = width/2; 
        float x = rayon*cos(phase);
        float y = rayon*sin(phase);
        translate (x, y, 200+(50*5*n));  
        colorMode(RGB, 255, 255, 255);
        fill( 0, 255, 0 ); 
        sphere(side*3);
        popMatrix();
  }
