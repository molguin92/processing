import java.util.Random;

class ObjectManager
{
  ArrayList<MassObject> mo;
  ArrayList<MassObject> cleanup;
  ArrayList<MassObject> merges;
  Random rand;
  
  public ObjectManager()
  {
    mo = new ArrayList();
    cleanup = new ArrayList();
    merges = new ArrayList();
    rand = new Random(System.nanoTime());
  }
  
  public void addMass(float x, float y, float mass)
  {
    MassObject m = new MassObject(x, y, mass/5, mass);
    m.vx = rand.nextFloat() * 5;
    m.vy = rand.nextFloat() * 5;
    
    if(rand.nextBoolean()) m.vx *= -1;
    if(rand.nextBoolean()) m.vy *= -1;
    
    mo.add(m);
  }
  
  public void addGravityPoint(float x, float y, float mass)
  {
    GravityPoint m = new GravityPoint(x, y, mass);
    mo.add(m);
  }
  
  public void draw()
  {
    for(MassObject m: mo)
    {
      m.draw();
    }
  }
  
  public void update()
  {
    
    System.out.printf("Number of particles: %d\n", mo.size());
    this.updateWithGravity();
    
    for(MassObject m: cleanup)
      mo.remove(m);
      
    for(MassObject m: merges)
      mo.add(m);
      
    merges.clear();
    cleanup.clear();    
  }
  
  private void updateWithGravity()
  {
    for(MassObject m1: mo)
    {
      for(MassObject m2: mo)
      {
        if(m1.equals(m2)) continue;
        
        float vecX = m1.x - m2.x;
        float vecY = m1.y - m2.y;
        double vec = -1 * Math.sqrt((vecX*vecX) + (vecY*vecY));
        
        if(Math.abs(vec) < m1.rad/2 || Math.abs(vec) < m2.rad/2)
        {
          if(cleanup.contains(m1) && cleanup.contains(m2))
            continue;
          this.merge(m1, m2);
          continue;
        }
        
        vecX = (float)(vecX/vec); //normalizing
        vecY = (float)(vecY/vec); //normalizing
        
        float force = m1.mass * m2.mass * 0.01 / (float)(vec*vec);
        m1.apply_force(force*vecX, force*vecY);
      }
      
      if (!(m1 instanceof GravityPoint))
        m1.update();
      //if(m1.x > width || m1.x < 0 || m1.y > height || m1.y < 0 || m1.mass > 600) cleanup.add(m1);
      if(m1.mass > 600) cleanup.add(m1);
    }
  }
  
  private void merge(MassObject m1, MassObject m2)
  {
    if(m1 instanceof GravityPoint || m2 instanceof GravityPoint) return;
    
    cleanup.add(m1);
    cleanup.add(m2);
    float mass = (m1.mass + m2.mass);
    float x = (m1.mass > m2.mass) ? m1.x : m2.x;
    float y = (m1.mass > m2.mass) ? m1.y : m2.y;
    MassObject M = new MassObject(x, y, mass/5, mass);
    M.fx = ((m1.mass*m1.fx) + (m2.mass*m2.fx))/((m1.mass + m2.mass));
    M.fy = ((m1.mass*m1.fy) + (m2.mass*m2.fy))/((m1.mass + m2.mass));
    M.vx = ((m1.mass*m1.vx) + (m2.mass*m2.vx))/((m1.mass + m2.mass));
    M.vy = ((m1.mass*m1.vy) + (m2.mass*m2.vy))/((m1.mass + m2.mass));
    merges.add(M);
  }  
}