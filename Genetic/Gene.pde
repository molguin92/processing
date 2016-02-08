class Gene
{

    private int attribute; // 0 - 255

    public Gene()
    {
        this.attribute = (int)(random(0, 255) + 255) % 255;
    }

    public int getAttribute()   {   return attribute;   }

    public void evolve()
    {
        this.attribute = (int)((this.attribute + random(-30.0, 30.0) + 255) % 255);
    }
}
