public interface BoundingBox
{
  void update();
  void draw();
  boolean checkCollision(BoundingBox b);
  boolean checkCollision(Particle p);
}
