class AABB implements BoundingBox
{
	private PVector center;
	private PVector upper_left;
	private PVector lower_right;

	private PVector nR;
	private PVector nL;
	private PVector nU;
	private PVector nD;

	private float w;
	private float h;

	public AABB( float center_x, float center_y, float w, float h )
	{
		this.center = new PVector( center_x, center_y );
		this.nR = new PVector( 1, 0 );
		this.nL = new PVector( -1, 0 );
		this.nU = new PVector( 0, 1 );
		this.nD = new PVector( 0, -1 );

		this.h = h;
		this.w = w;

		this.upper_left = new PVector(center_x - w/2.0, center_y + h/2.0);
		this.lower_right = new PVector(center_x + w/2.0, center_y - h/2.0);
	}

	void update()
	{
		return;
	}

	void draw()
	{
		rectMode( CENTER );
		rect( center.x, center.y, this.w, this.h );
	}

	boolean checkCollision( BoundingBox b )
	{
	}

	boolean checkCollision( Particle p )
	{
		if( (p.pos.y < this.upper_left.y && p.pos.y > this.lower_right.y)
			&& (p.pos.x > this.upper_left.x  && p.pos.x < this.lower_right.x))
			return true;

		return false;
	}
}
