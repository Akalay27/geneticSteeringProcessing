

//Copyright © 2019 Adam Kalayjian

//geneticSteering

int solutionLength = 100;
int populationSize = 800;

int DIAGONAL = 8;
int STRAIT = 4;
int ANGLE = 1;
Rocket[] population = new Rocket[populationSize];

float TargetX = 900;
float TargetY = 900;

ArrayList<Float> fitnessProgression = new ArrayList<Float>();
ArrayList<Float> adverageProgression = new ArrayList<Float>();

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
int obsX1 = 0;
int obsX2 = 0;
int obsY1 = 0;
int obsY2 = 0;
boolean premadeObstacles = false;
boolean solutionReached = false;
PFont radnika;
int travelType = ANGLE;
float[][] bestPath = new float[solutionLength][2];
float[][] adveragePath = new float[solutionLength][2];
float bestDistance;
float advDistance;
boolean colorByDir = false;
void setup () {
  rectMode(CORNERS);
  radnika = loadFont("Radnika-Medium-55.vlw");
  textFont(radnika);
  size(1000,1300);
  for (int r = 0; r < populationSize; r++) {
    float[] solution = new float[solutionLength];
    for (int b = 0; b < solutionLength; b++) {
     if (travelType == ANGLE) {
      solution[b] = random(-1,2*PI); 
     } else
     solution[b] = round(random(0,travelType)); 
    }
    population[r] = new Rocket(solution);
  }
  
  //create obstacles
  
  //for (int b = 0; b < 10; b++) {
  // obstacles.add(new Obstacle(500+cos(PI/5*b)*400,500+sin(PI/5*b)*400 ,100,b));
  //}
  //for (int b = 10; b < 15; b++) {
  // obstacles.add(new Obstacle(500+cos(PI/10*b)*200,500+sin(PI/10*b)*200 ,75,b));
  //}
  
  
  
}
int time = 0; 
boolean simActive = false;
int generation = 0;
 
void mousePressed() {
  if (!simActive) {
    obsX1 = mouseX;
    obsY1 = 1000-mouseY; 
  }
}
void mouseDragged() {
  if (!simActive) {
     obsX2 = mouseX;
     obsY2 = 1000-mouseY;
  }
  println(obsX1 + " - "+ obsX2);
  println(obsY1 + " - "+ obsY2);
  
}

void draw () {
  
  
  frameRate(60);
  background(20,20,20);
  fill(255);
  if (!premadeObstacles) {
  fill(245,10,10);
  rect(obsX1,1000-obsY1,obsX2,1000-obsY2);
  if (keyPressed) {
   if (obsX1 > obsX2) {
    int a = obsX1;
    obsX1 = obsX2;
    obsX2 = a;
   }
   if (obsY1 > obsY2) {
    int a = obsY1;
    obsY1 = obsY2; //<>//
    obsY2 = a;
   }
   simActive = true; 
    
  }
  } else {
   for (Obstacle o : obstacles) {
    o.show();
    o.move();
   }
   simActive = true; 
  }
  
  
  if (simActive) {
   if (time < solutionLength - 1 && solutionReached == false) {
    ellipse(TargetX,1000 - TargetY,50,50);
    time += 1;
    for (int r = 0; r < populationSize; r++) {
     population[r].move(time);
     population[r].show();
    } //<>//
   } else {
     generation+=1;
     nextGen();
     solutionReached = false;
   }
  }
  boolean allDisabled = true;
  for (int i = 0; i < population.length; i++) {
    if (!population[i].disabled) allDisabled = false;
    
  }
  if (allDisabled) solutionReached = true;
  if (bestPath != null) {
   noFill();
   stroke(255);
   beginShape();
   for (int p = 0; p < bestPath.length; p++) {
     curveVertex(bestPath[p][0],1000-bestPath[p][1]);
   }
   endShape();
  }
  if (adveragePath != null) {
   noFill();
   stroke(150,0,0);
   beginShape();
   for (int p = 0; p < adveragePath.length; p++) {
     curveVertex(adveragePath[p][0],1000-adveragePath[p][1]);
   }
   endShape();
  }
  stroke(255);
  line(0,1000,1000,1000);
  
  textSize(55);
  text("Generation " + generation,10,1050);
  textSize(30);
  text("Best fitness: " + bestDistance,10,1110);
  fill(200,0,0);
  text("Adverage fitness: " + advDistance, 10,1145);
  noFill();
  
  graphProgression(fitnessProgression);
  stroke(200,0,0);
  graphProgression(adverageProgression);
  
  stroke(0);
  strokeWeight(4);
  
}
void graphProgression (ArrayList<Float> progression) {
  float highestValue = Integer.MIN_VALUE;
  for (int l = 0; l < progression.size(); l++) {
    if (progression.get(l) > highestValue)
    highestValue = progression.get(l);
  }
  
  //Graph fitness over time
  if (progression.size() > 1) {
   beginShape();
   for (int l = 0; l < progression.size(); l++) {
    vertex(1000/(progression.size()-1f)*(l),progression.get(l)/(highestValue)*150+1150);
   }
   endShape();
  }
  
}
void nextGen () {
   for (int r = 0; r < populationSize; r++) {
     if (!population[r].disabled)
     population[r].calculateFitness(TargetX,TargetY); 
   }
   //Sorting population by fitness
   for (int t = 0; t < populationSize; t++) {
     for (int r = 1; r < populationSize; r++) {
      Rocket a = population[r-1];
      Rocket b = population[r];
      if (a.fitness > b.fitness) {
       population[r-1] = b;
       population[r] = a;
      }
     }
   }
  
   bestDistance = (float)(population[0].fitness); //<>//
   fitnessProgression.add(bestDistance);
   float adv = 0;
   for (int p = 0; p < populationSize; p++) {
    adv += (float)population[p].fitness; 
   }
   adverageProgression.add(adv/populationSize);
   advDistance = adv/populationSize;
   bestPath = population[0].path;
   
   //adverage path
   for (int t = 0; t < solutionLength; t++) {
      int x = 0;
      int y = 0;
     for (int p = 0; p < populationSize; p++) {
        x +=population[p].path[t][0];
        y +=population[p].path[t][1];
    }
    x /= populationSize;
    y /= populationSize;
     adveragePath[t][0] = x;
     adveragePath[t][1] = y;
   }
   
   Rocket[] topOfGeneration = new Rocket[populationSize/2];
   for (int r = 0; r < populationSize/2; r++) {
    topOfGeneration[r] = population[r]; 
   }
   //Crossover function //<>//
   Rocket[] nextPopulation = new Rocket[populationSize];
   for (int n = 0; n < populationSize; n++) {
    Rocket a = topOfGeneration[round(random(populationSize/2-1))];
    Rocket b = topOfGeneration[round(random(populationSize/2-1))];
    int splitPoint = round(random(solutionLength));
    float[] newSolution = new float[solutionLength];
    for (int i = 0; i < splitPoint; i++) {
     newSolution[i] = a.solution[i]; 
    }
    for (int i = splitPoint; i < solutionLength; i++) {
      newSolution[i] = b.solution[i];
    }
    nextPopulation[n] = new Rocket(newSolution);
   }
   for (int i = 0; i < nextPopulation.length; i++) {
     float rand = random(10);
     if (rand > 9.75) {
      nextPopulation[i].mutate(); 
     }
   }
   population = nextPopulation;
   time = 0;
}
