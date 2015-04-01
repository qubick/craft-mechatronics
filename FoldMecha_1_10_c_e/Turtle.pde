class Turtle {
    float x,y;
    float oldx,oldy;
    float angle;
    color tcolor;
     
    //Constructor
    Turtle() {
        oldx = float(width/2);
        oldy = float(height/2);
        x = oldx;
        y = oldy;
    //    tcolor = #FFFFFF;
        angle = 0;
        stroke (tcolor);
    }
     
    void forward (float step) {
        x = oldx - (step * cos(radians(angle+90)));
        y = oldy - (step * sin(radians(angle+90)));
        line(oldx,oldy,x,y);
        oldx = x;
        oldy = y;
    }
 
    void back (float step) {
        x = oldx + (step * cos(radians(angle+90)));
        y = oldy + (step * sin(radians(angle+90)));
        line(oldx,oldy,x,y);
        oldx = x;
        oldy = y;
    }
 
    void home () {
        oldx = float(width/2);
        oldy = float(height/2);
        line(oldx,oldy,x,y);
        oldx = x;
        oldy = y;
        angle = 0;
    }
 
    void setx(float step) {
        x = oldx + step;
        oldx = x;
    }
 
    void sety(float step) {
        y = oldy + step;
        oldy = y;
    }
 
    void setxy(float stepx, float stepy) {
        x = oldx + stepx;
        y = oldy + stepy;
        oldx = x;
        oldy = y;
    }
     
    void left (float dangle) {
        angle -= dangle;
    }
 
    void right (float dangle) {
        angle += dangle;
    }
 
    void setheading (float nangle) {
        angle = nangle;
    }
     
    void pencolor (color ncolor) {
        tcolor = ncolor;
        stroke (tcolor);
    }
     
    void penup() {
        noStroke();
    }
 
    void pendown() {
        stroke (tcolor);
    }
 
    void penerase() {
        stroke (bgColor);
    }
}

