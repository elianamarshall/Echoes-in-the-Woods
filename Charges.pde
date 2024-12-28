class Charges {
  private final PImage chargeImage;
  private final PImage dispersedImage;
  private final PImage ghostHit;

  private final int size = 30;
  private final int maxCharges = 10;
  private int currentCharges = 5;
  private float disperseTimer;
  private float x, y;

  private boolean disperse;

  private PVector[] velocity = new PVector[maxCharges];
  private PVector[] location = new PVector[maxCharges];
  private boolean[] shoot = new boolean[maxCharges];

  private ArrayList<ChargeOnPlatform> platformCharges = new ArrayList<>();


  Charges() {
    chargeImage = loadImage("charge.png");
    dispersedImage = loadImage("dispersedCharge.png");
    ghostHit = loadImage("ghostHit.png");
    
    createCharges();
  }


  public void displayChargeIndicator() {
    int diameter = 30; //diameter of each circle
    int spacing = 7; //spacing between each circle
    int totalWidth = currentCharges * (diameter + spacing) - spacing; //total width of all circles
    float startX = width / 2.0f - totalWidth / 2.0f; //start horizontally centered
    
    //draw the indicator circles
    for (int i = 0; i < currentCharges; i++) {
      float x = startX + i * (diameter + spacing);
      stroke(44, 98, 28);
      strokeWeight(4);
      fill(133, 243, 83);
      circle(x, height - 50, diameter);
    }
  }


  private void createCharges() {
    for (int i = 0; i < location.length; i++) {
      velocity[i] = new PVector();
      location[i] = new PVector(-1000, -1000); //initialize inactive charge off-screen
      shoot[i] = false; //mark the charge as not shot
    }
  }


  public void displayCharges() {
    //timer for charge dispersion
    if (disperse && millis() - disperseTimer > 500)
      disperse = false;
    
    //displayer the dispersed charge and hit ghost for the duration of the timer
    if (disperse) {
      image(ghostHit, x, y);
      image(dispersedImage, x, y);
    }

    for (int i = 0; i < location.length; i++) {
      //update the position of the charge if it is shot
      if (shoot[i]) {
        location[i].add(velocity[i]);
        image(chargeImage, location[i].x, location[i].y, size, size);
      }
    }
    //display charges on platforms
    for (ChargeOnPlatform charge : platformCharges) {
      charge.position.x = charge.platform.x + charge.offsetX; //move the charge with the platform
      charge.position.y = charge.platform.y - size;
      image(chargeImage, charge.position.x, charge.position.y, size, size);
    }
  }


  public void generatePlatformCharges(ArrayList<PVector> platforms, int platformLength) {
    for (PVector platform : platforms) {
      if (platform.x > width && random(1) < 0.7) { //randomly generate charges for platforms off-screen
        float offsetX = random(0, platformLength - size); //random position on the platform
        platformCharges.add(new ChargeOnPlatform(new PVector(), platform, offsetX)); //add the new charge to the list
      }
    }
  }


  public void collectCharges(float playerX, float playerY, float playerWidth, float playerHeight) {
    //remove charges collected by the player
    platformCharges.removeIf(charge -> {
      float chargeCenterX = charge.position.x + size / 2;
      float chargeCenterY = charge.position.y + size / 2;
      float playerCenterX = playerX + playerWidth / 2;
      float playerCenterY = playerY + playerHeight / 2;

      //check if the player is close enough to collect the charge
      boolean collected = abs(playerCenterX - chargeCenterX) < playerWidth / 2 + size / 2 &&
        abs(playerCenterY - chargeCenterY) < playerHeight / 2 + size / 2;

      if (collected && currentCharges < maxCharges) {
        currentCharges++; //increase the charge count
        collectCharge.play();
        return true;
      }
      return false;
    }
    );
  }


  public void shootCharges(float mouseX, float mouseY, float playerX, float playerY, float playerWidth) {
    if (currentCharges > 0) { //check if the player has charges
      for (int i = 0; i < location.length; i++) {
        if (!shoot[i]) { //check if the a charge has not been shot
          location[i] = new PVector(playerX + playerWidth - 20, playerY + 20); //set the initial position of the charge at the player's staff
          location[i].x -= 1*speedMultiplier;
          shoot[i] = true; //mark the charge as shot
          velocity[i] = PVector.sub(new PVector(mouseX, mouseY), location[i]); //calculate the direction from the charge to the mouse
          velocity[i].normalize(); //make the vector a unit vector
          velocity[i].mult(15); //set the speed
          chargeShot.play();
          currentCharges--; //decrease the charge count
          chargesUsed += 1; //increase the charges used counter
          break;
        }
      }
    }
  }


  public void hitGhost(ArrayList<Ghosts> ghosts) {
    for (int i = 0; i < location.length; i++) {
      if (shoot[i]) { //check if the charge has been shot
        for (Ghosts ghost : ghosts) {
          if (dist(location[i].x, location[i].y, ghost.getX(), ghost.getY()) < size / 2 + ghost.ghostHeight / 2) { //check if the charge collides with a ghost
            //reset charge
            location[i] = new PVector(-1000, -1000);
            velocity[i] = new PVector();
            shoot[i] = false;
            
            ghost.setDisappear(true);
            
            disperse = true;
            disperseTimer = millis();
            
            x = ghost.getX();
            y = ghost.getY();
            
            ghostsHit += 1;
            
            //play random ghost hit sound
            float randomGhost = random(0, 1);
            if (randomGhost <= 0.25)
              ghostHit1.play();
            else if (randomGhost <= 0.5)
              ghostHit2.play();
            else if (randomGhost <= 0.75)
              ghostHit3.play();
            else
              ghostHit4.play();
            break;
          }
        }
      }
    }
  }

  public void setCurrentCharges(int currentCharges) {
    this.currentCharges = currentCharges;
  }

  //helper class for charges on platforms
  class ChargeOnPlatform {
    PVector position;
    PVector platform;
    float offsetX;

    ChargeOnPlatform(PVector position, PVector platform, float offsetX) {
      this.position = position;
      this.platform = platform;
      this.offsetX = offsetX;
    }
  }
}
