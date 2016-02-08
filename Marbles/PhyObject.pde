abstract class PhyObject
{
  PVector vel;
  PVector f;
  PVector pos;
  PShape body;
  
  public void draw()
  {
    shape(this.body);
  }
}