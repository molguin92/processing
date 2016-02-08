class Star extends MassObject
{
    private color c;

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
        ellipse(this.position.x, this.position.y, this.radius * 2.0, this.radius * 2.0);
    }
}
