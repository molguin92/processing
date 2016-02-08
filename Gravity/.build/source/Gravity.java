import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Gravity extends PApplet {

float prev_x;
float prev_y;
boolean drag;

PhysicsManager pm;

public void setup()
{
  
  frameRate(60);

  prev_x = 0;
  prev_y = 0;
  drag = false;

  pm = new PhysicsManager(40f);
  pm.addStar(new PVector(width/2f, height/2f));
}

public void draw()
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
        stroke(0xffffffff);
        line(prev_x, prev_y, mouseX, mouseY);
    }
}

public void mouseDragged()
{

    if(!drag)
    {
        noCursor();
        drag = true;
        prev_x = mouseX;
        prev_y = mouseY;
    }

}

public void mouseReleased()
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

public void mouseClicked(MouseEvent event)
{
    if(event.getButton() == RIGHT)
    {
        pm.addStar(new PVector(mouseX, mouseY));
    }
}

public void keyPressed(KeyEvent event)
{
    if(event.getKey() == 'r') pm.reset();
    else if (event.getKey() == 'v') pm.toggleVectors();
    else if (event.getKey() == 't') pm.toggleTrails();
    else if (event.getKey() == 'q') exit();

}
abstract class MassObject
{

    PVector position;
    PVector velocity;
    PVector forces;

    float mass;
    float radius;

    MassObject(PVector position, PVector velocity, float mass, float radius)
    {
        this.position = position;
        this.velocity = velocity;
        this.forces = new PVector(0, 0);
        this.mass = mass;
        this.radius = radius;
    }

    public void update()
    {
        this.velocity = PVector.add(this.velocity, PVector.div(this.forces, this.mass * frameRate)); // a = f/m * 1/60
        this.position = PVector.add(this.position, PVector.mult(this.velocity, 1f/frameRate)); // (x', y') = (x, y) + (dx, dy) * 1/60
        //System.out.println(this.velocity);
        //System.out.println(this.position);
    }

    public void applyForce(PVector force)
    {
        this.forces = PVector.add(this.forces, force);
    }

    public void resetForces()
    {
        this.forces = new PVector(0,0);
    }

    public abstract void draw();




}


class PhysicsManager
{

    private LinkedList<Planet> planets;
    private LinkedList<Star> stars;
    private LinkedList<Planet> cleanup;

    private float gconst;
    private boolean showVectors;
    private boolean showTrails;

    public PhysicsManager(float gconst)
    {
        this.planets = new LinkedList();
        this.stars = new LinkedList();
        this.cleanup = new LinkedList();
        this.gconst = gconst;

        this.showVectors = false;
        this.showTrails = false;
    }

    public void addPlanet(PVector position, PVector init_velocity)
    {
        Planet p = new Planet(position, init_velocity, 100, 2.5f, 0xff0022ff, this.showVectors, this.showTrails);
        this.planets.addLast(p);
    }

    public void addStar(PVector position)
    {
        Star s = new Star(position, 10000, 20);
        this.stars.addLast(s);
    }

    public void update()
    {
        PVector force;
        float mm;
        float dist;
        for(Planet p: planets)
        {
            for(Star s: stars)
            {
                // F = (m1*m2/d^2) * K
                mm = p.mass * s.mass;
                dist = PVector.dist(p.position, s.position);

                if(dist != 0)
                {
                    force = PVector.sub(s.position, p.position).normalize();
                    force = PVector.mult(force, mm * this.gconst / (dist * dist));
                }
                else
                {
                    force = new PVector(0,0);
                }
                p.applyForce(force);
                this.checkCollision(s, p);
            }

            for(Planet s: planets)
            {
                if(p.equals(s)) continue;

                // F = (m1*m2/d^2) * K
                mm = p.mass * s.mass;
                dist = PVector.dist(p.position, s.position);

                if(dist != 0)
                {
                    force = PVector.sub(s.position, p.position).normalize();
                    force = PVector.mult(force, mm * this.gconst / (dist * dist));
                }
                else
                {
                    force = new PVector(0,0);
                }
                p.applyForce(force);
            }

            p.update();
        }

        for(Planet p: cleanup)
        {
            planets.remove(p);
        }

        cleanup.clear();
    }

    public void draw()
    {
        for(Star s: stars)
        {
            s.draw();
        }

        for(Planet p: planets)
        {
            p.draw();
            p.resetForces();
        }
    }

    private void checkCollision(Star s, Planet p)
    {

        if(PVector.dist(p.position, s.position) < s.radius)
        {
            this.cleanup.add(p);
        }

    }

    public int getNumberOfPlanets()
    {
        return this.planets.size();
    }

    public void reset()
    {
        this.planets = new LinkedList();
        this.stars = new LinkedList();
    }

    public void toggleTrails()
    {
        this.showTrails = !this.showTrails;

        for(Planet p: planets)
            p.showTrail = this.showTrails;
    }

    public void toggleVectors()
    {
        this.showVectors = !this.showVectors;

        for(Planet p: planets)
            p.showVectors = this.showVectors;
    }
}


class Planet extends MassObject
{
    private int c;
    private LinkedList<PVector> history;
    private int count;

    public boolean showVectors;
    public boolean showTrail;

    public Planet ( PVector position, PVector velocity, float mass, float radius, int c, boolean showVectors, boolean showTrail )
    {
        super(position, velocity, mass, radius);
        this.c = c;

        this.history = new LinkedList();
        this.count = 0;

        this.showTrail = showTrail;
        this.showVectors = showVectors;
    }

    @Override
    public void update()
    {
        if(this.count == 5)
        {
            if(this.history.size() == 300/count)
                this.history.removeFirst();

            this.history.addLast(this.position);
            count = 0;
        }
        else
        {
            this.count++;
        }

        super.update();
    }

    @Override
    public void draw()
    {
        if(this.position.x > width || this.position.x < 0 || this.position.y > height || this.position.y < 0)
            return;

        //draw trail:
        if (this.showTrail)
        {
            stroke(0xff00ffd9);
            noFill();
            beginShape();
            for(PVector p: this.history)
            {
                curveVertex(p.x,p.y);
            }
            endShape();
            noStroke();
        }

        fill(this.c);
        ellipse(this.position.x, this.position.y, this.radius * 2.0f, this.radius * 2.0f);

        if (this.showVectors)
        {
            //Debug forces:
            PVector f = this.forces.copy();
            f.mult(1f/this.mass);
            f.add(this.position);
            stroke(0xffffffff);
            line(this.position.x, this.position.y, f.x, f.y);

            f = PVector.add(this.position, this.velocity);
            stroke(0xff99ff00);
            line(this.position.x, this.position.y, f.x, f.y);
            noStroke();
        }
    }
}
class Star extends MassObject
{
    private int c;

    public Star ( PVector position, float mass, float radius)
    {
        super(position, new PVector(0,0), mass, radius);
        this.c = color(244, 136, 10);
    }

    @Override
    public void update()
    {}

    @Override
    public void draw()
    {
        fill(this.c);
        ellipse(this.position.x, this.position.y, this.radius * 2.0f, this.radius * 2.0f);
    }
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Gravity" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
