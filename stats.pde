class Statistics
{
    int throw_intensity = 50;
    int score;
    PImage stat_box;
    PImage background;
    

    Statistics(int throw_intensity, int score)
    {
        this.throw_intensity = throw_intensity;
        this.score = score;
    }

    void display()
    {
        stat_box = loadImage("images/text_box.png");
        background = loadImage("images/background.png");

        //tint(255, 254);
        image(background, 0, 0);
        noTint();
        image(stat_box, 0, height-100, width, 100);

        String str_score = "Punktestand: " + str(score);
        String str_intensity = "Wurfstärke: " + str(throw_intensity);
        String str_keys = "'N' - Nächster Wurf | 'R' - Reset";
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(12);
        text(str_keys, width - textWidth(str_keys)/2-20, height-80);
        textSize(15);
        text(str_score, textWidth(str_score)/2+20, height-50);             // score
        text(str_intensity, textWidth(str_intensity)/2+20, height-30);     // throw intensity
    }
}
