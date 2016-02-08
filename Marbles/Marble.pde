class Marble extends PhyObject
{
  
  float mass;
  float rad;
  float elast;
  
  public Marble(PVector pos, float mass, float rad, float elast)
  {
    this.vel = new PVector(0, 0);
    this.f = new PVector(0, 0);
    
    this.mass = mass;
    this.rad = rad;
    this.elast = elast;
    this.body = createShape(ELLIPSE, pos.x, pos.y, rad, rad);
    this.body.setFill(#0000ff);
    this.pos = pos;
  }
  
  public void update()
  {
    this.pos.add(this.vel);
    this.body.translate(this.vel.x, this.vel.y); 
    
    PVector acc = this.f;
    acc.div(this.mass);
    this.vel.add(acc);
    
    this.f.set(0, 0);
    
  }
  
  public void applyForce(PVector force)
  {
    this.f.add(force);
  }
}