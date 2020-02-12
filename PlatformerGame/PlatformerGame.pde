//FBomb video

import fisica.*;

PImage map;
int x = 0;
int y = 0;
int gridsize = 30;
float vx, vy;
//palette
color black = #000000;
color red = color(237, 28, 36);
color green = color(34, 177, 76);
color purple = #DFC4F0;
color orange = #F0B977;
FBox player;
FBomb bomb = null;

boolean spacekey, akey, wkey, skey, dkey, canJump;

FWorld world;

ArrayList<FBox> boxes = new ArrayList<FBox>();

PImage[] megamanSprites;
PImage[] runleft;
PImage[] run;
PImage[] idle;
PImage[] jump;
PImage[] currentAction;
int costumeNum = 0;
int frame = 0;

void setup() {
  size(600, 400);
  Fisica.init(this);
  map = loadImage("map.png");
  noStroke();
  loadWorld();
  makeplayer();
  player.setRotatable(false);
}

void draw() {
  background(255);
  pushMatrix();
  translate(-player.getX() + width/2, -player.getY() + height/2);
  world.step();
  world.draw();
  popMatrix();
  handleKeyboard();
  canJump = false;
  characterAnimation();

  image (run[frame], 50, 50);
  if (frameCount %10 == 0) {
    frame++;
    if (frame == 3) {
      frame = 0;
    }
  }

  ArrayList<FContact> contacts = player.getContacts();
  int i = 0;
  while (i < contacts.size()) {
    FContact c = contacts.get(i);
    if (c.contains("ground")) canJump = true;
    if (c.contains("platform")) canJump = true;
    i++;
  }
}

void loadWorld() {
  //instantiate world

  world = new FWorld(0, 0, 1000000, 1000000);
  world.setGravity(0, 980);
  //load world
  while (y < map.height) {
    color c = map.get(x, y);
    println(c);
    if (c == black) {
      FBox b = new FBox(gridsize, gridsize); 
      b.setFillColor(black);
      b.setPosition(x*gridsize, y*gridsize);
      b.setStatic(true);
      // b.setFriction(0);
      b.setName("ground");
      boxes.add(b);
      world.add(b);
    }
    if (c == red) {
      FBox r = new FBox(gridsize, gridsize); 
      r.setFillColor(red);
      r.setPosition(x*gridsize, y*gridsize);
      r.setStatic(true);
      r.setFriction(0);
      r.setName("lava");
      world.add(r);
    }    
    if (c == green) {
      FBox g = new FBox(gridsize, gridsize); 
      g.setFillColor(green);
      g.setPosition(x*gridsize, y*gridsize);
      g.setStatic(true);
      g.setFriction(0);
      g.setName("platform");
      world.add(g);
    }
    x++;
    if (x == map.width) {
      x = 0;
      y++;
    }
  }
}

void makeplayer() {
  player = new FBox(gridsize, gridsize); 
  player.setPosition(gridsize, height-200);
  player.setNoStroke();
  player.setStatic(false);
  player.setGrabbable(false);
  player.setFillColor(purple);
  //player1.setDensity(0.5);
  //player1.setFriction(1);
  player.setRestitution(0);
  world.add(player);
}

void handleKeyboard() {
  //left right movement 
  vx = 0;
  if (akey) { 
    vx = -150;
    currentAction = runleft;
    costumeNum = 0;
  }
  if (dkey) {
    vx = 150;
    player.setVelocity(vx, player.getVelocityY());
    currentAction = run;
    costumeNum = 0;
  }
  //jump
  if (wkey && canJump) { 
    player.setVelocity(player.getVelocityX(), -300);
    currentAction = jump;
    costumeNum = 0;
  }

  if (!akey && !dkey && !wkey) {
    currentAction = idle;
    costumeNum = 0;
  }

  //drop bomb
  if (spacekey && bomb == null) {
    bomb = new FBomb();
  }
  if (bomb != null) bomb.act();
}

void characterAnimation() {
  megamanSprites = new PImage[70];
  runleft = new PImage [3];
  run = new PImage [3];
  idle = new PImage [1];
  jump = new PImage [1];

  int a = 0;
  for (int y = 0; y < 500; y += 50) {
    for (int s = 0; x < 350; x += 50) {
      megamanSprites[a] = megamanSpriteSheet.get(x, y, gridsize, gridsize);
      megamanSprites[a].save("megaman"+a+".png");
      megamanSprites[a].resize(gridsize, gridsize);
      a++;
    }
  }

  run[0] = loadImage("megaman3.png");
  run[1] = loadImage("megaman4.png"); 
  run[2] = loadImage("megaman5.png");

  runleft[0] = loadImage("megaman");
  runleft[1] = loadImage("megaman");
  runleft[2] = loadImage("megaman");

  jump[0] = loadImage("megaman6.png");

  idle[0] = loadImage("megaman0.png");

  currentAction = idle;


  player.attachImage(currentAction[costumeNum]);
  if (frameCount %10 == 0) {
    costumeNum++;
    if (costumeNum >= currentAction.length) {
      costumeNum = 0;
    }
  }
}

void keyPressed() {
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'D' || key == 'd') dkey = true;
  if (key ==' ') spacekey = true;
}
void keyReleased() {
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'D' || key == 'd') dkey = false;
  if (key ==' ') spacekey = false;
}
