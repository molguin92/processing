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

public class Genetic extends PApplet {

CircleOrganism org;

public void setup()
{
    
    frameRate(60);
    randomSeed(System.nanoTime());
    noStroke();

    org = new CircleOrganism(new PVector(0, 0));
}

public void draw()
{
    //clear();
    //org.evolve();
    org.draw();
    org.position.add(new PVector(1,1));
    org.evolve();
}

public void mouseClicked()
{
    org.evolve();
}
class CircleOrganism
{

    private Gene red;
    private Gene green;
    private Gene blue;

    private PVector position;

    private int generation;

    public CircleOrganism(PVector position)
    {
        this.red = new Gene();
        this.green = new Gene();
        this.blue = new Gene();

        this.position = position;
        this.generation = 0;

        //System.out.printf("Starting conditions: RED = %d, GREEN = %d, BLUE = %d\n", red.getAttribute(), green.getAttribute(), blue.getAttribute());
    }

    public void evolve()
    {
        this.generation++;
        this.red.evolve();
        this.green.evolve();
        this.blue.evolve();

        //System.out.printf("Generation %d: RED = %d, GREEN = %d, BLUE = %d\n", generation, red.getAttribute(), green.getAttribute(), blue.getAttribute());
    }

    public void draw()
    {
        fill(red.getAttribute(), green.getAttribute(), blue.getAttribute());
        ellipse(position.x,position.y,50,50);
    }

}
class Gene
{

    private int attribute; // 0 - 255

    public Gene()
    {
        this.attribute = (int)(random(0, 255) + 255) % 255;
    }

    public int getAttribute()   {   return attribute;   }

    public void evolve()
    {
        this.attribute = (int)((this.attribute + random(-30.0f, 30.0f) + 255) % 255);
    }
}
  public void settings() {  size(600, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Genetic" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
