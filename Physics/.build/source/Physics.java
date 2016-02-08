import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Physics extends PApplet {

PhysicsManager pm;

public void setup()
{
    
    frameRate(60);
    randomSeed(System.nanoTime());
    pm = new PhysicsManager();
    for(int i = 0; i < 20; i++)
    {
        PVector pos = new PVector(random(-300,300), random(-300,300));
        PVector vel = new PVector(random(-10,10), random(-10,10));
        pm.addParticle(pos,vel);
    }
}

public void draw()
{
    clear();
    translate(300, 300); // set origin to center
    scale(1, -1); // invert Y axis
    stroke(0xffff0000);
    line(-1*width/2, 0, width/2, 0);
    line(0, -1*height/2, 0, height/2);
    pm.update();
}
class AABB implements BoundingBox
{
	private PVector center;
	private PVector nR;
	private PVector nL;
	private PVector nU;
	private PVector nD;

	public AABB( float center_x, float center_y, float w, float h )
	{
		this.center = new PVector( center_x, center_y );
		this.nR = new PVector( 1, 0 );
		this.nL = new PVector( -1, 0 );
		this.nU = new PVector( 0, 1 );
		this.nD = new PVector( 0, -1 );
		this.w = w;
		this.h = h;
	}

	public void update()
	{
		return;
	}

	public void draw()
	{
		rectMode( CENTER );
		rect( center.x, center.y, this.w, this.h );
	}

	public void checkCollision( BoundingBox b )
	{
	}
	public void checkCollision( Particle p )
	{
	}
}
public interface BoundingBox 
{
  public void update();
  public void draw();
  public void checkCollision(BoundingBox b);
  public void checkCollision(Particle p);
}
class Particle
{
  PVector pos;
  PVector vel;
  PVector acc;
  
  public Particle ( PVector pos, PVector vel )
  {
    this.pos = pos;
    this.vel = vel;
    this.acc = new PVector(0, 0);
  }
  
  public void update () 
  {
    this.pos.add(this.vel);
    this.vel.add(this.acc);
    this.acc = new PVector(0, 0);
  }
  
  public void accelerate( PVector acc )
  {
    this.acc = acc;
  }
  
  public void draw()
  {
    fill(0xffffffff);
    ellipse(this.pos.x, this.pos.y, 5, 5);
  }
}
class PhysicsManager
{
	ArrayList<Particle> particles;
	ArrayList<BoundingBox> bbs;

	public PhysicsManager()
	{
		particles = new ArrayList();
		bbs = new ArrayList();
	}

	public void addParticle( PVector pos, PVector vel )
	{
		particles.add( new Particle( pos, vel ) );
	}

	public void addAABB( PVector pos, float h, float w )
	{
	}

	public void update()
	{
		for( Particle p: particles )
		{
			p.update();
			p.draw();

			// collision resolution
			this.checkBorderCollision( p );
		}
	}

	private void checkBorderCollision( Particle p )
	{
		if( ( p.pos.x <= -1 * width / 2 && p.vel.x < 0 ) || ( p.pos.x >= width / 2 && p.vel.x > 0 ) )
			p.vel.x *= -1;                                                                           //vertical limits
		if( ( p.pos.y <= -1 * height / 2 && p.vel.y < 0 ) || ( p.pos.y >= height / 2 && p.vel.y > 0 ) )
			p.vel.y *= -1;                                                                             //horizontal limits
	}
}
  public void settings() {  size(600,600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Physics" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
