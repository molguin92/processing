class MassObject
{
  
  float x;
  float y;
  
  float vx;
  float vy;
  
  float mass;
  float rad;
  float fx; //force vector
  float fy;
  
  float drag = 0;
  
  public MassObject(float x, float y, float rad, float mass)
  {
    this.x = x;
    this.y = y;
    this.mass = mass;
    this.rad = rad;
    
    this.vx = 0;
    this.vy = 0;
  }
  
  void update()
  {
    this.x += vx;
    this.y += vy;
    
    //acceleration
    vx += fx/mass;
    vy += fy/mass;
    
    //add some drag
    if(fx > 0) fx -= drag;
    else if (fx < 0) fx += drag;
    
    if(fy > 0) fy -= drag;
    else if (fy < 0) fy += drag;
  }
  
  void apply_force(float fx, float fy)
  {
    this.fx += fx;
    this.fy += fy;
  }
  
  void draw()
  {
    fill(#ff0000);
    ellipse(x, y, rad, rad);
  }
}
  