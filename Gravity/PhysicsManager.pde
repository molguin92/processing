import java.util.*;

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
        Planet p = new Planet(position, init_velocity, 100, 2.5, #0022ff, this.showVectors, this.showTrails);
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
