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

    void update(float deltaT)
    {
        this.velocity = PVector.add(this.velocity, PVector.div(this.forces, this.mass * (1f/deltaT))); // a = f/m * 1/60
        this.position = PVector.add(this.position, PVector.mult(this.velocity, deltaT)); // (x', y') = (x, y) + (dx, dy) * 1/60
        //System.out.println(this.velocity);
        //System.out.println(this.position);
    }

    void applyForce(PVector force)
    {
        this.forces = PVector.add(this.forces, force);
    }

    void resetForces()
    {
        this.forces = new PVector(0,0);
    }

    abstract void draw();




}
