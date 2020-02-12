class FBomb extends FBox {
  int timer;
  FBomb() {
    super(gridsize, gridsize); //FBox constructor
    timer = 60;
    this.setFillColor(orange);
    this.setPosition(player.getX()+gridsize, player.getY()-1);
    world.add(this);
  }

  void act() {    
    timer--; 
    if (timer == 0) {
      explode();
      world.remove(this);
      bomb = null;
    }
  }

  void explode() {
    for (int i = 0; i < boxes.size(); i++) { 
      FBox b = boxes.get(i);
      if (dist(this.getX(), this.getY(), b.getX(), b.getY()) < 100) {
        float vx = (-this.getX() + b.getX())*5;
        float vy = (-this.getY() + b.getY())*5;
        b.setVelocity(vx, vy);
        b.setStatic(false);
      }
    }
  }
}
