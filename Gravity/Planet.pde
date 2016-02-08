import java.util.*;

class Planet extends MassObject
{
    private color c;
    private LinkedList<PVector> history;
    private int count;

    public boolean showVectors;
    public boolean showTrail;

    public Planet ( PVector position, PVector velocity, float mass, float radius, color c, boolean showVectors, boolean showTrail )
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
            stroke(#00ffd9);
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
        ellipse(this.position.x, this.position.y, this.radius * 2.0, this.radius * 2.0);

        if (this.showVectors)
        {
            //Debug forces:
            PVector f = this.forces.copy();
            f.mult(1f/this.mass);
            f.add(this.position);
            stroke(#ffffff);
            line(this.position.x, this.position.y, f.x, f.y);

            f = PVector.add(this.position, this.velocity);
            stroke(#99ff00);
            line(this.position.x, this.position.y, f.x, f.y);
            noStroke();
        }
    }
}
