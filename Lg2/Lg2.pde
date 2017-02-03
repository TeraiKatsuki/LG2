boolean isupdategen = true; //Generation update.
float ctime=0.0f; //Current time.
float ltime=0.0f; //Time of the previous frame.
float animspeed = 0.025f; //Animation speed.

class cell { 
  public boolean IsAlive=true;
  public boolean IsChanging=false;

  private int X=0;
  private int Y=0;
  private float Z =0;
  private boolean IsUp=true; //Is up animation.

  public cell(int x, int y) {
    X=x;
    Y=y;
    IsAlive = random(10) < 5;
    IsChanging = false;
  }

  public void update() {
    //Start animation.
    if (IsChanging) {
      //No update gen.
      isupdategen=false;

      if (IsUp) {
        Z += ctime * animspeed;
        if (5<Z) {
          IsUp=false;
        }
      } else {
        Z -= ctime * animspeed;
        if (Z <0) {
          //End
          Z=0;
          IsChanging=false;
          IsAlive = !IsAlive;
          IsUp=true;
        }
      }
    }

    pushMatrix();
    if (IsAlive) fill(#FFFFFF);
    else fill(#838281);
    translate(X, Y, Z);
    box(1);
    popMatrix();
  }
}

cell[][] now, next;
int ROWS = 40;
int COLS = 40;


void setup() {
  ctime = millis() - ltime;
  frameRate(30);
  size(1000, 1000, P3D);
  
  now = new cell[COLS][ROWS];
  next = new cell[COLS][ROWS];
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      now[i][j] = new cell(i, j);
      next[i][j] = new cell(i, j);
    }
  }
  
  ltime = millis();
};

void updategen() {
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      boolean up    = now[i][(j - 1 + ROWS) % ROWS].IsAlive;
      boolean right = now[(i + 1) % COLS][j].IsAlive;
      boolean left  = now[((i-1) + COLS) % COLS][j].IsAlive;
      boolean down  = now[i][(j + 1 + ROWS) % ROWS].IsAlive;
      boolean rightup   =  now[(i + 1) % COLS][(j - 1 + ROWS) % ROWS].IsAlive;
      boolean leftup    =  now[((i-1) + COLS) % COLS][(j - 1 + ROWS) % ROWS].IsAlive;
      boolean rightdown =  now[(i + 1) % COLS][(j + 1 + ROWS) % ROWS].IsAlive;
      boolean leftdown  =  now[((i-1) + COLS) % COLS][(j + 1 + ROWS) % ROWS].IsAlive;
      boolean array[] = {up, right, left, down, rightup, leftup, rightdown, leftdown};

      int lc=0; //life count.
      for (int k=0; k< 8; k++) {
        boolean c = array[k];
        if (c) lc++;
      }

      if (!now[i][j].IsAlive && lc==3)next[i][j].IsChanging=true; //Death to alive.
      else if (now[i][j].IsAlive && (lc==2 || lc==3)) next[i][j].IsChanging=false; //Keep alive.
      else if (now[i][j].IsAlive)next[i][j].IsChanging = true; //Alive to death.
      else next[i][j].IsChanging = false; //Keep death.
    }
  }  

  //Copy.
  for (int i=0; i < ROWS; i++) {
    for (int j=0; j < COLS; j++) {
      now[i][j].IsChanging = next[i][j].IsChanging;
    }
  }
}


void draw() {
  background(255);
  ctime = millis() - ltime;

  if (isupdategen) {
    updategen();
    isupdategen=false;
  }

  isupdategen=true;
  perspective(45, float(width)/float(height), 1.0, 1000.0);
  camera(0, 100, 100, 0, 0, 0, 0, 1, 0);
  translate(-20, 45, 60); //Center.
  beginCamera();
  for (int i=0; i < ROWS; i++) {
    for (int j=0; j < COLS; j++) {
      now[i][j].update();
    }
  }
  endCamera();
  
  ltime = millis();
}