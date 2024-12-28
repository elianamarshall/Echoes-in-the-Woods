class Cooldown {
  private final PImage cooldown0, cooldown1, cooldown2, cooldown3, cooldown4, cooldown5;
  private final int cooldownWidth = 300;
  private final int cooldownHeight = 68;
  private int x = width - cooldownWidth - 10;
  private int y = height - cooldownHeight - 10;
  private float start;
  private float current;
  private float end;

  private boolean beginTimer;


  Cooldown() {
    cooldown0=loadImage("cooldown0.png");
    cooldown1=loadImage("cooldown1.png");
    cooldown2=loadImage("cooldown2.png");
    cooldown3=loadImage("cooldown3.png");
    cooldown4=loadImage("cooldown4.png");
    cooldown5=loadImage("cooldown5.png");

    end = 5000; //set cooldown duration to 0.5 seconds
  }


  private void cooldownTimer() {
    if (beginTimer) {
      //if the cooldown is finished, stop the timer
      if (current - start > end)
        beginTimer = false;
      //if the cooldown is still running, disable the portals
      if (current - start < end)
        p.setUsePortals(false);
    }
    current = millis(); //update the current time
  }


  public void cooldownBar() {
    //display the cooldown in the bottom right corner based on the cooldown timer
    if (!beginTimer)
      image(cooldown5, x, y);
    else {
      if (current - start < 1000)
        image(cooldown4, x, y);
      else if (current - start < 2000 && current - start > 1000)
        image(cooldown3, x, y);
      else if ( current - start < 3000 && current - start > 2000)
        image(cooldown2, x, y);
      else if (current - start < 4000 && current - start > 3000)
        image(cooldown1, x, y);
      else if (current - start < 5000 && current - start > 4000)
        image(cooldown0, x, y);
    }
  }


  public void setBeginTimer(boolean beginTimer) {
    this.beginTimer = beginTimer;
  }


  public void setStart(float start) {
    this.start = start;
  }


  public void setCurrent(float current) {
    this.current = current;
  }
}
