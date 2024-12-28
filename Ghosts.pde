class Ghosts {
  private PImage ghost;
  private PImage[] ghostAnimation = new PImage[4];
  
  private final int ghostWidth = 104;
  private final int ghostHeight = 108;
  private final float animationSpeed = 0.05;
  private float animationCounter;
  private float x;
  private float y;
  private float oscillate;
  
  private boolean disappear;


  Ghosts(float x, float y) {
    ghost = loadImage("ghost.png");
    this.x = x;
    this.y = y;
    
    oscillate = int(random(1, 1000)); //initialize random value for oscillation

    //split the ghost animation into separate frames
    for (int i = 0; i < ghostAnimation.length; i++) 
      ghostAnimation[i] = ghost.get(i*ghostWidth, 0, ghostWidth, ghostHeight);
  }


  public void ghosts() {
    //determine which frame of the animation to display based on the animation counter
    int i = floor(animationCounter)%ghostAnimation.length;

    if (!disappear) { //check if the ghost has not disappeared
      image(ghostAnimation[i], x, y, ghostWidth, ghostHeight); //display the ghost
      animationCounter += animationSpeed; //increase animation counter
      ghostsMove();
    } else
    x = -ghostWidth; //move the ghost offscreen if set to disappear
  }


  private void ghostsMove() {
    if (x > -ghostWidth) { //if the ghost is still on-screen
      y += 5*sin(oscillate/4); //apply vertical oscillation
      x -= 2*speedMultiplier; //the ghost moves to the left based on the speed multiplier
      oscillate += 0.1; //gradually change the oscillation factor
    }
  }


  public void setDisappear(boolean disappear) {
    this.disappear = disappear;
  }


  public float getX() {
    return x;
  }


  public float getY() {
    return y;
  }


  public int getHeight() {
    return ghostHeight;
  }
  
  
  public int getWidth() {
    return ghostWidth;
  }
}
