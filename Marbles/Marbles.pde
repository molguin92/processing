PhysicsManager PM;
Board b;

void setup()
{
  shapeMode(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);
  size(600, 600);
  frameRate(30);
  PM = new PhysicsManager();
  
  b = new Board(new PVector(width/2, height), width, 30);
}

void draw()
{
  clear();
  b.draw();
  PM.update();
}

void mouseClicked()
{
  PM.addMarble(new PVector(mouseX, mouseY));
}