
ObjectManager om;
boolean click;

void setup()
{
  size(600, 600);
  frameRate(30);
  noStroke();
  om = new ObjectManager();
  click = false;
}

void draw(){
  clear();
  if(mousePressed && mouseButton == LEFT)
  {
    for(int i = 0; i < 1; i++) om.addMass(mouseX, mouseY, 10);
  }
  
  om.update();
  om.draw();
}

void mouseClicked()
{
  if(mouseButton == RIGHT)
    om.addGravityPoint(mouseX, mouseY, 300);
}