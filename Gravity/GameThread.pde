class GameThread implements Runnable
{
    private PhysicsManager pm;
    long prev_time;
    boolean running;

    GameThread(PhysicsManager pm)
    {
        this.pm = pm;
        this.prev_time = System.currentTimeMillis();
        this.running = true;
    }

    public void run()
    {
        while(this.running)
        {
            long deltaT = System.currentTimeMillis() - this.prev_time;
            pm.update(deltaT / 1000f);
            this.prev_time = System.currentTimeMillis();
            try{
                Thread.sleep((int)(1f/120f * 1000f));
            }
            catch ( InterruptedException e)
            {
                e.printStackTrace();
            }
        }
    }
}
