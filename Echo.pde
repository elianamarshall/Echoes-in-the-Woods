class Echo {
  private PImage jump;
  private PImage idle;
  private PImage[] idling = new PImage[4];
  private PImage walk;
  private PImage[] walking = new PImage[4];

  private final int playerWidth = 119;
  private final int playerHeight = 147;

  private float x;
  private float y;
  private float speed = 6;
  private float velocity;
  private float gravity = 0.6;
  private float jumpHeight = 225;
  private float walkingCounter;
  private float walkingSpeed = 0.1;
  private float idleCounter;
  private float idleSpeed = 0.075;
  private float invincibleTimer;

  private boolean jumping;
  private boolean falling;
  private boolean aPressed, dPressed;
  private boolean invincible;


  Echo() {
    jump = loadImage("jump.png");
    walk = loadImage("walking.png");
    idle = loadImage("idle.png");

    for (int i = 0; i < walking.length; i++) {
      //split the walking and idle images into separate frames
      walking[i] = walk.get(i*playerWidth, 0, playerWidth, playerHeight);
      idling[i] = idle.get(i*playerWidth, 0, playerWidth, playerHeight);
    }
  }


  void echo() {
    //end the player invincibility
    if (invincible && millis() - invincibleTimer > 1000)
      invincible = false;

    //set the tint colour for the player based on invincibility
    int tintColour = invincible ? color(255, 0, 0) : color(255);

    //determine the animation frame based on the walking and idle counters
    int i = floor(walkingCounter)%walking.length;
    int j = floor(idleCounter)%idling.length;

    x -= 1*speedMultiplier; //update the player's position based on the speedMultiplier

    if ((jumping || falling) && lastKey == 'a') { //display the flipped jump frame
      pushMatrix();
      scale(-1, 1);
      tint(tintColour);
      image(jump, -x - playerWidth, y);
      popMatrix();
    } else if (jumping || falling) { //display the jump frame
      tint(tintColour);
      image(jump, x, y);
    } else if (aPressed) { //display the flipped walking frame
      pushMatrix();
      scale(-1, 1);
      tint(tintColour);
      image(walking[i], -x - playerWidth, y, playerWidth, playerHeight);
      popMatrix();
      walkingCounter += walkingSpeed;
    } else if (dPressed) { //display the walking frame
      tint(tintColour);
      image(walking[i], x, y, playerWidth, playerHeight);
      walkingCounter += walkingSpeed;
    } else if (lastKey == 'a') { //display the flipped idle frame
      pushMatrix();
      scale(-1, 1);
      tint(tintColour);
      image(idling[j], -x - playerWidth, y, playerWidth, playerHeight);
      idleCounter += idleSpeed;
      popMatrix();
    } else { //display the idle frame
      tint(tintColour);
      image(idling[j], x, y, playerWidth, playerHeight);
      idleCounter += idleSpeed;
    }

    noTint(); //reset the tint

    bounds();
    jump();
    move();
  }


  private void bounds() {
    //prevent player from going off the right side of the screen
    if (x >= width - playerWidth)
      x = width - playerWidth;
  }


  private void jump() {
    if (jumping) {
      //move player upwards if jumping
      y -= (speed*3.25 - velocity);
      velocity += gravity;
    } else if (falling) {
      //move player downwards if falling
      velocity += gravity;
      y += velocity;
    }
    //if the upwards velocity it less than 0, the player starts falling
    if ((speed*3.25 - velocity) < 0)
      falling = true;
  }


  private void move() {
    if (aPressed) {
      x -= speed; //move left
    }
    if (dPressed) {
      x += speed; //move right
    }
  }


  public void ghostCollision() {
    for (Ghosts ghost : g) {
      if (dist(x, y, ghost.getX(), ghost.getY()) < playerHeight/2 + ghost.ghostHeight/2) { //check if the player collides with a ghost
        if (!invincible) { //check if the player is not invincible
          h.setHearts(h.getHearts() - 1); //decrease hearts by 1
          ghost.setDisappear(true);

          //start invincibility timer
          invincibleTimer = millis();
          invincible = true;

          //player a random player hit sound
          float randomHit = random(0, 1);
          if (randomHit <= 0.25)
            playerHit1.play();
          else if (randomHit <= 0.5)
            playerHit2.play();
          else if (randomHit <= 0.75)
            playerHit3.play();
          else
            playerHit4.play();
        }
      }
    }
  }


  public int getPlayerHeight() {
    return playerHeight;
  }


  public int getPlayerWidth() {
    return playerWidth;
  }


  public float getSpeed() {
    return speed;
  }


  public float getJumpHeight() {
    return jumpHeight;
  }


  public float getVelocity() {
    return velocity;
  }


  public void setVelocity(float velocity) {
    this.velocity = velocity;
  }

  public boolean getFalling() {
    return falling;
  }


  public void setFalling(boolean falling) {
    this.falling = falling;
  }


  public boolean getJumping() {
    return jumping;
  }


  public void setJumping(boolean jumping) {
    this.jumping = jumping;
  }


  public void setSpeed(float speed) {
    this.speed = speed;
  }


  public float getX() {
    return x;
  }


  public void setX(float x) {
    this.x = x;
  }


  public float getY() {
    return y;
  }


  public void setY(float y) {
    this.y = y;
  }


  public boolean getDPressed() {
    return dPressed;
  }


  public void setDPressed(boolean dPressed) {
    this.dPressed = dPressed;
  }


  public boolean getAPressed() {
    return aPressed;
  }


  public void setAPressed(boolean aPressed) {
    this.aPressed = aPressed;
  }
}
