PhysicsManager pm;

void setup()
{
	size( 600, 600 );
	frameRate( 60 );
	randomSeed( System.nanoTime() );
	pm = new PhysicsManager();
	for( int i = 0; i < 20; i++ )
	{
		PVector pos = new PVector( random( -300, 300 ), random( -300, 300 ) );
		PVector vel = new PVector( random( -10, 10 ), random( -10, 10 ) );
		pm.addParticle( pos, vel );
	}
}

void draw()
{
	clear();
	translate( 300, 300 ); // set origin to center
	scale( 1, -1 ); // invert Y axis
	stroke( #ff0000 );
	line( -1 * width / 2, 0, width / 2, 0 );
	line( 0, -1 * height / 2, 0, height / 2 );
	pm.update();
}
