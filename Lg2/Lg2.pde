boolean[][] now, next;
int ROWS = 40;
int COLS = 40;

void setup() {
  size(800, 800);
  now = new boolean[COLS][ROWS];
  next = new boolean[COLS][ROWS];
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      now[i][j] = random(10) < 5;
    }
  }
};