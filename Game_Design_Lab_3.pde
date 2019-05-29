/*
  Challenge - The challenging part of this game is to see just how 
              long you can dodge the bullets. More bullets spawn 
              and the field becomes smaller as time passes. People can challenge others
              to see who can get the higher score.
              
  Submission - The game is mindless fun. Because the game has simple
               controls/aspects, just about anybody can drop in and play 
               the game at anytime. Some people may just enjoy the pleasure of
               moving the cursor around to dodge everything.
*/
Bullet [] bullet = new Bullet[40];
Cursor cursor;
Field field;
Status status;

float timer;
float spawnTimer = 0;
int last = 0;
int x = 1;
int beforeStartTime = 0;
boolean startedGame = false;
int numberOfBullets = 40;

void setup()
{
  size(800,800);
  for(int x=0; x<bullet.length; x++)
    bullet[x] = new Bullet();
  cursor = new Cursor();
  field = new Field();
  status = new Status();
  textSize(13.5);
  frameRate(60);
}

void draw()
{
  background(122);
  field.displayField();
  if(startedGame == false)
    displayStart();
  if(startedGame == true)
    {
      noCursor();
      status.displayStatus();
      
      //Used to get the time the for when the game actually starts up
      if(x == 1)
      {
        beforeStartTime = millis()/1000;
        x =2;
      }
    cursor.cursorLocation(field);
    
    //Spawn the bullets and move them around. Also checks for hitbox
    for(int x = 0; x<numberOfBullets; x++)
    {
      bullet[x].spawn();
      bullet[x].gotHit();
      status.decreaseHealth(bullet[x]);
    }
    
    field.decreaseField();
      
    //Create new Bullet Objects after 4 seconds pass
    if(millis() > last+4000)
      {
        for(int x=0; x<bullet.length; x++)
          bullet[x] = new Bullet();
        last = millis();
      } 
    }
    
    //Game Over screen
    if (status.health <=0)
    {
      textSize(35);
      fill(255,0,0);
      
      //Show the score the player got
      text("    You lost with the score of: ", width/13, height-70);
      text(status.score, width-220, height-70);
      if(status.score >4000)
      {
        text("You're amazing at this", width/4, height - 30);
      }
      else if(status.score>2000)
      {
        text("You're pretty good at this", width/4, height - 30);
      }
      else
      {
        text("Better luck next time", width/4, height -30);
      }
      
      textSize(13.5);
    }
}

//Displays the start of the game. When the mouse hovers over the red circle, game starts.
void displayStart()
  {
    fill(255,0,0);
    ellipse(width/2, height/2, 50,50);
    fill(255);
  
    if(mouseX > width/2-35 && mouseX < width/2+35 &&
       mouseY > height/2-35 && mouseY < height/2+35)
       {
         startedGame = true;
       }
  }

class Bullet
{
  //Speed of the bullets
  float dx =5, dy =5;
  //spawnPoint Determines which of the 4 sides the bullet will come from
  int spawnPoint = int(random(4)), bulletWidth = 20, bulletHeight = 20;
  
  //randomizeX Determines the X value depending on the spawnPoint
  float randomizeLeftX = random(-30, 0 - bulletWidth/2);
  float randomizeTopX = random(-30 - bulletWidth/2, width+bulletWidth/2);
  float randomizeRightX = random( width + bulletWidth/2,width + 30);
  float randomizeBottomX = random(-30 - bulletWidth/2, width+bulletWidth/2);
  
  //randomizeY Determines the Y value depending on the spawnPoint
  float randomizeLeftY = random(-30 - bulletHeight/2, height + bulletHeight/2);
  float randomizeTopY = random(-30, bulletHeight/2);
  float randomizeRightY = random(-30 - bulletHeight/2, height + bulletHeight/2);
  float randomizeBottomY = random(height, height+bulletHeight/2);
  
  int direction = int(random(0,4));
  
  //If spawnPoint = 0, spawn somewhere from left
  //If spawnPoint = 1, spawn somewhere from top
  //If spawnPoint = 2, spawn somewhere from right
  //If spawnPoint = 3, spawn somewhere from bottom
  
  //If direction = 0, move left
  //If direction = 1, move up
  //If direction = 2, move right
  //If direction = 3, move down
  
  void spawn()
  {
    //accelrates of bullet the longer they're on the screen
    dx += .005;
    dy += .005;
    
    fill(122,122,122);
    
    switch (spawnPoint)
    {
      //Spawn from Left. Will constantly go right. Will either move up or down.
      case 0:
        ellipse(randomizeLeftX, randomizeLeftY, bulletWidth, bulletHeight);
        randomizeLeftX += dx;
        
        switch(direction)
        {
          case 1:
            randomizeLeftY -= dy;
            break;
          case 3:
            randomizeLeftY += dy;
            break;
        }
        break;
        
      //Spawn from top. Will constantly go down. Will either move left or right.
      case 1:
        ellipse(randomizeTopX, randomizeTopY, bulletWidth, bulletHeight);
        switch(direction)
        {
          case 0:
            randomizeTopX -= dx;
            break;
          case 2:
            randomizeTopX += dx;
            break;
        }
        randomizeTopY += dy;
        break;
        
      //Spawn from right. Will constantly go left. Will either move up or down.
      case 2:
        ellipse(randomizeRightX, randomizeRightY, bulletWidth, bulletHeight);
        randomizeRightX -= dx;
        
        switch(direction)
        {
          case 1:
            randomizeRightY -= dy;
            break;
          case 3:
            randomizeRightY += dy;
            break;
        }
        
        break;
        
      //Spawn from bottom. Will constantly go up. Will either move left or right.
      case 3:
        ellipse(randomizeBottomX, randomizeBottomY, bulletWidth, bulletHeight);
        randomizeBottomY -= dy;
        
        switch(direction)
        {
          case 0:
            randomizeBottomX += dx;
            break;
          case 2:
            randomizeBottomX -= dx;
            break;
        }       
        break;
    }
  }
  
  //Hitbox for bullets.
  boolean gotHit()
  {
    if(dist(randomizeLeftX, randomizeLeftY, mouseX, mouseY) < bulletWidth/2)
    {
      return true;
    }
    
    if(dist(randomizeTopX, randomizeTopY, mouseX, mouseY) < bulletWidth/2)
    {
      return true;
    }
    
    if(dist(randomizeRightX, randomizeRightY, mouseX, mouseY) < bulletWidth/2)
    {
      return true;
    }
    
    if(dist(randomizeBottomX, randomizeBottomY, mouseX, mouseY) < bulletWidth/2)
    {
      return true;
    }
    return false;
  }
  
}

class Cursor
{
  float cursorWidth = 30;
  float cursorHeight = 30;
  
  void cursorLocation(Field field)
  {
    stroke(255);
    fill(255);
    //Check Cursor placement for the top left hand side
    if(mouseX<field.fieldX1+cursorWidth/2 && mouseY < field.fieldY1 + cursorHeight/2)
    {
      ellipse(field.fieldX1+cursorWidth/2, field.fieldY1+cursorHeight/2, cursorWidth, cursorHeight);
    }
    
    //Check Cursor placement for the top right hand side
    else if(mouseX>field.fieldX2-cursorWidth/2 && mouseY<field.fieldY1+cursorHeight/2)
    {
      ellipse(field.fieldX2-cursorWidth/2,field.fieldY1+cursorHeight/2,cursorWidth,cursorHeight);
    }

    //Check Cursor placement for the bottom right hand side
    else if(mouseX > field.fieldX2-cursorWidth/2 && mouseY > field.fieldY2 - cursorHeight/2)
    {
      ellipse(field.fieldX2-cursorWidth/2,field.fieldY2-cursorHeight/2,cursorWidth,cursorHeight);
    }
    
    //Check Cursor placement for the bottom left hand side
    else if(mouseX < field.fieldX1 + cursorWidth/2 && mouseY > field.fieldY2-cursorHeight/2)
    {
      ellipse(field.fieldX1+cursorWidth/2, field.fieldY2-cursorHeight/2, cursorWidth, cursorHeight);
    }
    //Check Cursor placement for left hand side
    else if(mouseX<field.fieldX1+cursorWidth/2)
    {
      ellipse(field.fieldX1 + cursorWidth/2,mouseY,cursorWidth,cursorHeight);
    }
    
    //Check Cursor placement for top
    else if(mouseY < field.fieldY1+cursorHeight/2)
    {
      ellipse(mouseX, field.fieldY1 + cursorHeight/2, cursorWidth, cursorHeight);
    }
    
    //Check Cursor placement for right hand side
    else if (mouseX>field.fieldX2 - cursorWidth/2)
    {
      ellipse(field.fieldX2 - cursorWidth/2,mouseY,cursorWidth,cursorHeight);
    }
    
    //Check Cursor placement for bottom side
    else if (mouseY > field.fieldY2 -cursorHeight/2)
    {
      ellipse(mouseX, field.fieldY2 - cursorHeight/2, cursorWidth, cursorHeight);
    }
    
    //If the Cursor is within the field, move the ellipse
    else
      ellipse(mouseX, mouseY, cursorWidth, cursorHeight);
  }
  
}

class Field
{
  //fieldWidth is the width of the field
  int fieldWidth = 600;
  
  //fieldHeight is the height of the field
  int fieldHeight = 600;
  
  //fieldX1 is the X axix of the left side field
  float fieldX1 = 100;
  
  //fieldY1 is the Y axix of the top side field
  float fieldY1 = 100;
  
  //fieldX2 is the X axises of the right side field
  float fieldX2 = fieldX1 + fieldWidth;
  
  //fieldY2 is the Y axis of the bottom side field
  float fieldY2 = fieldY1 + fieldHeight;
  
  //Display a field, the field determines where the player can move
  void displayField()
  {
    fill(0);
    rect(fieldX1, fieldY1, fieldWidth, fieldHeight);
  }
  
  //Decrease the field each time when 3.6 seconds pass
  void decreaseField()
  {
    if(millis() > last+3600)
    {
      if(fieldWidth >200)
      {
      fieldX1 += .5;
      fieldY1 += .5;
      fieldWidth -=.5;
      fieldHeight -= .5;
      fieldX2 -=.5;
      fieldY2 -=.5;
      }
    }
  }
}

class Status
{
  int health = 10;
  int score = 0;
  int temp, seconds = 00, minutes = 00, hours = 00;
  boolean immune = false;
  
  //Show the health, score, and time.
  void displayStatus()
  {
    rect(10,10, 120, 70);
    fill(255);
    text("Health:", width/37 , height/33);
    text(" Score:", width/35, height/17);
    text(score, width/10, height/17);
    text(" Time:", width/34.0, height/11);
    if(startedGame == true)
    {
      //Convert milliseconds to seconds, and seconds to minutes
      //Time is equal to start of the program timer - start of the game timer
      temp = 0;
      temp += millis();
      seconds = temp/1000 - beforeStartTime;
      minutes = seconds/60;
    }
    
    //Show the time
    text((int)minutes, width/10, height/11);
    text(" .", width/9, height/11);
    text((int)seconds%60, width/8, height/11);
    fill(0);
    
    //The amount of health that is left changes the color of the health counter
    
    if(health > 7)
    {
      fill(0,255,0,122);
      text(health, width/10, height/33);
      fill(255);
    }
    
    else if(health > 4)
    {
      fill(255,255,0);
      text(health, width/10, height/33);
      fill(255);
    }
    
    else
    {
      fill(255,0,0);
      text(health, width/10, height/33);
      fill(255);
    }
    
    //Increase the score as long as the player has health
    if(health >=1)
      score ++;
      fill(0);
  }
  
  //Decrease health if a bullet touches
  void decreaseHealth(Bullet bullet)
  {
      if(bullet.gotHit())
      {
        if(health>=1)
          health--;
      }
  }
}
