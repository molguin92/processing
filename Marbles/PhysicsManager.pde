class PhysicsManager
{
  ArrayList<Marble> marbles;
  ArrayList<Board> boards;
  PVector gravity;
  
  public PhysicsManager()
  {
    this.marbles = new ArrayList();
    this.boards = new ArrayList();
  }
  
  void addMarble(PVector pos)
  {
    this.marbles.add(new Marble(pos, 1, 10, 1));
    this.gravity = new PVector(0, 1);
  }
  
  void update()
  {
    for(Marble m: marbles)
    {
      m.applyForce(gravity);
      m.update();
      m.draw();
    }
  }
  
  void checkCollision()
  {
    for(Marble m: marbles)
    {
      for(Board b: boards)
      {
        
      }
    }
  }
}