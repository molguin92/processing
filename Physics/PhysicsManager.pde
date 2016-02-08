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
