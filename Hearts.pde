class Hearts {
  private final PImage hearts0, hearts1, hearts2, hearts3;

  private final int heartHeight = 72;
  private int hearts = 3;


  Hearts() {
    hearts0=loadImage("hearts0.png");
    hearts1=loadImage("hearts1.png");
    hearts2=loadImage("hearts2.png");
    hearts3=loadImage("hearts3.png");
  }


  public void displayHearts() {
    //displays hearts in the bottom left corner based on the number of lives remaining
    switch (hearts) {
    case 3:
      image(hearts3, 10, height - heartHeight - 10);
      break;
    case 2:
      image (hearts2, 10, height - heartHeight - 10);
      break;
    case 1:
      image (hearts1, 10, height - heartHeight - 10);
      break;
    default:
      image (hearts0, 10, height - heartHeight - 10);
      break;
    }
  }


  public int getHearts() {
    return hearts;
  }


  public void setHearts(int hearts) {
    this.hearts = hearts;
  }
}
