float prev_x;
float prev_y;
boolean drag;

PhysicsManager pm;

void setup()
{
  size(800, 600);
  frameRate(60);

  prev_x = 0;
  prev_y = 0;
  drag = false;

  pm = new PhysicsManager(40f);
  pm.addStar(new PVector(width/2f, height/2f));
}

void draw()
{
    clear();
    noStroke();

    //framerate
    fill(color(85, 210, 254));
    textSize(24);
    text("" + frameRate, 5, 25);
    text("" + pm.getNumberOfPlanets(), 5, 50);

    pm.update();
    pm.draw();
    if(drag)
    {
        stroke(#ffffff);
        line(prev_x, prev_y, mouseX, mouseY);
    }
}

void mouseDragged()
{

    if(!drag)
    {
        noCursor();
        drag = true;
        prev_x = mouseX;
        prev_y = mouseY;
    }

}

void mouseReleased()
{
    if (drag)
    {
        cursor();
        PVector pos1 = new PVector(mouseX, mouseY);
        PVector pos2 = new PVector(prev_x, prev_y);

        PVector vel = PVector.sub(pos1, pos2).normalize().mult(PVector.dist(pos2, pos1));
        pm.addPlanet(pos2, vel);

        drag = false;
        prev_x = 0;
        prev_y = 0;
    }
}

void mouseClicked(MouseEvent event)
{
    if(event.getButton() == RIGHT)
    {
        pm.addStar(new PVector(mouseX, mouseY));
    }
}

void keyPressed(KeyEvent event)
{
    if(event.getKey() == 'r')
    {
        pm.reset();
    }
}
