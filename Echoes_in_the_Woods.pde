import processing.sound.*;
SoundFile jump1, jump2, jump3, jump4;
SoundFile playerHit1, playerHit2, playerHit3, playerHit4;
SoundFile ghost1, ghost2, ghost3;
SoundFile ghostHit1, ghostHit2, ghostHit3, ghostHit4;
SoundFile walk;
SoundFile death;
SoundFile collectCharge;
SoundFile chargeShot;
SoundFile portalOpen;
SoundFile backgroundMusic;

ArrayList<PVector> coordinates = new ArrayList<PVector>();
public ArrayList<Ghosts> g = new ArrayList<>();
Echo e;
Portals p;
Cooldown cool;
Charges c;
Hearts h;
Background b;

PFont font;
PImage title;
PImage end;
PImage plat;
PImage tutorial0, tutorial1, tutorial2, tutorial3;

final int platformLength = 500;
final int platformHeight = 125;
final int platformSpacing = 40;
int chargesUsed;
int ghostsHit;
int tutorialCounter;
float speedMultiplier = 1;
float speedIncrease = 0.001;
float startTime, time;

boolean startGame, endGame;
boolean startTutorial;
boolean walking;

char lastKey;


void setup() {
  size(1920, 1080);
  fullScreen(P2D);

  loadSounds();
  loadImages();

  e = new Echo();
  p = new Portals();
  cool = new Cooldown();
  c = new Charges();
  h = new Hearts();
  b = new Background();

  font = createFont("PIXEL-LI.TTF", 75);

  initialPlatforms();
  initialGhosts();
  
  //set player's starting position to be on the first platorm
  e.setX(coordinates.get(0).x + platformLength/2);
  e.setY(coordinates.get(0).y - e.getPlayerHeight());
}


void draw() {
  if (endGame)
    displayEndScreen();
  else if (startTutorial)
    displayTutorial();
  else if (!startGame)
    displayTitleScreen();
  else
    playGame();
}

void loadSounds() {
  jump1 = new SoundFile(this, "jump1.wav");
  jump2 = new SoundFile(this, "jump2.wav");
  jump3 = new SoundFile(this, "jump3.wav");
  jump4 = new SoundFile(this, "jump4.wav");
  playerHit1 = new SoundFile(this, "playerHit1.wav");
  playerHit2 = new SoundFile(this, "playerHit2.wav");
  playerHit3 = new SoundFile(this, "playerHit3.wav");
  playerHit4 = new SoundFile(this, "playerHit4.wav");
  ghost1 = new SoundFile(this, "ghost1.wav");
  ghost2 = new SoundFile(this, "ghost2.wav");
  ghost3 = new SoundFile(this, "ghost3.wav");
  ghostHit1 = new SoundFile(this, "ghostHit1.wav");
  ghostHit2 = new SoundFile(this, "ghostHit2.wav");
  ghostHit3 = new SoundFile(this, "ghostHit3.wav");
  ghostHit4 = new SoundFile(this, "ghostHit4.wav");
  walk = new SoundFile(this, "walk.wav");
  death = new SoundFile(this, "death.wav");
  collectCharge = new SoundFile(this, "collectCharge.wav");
  chargeShot = new SoundFile(this, "chargeShot.wav");
  portalOpen = new SoundFile(this, "portalOpen.wav");
  backgroundMusic = new SoundFile(this, "backgroundMusic.wav");
  
  //adjust the volume of all sounds
  jump1.amp(0.1);
  jump2.amp(0.1);
  jump3.amp(0.1);
  jump4.amp(0.1);
  playerHit1.amp(0.1);
  playerHit2.amp(0.1);
  playerHit3.amp(0.1);
  playerHit4.amp(0.1);
  ghost1.amp(0.005);
  ghost2.amp(0.005);
  ghost3.amp(0.005);
  ghostHit1.amp(0.3);
  ghostHit2.amp(0.3);
  ghostHit3.amp(0.3);
  ghostHit4.amp(0.3);
  walk.amp(0.0075);
  death.amp(0.05);
  collectCharge.amp(0.1);
  chargeShot.amp(0.3);
  portalOpen.amp(0.4);
  backgroundMusic.amp(0.05);
}


void loadImages() {
  title = loadImage("title.png");
  end = loadImage("end.png");
  plat = loadImage("platform.png");
  tutorial0 = loadImage("tutorial0.png");
  tutorial1 = loadImage("tutorial1.png");
  tutorial2 = loadImage("tutorial2.png");
  tutorial3 = loadImage("tutorial3.png");
}


void playBackgroundMusic() {
  //play background music and increase the playback speed over time
  if (!backgroundMusic.isPlaying()) {
    backgroundMusic.play();
    if (speedMultiplier > 20)
      backgroundMusic.rate(2);
    else if (speedMultiplier > 18)
      backgroundMusic.rate(1.9);
    else if (speedMultiplier > 16)
      backgroundMusic.rate(1.8);
    else if (speedMultiplier > 14)
      backgroundMusic.rate(1.7);
    else if (speedMultiplier > 12)
      backgroundMusic.rate(1.6);
    else if (speedMultiplier > 10)
      backgroundMusic.rate(1.5);
    else if (speedMultiplier > 8)
      backgroundMusic.rate(1.4);
    else if (speedMultiplier > 6)
      backgroundMusic.rate(1.3);
    else if (speedMultiplier > 4)
      backgroundMusic.rate(1.2);
    else if (speedMultiplier > 2)
      backgroundMusic.rate(1.1);
    else
      backgroundMusic.rate(1);
  }
}


void playBackgroundSounds() {
  float randomNumber = random(0, 100);
  float randomSound = random(0, 1);

  //play random ghost sounds
  if (randomNumber < 0.5) {
    if (randomSound > 0.6 && !ghost1.isPlaying())
      ghost1.play();
    else if (randomSound >= 0.2 && randomSound <= 0.6 && !ghost2.isPlaying())
      ghost2.play();
    else if (randomSound < 0.2 && !ghost3.isPlaying())
      ghost3.play();
  }
  //set walking to true if movement keys are pressed and if the player is not falling or jumping
  if ((e.getDPressed() || e.getAPressed()) && !e.getFalling() && !e.getJumping())
    walking = true;
  else
    walking = false;
  
  //play walking sound
  if (walking && !walk.isPlaying())
    walk.play();
  else if (!walking && walk.isPlaying())
    walk.stop();
}


void displayTitleScreen() {
  image(title, 0, 0);
  hoverButton(732, 1198, 570, 701, 2, 38, 3);
  hoverButton(732, 1198, 769, 900, 2, 38, 3);
}


void displayEndScreen() {
  image(end, 0, 0);
  backgroundMusic.stop();
  hoverButton(1409, 1878, 935, 1043, 52, 31, 95);
  displayStats();
}


void displayTutorial() {
  //display the current tutorial screen based on the tutorial counter
  switch (tutorialCounter) {
  case 3:
    image(tutorial3, 0, 0);
    break;
  case 2:
    image(tutorial2, 0, 0);
    break;
  case 1:
    image(tutorial1, 0, 0);
    break;
  default:
    image(tutorial0, 0, 0);
    break;
  }
  hoverButton(712, 1209, 869, 999, 2, 38, 3);
}


void hoverButton(int x1, int x2, int y1, int y2, int r, int g, int b) {
  //highlight button if mouse hovers over it
  if (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y2) {
    fill(r, g, b, 100);
    noStroke();
    rect(x1, y1, x2 - x1, y2 - y1);
  }
}


void playGame() {
  if (e.getY() > height + 200 || e.getX() < -350 || h.getHearts() < 1) { //check if the player goes out of bounds
    endGame = true;
    startGame = false;
    death.play();
  }
  
  time = (millis() - startTime) / 1000; //calculate elapsed time in seconds

  playBackgroundMusic();
  playBackgroundSounds();

  speedMultiplier += speedIncrease; //gradually increase the speed of the game

  b.displayBackground();
  cool.cooldownTimer();
  p.portalTimer();
  p.portals();
  e.echo();
  updatePlatforms();
  platformCollision();
  generatePlatforms();
  c.collectCharges(e.getX(), e.getY(), e.getPlayerWidth(), e.getPlayerHeight());
  c.hitGhost(g);
  e.ghostCollision();

  for (Ghosts ghost : g)
    ghost.ghosts();

  generateGhosts();
  cool.cooldownBar();
  h.displayHearts();
  c.displayChargeIndicator();
}


void displayStats() {
  //display elapsed time, ghosts hit, and charges used
  textFont(font);
  fill(81, 56, 130);
  text(time, 1005, 535);
  text(ghostsHit, 1000, 730);
  text(chargesUsed, 1100, 920);
}


void initialPlatforms() {
  for (int i = 0; i < 5; i ++) {
    //randomly generate positions for the first 5 platforms
    float x = i*(platformLength + platformSpacing) + random(platformSpacing, platformSpacing*2);
    float y = random(platformHeight, height - platformHeight);
    coordinates.add(new PVector(x, y)); //add platform coordinates to the list
  }
}


void generatePlatforms() {
  //check if new platforms should be generated based on current platform positions
  if (coordinates.size() < 5 || coordinates.get(coordinates.size() - 1).x < width - platformLength) {
    //randomly generate coordinates
    float newX = coordinates.get(coordinates.size() - 1).x + platformLength + random(platformSpacing, platformSpacing * 2);
    float newY = random(platformHeight, height - platformHeight);
    PVector newPlatform = new PVector(newX, newY); //create a new platform
    coordinates.add(newPlatform); //add the new platform to the list
    c.generatePlatformCharges(coordinates, platformLength); //generate charges for the new platform
  }
}


void updatePlatforms() {
  for (PVector platform : coordinates) {
    image(plat, platform.x, platform.y); //display each platform
    platform.x -= 1*speedMultiplier; //move the platforms to the left
  }
  c.displayCharges();
  coordinates.removeIf(platform -> platform.x + platformLength < 0); //remove off-screen platforms
}


void platformCollision() {
  boolean onPlatform = false;
  for (PVector platform : coordinates) {
    //check if player is standing on a platform
    if (e.getX() + (e.getPlayerWidth()*2)/3 > platform.x && e.getX() + e.getPlayerWidth()/4 < platform.x + platformLength
      && e.getY() + e.getPlayerHeight() <= platform.y
      && e.getY() + e.getPlayerHeight() + e.getVelocity() >= platform.y) {
      e.setFalling(false);
      e.setJumping(false);
      e.setVelocity(0);
      e.setY(platform.y - e.playerHeight); //set player y-position to be on the platform
      onPlatform = true;
      break;
    }
  }
  if (!onPlatform)
    e.setFalling(true); //player is falling if not on any platform
}


void initialGhosts() {
  for (int i = 0; i < 5; i ++) {
    //randomly generate positions for the first 5 ghosts
    float x= width + random(105, 1050);
    float y = random(175, height - 175);
    g.add(new Ghosts(x, y)); //add the new ghost to the list
  }
}


void generateGhosts() {
  //if there are fewer than 5 ghosts or the last ghost is too far left, generate new ones
  if (g.size() < 5 || (g.get(g.size() - 1).getX() < width - 200)) {
    //randomly generate the new ghost's starting position off-screen
    float newX = width + random(105, 255);
    float newY = random(175, height - 175);
    g.add(new Ghosts(newX, newY)); //add the new ghost to the list
  }
  g.removeIf(ghost -> ghost.getX() < -105); //remove off-screen ghosts
}


void keyPressed() {
  if (startGame) {
    //handle movement and jumping
    if (key == 'd' || keyCode == RIGHT) {
      e.setDPressed(true);
      lastKey = 'd';
    }
    if (key == 'a' || keyCode == LEFT) {
      e.setAPressed(true);
      lastKey = 'a';
    }

    if ((key == ' ' || key == 'w' || keyCode == UP) && !e.falling && !e.jumping) {
      e.setJumping(true);
      
      //play a random jump noise
      float randomJump = random(0, 1);
      if (randomJump <= 0.25)
        jump1.play();
      else if (randomJump <= 0.5)
        jump2.play();
      else if (randomJump <= 0.75)
        jump3.play();
      else
        jump4.play();
    }
  }
}


void keyReleased() {
  if (key == 'd' || keyCode == RIGHT)
    e.setDPressed(false);
  else if (key == 'a' || keyCode == LEFT)
    e.setAPressed(false);
}


void mousePressed() {
  if (startGame) {
    if (mouseButton == LEFT) {
      c.shootCharges(mouseX, mouseY, e.x, e.y, e.playerWidth); //shoot a charge towards the mouse position
    } else if (mouseButton == RIGHT) {
      p.setStart(millis()); //record current time for portal timer
      if (!cool.beginTimer) { //check if the cooldown timer is not running
        p.setUsePortals(true); //enable portals
        portalOpen.play(); //play portal sound
      }
      //set the position for the second portal to the mouse position
      p.setX(mouseX);
      p.setY(mouseY);
    }
  } else if (startTutorial) {
    if (mouseButton == LEFT) {
      //handle tutorial buttons
      if (mouseX > 712 && mouseX < 1209 && mouseY > 869 && mouseY < 999)
        startTutorial = false;
      else if (mouseX > 1770 && mouseX < 1860 && mouseY > 366 && mouseY < 514 && tutorialCounter < 3)
        tutorialCounter += 1;
      else if (mouseX > 60 && mouseX < 150 && mouseY > 366 && mouseY < 514 && tutorialCounter > 0)
        tutorialCounter -= 1;
    }
  } else if (endGame) {
    //reset the game if the play again button is pressed
    if (mouseButton == LEFT && mouseX > 1409 && mouseX < 1978 && mouseY > 935 && mouseY < 1043) {
      endGame = false;
      startGame = true;
      
      speedMultiplier = 1;
      
      startTime = millis();
      time = 0;
      
      chargesUsed = 0;
      ghostsHit = 0;
      
      cool.setCurrent(millis());
      cool.setStart(0);
      
      c.setCurrentCharges(5);
      h.setHearts(3);
      
      c.platformCharges.clear();
      
      coordinates.clear();
      initialPlatforms();
      
      g.clear();
      initialGhosts();
      
      e.setX(coordinates.get(0).x + platformLength/2);
      e.setY(coordinates.get(0).y - e.getPlayerHeight()*1.5);
    }
  } else {
    if (mouseButton == LEFT) {
      //handle title screen buttons
      if (mouseX > 732 && mouseX < 1198 && mouseY > 570 && mouseY < 701 && mouseButton == LEFT)
        startGame = true;

      else if (mouseX > 732 && mouseX < 1198 && mouseY > 769 && mouseY < 900)
        startTutorial = true;
    }
  }
}
