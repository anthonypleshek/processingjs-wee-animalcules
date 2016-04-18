ParticleSystem ps;
ArrayList<Leader> leaders;

color background = color(25);

void setup() {
  size(800,300);
  ps = new ParticleSystem();

  initializePS();
  initializeLeaders();

  smooth();
  pushStyle();
  fill(background);
  rect(0,0,width,height);
  popStyle();
}

void initializeLeaders() {
  leaders = new ArrayList<Leader>();

  for(int i=0; i<100; i++) {
    leaders.add(new Leader(
        new PVector(
            random(0,width),
            random(0,height)),
        new PVector(random(.4,.6),random(.4,.6))));
  }
}

void initializePS() {
  ps = new ParticleSystem();
  for(int i=0; i<175; i++) {
    ps.addParticle();
  }
}

void draw() {
  pushMatrix();
  noStroke();
  //fill(red(background), green(background), blue(background), 5);
  fill(red(background), green(background), blue(background));
  rect(0, 0, width, height);
  popMatrix();

  ps.run();

  for(Leader l : leaders) {
    l.run();
  }
}

class Leader {
  PVector location;
  PVector direction = new PVector();
  PVector velocity;

  Leader(PVector start, PVector velocity) {
    location = start.get();
    this.velocity = velocity;
    direction.x = round(random(0,1));
    if(direction.x == 0) {
      direction.x = -1;
    }

    direction.y = round(random(0,1));
    if(direction.y == 0) {
      direction.y = -1;
    }
  }

  PVector getLocation() {
    PVector newLoc = new PVector(location.x,location.y);
    newLoc.x += velocity.x*direction.x;
    newLoc.y += velocity.y*direction.y;
    if(newLoc.x < 0) {
      newLoc.x *= -1;
      direction.x = 1;
    } else if(newLoc.x > width) {
      newLoc.x = width-(location.x-width);
      direction.x = -1;
    }

    if(newLoc.y < 0) {
      newLoc.y *= -1;
      direction.y = 1;
    } else if(newLoc.y > height) {
      newLoc.y = height-(location.y-height);
      direction.y = -1;
    }

    return newLoc;
  }

  void run() {
    update();
//    display();
  }

  void update() {
//    theta += velocity/radius;
    PVector newLoc = getLocation();
    location.x = newLoc.x;
    location.y = newLoc.y;
  }

  void display() {
    noStroke();
    fill(255,0,0);
    ellipse(location.x,location.y,2,2);
  }
}

class Particle {
  PVector location;
  PVector lastLoc;
  PVector arcLoc;
  PVector velocity;
  PVector acceleration;

  Particle(PVector l) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
//    velocity = new PVector(random(-1,1),random(-1,1));
    location = l.get();
    lastLoc = l.get();
    arcLoc = l.get();
  }

  void run() {
    update();
    display();
    arcLoc.x = lastLoc.x;
    arcLoc.y = lastLoc.y;
    lastLoc.x = location.x;
    lastLoc.y = location.y;
  }

  // Method to update location
  void update() {
    updateAcceleration();
    velocity.add(acceleration);
    velocity.limit(.5);
//    if(abs(velocity.x*velocity.y) > 4) {
//      velocity.sub(acceleration);
//    }
    location.add(velocity);
  }

  // Method to display
  void display() {
    color particleColor = color(93,170,241,250);
    stroke(particleColor);
    strokeWeight(10);
    curve(lastLoc.x,lastLoc.y,arcLoc.x,arcLoc.y,location.x,location.y,location.x,location.y);
    //line(lastLoc.x,lastLoc.y,location.x,location.y);
    for(Leader l : leaders) {
      if((int)l.getLocation().x == (int)location.x && (int)l.getLocation().y == (int)location.y) {
//        fill(200,0,230,15);
//        rect(0,0,width,height);
      }
    }
//    ellipse(location.x,location.y,1,1);
  }

  boolean isDead() {
    return false;
  }

  void updateAcceleration() {
    this.acceleration.x = 0;
    this.acceleration.y = 0;
    float nearest = MAX_FLOAT;
    float farthest = 0.0;
    for(Leader l : leaders) {
      PVector lLoc = l.getLocation();
      float distance = dist(lLoc.x,lLoc.y,this.location.x,this.location.y);
      if(distance < nearest) {
//      if(distance > farthest) {
        nearest = distance;
//        farthest = distance;
        distance *= 100;
        this.acceleration.x = ((lLoc.x-location.x)/(distance));
        this.acceleration.y = ((lLoc.y-location.y)/(distance));
      }
    }
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
//    particles.add(new Particle(new PVector(random(width*2/5,width*3/5),random(height*4/9,height*5/9))));
    particles.add(new Particle(new PVector(random(width*0,width*5/5),random(height*0/9,height*9/9))));
  }

  ArrayList<Particle> getParticles() {
    return particles;
  }

  int size() {
    return particles.size();
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
