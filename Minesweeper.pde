public final static int ROWS = 20;
public final static int COLLUMNS = 20;
public final static int BUTTON_SIZE = 30;
public final static int MAX_BOMBS = 75;

public Button[][] field = new Button[ROWS][COLLUMNS];
public int gameState = 0;
public boolean gameOver = false;

/*
0 - game start
1 - game play
2 - game lose
3 - game win
*/

public void setup() {
  size(650, 650);
  textAlign(CENTER,CENTER);
  resetField();
}

public void resetField() {
  int posX = 20;
  int posY = 20;

  /* Initialize field of buttons */
  for(int y = 0; y < field.length; y++) {
    for(int x = 0; x < field[y].length; x++) {
      field[y][x] = new Button(posX, posY, BUTTON_SIZE);
      posX += BUTTON_SIZE;
    }
    posY += BUTTON_SIZE;
    posX = 20;
  }

  int numBombs = 0;
  /* Randomly assign bombs */
  while(numBombs < MAX_BOMBS) {
    int randY = (int)(Math.random()*ROWS);
    int randX = (int)(Math.random()*COLLUMNS);

    if(!field[randY][randX].getType().equals("bomb")) {
      field[randY][randX].setType("bomb");
      numBombs++;
    }

  }

  /* Assign number to each non-bomb cell */
  for(int y = 0; y < field.length; y++) {
    for(int x = 0; x < field[y].length; x++) {
      if(field[y][x].getType().equals("safe")) {
        int c = 0;

        try {
          if (field[y-1][x-1].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        try {
          if (field[y-1][x].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        try {
          if (field[y-1][x+1].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        try {
          if (field[y][x-1].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        try {
          if (field[y][x+1].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        try {
          if (field[y+1][x-1].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        try {
          if (field[y+1][x].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        try {
          if (field[y+1][x+1].getType().equals("bomb")) c++;
        } catch(ArrayIndexOutOfBoundsException e) {}

        field[y][x].setSurroundingBombs(c);
      }
    }
  }
}

public void draw() {
  switch (gameState) {

    case 0:
      textSize(20);
      background(0);
      fill(255);
      text("Press ENTER to start", 400, 400);
      break;

    case 1:
      textSize(20);
      background(0);
      for(int y = 0; y < field.length; y++) {
        for(int x = 0; x < field[y].length; x++) {
          field[y][x].render();
        }
      }
      if(gameOver) gameState = 2;
      if(fieldCleared()) gameState = 3;
      break;

    case 2:
      fill(150,150,150);
      textSize(36);
      text("You died", 300,200);
      text("ENTER to try again", 300, 500);
      break;

    case 3:
      fill(150,150,150);
      textSize(36);
      text("You WIN!", 300,200);
      text("ENTER to play again", 300, 500);
      break;
  }
}

public boolean fieldCleared() {
  for(int y = 0; y < field.length; y++) {
    for(int x = 0; x < field[y].length; x++) {
      if(field[y][x].getType().equals("safe") && !field[y][x].isClicked()) return false;
    }
  }
  return true;
}

public void mousePressed() {
  if(gameState == 1)
  for(int y = 0; y < field.length; y++) {
    for(int x = 0; x < field[y].length; x++) {
      if(field[y][x].inRange(mouseX, mouseY)) {
        if(mouseButton == LEFT) {
          field[y][x].leftClick();
          if(field[y][x].getSurroundingBombs() == 0) checkSurroundings(y, x);
        }
        if(mouseButton == RIGHT) field[y][x].rightClick();
      }
    }
  }
}

public void keyPressed() {
  if(keyCode == ENTER || keyCode == RETURN) {
    if(gameState == 0) gameState = 1;
    if(gameState == 2 || gameState == 3) {
      gameOver = false;
      field = new Button[ROWS][COLLUMNS];
      resetField();
      gameState = 1;
    }
  }
}

public void checkSurroundings(int y, int x) {

  if(field[y][x].getSurroundingBombs() == 0 && field[y][x].getType().equals("safe")) {

    if(y-1 >= 0 && !field[y-1][x].isClicked() && field[y-1][x].getType().equals("safe")) {
      field[y-1][x].leftClick();
      checkSurroundings(y-1, x);
    }

    if(y+1 < ROWS && !field[y+1][x].isClicked() && field[y+1][x].getType().equals("safe")) {
      field[y+1][x].leftClick();
      checkSurroundings(y+1, x);
    }

    if(x+1 < COLLUMNS && !field[y][x+1].isClicked() && field[y][x+1].getType().equals("safe")) {
      field[y][x+1].leftClick();
      checkSurroundings(y, x+1);
    }

    if(x-1 >= 0 && !field[y][x-1].isClicked() && field[y][x-1].getType().equals("safe")) {
      field[y][x-1].leftClick();
      checkSurroundings(y, x-1);
    }

    if(x-1 >= 0 && y-1 >= 0 && !field[y-1][x-1].isClicked() && field[y-1][x-1].getType().equals("safe")) {
      field[y-1][x-1].leftClick();
      checkSurroundings(y-1, x-1);
    }

    if(x+1 < COLLUMNS && y-1 >= 0 && !field[y-1][x+1].isClicked() && field[y-1][x+1].getType().equals("safe")) {
      field[y-1][x+1].leftClick();
      checkSurroundings(y-1, x+1);
    }

    if(x+1 < COLLUMNS && y+1 < ROWS && !field[y+1][x+1].isClicked() && field[y+1][x+1].getType().equals("safe")) {
      field[y+1][x+1].leftClick();
      checkSurroundings(y+1, x+1);
    }

    if(x-1 >= 0 && y+1 < ROWS && !field[y+1][x-1].isClicked() && field[y+1][x-1].getType().equals("safe")) {
      field[y+1][x-1].leftClick();
      checkSurroundings(y+1, x-1);
    }

  }
}

public class Button {

  private int x, y, size, roundness, cellColor, textColor, surroundingBombs;
  private String type, display;
  private boolean clicked;

  public Button(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    cellColor = 200;
    textColor = color(255,255,255);
    type = "safe";
    display = "";
    surroundingBombs = 0;
    clicked = false;
    roundness = 3;
  }

  public void render() {
    fill(cellColor);
    stroke(0);
    rect(x, y, size, size, roundness);
    fill(textColor);
    text(display, x+size/2, y+size/2);
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getType() {
    return type;
  }

  public void leftClick() {
    cellColor = 100;
    clicked = true;
    if(type.equals("bomb")) {
      textColor = color(255,0,0);
      cellColor = color(0,0,0);
      display = "B";
      gameOver = true;
    }
    else if (surroundingBombs == 0) {
      display = "";
    } else {
      switch (surroundingBombs) {
        case 1:
          textColor = color(0,0,255);
          break;
        case 2:
          textColor = color(0,255,0);
          break;
        case 3:
          textColor = color(255,255,0);
          break;
        case 4:
          textColor = color(0,255,255);
          break;
        case 5:
          textColor = color(255,0,255);
          break;
        case 6:
          textColor = color(139,69,19);
          break;
        case 7:
          textColor = color(255,20,147);
          break;
        case 8:
          textColor = color(244,164,96);
          break;
      }
      display = "" + surroundingBombs;
    }
  }

  public void rightClick() {
    if(!clicked) {
      if(display.equals("F")) {
        cellColor = 200;
        display = "";
      } else {
        cellColor = color(255, 0, 0);
        display = "F";
      }
    }
  }

  public void setSurroundingBombs(int c) {
    surroundingBombs = c;
  }

  public int getSurroundingBombs() {
    return surroundingBombs;
  }

  public boolean isClicked() {
    return clicked;
  }

  public boolean inRange(int mX, int mY) {
    return (mX >= x && mX <= x + size && mY >= y && mY <= y+size);
  }

}