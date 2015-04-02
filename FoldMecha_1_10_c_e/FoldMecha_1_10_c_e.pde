Turtle t1, t2, t5, t6; // 1, 2: Draw flower, 5: piston, 6: rack & pinion
Pairs[] pair = new Pairs[1];  // class to draw petals
import processing.pdf.*;   // plugin to save the folding net as a pdf file

color bgColor = #FFFFFF; // white
color blank_rotate, blank_apply, blank_clear,  blank_viewMap, blank_saveImage, blank_totalLength; //panels
color colorcheck;    int colorIndex = 0;    // check what color is picked
color [] colorsend = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }; // to save the selected colors
PFont instruction; // to import a font for all instructions
int UI;     // UI = 1 : design page , UI = 2 : foldingnet page
int gearindex = 0;  // draw selected gears for the latest model
int typeMode = 0;   // mode 0: nothing, mode 1~5: type A~E parameters, mode 6: type Length
int drawMode = 0;  // mode 0: default , mode 1: add more models, mode 2: clear all, mode 3: show the map page
boolean didntTypeYet = true; // at the beginning, there is not typing yet
float [] sum_buffFloat = { 0.0, 0.0 }; // to draw upper part of the petal
float [] sum2_buffFloat = { 0.0, 0.0 }; // to draw bottom part of the petal
String buff = "";     float [] buffFloat = { 0.0, 0.0 };     // for A buff
String buff2 = "";     float [] buffFloat2 = { 0.0, 0.0 };     // for B buff
String buff3 = "";     float [] buffFloat3 = { 0.0, 0.0 };     // for C buff
String buff4 = "";     float [] buffFloat4 = { 0.0, 0.0 };     // for D buff
String buff5 = "";     float [] buffFloat5 = { 0.0, 0.0 };     // for E buff
String buff6 = "";     float [] buffFloat6 = { 0.0, 0.0 };     String buff6_string = "";    // for W buff

float map_buff01, map_buff02, map_buff03, map_buff04, map_buff05, map_buff06; // to save the customized parameters
float map_part01, map_part02, map_part03, map_part04, map_part04B, map_part05B, map_part06B, map_part07B,  
      map_part08, map_part09, map_part10, map_part11, map_part12; // to draw the map

int leftmargin = 53;  int rightmargin = 885;  int leftmargin2 = 127;  int rightmargin2 = 805; //typing box position
int gNum, TR, TL, TL2; // to draw Rack gear
int RP_gear_status = 0;    int RackPinion_status = 0;    // Rack and pinion gear status
int P_gear_status = 0;    int Piston_status = 0;  // piston gear status

void setup() {
  
  size(950, 660);    background(bgColor);
  colorcheck = color(#FF0331);   // when the system starts, color default setting is red.
  colorsend[0] = colorcheck;    colorsend[1] = colorcheck;  //remember two latest selected colors
  instruction = createFont ("HelveticaNeue", 16);    textFont(instruction);  // setting for fonts
  UI = 1;    UI_A(); // UI= 1 : design page, UI_A : starting mode for the left panels

  /* setting for saving the customized parameters of two latest models*/
  if (buffFloat[0] != 0 && buffFloat2[0] != 0)  
    pair[0] = new Pairs(buffFloat[0], buffFloat2[0], buffFloat3[0], buffFloat4[0], buffFloat5[0], colorsend[0]);
  else
    pair[0] = new Pairs(buffFloat[1], buffFloat2[1], buffFloat3[1], buffFloat4[1], buffFloat5[1], colorsend[1]);   
//frameRate(10);
}

void draw() {

  if (UI == 1) {
    UI_page1();   // UI for the design page    
  } else if (UI == 2) {   
    UI_page2();   // UI for the foldingnet page    
  }
}  

void mouseReleased() {

  if (UI == 1) {

    color_clicked();  // select color
    gear_clicked();  // select gear
    function_clicked();  // select add, clear, or view Map 
    
    if (mouseX>=48 && mouseX<=80 && mouseY>239 && mouseY<=264) 
      typeMode = 1;  // enabling typing "A"
    else if (mouseX>=125 && mouseX<=157 && mouseY>239 && mouseY<=264) 
      typeMode = 2;  // enabling typing "B"
    else if (mouseX>=48 && mouseX<=80 && mouseY>=269 && mouseY<=294) 
      typeMode = 3;  // enabling typing "C"
    else if (mouseX>=125 && mouseX<=157 && mouseY>=269 && mouseY<=294) 
      typeMode = 4;  // enabling typing "D"
    else if (mouseX>=48 && mouseX<=80 && mouseY>=299 && mouseY<=324) 
      typeMode = 5;  // enabling typing "E"
      
  } else if (UI == 2) {

    if (mouseX>=150 && mouseX <=180 && mouseY >=605 && mouseY <=625) {
      UI = 1;    drawMode = 1;    UI_A();        
    }  else if (mouseX>=150 && mouseX <=170 && mouseY >=575 && mouseY <=595) {       ////////////// save Image
      Draw_FoldingNet();

    }
    if (mouseX>=85 && mouseX<=115 && mouseY>260 && mouseY<=285) {  ////////////////// type to change the total length
      typeMode = 6;
    }
    if (mouseX>=128 && mouseX<=150 && mouseY>260 && mouseY<=285) {   ////////////////// change the total length
    /*  buffFloat[0] = buffFloat[0] * buffFloat6[0];      buffFloat2[0] = buffFloat2[0] * buffFloat6[0];
      buffFloat3[0] = buffFloat3[0] * buffFloat6[0];    buffFloat4[0] = buffFloat4[0] * buffFloat6[0];
      buffFloat5[0] = buffFloat5[0] * buffFloat6[0];*/                
      buffFloat[1] = buffFloat[1] * buffFloat6[1];      buffFloat2[1] = buffFloat2[1] * buffFloat6[1];
      buffFloat3[1] = buffFloat3[1] * buffFloat6[1];    buffFloat4[1] = buffFloat4[1] * buffFloat6[1];
      buffFloat5[1] = buffFloat5[1] * buffFloat6[1];
      println("**MULTIPLY***");
            
    }
  }
}

void UI_page1(){
  
    viewMode_A();    // left panel UI to customize parameters

    if (drawMode == 0) {    // when system starts, the drawmode is "0"
        fill(bgColor);    noStroke();    rect(200, 0, 750, height);    // white background for flower simulation
        pair[0].drawing();    // draw one flower when system starts
    } else if (drawMode ==1) {    // as add more flowers, the drawmode becomes "1"
        noStroke();    fill(bgColor);    rect(200, 0, width-200, height);    // white background for flower simulation
        for (int i = 0; i<pair.length; i++) {
          pair[i].drawing();        
          if (RP_gear_status == 1)
             pair[gearindex].GearRack();   // if selected, apply r&p gears for the latest model
          if (P_gear_status == 1)
             pair[gearindex].GearPiston();   // if selected, apply piston gear for the latest model
        }      
    } else if (drawMode ==2) {      // drawMode 2 stands for "clear" mode
        noStroke();    fill(bgColor);    rect(200, 0, width-200, height);    // white background for flower simulation              
        for (int i = 0; i<pair.length; i++) {
          pair[i].clearColor();
        }      
    } else if (drawMode == 3) {    // drawMode 3 stands for the page showing folding nets
        noStroke();    fill(bgColor);  rect(200, 0, width-200, height);    // white background for flower simulation     
        UI = 2;
   }
   
    if (typeMode == 1){  type_A();  }
    else if (typeMode == 2){  type_B();  }
    else if (typeMode == 3){  type_C();  }
    else if (typeMode == 4){  type_D();  }
    else if (typeMode == 5){  type_E();  }

    if (mousePressed == true){   // while pressing mouse, each box stays in black
        if (mouseX>=105 && mouseX <=125 && mouseY >=500 && mouseY <=520) {
          blank_apply = color(#000000);    applybox();
        } else if (mouseX>=105 && mouseX <=125 && mouseY >=530 && mouseY <=550) {
          blank_clear = color(#000000);    clearbox();
        } else if (mouseX>=150 && mouseX <=180 && mouseY >=605 && mouseY <=625) {
          blank_viewMap = color(#000000);    viewMap();
        }
    }else{    // otherwise, all stay in white
        blank_clear = color(#FFFFFF);  blank_apply = color(#FFFFFF);  blank_viewMap = color(#FFFFFF);
    }
    
    viewMap();        applybox();        clearbox();   // left panel
    
    if (RackPinion_status == 1){    RackPinion_on();    }   
    else if (RackPinion_status == 0){    RackPinion_off();    }   
    if (Piston_status == 1){    Piston_on();    }
    else if (Piston_status == 0){    Piston_off();    }
}

void UI_page2(){

    noStroke();  fill(bgColor);  rect(100, 0, width-100, height);  // white background

    if (mousePressed == true) {  
        if (mouseX>=150 && mouseX <=180 && mouseY >=605 && mouseY <=625) {
          blank_viewMap = color(#000000);    viewMap();
        } else if (mouseX>=150 && mouseX <=170 && mouseY >=575 && mouseY <=595) {
          blank_saveImage = color(#000000);    saveImage();
        } else if (mouseX>=120 && mouseX <=150 && mouseY >=260 && mouseY <=280) {
          blank_totalLength = color(#000000);    totalLength();
        }
    } else {
        blank_viewMap = color(#FFFFFF);  blank_saveImage = color(#FFFFFF);  blank_totalLength = color(#FFFFFF);
    }   

    noStroke();    noFill();    UI_B();    //viewMode_B();    // view map page UI (left panel) display
    viewMap();    totalLength();    drawMap();  howtoFold(170);
    fill(0);    stroke(0);   line (85, 285, 118, 285); // typing line for G
    text("How to Fold", 25, 50);    text("Size:  x", 25, 280);
    text("Save This File", 25, 590);     text("View Simulation", 25, 620);     
    if (typeMode == 6) {   type_Size();   } 

}

void color_clicked(){
    if (mouseX>=30 && mouseX <=48 && mouseY >=465 && mouseY <=481) {     ////////////// red
      colorbox();        colorcheck = color(#FF0331);
      colorIndex++;        colorsend[colorIndex] = colorcheck;   
      line(31, 465, 47, 481);    line(31, 481, 47, 465);  // check red      
    }  else if (mouseX>=50 && mouseX <=68 && mouseY >=465 && mouseY <=481) {     ////////////// orange
      colorbox();        colorcheck = color(#FF9F03);       
      colorIndex++;        colorsend[colorIndex] = colorcheck;
      line(51, 465, 67, 481);    line(51, 481, 67, 465);  // check orange
    }  else if (mouseX>=70 && mouseX <=88 && mouseY >=465 && mouseY <=481) {     ////////////// yellow
      colorbox();        colorcheck = color(#C0C60A);
      colorIndex++;        colorsend[colorIndex] = colorcheck;
      line(71, 465, 87, 481);    line(71, 481, 87, 465);  // check yellow
    }  else if (mouseX>=90 && mouseX <=108 && mouseY >=465 && mouseY <=481) {     ////////////// green
      colorbox();        colorcheck = color(#55C60A);
      colorIndex++;        colorsend[colorIndex] = colorcheck;
      line(91, 465, 107, 481);    line(91, 481, 107, 465);  // check green
    }  else if (mouseX>=110 && mouseX <=128 && mouseY >=465 && mouseY <=481) {     ////////////// blue
      colorbox();        colorcheck = color(#0290E5);
      colorIndex++;        colorsend[colorIndex] = colorcheck;
      line(111, 465, 127, 481);    line(111, 481, 127, 465);  // check blue
    }  else if (mouseX>=130 && mouseX <=148 && mouseY >=465 && mouseY <=481) {     ////////////// navy
      colorbox();        colorcheck = color(#020BE5);
      colorIndex++;        colorsend[colorIndex] = colorcheck;
      line(131, 465, 147, 481);    line(131, 481, 147, 465);  // check navy
    }  else if (mouseX>=150 && mouseX <=168 && mouseY >=465 && mouseY <=481) {     ////////////// purple
      colorbox();        colorcheck = color(#A802E5);
      colorIndex++;        colorsend[colorIndex] = colorcheck;
      line(151, 465, 167, 481);    line(151, 481, 167, 465);  // check purple
    }   
}

void gear_clicked(){
  
    if (mouseX>=155 && mouseX<=175 && mouseY>=397 && mouseY<=417) {        // checked or removed Rack and Pinion
      if (RackPinion_status == 0) {
        RackPinion_status =1;        RP_gear_status = 1;
      } else if (RackPinion_status == 1) {
        RackPinion_status =0;        RP_gear_status = 0;
      }
    }
    if (mouseX>=104 && mouseX<=122 && mouseY>=372 && mouseY<=392) {        // checked or removed Piston
      if (Piston_status == 0) {
        Piston_status = 1;        P_gear_status = 1;
      }
      else if (Piston_status ==1) {
        Piston_status = 0;        P_gear_status = 0;
      }
    }  
}

void function_clicked(){
    if (mouseX>=105 && mouseX <=125 && mouseY >=500 && mouseY <=520) {     ////////////// ADD

      if (buffFloat[1] == 0){  buffFloat[1] = 2;  }
      if (buffFloat2[1] == 0){  buffFloat2[1] = 8;  }      
      if (buffFloat3[1] == 0){  buffFloat3[1] = 3;  }      
      if (buffFloat4[1] == 0){  buffFloat4[1] = 4;  }      
      if (buffFloat5[1] == 0){  buffFloat5[1] = 6;  }      
      float A = buffFloat[1];      float B = buffFloat2[1];      float C = buffFloat3[1];
      float D = buffFloat4[1];      float E = buffFloat5[1];
      
      if (parametersOK(A,B,C,D,E)) {
        Pairs n = new Pairs(A, B, C, D, E, colorcheck);
        pair = (Pairs []) append(pair, n);
        gearindex++;        drawMode = 1;         
      } else { println ("Error Bad Parameters"); }
      
    }  else if (mouseX>=105 && mouseX <=125 && mouseY >=530 && mouseY <=550) {       ////////////// CLEAR
      drawMode =2;
    }  else if (mouseX>=150 && mouseX <=180 && mouseY >=605 && mouseY <=625) {       ////////////// View Map
      UI =2;
      drawMode = 3;
    }  
}

void type_A(){
 
      fill(70);   text(buff2, 127, 255);  text(buff3, 55, 285);   
      text(buff4, 127, 285);  text(buff5, 55, 315);  // display other text 

      float rPos;    rPos = textWidth(buff) + leftmargin; // Store the cursor rectangle's position     
      stroke(0); fill(0);  rect(rPos+1, 235, 5, 21); // blinking rect size
      pushMatrix();  translate(rPos, 255);
      char k;
      for (int i = 0;i < buff.length(); i++) {
        if (int(buff.charAt(i))>=48 && int(buff.charAt(i))<=57) { 
              k = buff.charAt(i);       
              translate(-textWidth(k), 0);             
              text(k, 0, 0);
        }
      }
      popMatrix();  // about typing 
}

void type_B(){
  
      fill(70);  text(buff, 55, 255);   text(buff3, 55, 285);   
      text(buff4, 127, 285);  text(buff5, 55, 315);  // display other text   

      float rPos2;    rPos2 = textWidth(buff2) + leftmargin2; // Store the cursor rectangle's position      
      stroke(0); fill(0);  rect(rPos2+1, 235, 5, 21); // blinking rect size
      pushMatrix();  translate(rPos2, 255);
      char k;
      for (int i = 0;i < buff2.length(); i++) {
        if (int(buff2.charAt(i))>=48 && int(buff2.charAt(i))<=57) { 
            k = buff2.charAt(i);
            translate(-textWidth(k), 0);
            text(k, 0, 0);
        }
      }
      popMatrix();  // about typing    
}

void type_C(){
  
      fill(70);  text(buff, 55, 255);  text(buff2, 127, 255);   
      text(buff4, 127, 285);  text(buff5, 55, 315);  // display other text  

      float rPos3;    rPos3 = textWidth(buff3) + leftmargin; // Store the cursor rectangle's position      
      stroke(0); fill(0);  rect(rPos3+1, 265, 5, 21); // blinking rect size
      pushMatrix();  translate(rPos3, 285);
      char k;
      for (int i = 0;i < buff3.length(); i++) {
        if (int(buff3.charAt(i))>=48 && int(buff3.charAt(i))<=57) { 
            k = buff3.charAt(i);
            translate(-textWidth(k), 0);
            text(k, 0, 0);
        }
      }
      popMatrix();  // about typing  
}

void type_D(){
  
      fill(70);  text(buff, 55, 255);  text(buff2, 127, 255);   
      text(buff3, 55, 285);  text(buff5, 55, 315);  // display other text 

      float rPos4;    rPos4 = textWidth(buff4) + leftmargin2; // Store the cursor rectangle's position
      stroke(0); fill(0);  rect(rPos4+1, 265, 5, 21); // blinking rect size
      pushMatrix();  translate(rPos4, 285);
      char k;
      for (int i = 0;i < buff4.length(); i++) {
        if (int(buff4.charAt(i))>=48 && int(buff4.charAt(i))<=57) { 
            k = buff4.charAt(i);
            translate(-textWidth(k), 0);
            text(k, 0, 0);
        }
      }
      popMatrix();  // about typing  
}

void type_E(){
  
      fill(70);  text(buff, 55, 255);  text(buff2, 127, 255);   
      text(buff3, 55, 285);  text(buff4, 127, 285);  // display other text 

      float rPos5;    rPos5 = textWidth(buff5) + leftmargin; // Store the cursor rectangle's position    
      stroke(0); fill(0);  rect(rPos5+1, 295, 5, 21); // blinking rect size
      pushMatrix();  translate(rPos5, 315);
      char k;
      for (int i = 0;i < buff5.length(); i++) {
        if (int(buff5.charAt(i))>=48 && int(buff5.charAt(i))<=57) { 
            k = buff5.charAt(i);
            translate(-textWidth(k), 0);
            text(k, 0, 0);
        }
      }
      popMatrix();  // about typing  
}

void type_Size(){
  
      float rPos6;    rPos6 = textWidth(buff6) + leftmargin+32; // Store the cursor rectangle's position    
      stroke(0); fill(0);  rect(rPos6+1, 260, 5, 21); // blinking rect size
      pushMatrix();  translate(rPos6, 280);
      char k;
      for (int i = 0;i < buff6.length(); i++) {
        if (int(buff6.charAt(i))>=48 && int(buff6.charAt(i))<=57) { 
            k = buff6.charAt(i);
            translate(-textWidth(k), 0);
            text(k, 0, 0);
        }
      }
      popMatrix();  // about typing  
}
boolean parametersOK (float a,float b,float c,float d,float e) {
   return (a < b + c + d) && (b < a + c + d) && (c + d < a + b);
}    // the function parametersOK returns True if the user's given numbers make a figure that can be drawn.

void keyPressed()
{
    if (typeMode ==1) {
      char k;    k = (char)key;
      switch(k) {
      case 8: //delete
         if (buff.length()>0) {
         buff = buff.substring(1);
         }
      break;  case 13:  case 10:  case 65535:  case 127:  case 27:  // Avoid special keys
      break;  default:
        if (textWidth(buff+k)+leftmargin < width-rightmargin) {
          didntTypeYet = false;
          buff = k+buff;
          castToNumber();
        }  break;
      }
    }  else if (typeMode ==2) {
      char k;    k = (char)key;
      switch(k) {
      case 8:
        if (buff2.length()>0) {
          buff2 = buff2.substring(1);
        }
      break;  case 13:  case 10:  case 65535:  case 127:  case 27:  // Avoid special keys
      break;  default:
        if (textWidth(buff2+k)+leftmargin2 < width-rightmargin2) {
          didntTypeYet = false;
          buff2 = k+buff2;
          castToNumber2();
        }  break;
      }
    }  else if (typeMode ==3) {
      char k;    k = (char)key;
      switch(k) {
      case 8:
        if (buff3.length()>0) {
          buff3 = buff3.substring(1);
        }
      break;  case 13:  case 10:  case 65535:  case 127:  case 27:  // Avoid special keys
      break;  default:
        if (textWidth(buff3+k)+leftmargin < width-rightmargin) {
          didntTypeYet = false;
          buff3 = k+buff3;
          castToNumber3();
        }  break;
      }
    }  else if (typeMode ==4) {
      char k;    k = (char)key;
      switch(k) {
      case 8:
        if (buff4.length()>0) {
          buff4 = buff4.substring(1);
        }
      break;  case 13:  case 10:  case 65535:  case 127:  case 27:  // Avoid special keys
      break;  default:
        if (textWidth(buff4+k)+leftmargin2 < width-rightmargin2) {
          didntTypeYet = false;
          buff4 = k+buff4;
          castToNumber4();
        }  break;
      }
    }  else if (typeMode ==5) {
      char k;    k = (char)key;
      switch(k) {
      case 8:
        if (buff5.length()>0) {
          buff5 = buff5.substring(1);
        }
      break;  case 13:  case 10:  case 65535:  case 127:  case 27:  // Avoid special keys
      break;  default:
      if (textWidth(buff5+k)+leftmargin < width-rightmargin) {
          didntTypeYet = false;
          buff5 = k+buff5;
          castToNumber5();
      }  break;
     }
   }  else if (typeMode ==6) {
      char k;    k = (char)key;
      switch(k) {
      case 8:
        if (buff6.length()>0) {
          buff6 = buff6.substring(1);
        }
      break;  case 13:  case 10:  case 65535:  case 127:  case 27:  // Avoid special keys
      break;  default:
      if (textWidth(buff6+k)+leftmargin < width-rightmargin) {
          didntTypeYet = false;
          buff6 = k+buff6;
          castToNumber6();
      }  break;
     }
   }
} 

void UI_A() {
  noStroke();  fill(210);    rect(0, 0, 200, height); // draw gray background for the left panel
  fill(0);    stroke(0);  // set how to write text
  text("Change Design", 30, 30);    text("Select Color", 30, 455);
  text("Add", 30, 515);             text("Clear All", 30, 545);
  text("View the Map", 30, 620);    text("Motor & Gear :", 30, 359);
  text("Piston", 30, 386);          text("Rack and Pinion", 30, 410);
  colorbox();  applybox();  clearbox();  viewMap();    //check box on the panel 
  line(31, 465, 47, 481);  line(31, 481, 47, 465);   // red check for start
}

void UI_B() {
  fill(210);  rect(0, 0, 200, height);   // draw gray background for the left panel
  noStroke();  fill(255);  rect(200, 0, 800, 600);  // draw white background for the right side
  saveImage();
}

void applybox() {  stroke(0);    fill(color(blank_apply));    rect(105, 500, 17, 17);  }  

void clearbox() {  stroke(0);    fill(color(blank_clear));    rect(105, 530, 17, 17);  }  

void viewMap() {  stroke(0);    fill(color(blank_viewMap));    triangle(150, 605, 150, 625, 170, 615);  }

void totalLength() {  stroke(0);    fill(color(blank_totalLength));    triangle (130, 263, 130, 283, 150, 273);  }

void saveImage() {  stroke(0);    fill(color(blank_saveImage));    rect(150, 575, 17, 17);  }

void drawMap() {         ///////////////////////////// convert to the map

  sum_buffFloat[1] = buffFloat[1]*2+buffFloat2[1]*2+buffFloat3[1]*2+buffFloat4[1];
  sum2_buffFloat[1] = buffFloat4[1]*2+buffFloat5[1]*2;

  map_buff01 = (buffFloat[1]/sum_buffFloat[1])*800;
  map_buff02 = (buffFloat2[1]/sum_buffFloat[1])*800;
  map_buff03 = (buffFloat3[1]/sum_buffFloat[1])*800;
  map_buff04 = (buffFloat4[1]/sum_buffFloat[1])*800;
  map_buff05 = (buffFloat5[1]/sum_buffFloat[1])*800;

  map_part01 = map_buff02;
  map_part02 = map_buff02+map_buff01;   
  map_part03 = map_buff02+map_buff01+map_buff03+map_buff04;   
  map_part04 = map_buff02+map_buff01+map_buff03+map_buff04+50;   
  
  map_part04B = 50;
  map_part05B = 50+map_buff03+map_buff04;
  map_part06B = 50+map_buff03+map_buff04+map_buff01;
  map_part07B = 50+map_buff03+map_buff04+map_buff01+map_buff02;

  map_part08 = map_buff04;
  map_part09 = map_buff04 + map_buff05;
  map_part10 = map_buff04 + map_buff05 + 50;
  map_part11 = map_buff04 + map_buff05 + 50 + map_buff05;
  map_part12 = map_buff04 + map_buff05 + 50 + map_buff05 + map_buff04;

  stroke(0);    stroke(colorsend[colorIndex]); 
  line(240+map_part01, 75, 240+map_part01, 125);  line(240+map_part02, 75, 240+map_part02, 125);
  line(240+map_part03, 75, 240+map_part03, 125);  line(240+map_part04, 75, 240+map_part04, 125);

  line(240+50, 175, 240+map_part04B, 225);  line(240+map_part05B, 175, 240+map_part05B, 225);
  line(240+map_part06B, 175, 240+map_part06B, 225);  line(240+map_part07B, 175, 240+map_part07B, 225);

  line(240+map_part08, 275, 240+map_part08, 325);  line(240+map_part09, 275, 240+map_part09, 325);
  line(240+map_part10, 275, 240+map_part10, 325);  line(240+map_part11, 275, 240+map_part11, 325);
  line(240+map_part12, 275, 240+map_part12, 325);

  noFill();  line(240, 75, 240, 125); //left edge of the mapA
  line(240, 75, 240+map_part04, 75);    line(240, 125, 240+map_part04, 125); //horizontal lineA
  noFill();  line(240, 175, 240, 225); //left edge of the mapA2
  line(240, 175, 240+map_part04, 175);    line(240, 225, 240+map_part04, 225); //horizontal lineA2
  line(240, 275, 240, 325); //left edge of the mapB
  line(240, 275, 240+map_part12, 275);    line(240, 325, 240+map_part12, 325);  //horizontal lineB

  fill(colorsend[colorIndex]);
  text("1", 245, 120);  text("2", 245+map_part01, 120);  text("3", 245+map_part02, 120);
  text("4", 245+map_part03, 120);  text("4", 245, 220);  text("5", 245+map_part04B, 220);
  text("6", 245+map_part05B, 220);  text("7", 245+map_part06B, 220);
  text("8", 245, 320);  text("9", 245+map_part08, 320);  text("10", 245+map_part09, 320);
  text("11", 245+map_part10, 320);   text("12", 245+map_part11, 320);

  text("1:", 700, 455);    text(buffFloat2[1], 720, 455);
  text("2:", 800, 455);    text(buffFloat[1], 820, 455);
  text("3:", 700, 480);    text(buffFloat3[1]+buffFloat4[1], 720, 480);
  text("4:", 800, 480);    text(" 2.000", 820, 480);
  text("5:", 700, 505);    text(buffFloat3[1]+buffFloat4[1], 720, 505);
  text("6:", 800, 505);    text(buffFloat[1], 820, 505);
  text("7:", 700, 530);    text(buffFloat2[1], 720, 530);
  text("8:", 800, 530);    text(buffFloat4[1], 820, 530);
  text("9:", 700, 555);    text(buffFloat5[1], 720, 555);
  text("10:", 795, 555);   text(" 2.000", 820, 555);
  text("11:", 695, 580);   text(buffFloat5[1], 720, 580);
  text("12:", 795, 580);   text(buffFloat4[1], 820, 580);
}



void Draw_FoldingNet() {
  PGraphics pdf = createGraphics(1400, 550, PDF, "folding_net.pdf");
  pdf.beginDraw();
  pdf.background(255);    pdf.stroke(0);

  pdf.line(20, 50, 20, 110);
  pdf.line(20+map_part01*1.7, 50, 20+map_part01*1.7, 110);
  pdf.line(20+map_part02*1.7, 50, 20+map_part02*1.7, 110);
  pdf.line(20+map_part03*1.7, 50, 20+map_part03*1.7, 110);
  pdf.line(20+map_part04*1.7, 50, 20+map_part04*1.7, 110);
  pdf.line(20, 50, 20+map_part04*1.8, 50);
  pdf.line(20, 110, 20+map_part04*1.8, 110);
  pdf.fill(0);
  pdf.text("1", 20+5, 125);    pdf.text("2", 20+map_part01*1.8+5, 125);
  pdf.text("3", 20+map_part02*1.8+5, 125);    pdf.text("4", 20+map_part03*1.8+5, 125);  

  pdf.line(20, 160, 20, 220);
  pdf.line(20+map_part04B*1.7, 160, 20+map_part04B*1.7, 220);
  pdf.line(20+map_part05B*1.7, 160, 20+map_part05B*1.7, 220);
  pdf.line(20+map_part06B*1.7, 160, 20+map_part06B*1.7, 220);
  pdf.line(20+map_part07B*1.7, 160, 20+map_part07B*1.7, 220);
  pdf.line(20, 160, 20+map_part07B*1.7, 160);    pdf.line(20, 220, 20+map_part07B*1.7, 220);
  pdf.text("4", 20+5, 235);    pdf.text("5", 20+map_part04B*1.7+5, 235);
  pdf.text("6", 20+map_part05B*1.7+5, 235);    pdf.text("7", 20+map_part06B*1.7+5, 235);  

  pdf.line(20, 270, 20, 330);
  pdf.line(20+map_part08*1.7, 270, 20+map_part08*1.7, 330);
  pdf.line(20+map_part09*1.7, 270, 20+map_part09*1.7, 330);
  pdf.line(20+map_part10*1.7, 270, 20+map_part10*1.7, 330);
  pdf.line(20+map_part11*1.7, 270, 20+map_part11*1.7, 330);
  pdf.line(20+map_part12*1.7, 270, 20+map_part12*1.7, 330); 
  pdf.line(20, 270, 20+map_part12*1.7, 270);    pdf.line(20, 330, 20+map_part12*1.7, 330);  
  pdf.text("8", 20+5, 345);    pdf.text("9", 20+map_part08*1.7+5, 345);
  pdf.text("10", 20+map_part09*1.7+5, 345);    pdf.text("11", 20+map_part10*1.7+5, 345);  
  pdf.text("12", 20+map_part11*1.7+5, 345);   
/*  
  if (RP_gear_status ==1)
    pdf.rect(100,100,100,100);  // draw rack and pinion gears here
  if (P_gear_status == 1)
    pdf.noFill();    pdf.ellipse(85,430,10,10);    pdf.ellipse(85,430,130,130);  // draw piston gear here
*/    
  pdf.dispose();   pdf.endDraw();
}

void colorbox() {
  fill(#FF0331);  rect(31, 465, 16, 16);  fill(#FF9F03);  rect(51, 465, 16, 16); // red & orange
  fill(#C0C60A);  rect(71, 465, 16, 16);  fill(#55C60A);  rect(91, 465, 16, 16); // yellow & green  
  fill(#0290E5);  rect(111, 465, 16, 16);  fill(#020BE5);  rect(131, 465, 16, 16);    // blue & navy  
  fill(#A802E5);  rect(151, 465, 16, 16);    // purple
} 

void viewMode_A() {
  noStroke();  fill(255);  rect(10, 40, 180, 185); // white background of the petal image 
  fill(210);  rect(10, 235, 180, 100);   // gray background of the panel to customize parameters
  stroke(0);   triangle(20, 60, 40, 110, 175, 110);    // petal (triangle) on the image
  line(175, 110, 175, 205);  line(120, 110, 175, 205);  // stem (connect black and white pivots)
  fill(0);    ellipse(175, 110, 7, 7);    // black pivot (fixed pivot) on the image
  fill(255);    ellipse(175, 205, 8, 8);    // white pivot (moving pivot) on the image
  fill(0);  text("A", 40, 93);  text("B", 95, 80);  text("C", 75, 130);
  text("D", 147, 130);  text("E", 125, 165);  // text on the image
  text("A:", 30, 255);  text("B:", 100, 255);  text("C:", 30, 285);  
  text("D:", 100, 285);  text("E:", 30, 315);  // text on the customization panel
  line (48, 259, 80, 259);   line (125, 259, 157, 259);   line (48, 289, 80, 289); // typing line for A & B & C
  line (125, 289, 157, 289);    line (48, 319, 80, 319); // typing line for D & E 
}

void viewMode_B() {

  fill(0);    //text("W", 90, 62);    
  text("Size:", 30, 55);
}

void howtoFold(float h){
  noStroke();   fill(255);   rect(10,230-h,180,190);
  stroke(0);  line(25,260-h,90,295-h);  line(25,260-h,35,285-h);  line(35,285-h,90,295-h);  line(90,295-h,110,295-h);
  line(110,295-h,165,285-h);  line(165,285-h,175,260-h);  line(175,260-h,110,295-h);
  line(90,330-h,60,325-h);  line(60,325-h,90,380-h);  line(90,380-h,110,380-h);  line(110,380-h,140,325-h);  line(140,325-h,110,330-h);
  
  fill(0);  text("1", 50,270-h);  text("2", 15,285-h);  text("3", 48,305-h);  text("4", 97,315-h);
  text("5", 140,305-h);  text("6", 175,285-h);  text("7", 140,270-h);  text("8", 75,345-h);  text("9", 60,365-h);
  text("10", 90,398-h);  text("11", 130,365-h);  text("12", 110,345-h);  
}

void RackPinion_on() {     // to show the status of applying Rack and Pinion Gears
  fill(255);    stroke(0);    rect(155, 397, 17, 17);  
  line(155, 397, 172, 414);    line(172, 397, 155, 414); // check Rack and Pinion
}

void RackPinion_off() {     // to show the status of canceling Rack and Pinion Gears
  fill(255);    stroke(0);    rect(155, 397, 17, 17);
}

void Piston_on() {     // to show the status of applying Piston Gear
  fill(255);    stroke(0);    rect(105, 372, 17, 17);    // check box of the piston
  line(106, 373, 121, 388);    line(121, 373, 106, 388); // check Piston 
}   

void Piston_off() {    // to show the status of canceling Piston Gear
  fill(255);    stroke(0);    rect(105, 372, 17, 17);    // check box of the piston
}

void castToNumber() {

  buffFloat[0] = 0.0;
  if (buffFloat[0] != 0)
    buffFloat[0] = float(buff);
  else
    buffFloat[1] = float(buff);
}

void castToNumber2() {

  buffFloat2[0] = 0.0;
  if (buffFloat2[0] != 0)
    buffFloat2[0] = float(buff2);
  else
    buffFloat2[1] = float(buff2);
}

void castToNumber3() {

  buffFloat3[0] = 0.0;
  if (buffFloat3[0] != 0)
    buffFloat3[0] = float(buff3);
  else
    buffFloat3[1] = float(buff3);
}
void castToNumber4() {

  buffFloat4[0] = 0.0;
  if (buffFloat4[0] != 0)
    buffFloat4[0] = float(buff4);
  else
    buffFloat4[1] = float(buff4);
}
void castToNumber5() {

  buffFloat5[0] = 0.0;
  if (buffFloat5[0] != 0)
    buffFloat5[0] = float(buff5);
  else
    buffFloat5[1] = float(buff5);
}
void castToNumber6() {

  buffFloat6[0] = 0.0;
  if (buffFloat6[0] != 0)
    buffFloat6[0] = float(buff6);
  else
    buffFloat6[1] = float(buff6);
}
