class Planet extends MassObject
{
    private color c;

    public Planet ( PVector position, PVector velocity, float mass, float radius, color c )
    {
        super(position, velocity, mass, radius);
        this.c = c;
    }

    @Override
    public void draw()
    {
        fill(this.c);
        ellipse(this.position.x, this.position.y, this.radius * 2.0, this.radius * 2.0);

        PVector f = this.forces.copy();
        f.mult(0.1);
        f.add(this.position);
        stroke(#ffffff);
        line(this.position.x, this.position.y, f.x, f.y);

        f = PVector.add(this.position, this.velocity);
        stroke(#99ff00);
        line(this.position.x, this.position.y, f.x, f.y);
    }
}
