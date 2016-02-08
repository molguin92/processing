class Board extends PhyObject
{
  float w;
  float h;
  
  public Board(PVector pos, float w, float h)
  {
    this.h = h;
    this.w = w;
    this.body = createShape(RECT, pos.x, pos.y, w, h);
    this.body.setFill(#ff0000);
    this.pos = pos;
  }
  
}