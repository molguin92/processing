import java.util.*;
import java.util.concurrent.locks.ReentrantLock;

class PhysicsManager
{

    private LinkedList<Planet> planets;
    private LinkedList<Star> stars;
    private LinkedList<Planet> cleanup;

    private float gconst;
    private boolean showVectors;
    private boolean showTrails;

    public ReentrantLock lock;

    public PhysicsManager(float gconst)
    {
        this.planets = new LinkedList();
        this.stars = new LinkedList();
        this.cleanup = new LinkedList();
        this.gconst = gconst;

        this.showVectors = false;
        this.showTrails = false;

        this.lock = new ReentrantLock();
    }

    public void addPlanet(PVector position, PVector init_velocity)
    {
        this.lock.lock();
        try{
            Planet p = new Planet(position, init_velocity, 100, 2.5, #0022ff, this.showVectors, this.showTrails);
            this.planets.addLast(p);
        }
        finally
        {
            this.lock.unlock();
        }
    }

    public void addStar(PVector position)
    {
        this.lock.lock();
        try{
            Star s = new Star(position, 10000, 20);
            this.stars.addLast(s);
        }
        finally
        {
            this.lock.unlock();
        }
    }

    public void update(float deltaT)
    {
        //lock
        this.lock.lock();

        try
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

                p.update(deltaT);
                p.resetForces();
            }

            for(Planet p: cleanup)
            {
                planets.remove(p);
            }

            cleanup.clear();
        }

        finally
        {
            this.lock.unlock();
        }
    }

    public void draw()
    {
        this.lock.lock();
        try
        {
            for(Star s: stars)
            {
                s.draw();
            }

            for(Planet p: planets)
            {
                p.draw();
                //p.resetForces();
            }
        }

        finally
        {
            this.lock.unlock();
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
        this.lock.lock();
        try
        {
            return this.planets.size();
        }
        finally
        {
            this.lock.unlock();
        }
    }

    public void reset()
    {
        this.lock.lock();
        try
        {
            this.planets = new LinkedList();
            this.stars = new LinkedList();
        }
        finally
        {
            this.lock.unlock();
        }
    }

    public void toggleTrails()
    {
        this.lock.lock();
        try
        {
            this.showTrails = !this.showTrails;

            for(Planet p: planets)
                p.showTrail = this.showTrails;
        }
        finally
        {
            this.lock.unlock();
        }
    }

    public void toggleVectors()
    {
        this.lock.lock();
        try
        {
            this.showVectors = !this.showVectors;

            for(Planet p: planets)
                p.showVectors = this.showVectors;
        }
        finally
        {
            this.lock.unlock();
        }
    }
}
