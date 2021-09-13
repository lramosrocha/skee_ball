class Reserve
{
    PVector pos;
    int size;
    PImage ball;
    boolean ball_thrown;

    Reserve (int size, PVector pos, boolean ball_thrown)
    {
        this.size = size;
        this.pos = pos;
        this.ball_thrown = ball_thrown;
        //pos = new PVector(width-(size/2), height-100-(size/2));
    }

    void drawBall()
    {
        /*fill(255); // ball colour
        strokeWeight(1);
        circle(this.pos.x, this.pos.y, size);*/

        if (!this.ball_thrown)
        {
            ball = loadImage("images/ball.png");
            noTint();
            image(ball, this.pos.x-8, this.pos.y-8, size, size);
        }
    }

    void thrown(boolean bool)
    {
        this.ball_thrown = bool;
    }
}
