class Rocket {
 float[] solution; 
 double fitness;
 float x = 20;
 float y = 20;
 float vx = 0;
 float vy = 0;
 float size = 20;
 float thrusterMagnitude = 1.5;
 float diagonalMagnitude = thrusterMagnitude/sqrt(2);
 int t = 0;
 int timeReached = solutionLength;
 boolean disabled = false;
 float[][] path = new float[solutionLength][2]; //For display
 Rocket (float[] solut) {
   solution = solut;
 }
 
 void move (int time) {
   if (!disabled) {
     x+=vx;
     y+=vy;
     if (travelType == ANGLE) {
       if (solution[time] >= 0) {
       vy+=sin(solution[time])*thrusterMagnitude;
       vx+=cos(solution[time])*thrusterMagnitude;
       }
     } else
     switch (round(solution[time])) {
       case 0:
         break;
       case 1:
         vx+=thrusterMagnitude;
         break;
       case 2:
         vy-=thrusterMagnitude;
         break;
       case 3:
         vx-=thrusterMagnitude;
         break;
       case 4:
         vy+=thrusterMagnitude;
         break;
       case 5:
         vx+=diagonalMagnitude;
         vy+=diagonalMagnitude;
         break;
       case 6:
         vx+=diagonalMagnitude;
         vy-=diagonalMagnitude;
         break;
       case 7:
         vx-=diagonalMagnitude;
         vy-=diagonalMagnitude;
         break;
       case 8:
         vx-=diagonalMagnitude;
         vy+=diagonalMagnitude;
         break;
       
     }
     if (x < size || x > 1000-size) {
      vx *= -1; 
     }
     if (y < size || y > 1000-size) {
      vy *= -1; 
     }
     //vy-=0.7;
     vx*=0.99;
     vy*=0.99;
   }
   path[time][0] = x;
   path[time][1] = y;
   
   if (dist(x,y,TargetX,TargetY) < 25) solutionReached = true;
   //Obstacles
   if (!premadeObstacles) {
   if (checkObstacle(obsX1,obsX2,obsY1,obsY2)) {
     disabled = true;
     fitness = 100000000;
   }
   } else {
    if (premadeObstacleCheck()) {
     disabled = true;
     fitness = 100000000;
   } 
     
   }
   t = time;
 }
 boolean checkObstacle (int x1, int x2, int y1, int y2) {
    if (x > x1 && x < x2 && y > y1 && y < y2) {
     return true; 
    }
    
    return false;
 }
 
 boolean premadeObstacleCheck() {
   
  for (Obstacle o : obstacles) {
    if (o.collision(x,y)) return true;
    
   }
  return false; 
 }
 void show () {
   if (colorByDir)
   switch (round(solution[t])) {
    case 0:
      fill(255,255,255);
    break;
    case 1:
      fill(255,0,0);
    break;
    case 2:
      fill(0,0,255);
    break;
    case 3:
      fill(255,0,255);
    break;
    case 4:
      fill(0,0,255);
    break;
   }
  if (!disabled) fill(255,255,255); else fill (200,200,200);
  ellipse(x,1000-y,size,size); 
  fill(255,255,255);
 }
 void calculateFitness(float targetX, float targetY) {
  fitness = dist(x,y,targetX,targetY); 
  //float multiplier = (abs(vx)+abs(vy))/2;
  
  //to make path look nice
  
  for (int i = time; i < solutionLength; i++) {
  path[i][0] = x;
  path[i][1] = y;
  }
 }
 
 void mutate () {
 int randPos = floor(random(solution.length));
 float randAction = random(1);
 
 
 if (randAction > 0.2) {
   float randAddition = random(-5,5);
   solution[randPos]+= randAddition;
 } else {
   float randomRotation = random(0,2*PI);
   solution[randPos] = randomRotation;
 }
   
   
 }
 
}