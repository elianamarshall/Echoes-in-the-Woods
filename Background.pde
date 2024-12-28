class Background {
  private final PImage background;
  private final PImage frontTrees;
  private final PImage middleTrees;
  private final PImage backTrees;
  private final float frontSpeed = 3;
  private final int middleSpeed = 2;
  private final int backSpeed = 1;
  private float frontTreesX;
  private float middleTreesX;
  private float backTreesX;


  Background() {
    background = loadImage("background.png");
    frontTrees = loadImage("frontTrees.png");
    middleTrees = loadImage("middleTrees.png");
    backTrees = loadImage("backTrees.png");
  }


  public void displayBackground() {
    image(background, 0, 0);

    scrollingBackground(backTrees, backTreesX, backSpeed);
    scrollingBackground(middleTrees, middleTreesX, middleSpeed);
    scrollingBackground(frontTrees, frontTreesX, frontSpeed);
  }


  private void scrollingBackground(PImage img, float x, float speed) {
    image(img, x, 0); //draw the image at its current position
    image(img, x + img.width, 0); //draw the image directly to the left of the original image
    x -= speed;

    if (x <= -img.width) //if the image has scrolled past the screen
      x = 0; //reset its position

    //update the corresponding x position for each layer
    if (img == backTrees)
      backTreesX = x;
    else if (img == middleTrees)
      middleTreesX = x;
    else if (img == frontTrees)
      frontTreesX = x;
  }
}
