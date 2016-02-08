CircleOrganism org;

void setup()
{
    size(600, 600);
    frameRate(60);
    randomSeed(System.nanoTime());
    noStroke();

    org = new CircleOrganism(new PVector(0, 0));
}

void draw()
{
    //clear();
    //org.evolve();
    org.draw();
    org.position.add(new PVector(1,1));
    org.evolve();
}

void mouseClicked()
{
    org.evolve();
}
