class Target
{
    int points;
    int size;
    String name;
    PVector pos;
    PImage pokemon;

    Target (int points, int size, PVector pos, String name)
    {
        this.points = points;
        this.size = size;
        this.pos = pos;
        this.name = name;
    }

    void display()
    {
        /*fill(255);
        strokeWeight(1);
        ellipseMode(CENTER);
        circle(pos.x, pos.y, size);
        textSize(12);
        fill(0);
        textAlign(CENTER, CENTER);
        text(str(points), pos.x, pos.y);*/
        
        pokemon = loadImage("images/"+this.name+".png");
        image(pokemon, this.pos.x-19, this.pos.y-19, size, size);
    }
}
