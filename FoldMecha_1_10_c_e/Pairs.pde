class Pairs {
  
  int center_x, center_y;    // center of the petals
  int centerwidth;  // the length of the base
  int gear_status = 0;  // whether or not to show gears
  
  float a,b,c,d,e,f,f1,f2;  // segment distances of geometry
  float change_f1;  // to change the value of f1 (apply up-down movement)
  
  float step1_f2,step2_f2,angle_cosine_f2,step3_f2,angle_f2; // to calcurate the angle f2
  float step1_d,step2_d,angle_cosine_d,step3_d,angle_d; // to calcurate the angle d
  float step1_a,step2_a,angle_cosine_a,step3_a,angle_a; // to calcurate the angle a
  float step1_cd,step2_cd,angle_cosine_cd,step3_cd,angle_cd; // to calcurate the angle cd
  
  float[] pinion_x1 = new float[33];    float[] pinion_y1 = new float[33];  
  float[] pinion_x2 = new float[33];    float[] pinion_y2 = new float[33];  
  float[] pinion_x3 = new float[33];    float[] pinion_y3 = new float[33]; // to draw pinion gears
    
  color tempC;  // selected color
  float de_x, de_y, ab_x, ab_y, ac_x, ac_y, de_x_R, de_y_R, ab_x_R, ab_y_R,
        ac_x_R, ac_y_R, ef_x, ef_y, ef_x_R, ef_y_R, df_y, df_x, df_y_R, df_x_R; 
  
  float Tr, Tlength, Tlength2,TL3,TL4; 
  float distA,distC, deg;
  float RL, RW, startingX, startingX2;
  float startingY, i3, ii, pinion_X, pinion_Y;
  int n,p,u;
  float pinion_rotate, p_rad, p_rotate, p_rotate_mode, Pcenter_x,Pcenter_y;
  int left, right;
  
  Pairs(float sideA, float sideB, float sideC, float axisX, float axisY, color cColor){
    t1 = new Turtle(); // Flower bottom.
    t2 = new Turtle(); // Flower top.
    t5 = new Turtle(); // Rack & Pinion gears.
    t6 = new Turtle(); // Piston gear.

    center_x = width/2+100;    center_y = height/2;
      
    if(sideA != 0)
      a = sideA*30;
    else
      a = 60;
    if(sideB != 0)
      b = sideB*30;
    else
      b = 240;
    if(sideC != 0)
      c = sideC*30;
    else
      c = 90;
    if(axisX != 0)
      d = axisX*30;
    else
      d = 120;
    if(axisY != 0)
      e = axisY*30;
    else
      e = 180;

    tempC = cColor;  // selected color    
    centerwidth = 15;  // base length      
    f1 = 0;    // default for the base up-down movement
    change_f1 = 1;    // changing value to apply up-down movement
    
    RW = 50;    RL = 200;  // width and length of the rack gear
    Tr = 40;    Tlength = 9;    Tlength2 = 5;
    startingX2 = (width/2+130)-(Tr+Tlength+Tlength2);
    startingX = startingX2+RW;
    TL3 = Tlength2/2;     TL4 = Tlength2/2*sqrt(3);  // to draw the rack (linear) gear 
    deg = 31;  n = 15;    // to draw the pinion gear
    ii = 360/(n*2);    
    pinion_X = 177;    pinion_Y = 220;//pinion_Y = 118;
    p_rad = 80;    // radious of the piston gear
    p_rotate_mode = 0;    // whether or not showing the piston gear
    Pcenter_x = 575;    Pcenter_y = 595;
    ef_x_R = 485;    ef_y_R = 595;
    left = 1; right = -1;
  }

void clearColor(){
 
    stroke(0);
    line(center_x,df_y,center_x,height-100);  // stem line (vertical)
    line(552,df_y,599,df_y);   // base line (horizontal)
    noStroke();    fill(0);
    ellipse(552,df_y,8,8);    ellipse(599,df_y,8,8);    // black (fixed) pivots
    tempC = color(#FFFFFF);  // draw all in white (to hide)    
}

/* DRAWING:   draws a pair of petals. */
void drawing(){
  
  calculate_flower_geometry();  
  draw_flower(left);
  draw_flower(right);
  move_base();   

// println("ANGLE F2: " + angle_f2 + " DEX: " + de_x + " DEY: " + de_y + " DFX: " + df_x +" DFY: "+df_y + " F1: " +f1);
}

void calculate_flower_geometry(){
 // a, b, c, d, e, f are all segments of the petal geometry. 
  f = sqrt(sq(e)-sq(d));        // f is calculated from given distances d and e.                      
  f2 = f-f1;                    // f = f1 + f2, the vertical from petal base.  

// calcuating the angle f2, which varies as the base of the petal moves up and down.
  step1_f2 = sq(d) + sq(e) - sq(f2);      //numerator
  step2_f2 = 2*d*e;                       // denominator
  angle_cosine_f2 = step1_f2/step2_f2;
  step3_f2 = acos(angle_cosine_f2);
  angle_f2 = degrees(step3_f2); 

  if (angle_cosine_f2<-1 || angle_cosine_f2>1){
    println("********ERROR*****F2******" + "   F2: " +angle_cosine_f2);
  }

// calculating the angle d. 
  step1_d = sq(e) + sq(f2) - sq(d);
  step2_d = 2*e*f2;  
  angle_cosine_d = step1_d/step2_d;
  step3_d = acos(angle_cosine_d);
  angle_d = degrees(step3_d);     

  if (angle_cosine_d<-1 || angle_cosine_d>1){
    println("********ERROR*******D****"+" D: " +angle_cosine_d);
  }

// calculating the angle a.   
  step1_a = sq(b) + sq(c+d) - sq(a);
  step2_a = 2*b*(c+d);  
  angle_cosine_a = step1_a/step2_a;
  step3_a = acos(angle_cosine_a);
  angle_a = degrees(step3_a); 

  if (angle_cosine_a<-1 || angle_cosine_a>1){
    println("********ERROR*****A******"+ "   " + angle_a);
  }

// calculating the angle cd. 
  step1_cd = sq(a) + sq(b) - sq(c+d);
  step2_cd = 2*a*b;  
  angle_cosine_cd = step1_cd/step2_cd;
  step3_cd = acos(angle_cosine_cd);
  angle_cd = degrees(step3_cd);   
  
  if (angle_cosine_cd<-1 || angle_cosine_cd>1){
    println("********ERROR*****CD******"+ "     " + angle_cd);
  }  
  
}

void draw_flower(float side){
/* SET TURTLE TO STARTING POINT*/
  t1.penup();      // Position the drawing starting point.
  t1.back(20);
  t1.left(90*side);
  t1.forward(10);
  t1.right(90*side);

/* Actual drawing of the figure, based on variables a-f */
/* T1 DRAWS THE LOWER PART OF THE PETAL */
/* FIRST, SET UP POINTS EF, DE, DF FOR DRAWING THE PETAL */
 
/* WALK THROUGH FIGURE AND SET CONTROL POINTS. */
  t1.forward(f1);     // Move turtle to base of figure.

  ef_x = t1.x;    ef_y = t1.y;
  
  t1.penup();         // Move turtle to point DE.
  t1.left(angle_d*side);
  t1.forward(e);  
  de_x = t1.x;  // Store point DE coordinates.
  de_y = t1.y;
 // println("DEX: " + de_x + " T1X: " + t1.x);
  t1.penup();        // Move turtle to point DF.
  t1.right((180-angle_f2)*side);
  t1.forward(d);

  df_x = t1.x;  df_y = t1.y;      // Store point DF coordinates. df_x is given as the fixed value at the top
 
  /* NOW WE ARE DONE WALKING THE FIGURE, AND LET'S RETURN TO THE HOME POINT.*/
      
  t1.penup();       // Return to start position
  t1.back(d);
  t1.left((180-angle_f2)*side);
  t1.back(e);
  t1.right((angle_d)*side);
  t1.back(f1-20);
  t1.right(90*side);
  t1.forward(10);
  t1.left(90*side); 

/* NOW DRAW THE BOTTOM TRIANGLE OF FLOWER. */
  noFill();
  stroke(color(tempC)); 
  line(de_x+100+(centerwidth*-1*side),de_y,ef_x+100+(centerwidth*-1*side),ef_y);
  line(de_x+100+(centerwidth*-1*side),de_y,df_x+100+(centerwidth*-1*side),df_y);

/* TURTLE T2 NOW DRAWS THE UPPER PART OF THE PETAL.*/
  t2.penup();
  t2.back(20);
  t2.left(90*side);
  t2.forward(10);
  t2.right(90*side);
  t2.forward(f);
  
  t2.left((180-angle_a-(180-angle_f2-angle_d))*side);
  t2.forward(b);
  
  ab_x = t2.x;  ab_y = t2.y;   // Store point AB coordinates.
  
  t2.penup();
  t2.left((180-angle_cd)*side);
  t2.forward(a);

  ac_x = t2.x;  ac_y = t2.y;  // Store point AC coordinates.
  
  /* Return to start position */
  t2.penup();
  t2.back(a);
  t2.right((180-angle_cd)*side);
  t2.back(b);
  t2.right((180-angle_a-(180-angle_f2-angle_d))*side);
  t2.back(f);
  t2.left(90*side);
  t2.back(10);
  t2.right(90*side);
  t2.forward(20);
  
  /* DRAW THE LEFT SIDE PETAL */
  noStroke();
  fill(color(tempC));
  triangle(df_x+100+(centerwidth*-1*side),df_y,de_x+100+(centerwidth*-1*side),de_y,ab_x+100+(centerwidth*-1*side),ab_y);
  triangle(ac_x+100+(centerwidth*-1*side),ac_y,de_x+100+(centerwidth*-1*side),de_y,ab_x+100+(centerwidth*-1*side),ab_y);  
}

/* DRAW BASE OF THE FLOWER */
void move_base(){
  
 stroke(0);
 line(center_x,df_y,center_x,height-100); // vertical line for the stem 
 line(df_x+100+centerwidth,df_y,df_x+100-centerwidth-20,df_y); // horizontal line for the base
 
 stroke(color(tempC));  line(ef_x+100-centerwidth-20,ef_y,ef_x_R+100+centerwidth,ef_y);  //colored line for the bottom
 fill(color(tempC)); // Colored pivots (moving pivots of the bottom)
 ellipse(ef_x+100+centerwidth,ef_y,8,8);  //moving pivot for the right side
 ellipse(ef_x+100-centerwidth-20,ef_y,8,8);  // moving pivot for the left side
 noStroke();    fill(0);  // black pivots (fixed pivots of the base)
 ellipse(552,df_y,8,8);    ellipse(599,df_y,8,8);
  
/* CHANGE AND ROTATE AT END OF STROKE. */   
 //  if(f1>e-d-1 || f1<=-20){//-20~e-d-1
    if(angle_d+angle_a>=180-20 || angle_d+angle_a <=angle_a+20){ 
     change_f1 = change_f1*-1;
   } 
   
  if(p_rotate_mode ==0){
    p_rotate = map(f1,-20,e-d-1,0,180);
    if (p_rotate ==180){
          p_rotate_mode =1;
    }
  }else if(p_rotate_mode ==1){
    p_rotate = map(f1,-20,e-d-1,360,180);
    if (p_rotate ==360){
          p_rotate_mode =0;
    }
  }
  f1 = f1+change_f1; //MOVE THE BOTTOM UP AND DOWN   
//  println(angle_d);
}  

void GearPiston(){
  fill(color(tempC));
  ellipse(ef_x+100-10,ef_y+30,10,10);  // fixed pivot on the base
  stroke(color(tempC));    fill(255);
  ellipse(575,height-70,p_rad+30,p_rad+30); // outline of the piston gear
  noStroke();    fill(0);
  ellipse(575,height-70,8,8); // center of the piston gear: fixed pivot
   
     t6.penup();
     t6.right(90);
     t6.forward(100);
     t6.left(90);
     t6.back(230);   // center of the piston gear   
     t6.left(p_rotate);
     t6.back(p_rad/2-5);     
     Pcenter_x = t6.x;  Pcenter_y = t6.y;
     
     t6.penup();
     t6.forward(p_rad/2-5);
     t6.right(p_rotate);
     t6.forward(230);
     t6.right(90);
     t6.back(100);
     t6.left(90);
     
     fill((color(tempC)));  ellipse(Pcenter_x,Pcenter_y,12,12);  // moving pivot circling the piston gear edge
     stroke(color(tempC));  line(Pcenter_x,Pcenter_y,ef_x+100-10,ef_y); // linkage to move the base up & down
}

/* RACK GEAR: LINEAR GEAR */
void GearRack(){

  distA = 9; // the teeth length
  distC = distA+2.5; // the gap between teeth
  startingY = ef_y;  
  fill(color(tempC));  rect(startingX2,ef_y,RW,280); // the body of the linear gear
  
// DRAW TEETH
    for (float Ri=10; Ri < 270; Ri=Ri+distA+distC){
        quad(startingX,startingY+Ri,startingX+Tlength,startingY+Ri,startingX+Tlength+TL4,startingY+TL3+Ri,startingX,startingY+TL3+Ri);
        quad(startingX+Tlength+TL4,startingY+TL3+Ri,startingX,startingY+TL3+Ri,startingX,startingY+distA-TL3+Ri,startingX+Tlength+TL4,startingY+distA-TL3+Ri); 
        quad(startingX,startingY+distA+Ri,startingX+Tlength,startingY+distA+Ri,startingX+Tlength+TL4,startingY+distA-TL3+Ri,startingX,startingY+distA-TL3+Ri);
    }

// MATCHING RACK AND PINION GEARS      
   if (f1<=0)   
     pinion_rotate = map(f1,0,-19,-2,20.5); 
   else if(f1>0)
     pinion_rotate = map(f1,0,59,-2,-73);  
    
  Gearpinion(pinion_rotate);  // DRAW PINION GEAR 
  
  if(gear_status == 0){
    f1 = 0;      change_f1 = 1;
    gear_status = 1-gear_status;
  }
}

/* PINION GEAR: ROTATING GEAR */
void Gearpinion(float i0){
 calculate_pinion_gear(i0);
 
// DRAW THE PINION GEAR TEETH
    for(int i = 0; i<30;i=i+2){
      stroke(color(tempC));        
      line(pinion_x1[i],pinion_y1[i],pinion_x2[i],pinion_y2[i]);
      line(pinion_x2[i],pinion_y2[i],pinion_x3[i],pinion_y3[i]);        
      line(pinion_x3[i],pinion_y3[i],pinion_x3[i+1],pinion_y3[i+1]);        
      line(pinion_x1[i+1],pinion_y1[i+1],pinion_x1[i+2],pinion_y1[i+2]);        
      line(pinion_x1[i+1],pinion_y1[i+1],pinion_x2[i+1],pinion_y2[i+1]);
      line(pinion_x2[i+1],pinion_y2[i+1],pinion_x3[i+1],pinion_y3[i+1]);        
   }
// DRAW THE CENTER POINT OF THE PINION GEAR
    ellipse(width/2+pinion_X,height/2+pinion_Y,10,10);
 }

/*PREPARE TO DRAW THE PINION GEAR */ 
void calculate_pinion_gear(float i1){ 
// MOVE TO THE CENTER OF THE PINION GEAR  
      t5.penup();
      t5.right(90);
      t5.forward(pinion_X);
      t5.left(90);
      t5.back(pinion_Y);

// WALK THROUGH PINIONS OF THE PINION GEAR     
   for(int d=0; d<31;d=d+2){     
      t5.left(i1+ii*d);
      t5.forward(Tr); 
      pinion_x1[d] = t5.x;    pinion_y1[d] = t5.y;   
      t5.penup();
      t5.forward(Tlength); 
      pinion_x2[d] = t5.x;    pinion_y2[d] = t5.y;   
      t5.penup();
      t5.left(deg);
      t5.forward(Tlength2);
      pinion_x3[d] = t5.x;    pinion_y3[d] = t5.y;         
      t5.penup();
      t5.back(Tlength2);
      t5.right(deg);
      t5.back(Tlength);
      t5.back(Tr);
      t5.right(i1+ii*d);  
      
      t5.penup();
      t5.left(i1+ii*(d+1));
      t5.forward(Tr); 
      pinion_x1[d+1] = t5.x;    pinion_y1[d+1] = t5.y;   
      t5.penup();
      t5.forward(Tlength); 
      pinion_x2[d+1] = t5.x;    pinion_y2[d+1] = t5.y;   
      t5.penup();
      t5.right(deg);
      t5.forward(Tlength2);
      pinion_x3[d+1] = t5.x;    pinion_y3[d+1] = t5.y;       
      t5.penup();
      t5.back(Tlength2);
      t5.left(deg);
      t5.back(Tlength);
      t5.back(Tr);
      t5.right(i1+ii*(d+1));
   }   
// BACK TO THE HOME   
      t5.forward(pinion_Y);
      t5.left(90);
      t5.forward(pinion_X);
      t5.right(90);  
  }
}
