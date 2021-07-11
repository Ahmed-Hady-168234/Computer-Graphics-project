Shape shape, nextHalf;
Background bg;
PFont font; 

void setup(){
  size(720,720);
  font = loadFont("ArialRoundedMTBold-48.vlw");  
  shape = new Shape();
  shape.isActive = true;
  nextHalf = new Shape();
  bg = new Background();
}

void draw(){
   bg.display(); // screen back without shape for now
   shape.display();
   nextHalf.showNextHalf(); // the text and the next shape
   if(shape.checkBlack(bg)) // under me black t under me shape f
   {
     shape.moveDown();
   }else{
    shape.isActive = false ; // shape stops
   }
  newShape();
  gameoverDisplay(); 
}

void newShape(){
  if(!shape.isActive){// if shape stops 
    bg.saveShape(shape); // this saves the shapes in the back ground
    shape = nextHalf;
    shape.isActive = true;
    nextHalf = new Shape();
  }
}

void gameoverDisplay(){
  if(!bg.gameOver()){
     fill(126);
     rect(0,0,720,720);
     textFont(font);
     textSize(97);
      fill(150);
       text("GAME OVER" , 50 , 300) ;
       fill(0);
       translate(55,305);
       text("GAME OVER" ,0,0) ;
       textSize(70);
       fill(0);
       text("SC0RE : " + bg.score , 140, 140) ;
   }
}

void keyPressed(){
  if(keyCode == RIGHT){
    shape.move("RIGHT");
  } else if (keyCode == LEFT){
    shape.move("LEFT");
  } else if (keyCode == DOWN){
    shape.move("DOWN");
  }
}

void keyReleased(){
  if(keyCode == UP){
    shape.rotate();
    shape.rotate();
  } 
  shape.rotCount++; 
}

 ///////////////////////////////Background class //////////////////
 
public class Background{

     private int[][][] bgColors;
     private int r,g,b;
     private int w;
     private int theX, theY;
     private int score  ;
     
  public Background(){
      bgColors = new int[12][24][3];
      w = width / 24;
  }
  
  //Write the method to draw a rectangle FOR every x,y using the bgColors RGB
  public void display(){
      for(int i = 0; i < 12; i++){
        for(int j = 0; j < 24; j++){
          r = bgColors[i][j][0];
          g = bgColors[i][j][1];
          b = bgColors[i][j][2];
          fill(r,g,b);
          rect(i*w, j*w, w, w);
        }
      }
      for(int i=0 ; i<24 ; i++ )
      {
       if(checkLine(i)){
         
         removeShift(i);
       }
      }
  }
  
  public void saveShape(Shape s){ // get the color of the shape to the background
       //get theX and theY of each block
       for(int i = 0; i < 4; i++){
         theX = s.theShape[i][0];
         theY = s.theShape[i][1];
         //Write the bgColors of the shape into these x,y valuees
         bgColors[theX][theY][0] = s.r;
         bgColors[theX][theY][1] = s.g;
         bgColors[theX][theY][2] = s.b;
       } 
   }
   
  public boolean checkLine (int row)
  {
       for(int i =0 ;i< 12 ; i++){
        if(bgColors[i][row][0] == 0 && bgColors[i][row][1] == 0 && bgColors[i][row][2] == 0){
          return false ;
        }
       }
       return true ;
  }
  
    public boolean gameOver ()
  {
       for(int i =0 ;i< 12 ; i++){
        if(bgColors[i][0][0] != 0 || bgColors[i][0][1] != 0 || bgColors[i][0][2] != 0){
            
                  return false ;
        }
       }
       return true ;
  }
  
  public void removeShift(int row){
       int [][][] newBackground = new int [12][24][3];
       for(int i=0 ; i<12 ; i++){
         for(int j=23 ; j>row ; j--){
            for(int a=0 ; a<3 ; a++){
               newBackground[i][j][a] = bgColors[i][j][a]; // for those under the removed line
           } 
         }
       }
       for(int r= row ; r>0 ; r--){
         for(int j=0 ; j<12 ; j++){
            for(int a=0 ; a<3 ; a++){
               newBackground[j][r][a] = bgColors[j][r-1][a]; // for the above the line to be shifted
           } 
         }
       }
       bgColors = newBackground;
       score++;
      }
}

 ////////////////////// Shape class ////////////////////
 
public class Shape{
   
    //7 Tetris Shapes
    private int[][] square = {{0,0}, {1,0}, {0,1}, {1,1}};
    private int[][] line =   {{0,0}, {1,0}, {2,0}, {3,0}};
    private int[][] leg3 =   {{0,0}, {1,0}, {2,0}, {1,1}};
    private int[][] rightL = {{0,0}, {1,0}, {2,0}, {2,1}};
    private int[][] leftL =  {{0,0}, {1,0}, {2,0}, {0,1}};
    private int[][] theS =   {{0,0}, {1,0}, {1,1}, {2,1}};
    private int[][] otherS = {{0,1}, {1,0}, {1,1}, {2,0}};
     
    
    private int[][] theShape, S;   
    private boolean isActive;
    private int movecounter, r, g, b;
    private float w; //width of each block in the piece
    private int choice, rotCount , theX , theY ,boundLX ,boundRX ;
    
    public Shape(){
      choice = (int)random(7);
      boundLX = 0 ;
      boundRX = 11 ;
      w = width/24;
      switch(choice){
         case 0: theShape = square;
                 r = 255;
                 break;
         case 1: theShape = line;
                 g = 255;
                 break;      
         case 2: theShape = leg3;
                 b = 255;
                 break;
         case 3: theShape = leftL;
                 r = 255;
                 g = 255;
                 break;               
         case 4: theShape = rightL;
                 g = 255;
                 b = 255;
                 break;
         case 5: theShape = theS;
                 r = 255;
                 b = 255;
                 break;
         case 6: theShape = otherS;
                 r = 255;
                 g = 255;
                 b = 255;
                 break;               
      }
      movecounter = 1;
      S = theShape;
      rotCount = 0;
    }
    
    public void display(){
      fill(r,g,b);
      for(int i = 0; i < 4; i++){
          rect(theShape[i][0]*w, theShape[i][1]*w, w, w);  
      }
    }
    
     public void showNextHalf(){
       fill(126);
       rect(width/2 , 0 ,width/2 , height);
       fill(220);
       textSize(60);
       text("CG project " , width/2+20 , 80) ;
       textSize(44);
       fill(0);
       text("NEXT : " , width/2+20 , 540) ;
       fill(0);
       text("SC0RE : " + bg.score , width/2+20, 650) ;
      fill(r,g,b);
      for(int i = 0; i < 4; i++){
          rect(theShape[i][0]*w + width/2 + 180, theShape[i][1]*w+490, w, w);  
      }
    }
  
    public void moveDown(){
       if(movecounter % (50-bg.score*5) == 0){
         move("DOWN");
       }
       movecounter++;
    }
  
    public boolean checkBoundry(String Boundry){
        
        switch(Boundry){ 
           case "LEFT":
             for(int i = 0; i < 4; i++){
                if(theShape[i][0]==boundLX ){
                  return false;
                }
             }
             boundLX = 0;
             break;
             
           case "RIGHT":
             for(int i = 0; i < 4; i++){
                if(theShape[i][0]== boundRX ){
                  return false;
                }
             }
             boundRX = 11;
             break;
             
           case "DOWN":
             for(int i = 0; i < 4; i++){
                if(theShape[i][1]==23){
                  isActive = false;
                  
                  return false;
                }
             }
             break;           
        }
        return true;
    }
  
    public void move(String dir){
       
      if(checkBoundry(dir)){
   
         switch(dir){
           case "LEFT":
             for(int i = 0; i < 4; i++){
                theShape[i][0]--;  
             } 
             break;
           case "RIGHT":
             for(int i = 0; i < 4; i++){
                theShape[i][0]++;  
             }
             break;
           case "DOWN":
             for(int i = 0; i < 4; i++){
                theShape[i][1]++;  
             }     
             break;
         }     
      }
  }
   
  public void rotate(){
    if(theShape != square){
       int[][] rotated = new int[4][2];
       if(rotCount % 4 == 0){
         for(int i = 0; i < 4; i++){
            rotated[i][0] = S[i][1] - theShape[1][0];
            rotated[i][1] = -S[i][0] - theShape[1][1];
         }
       } else if (rotCount % 4 == 1){
          for(int i = 0; i < 4; i++){
            rotated[i][0] = -S[i][0] - theShape[1][0];
            rotated[i][1] = -S[i][1] - theShape[1][1];
         }
       } else if (rotCount % 4 == 2){ 
         for(int i = 0; i < 4; i++){
            rotated[i][0] = -S[i][1] - theShape[1][0];
            rotated[i][1] = S[i][0] - theShape[1][1];
         }
       } else if (rotCount % 4 == 3){
          for(int i = 0; i < 4; i++){
            rotated[i][0] = S[i][0] - theShape[1][0];
            rotated[i][1] = S[i][1] - theShape[1][1];
         } 
       }
       theShape = rotated;
    }
  }
  
  public boolean checkBlack(Background b)
  {
    
   for(int i=0 ; i<4 ; i++)
   {
     theX = theShape[i][0];
     theY = theShape[i][1];
     if(theX >=0 && theX <12 && theY >=0 && theY <23)
     {
       for(int a =0 ; a<3 ; a++){
         if(b.bgColors[theX][theY+1][a] != 0)
         {
           return false ;
         }
         
         if(theX>0 && b.bgColors[theX-1][theY][a] != 0){
             boundLX = theX ;
         }
         
         if(theX<11 && b.bgColors[theX+1][theY][a] != 0){
             boundRX = theX ;
         }
       }
     }
   }
   return true ;
  }  
}
