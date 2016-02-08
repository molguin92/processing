import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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

    private ArrayList<Planet> planets;
    private ArrayList<Star> stars;
    private ArrayList<Planet> cleanup;

    private float gconst;

    public PhysicsManager(float gconst)
    {
        this.planets = new ArrayList();
        this.stars = new ArrayList();
        this.cleanup = new ArrayList();
        this.gconst = gconst;
    }

    public void addPlanet(PVector position, PVector init_velocity)
    {
        Planet p = new Planet(position, init_velocity, 100, 2.5f, 0xff0022ff);
        this.planets.add(p);
    }

    public void addStar(PVector position)
    {
        Star s = new Star(position, 10000, 20);
        this.stars.add(s);
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

}
class Planet extends MassObject
{
    private int c;

    public Planet ( PVector position, PVector velocity, float mass, float radius, int c )
    {
        super(position, velocity, mass, radius);
        this.c = c;
    }

    @Override
    public void draw()
    {
        fill(this.c);
        ellipse(this.position.x, this.position.y, this.radius * 2.0f, this.radius * 2.0f);

        PVector f = this.forces.copy();
        f.mult(0.1f);
        f.add(this.position);
        stroke(0xffffffff);
        line(this.position.x, this.position.y, f.x, f.y);

        f = PVector.add(this.position, this.velocity);
        stroke(0xff99ff00);
        line(this.position.x, this.position.y, f.x, f.y);
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
