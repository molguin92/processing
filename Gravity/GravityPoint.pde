class GravityPoint extends MassObject
{
  public GravityPoint(float x, float y, float mass)
  {
    super(x, y, 1, mass);
  }
  
  @Override
  public void draw()
  {
    fill(#ffffff);
    ellipse(x, y, rad, rad);
  }
}