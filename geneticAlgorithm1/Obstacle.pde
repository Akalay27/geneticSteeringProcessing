class Obstacle {
 float x;
 float y;
 float w;
 float h;
 float r;
 int type;
 int id;
 Obstacle (float xPos, float yPos, float wid, float hei, int idd) {
  x = xPos;
  y = yPos;
  w = wid;
  h = hei;
  type = 0; // rectangle
  id = idd; 
 }
  
 Obstacle (float xPos, float yPos, float rad, int idd) {
 x = xPos;
 y = yPos;
 r = rad;
 type = 1; // circle
 id = idd;
 }
  
 boolean collision(float px, float py) {
   if (type == 0) {
    if (px <x+w/2 && px > x-w/2 && py <y+w/2 && py > y-w/2) {
      return true;
    }
   } else {
    if (dist(x,y,px,py) < r/2) {
     return true; 
    }
   }
   
   return false; 
 }
 
 void show () {
   fill(245,10,10);
   stroke(0);
   if (type == 0) {
    rectMode(CENTER);
    rect(x,1000-y,w,h);
   } else {
    ellipse(x,1000-y,r,r); 
   }
   
 }
 
 void move () {
  if (type == 1) {
    if (id < 10) {
    x = 500+cos(((PI*2)/solutionLength)*time+(PI/5*id)) * 400;
    
    y = 500+sin(((PI*2)/solutionLength)*time+(PI/5*id)) * 400;
    } else {
      x = 500+cos(((PI*2)/solutionLength/2)*-time+(PI/2.5*id)) * 200;
    
    y = 500+sin(((PI*2)/solutionLength/2)*-time+(PI/2.5*id)) * 200;
    }
  }
   
 }
  
}