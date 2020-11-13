
//GLOBAL VARS


  //width and height of canvas
  int WIDTH = 1920;//3840; //1920
  int HEIGHT = 1080;//2160; //1080
  //tracker for how many frames have elapsed
  int frames = 0;
  
  Game gameLogic; //where all the game data is stored
  
  BoardPlace hoveredSpace;
  
  Piece selectedPiece;

  int boardSz = 800; //size of board width/height
  
  int spaceSz = boardSz / 8 ;
  
  int[][][] spacePos = new int[8][8][2];
  
  boolean playerChanged = true;
  
  color whiteColor = color(255, 247, 227);
  color blackColor = color(46, 39, 24);
void setup() {
  //set canvas size
  size(1920,1080); //h: 2160
  
  //create instance of the simplex noise class
  //background(255); // reset screen
  noStroke();
  //noLoop(); //uncomment to only render one frame

  //draw();
  gameLogic = new Game();
  gameLogic.gameStart();
}

//loop function that runs on a loop 
void draw() {
  //println(mouseX + ", " + mouseY);
  frames++;
  //println(frames);
  //println(hoveredSpace);
  //clear(); // reset screen
  background(100); // reset screen

  translate(width/2, height/2);
  
  boolean isWhitesTurn = gameLogic.whitesTurn;

  drawBoard(!isWhitesTurn);
  
}

public void drawBoard( boolean isBlack) {

    
    boolean startsBlack = isBlack;

    fill(whiteColor);
    strokeWeight(1);
    stroke(255);
    rect(-boardSz/2, -boardSz/2, boardSz, boardSz);
    textSize(boardSz/16);
    fill(blackColor);

    pushMatrix();
    
    translate(-boardSz/2 -spaceSz , -boardSz/2);
    
    int curX = width/2 - boardSz/2 - spaceSz;
    int curY = height/2 - boardSz/2;
    
    for (int i = 0; i < 9;++i) {
      pushMatrix();
      for (int j = 0; j < 9; ++j) {
        if(j == 0 && i != 8) {
          fill(0);
          String numStr = startsBlack ? i+1+"" : 8-i+"";
          text( numStr , boardSz/18, boardSz/12); 
          
        } else if ( i >= 0 && i < 8 ) {
          
          if (isBlack) { 
            fill(blackColor);
            rect(0,0, spaceSz, spaceSz);
          }
            
          BoardPlace renderingSpace;
          
          if (startsBlack) 
            renderingSpace = gameLogic.gameBoard.gameSpace2D[i][j-1];
          else
            renderingSpace = gameLogic.gameBoard.gameSpace2D[7-i][j-1];
          
          
          if (!renderingSpace.isEmpty()) {
            
              renderPiece(renderingSpace.holding);
              fill(blackColor);
          } 
          
          if (
              selectedPiece != null 
              && renderingSpace.holding == selectedPiece
          ) {
            renderHighlight( 0, 0, (float) spaceSz,  (float) spaceSz);
          }
            
          isBlack = !isBlack;       
        } else if ( j != 0 ) {
          fill(0);
          String letterStr = mapNumToChessLetter(j);
          text( letterStr, boardSz/20, boardSz/12 );
        }
       
        if ( playerChanged && i >= 0 && i < 8 && j >= 1 && j < 9 ) {
           //println(curX + ", " + curY);
           spacePos[i][j-1][0] = curX;
           spacePos[i][j-1][1] = curY;
           
        }
        
        translate(spaceSz, 0);
        curX += spaceSz;
       
        
      }
      popMatrix();
      curX -= spaceSz * 9;
      translate(0, spaceSz);
      curY += spaceSz;
      isBlack = !isBlack;
    }
    popMatrix();
    
    if (!playerChanged) {
    
      highlightSpace();
      
    }
    
    playerChanged = false;
    
    
}

public void renderPiece (Piece renderingPiece) {
    
    if (renderingPiece.isWhite) 
      fill (200, 0, 200);
    else 
      fill (0, 200, 200);
    text(renderingPiece.toString(), boardSz/75, boardSz/12);
}


public void highlightSpace() {
  
    for ( int i = 0; i < 8; ++i ) {
    
        for ( int j = 0; j < 8; ++j ) {
          
            int x = spacePos[i][j][0];
            int y = spacePos[i][j][1];
            BoardPlace space;
            
            if (!gameLogic.whitesTurn) 
            space = gameLogic.gameBoard.gameSpace2D[i][j];
            else
            space = gameLogic.gameBoard.gameSpace2D[7-i][j];
            
            if (mouseX > x && mouseX < x+spaceSz && mouseY > y && mouseY < y+spaceSz) {
              
              hoveredSpace = space;
              
              renderHighlight(
                x-boardSz-spaceSz*1.6, 
                y-boardSz+spaceSz*2.6, 
                (float) spaceSz, (float) spaceSz
              );
              
              return; 
            } 
        }
    }
}

public void mousePressed() { 
  
    if ( 
      hoveredSpace == null 
      || hoveredSpace.holding == null 
      || ( mouseX > width/2 + boardSz/2 && mouseX < width/2 - boardSz/2 )
      || ( mouseY > height/2 + boardSz/2 && mouseY < height/2 - boardSz/2 )
    ) return;
    
    Piece hoverP = hoveredSpace.holding;
    
    boolean isPlayersPiece = ( hoverP.isWhite && gameLogic.whitesTurn ) || ( !hoverP.isWhite && !gameLogic.whitesTurn );
    
    if (isPlayersPiece) {
      println(hoveredSpace.holding.toString() + ": " + hoveredSpace.holding.position.notation);
      selectedPiece = hoveredSpace.holding;
    } else {
      println("That's not yours");
    }  
};

public void renderHighlight (float transX, float transY, float rectWidth, float rectHeight) {
    
    color highlightColor = gameLogic.whitesTurn ? color(186, 125, 180) : color(125, 182, 186); //light-tan: 255, 237, 194
    
    noFill();
    stroke(highlightColor); 
    strokeWeight(10);
    
    rect(
      transX, 
      transY, 
      rectWidth, 
      rectHeight
    );
    noStroke();
}


public String mapNumToChessLetter ( int number ) {
    //number;
    switch (number) {
       case 1: 
         return "A";
       case 2: 
         return "B";
       case 3: 
         return "C";
       case 4: 
         return "D";
       case 5: 
         return "E";
       case 6: 
         return "F";
       case 7: 
         return "G";
       case 8: 
         return "H";
       default:
         return "Z";
    }
} 
