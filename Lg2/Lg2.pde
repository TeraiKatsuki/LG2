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
  
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      boolean up    = now[i][(j - 1 + ROWS) % ROWS];
      boolean right = now[(i + 1) % COLS][j];
      boolean left  = now[((i-1) + COLS) % COLS][j];
      boolean down  = now[i][(j + 1 + ROWS) % ROWS];
      boolean rightup   =  now[(i + 1) % COLS][(j - 1 + ROWS) % ROWS];
      boolean leftup    =  now[((i-1) + COLS) % COLS][(j - 1 + ROWS) % ROWS];
      boolean rightdown =  now[(i + 1) % COLS][(j + 1 + ROWS) % ROWS];
      boolean leftdown  =  now[((i-1) + COLS) % COLS][(j + 1 + ROWS) % ROWS];
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


void draw(){
  background(255);
  update();
  int cw = width  / COLS;
  int ch = height / ROWS;
   
   for(int i=0; i < ROWS; i++){
    for(int j=0; j < COLS; j++){
      now[i][j] = next[i][j];
      if(now[i][j]){ 
        fill(255,0,0);
      }else{
        fill(255);
      }
      
      float x = j * cw;
      float y = i * ch;
      rect(x,y,cw,ch);
    }
  }
  
}