float prev_x;
float prev_y;
boolean drag;

PhysicsManager pm;
Thread thread;
GameThread gt;

void setup()
{
    size(800, 600);
    frameRate(60);

    prev_x = 0;
    prev_y = 0;
    drag = false;

    pm = new PhysicsManager(40f);
    pm.addStar(new PVector(width/2f, height/2f));

    gt = new GameThread(pm);
    thread = new Thread(gt);
    thread.start();
}

void draw()
{
    // We only draw stuff here.
    // The updating of the models is handled by the thread!
    // This ensures a (more or less) constant framerate, regardless of the
    // amount of stuff that needs to be drawn onscreen (again, more or less...
    // drawing a lot of stuff is still going to make framerates suffer, but at
    // least this way that only depends on the amount of stuff to DRAW, and not
    // on the time needed for calculating new positions.

    clear();
    noStroke();

    //framerate
    fill(color(85, 210, 254));
    textSize(24);
    text("" + frameRate, 5, 25);
    text("" + pm.getNumberOfPlanets(), 5, 50);

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
    if(event.getKey() == 'r') pm.reset();
    else if (event.getKey() == 'v') pm.toggleVectors();
    else if (event.getKey() == 't') pm.toggleTrails();
    else if (event.getKey() == 'q')
    {
        gt.running = false;
        try
        {
            thread.join();
        }
        catch ( InterruptedException e)
        {
            e.printStackTrace();
        }

        exit();
    }

}
