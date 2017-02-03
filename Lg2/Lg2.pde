boolean isupdate = true;
float ctime=0.0f;
float ltime=0.0f;
int maxh =5;
float animspeed = 0.025f;

class cell{
   public boolean IsAlive=true;
   public boolean IsChange=false;
   
   private int X=0;
   private int Y=0;
   private float Z =0;
   private boolean IsUp=true;
   
   //Colors.
   private int R = 255;
   private int G = 255;
   private int B = 255;
   
   public cell(int x,int y){
     X=x;
     Y=y;
     IsAlive = random(10) < 5;
     IsChange = false;
   }
   
   public void update(){
     //Start animation.
     if(IsChange){
       if(IsAlive)aliveToDeath();
       else deathToAlive();
       //No update gen.
       isupdate=false;
     }
     
     pushMatrix();
     fill(R,G,B);
     translate(X,Y,Z);
     box(1);
     popMatrix(); 
 }
   
   
   private void aliveToDeath(){
     if(IsUp){
       Z += ctime * animspeed;
       if(maxh<Z){
         IsUp=false;
       }
       
     }else{
         Z -= ctime * animspeed;
         if(Z <0){
         //End
         R=255;G=0;B=0;
         Z=0;
         IsChange=false;
         IsAlive = !IsAlive;
         IsUp=true;
        }
         
     }  
 }
   
   private void deathToAlive(){
     if(IsUp){
       Z += ctime * animspeed;
      if(maxh<Z)IsUp=false;
     }else{
         Z -= ctime * animspeed;
         
         if(Z <0){
         //End. 
          R=G=B=255;
          Z=0;
          IsChange=false;
          IsAlive = !IsAlive;
          IsUp=true;
        }  
     }  
 
  }
}

cell[][] now, next;
int ROWS = 40;
int COLS = 40;


void setup() {
  ctime = millis() - ltime;
  frameRate(30);
  size(800, 800,P3D);
  float fov = radians(45);
  perspective(fov, float(width)/float(height), 1.0, 600.0);
  now = new cell[COLS][ROWS];
  next = new cell[COLS][ROWS];
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      now[i][j] = new cell(i,j);
      next[i][j] = new cell(i,j);
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
      boolean array[] = {up,right,left,down,rightup,leftup,rightdown,leftdown};
      
      int lc=0; //life count.
      for(int k=0; k< 8; k++){
         boolean c = array[k];
         if(c) lc++;
      }
      
      if(!now[i][j].IsAlive && lc==3)next[i][j].IsChange=true; //Death to alive.
      else if(now[i][j].IsAlive && (lc==2 || lc==3)) next[i][j].IsChange=false; //Keep alive.
      else if(now[i][j].IsAlive)next[i][j].IsChange = true; //Alive to death.
      else next[i][j].IsChange = false; //Keep death.
      }
  }  
  
   //Copy.
   for(int i=0; i < ROWS; i++){
    for(int j=0; j < COLS; j++){
      now[i][j].IsChange = next[i][j].IsChange;
    }
  }
  
}


void draw(){
  background(255);
  ctime = millis() - ltime;
  
  if(isupdate){
     updategen();
     isupdate=false;
  }
  
   isupdate=true;
   camera(0,100,100, 0,0, 0, 0, 1, 0);
   translate(-20, 30, 60);
   beginCamera();
   for(int i=0; i < ROWS; i++){
    for(int j=0; j < COLS; j++){
      now[i][j].update();
    }
  }
  
  endCamera();
  ltime = millis();
}