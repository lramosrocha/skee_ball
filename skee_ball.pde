/*
    git: https://git.gsi.de/l.ramosrocha/lf5_project
*/
import processing.sound.*;

SoundFile zubat;
SoundFile pidgey;
SoundFile charizard;
SoundFile zapdos;
SoundFile mewtwo;

boolean is_bounced = false;         // does the ball have to bounce
boolean thrown = false;             // is the ball thrown?
boolean end_of_try = false;
boolean target_hit = false;
int max_tries = 6;                  // change int for different tries (scales the game)
int current_try = 0;
int reserve_count = max_tries;      // counter for removing balls from left to right

float real_ball_end_posY;
float throw_intensity = 50;
float throw_progress = 0.0;
float throw_progress_bounce = 0.0;

int target_count = 5;
int target_size = 40;
int ball_size = 24;
int stat_box_size = 100;
int score = 0;

Target[] target;
Ball ball;
Reserve[] reserve;

void setup()
{
    size(400, 600);

    // play soundfiles for hitting the targets
    zubat = new SoundFile(this, "zubat.mp3");
    pidgey = new SoundFile(this, "pidgey.mp3");
    charizard = new SoundFile(this, "charizard.mp3");
    zapdos = new SoundFile(this, "zapdos.mp3");
    mewtwo = new SoundFile(this, "mewtwo.mp3");

    // ball initialization
    ball = new Ball(ball_size);
    
    // target initialization
    target = new Target[target_count];
    target[0] = new Target(50, target_size, new PVector(width/2, 200), "zubat");
    target[1] = new Target(150, target_size, new PVector(width/2, 150), "pidgey");
    target[2] = new Target(300, target_size, new PVector(width/2, 100), "charizard");
    target[3] = new Target(600, target_size, new PVector(width/2-100, 50), "zapdos");
    target[4] = new Target(600, target_size, new PVector(width/2+100, 50), "mewtwo");

    // init the visuals for ball "reserve"
    reserve = new Reserve[max_tries];
    int reserve_x = width-15-(ball_size/2);
    for (int i = 0; i < max_tries; ++i)
    {
        reserve[i] = new Reserve(18, new PVector(reserve_x, height-100-5-ball_size/2), false);
        reserve_x -= (ball_size-2);
    }
}

void draw()
{
    background(211, 239, 222);  // background colour is "mint green"
    
    new Statistics(int(throw_intensity), score).display();

    // throwline
    strokeWeight(2);
    stroke(105, 146, 242);      // blue, like the ocean
    line(0, 300, 400, 300);
    stroke(0);

    // tries
    int res_len = ball_size * max_tries;
    int res_posY = height - stat_box_size - 5;
    int arrow_x = width - res_len - 20;
    line(width-10, res_posY-5-ball_size/2, width-10, res_posY);                 // vertical line
    line(arrow_x, res_posY, width-10, res_posY);                                // horizontal line
    triangle(arrow_x, res_posY, arrow_x+5, res_posY, arrow_x+5, res_posY-5);    // arrow point
    
    // circles for thrown balls
    for (int i = 0; i < max_tries; ++i)
    {
        fill(255);
        circle(reserve[i].pos.x, reserve[i].pos.y, 18);
    }

    // target creation
    for (int i = 0; i < target_count; ++i)
        target[i].display();

    // throw of the ball and ball draw
    if (current_try <= max_tries)
    {
        if (reserve_count > 0)
        {
            for (int i = 0; i < reserve_count; ++i)
            {
                if (max_tries-current_try != 0)
                {
                    reserve[i].drawBall();
                    reserve_count = max_tries-current_try;
                }
            }
        }

        if ((mouseY > height/2 && mouseY < height-stat_box_size) || thrown)
            if (!(current_try == max_tries))
                ball.drawBall();
        
        if (!thrown)
            ball.pos.set(mouseX, mouseY);
        else
            throwBall();
    }
}

void throwBall()
{
    if (!end_of_try)
    {
        if (throw_progress <= 1.0)
        {
            if (ball.pos_end.y < 0.0)       // does the ball need to be bounced back?
            {
                float y = lerp(ball.pos.y, 0, throw_progress);
                ball.pos.set(ball.pos.x, y);
                throw_progress += 0.085;
                if (throw_progress >= 1.0)
                    is_bounced = true;
            }
            else
            {
                float y = lerp(ball.pos.y, ball.pos_end.y, throw_progress);
                ball.pos.set(ball.pos.x, y);
                throw_progress += 0.1;
                if (throw_progress >= 1.0)
                    end_of_try = true;
            }
        }
        else if (is_bounced)
        {
            float y = lerp(ball.pos.y, real_ball_end_posY, throw_progress_bounce);
            ball.pos.set(ball.pos.x, y);
            throw_progress_bounce += 0.05;
            if (throw_progress_bounce >= 1.0)
            {
                is_bounced = false;
                end_of_try = true;
            }
        }
    }

    if (end_of_try && !target_hit)
    {
        calculateDistance();
        if (!(current_try <= max_tries))
            resetGame();

        throw_progress = 0.0;
        throw_progress_bounce = 0.0;
    }
}

void calculateDistance()
{
    for (int i = 0; i < target.length; ++i)
    {
        float distance = dist(ball.pos.x, ball.pos.y, target[i].pos.x, target[i].pos.y);
        
        if (distance <= target[i].size/3)
        {
            target_hit = true;
            score += target[i].points;
            switch (target[i].name)
            {
                case "zubat":
                    zubat.play();
                    break;
                case "pidgey":
                    pidgey.play();
                    break;
                case "charizard":
                    charizard.play();
                    break;
                case "zapdos":
                    zapdos.play();
                    break;
                case "mewtwo":
                    mewtwo.play();
                    break;
            }
        }
    }
}

void keyPressed()
{
    switch (key)
    {
        case '+':
            throw_intensity++;
            if (throw_intensity >= (height*1.5))
                throw_intensity = height * 1.5;
            break;
        case '-':
            throw_intensity--; 
            if (throw_intensity <= 0)
                throw_intensity = 0;
            break;
        case 'n':
            if (thrown)
                nextTry();
            else
            {
                end_of_try = false;
                target_hit = true;
                thrown = false;
                throw_progress = 0.0;
                throw_progress_bounce = 0.0;
            }
            break;
        case 'r':
            resetGame();
            break;
    /*    case 'p':
            println("debug " + real_ball_end_posY);    //debug
            println("debug " + ball.pos.y);    //debug
            println("debug " + is_bounced);    //debug
            println("debug " + throw_progress);    //debug
            println("debug " + throw_progress_bounce);    //debug
            break;*/
    }
}

void mouseReleased()
{
    if (!(current_try == max_tries))
    {
        if (!thrown)
        {
            if (mouseY < height/2)
            {
                if (score > 0)
                {
                    score -= 50;
                    nextTry();
                    return;
                }
                else
                    score = 0;
                    nextTry();
                    return;
            }
            thrown = true;
            ball.pos_end.set(ball.pos.x, ball.pos.y - throw_intensity);
            if (throw_intensity > ball.pos_end.y)
                real_ball_end_posY = throw_intensity - ball.pos.y;
        }
    }
}

void mouseDragged()
{
    throw_intensity++;
    if (throw_intensity >= (height*1.5))
        throw_intensity = height * 1.5;
}

void nextTry()
{
    end_of_try = false;
    target_hit = false;
    thrown = false;
    throw_progress = 0.0;
    throw_progress_bounce = 0.0;
    throw_intensity = 50;
    ball.pos_end.set(0, 0);
    current_try++;
    reserve_count = max_tries-current_try;
    reserve[reserve_count].thrown(true);
    if (current_try > max_tries)
        current_try = max_tries;
    return;
}

void resetGame()
{
    end_of_try = false;
    thrown = false;
    throw_progress = 0.0;
    throw_progress_bounce = 0.0;
    throw_intensity = 50;
    score = 0;
    current_try = 0;
    reserve_count = max_tries;
    for (int i = 0; i < max_tries; ++i)
        reserve[i].thrown(false);
}
