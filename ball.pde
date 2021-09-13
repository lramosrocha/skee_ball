class Ball
{
    PVector pos;
    PVector pos_end;
    int size;
    PImage ball;

    Ball (int size)
    {
        this.size = size;
        pos = new PVector(0, 0);
        pos_end = new PVector(0, 0);
    }

    void drawBall()
    {
        fill(255, 0, 0); // ball colour
        strokeWeight(1);
        //circle(pos.x, pos.y, size);
        ball = loadImage("images/ball.png");
        //noTint();
        image(ball, this.pos.x-8, this.pos.y-8, size, size);
    }
}
