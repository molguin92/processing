class CircleOrganism
{

    private Gene red;
    private Gene green;
    private Gene blue;

    private PVector position;

    private int generation;

    public CircleOrganism(PVector position)
    {
        this.red = new Gene();
        this.green = new Gene();
        this.blue = new Gene();

        this.position = position;
        this.generation = 0;

        //System.out.printf("Starting conditions: RED = %d, GREEN = %d, BLUE = %d\n", red.getAttribute(), green.getAttribute(), blue.getAttribute());
    }

    public void evolve()
    {
        this.generation++;
        this.red.evolve();
        this.green.evolve();
        this.blue.evolve();

        //System.out.printf("Generation %d: RED = %d, GREEN = %d, BLUE = %d\n", generation, red.getAttribute(), green.getAttribute(), blue.getAttribute());
    }

    public void draw()
    {
        fill(red.getAttribute(), green.getAttribute(), blue.getAttribute());
        ellipse(position.x,position.y,50,50);
    }

}
