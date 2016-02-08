class Particle
{
	PVector pos;
	PVector vel;
	PVector acc;

	public Particle ( PVector pos, PVector vel )
	{
		this.pos = pos;
		this.vel = vel;
		this.acc = new PVector( 0, 0 );
	}

	void update()
	{
		this.pos.add( this.vel );
		this.vel.add( this.acc );
		this.acc = new PVector( 0, 0 );
	}

	void accelerate( PVector acc )
	{
		this.acc = acc;
	}

	void draw()
	{
		fill( #ffffff );
		ellipse( this.pos.x, this.pos.y, 5, 5 );
	}
}
