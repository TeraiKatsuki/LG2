boolean[][] now, next;
int ROWS = 40;
int COLS = 40;

void setup() {
  size(800, 800);
  now = new boolean[COLS][ROWS];
  next = new boolean[COLS][ROWS];
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      now[i][j] = random(10) < 5;
    }
  }
};

void update() {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      boolean up    = now[i][(j - 1 + height) % height];
      boolean right = now[(i + 1) % width][j];
      boolean left  = now[((i-1) + width) % width][j];
      boolean down  = now[i][(j + 1 + height) % height];
      boolean rightup   =  now[(i + 1) % width][(j - 1 + height) % height];
      boolean leftup    =  now[((i-1) + width) % width][(j - 1 + height) % height];
      boolean rightdown =  now[(i + 1) % width][(j + 1 + height) % height];
      boolean leftdown  =  now[((i-1) + width) % width][(j + 1 + height) % height];
      boolean array[] = {up,right,left,down,rightup,leftup,rightdown,leftdown};
      
      int lc=0; //life count.
      for(int k=0; k< 8; k++){
         boolean c = array[k];
         if(c) lc++;
      }
      
      if(!now[i][j] && lc==3) next[i][j] = true;
      else if(now[i][j] && (lc==2 || lc==3) ) next[i][j] = true;
      else next[i][j] = false;
      
    }
  }
}