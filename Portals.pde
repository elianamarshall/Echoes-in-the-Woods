class Portals {
  private final PImage portal;

  private final int portalWidth = 270;
  private final int portalHeight = 489;
  private float x;
  private float y;
  private float start;
  private float current;
  private float end;

  private boolean beginTimer;
  private boolean usePortals;


  Portals() {
    portal = loadImage("portal.png");

    end = 500; //set portal duration to 0.5 seconds
  }


  public void portals() {
    if (usePortals && !cool.beginTimer) {  //check if the portals are active and the cooldown timer has not begun
      image(portal, e.x-70, e.y-165); //display portal at player's position
      image(portal, x-portalWidth/2, y-portalHeight/2); //display second portal where mouse clicked
      e.setSpeed(0); //freeze player movement while portal is active
    } else {
      e.setSpeed(5);
    }
  }


  public void portalTimer() {
    if (!beginTimer) {
      beginTimer = true;
      start = millis(); //record the start time of the portal timer
    }
    current = millis(); //record the current time
    if (current - start > end && usePortals) {
      usePortals = false; //the portals are no longer active after the timer ends
      beginTimer = false;
      cool.setBeginTimer(true); //start cooldown timer
      cool.setStart(millis()); //record the start time of the cooldown timer

      //move the player to the second portal location
      e.setX(x-portalWidth/4);
      e.setY(y-portalHeight/4);
    }
  }


  public void setUsePortals(boolean usePortals) {
    this.usePortals = usePortals;
  }


  public void setStart(float start) {
    this.start = start;
  }


  public void setX(float x) {
    this.x = x;
  }


  public void setY(float y) {
    this.y = y;
  }
}
