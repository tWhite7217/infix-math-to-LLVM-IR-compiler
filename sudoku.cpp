#include <stdio.h>
#include <assert.h>

const int GRIDSIZE = 3;
const int GRID_SQUARED = GRIDSIZE*GRIDSIZE;
const int ALL_VALUES = (1<<GRID_SQUARED)-1;

int board[GRID_SQUARED][GRID_SQUARED];

char *easy_board_init[GRID_SQUARED] = {"******3**", 
													"*8***3**9", 
													"*24*7**86", 
													"9****54*8", 
													"***4*2***", 
													"1*69****5", 
													"56**3*14*", 
													"4**5***9*", 
													"**7******"};

char *hard_board_init[GRID_SQUARED] = {"*94******", 
													"1**79****", 
													"**3*86**1", 
													"92*****3*", 
													"****7****", 
													"*8*****25", 
													"4**52*9**", 
													"****61**3", 
													"******64*"};

char *third_board_init[GRID_SQUARED] = {"*3*2****6", 
													"*****9**4", 
													"76*******", 
													"****5*7**", 
													"*****186*", 
													"*5*48**9*", 
													"8********", 
													"****76***", 
													"*75**81**"};




int bit_count(int value);
int get_nth_set_bit(int value, int index);
bool singleton(int value); 
int get_singleton(int value);
bool rule2();

// Use the "board_init" variable to initialize the bitmasks for each square.
void
init_board(char *board_init[GRID_SQUARED]) {
  for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
	 for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
		char c = board_init[i][j];
		if (c == '*') {
		  board[i][j] = ALL_VALUES;
		} else {
		  board[i][j] = 1 << (c - '0' - 1);  //  DO YOU UNDERSTAND WHAT THIS DOES?  YOU SHOULD.
		}
	 }
  }
}

// A board is done if all squares are singletons.
bool
board_done(int board[GRID_SQUARED][GRID_SQUARED]) {
  for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
	 for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
		if (!singleton(board[i][j])) {
		  return false;
		}
	 }
  }
  return true;
}

// Print the board with one value per square.
void
print_board(int board[GRID_SQUARED][GRID_SQUARED]) {
  for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
	 for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
		int value = board[i][j];
		char c = '*';
		if (singleton(value)) {
		  c = get_singleton(value) + '1';
		}
		printf("%c", c);
	 }
	 printf("\n");
  }
}

// Print the board with up to 9 values per square, based on what
// the possibilities are.
void
print_board_verbose() {
  for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
	 for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
		int value = board[i][j];
		char c = ' ';
		if (singleton(value)) {
		  c = '*';
		}
		for (int k = 0 ; k < GRID_SQUARED ; ++ k) {
		  char cc = (value & (1<<k)) ? ('1'+k) : c;
		  printf("%c", cc);
		}
		printf("%c", (j == (GRID_SQUARED-1)) ? '\n' : '|');
	 }
  }
}

int 
get_square_begin(int index) {
  return (index/GRIDSIZE) * GRIDSIZE;
}

bool
rule1() {
  bool changed = false;
  for (int i = 0 ; i < GRID_SQUARED ; ++ i) {  
	 for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
		// for every square, if the value is a singleton, remove it from the row, column, and square.
		int value = board[i][j];
		if (singleton(value)) {
		  for (int k = 0 ; k < GRID_SQUARED ; ++ k) {
			 // eliminate from row
			 if (k != j) {
				if (board[i][k] & value) {
				  changed = true;
				}
				board[i][k] &= ~value;
			 }
			 // eliminate from column
			 if (k != i) {
				if (board[k][j] & value) {
				  changed = true;
				}
				board[k][j] &= ~value;
			 }
		  }

		  // elimnate from square
		  int ii = get_square_begin(i);
		  int jj = get_square_begin(j);
		  for (int k = ii ; k < ii + GRIDSIZE ; ++ k) {
		  	 for (int l = jj ; l < jj + GRIDSIZE ; ++ l) {
		  		if ((k == i) && (l == j)) {
		  		  continue;
		  		}
				if (board[k][l] & value) {
				  changed = true;
				}
		  		board[k][l] &= ~value;
		  	 }
		  }
		}
	 }
  }
  return changed;
}

bool 
solve(char *board_init[GRID_SQUARED]) {
  init_board(board_init);
  bool changed;
  do {
	 changed = rule1();
	 changed |= rule2();
  } while (changed);
  if (board_done(board)) {
	 printf("SUCCESS!\n");
	 print_board(board);
	 printf("\n");
	 return true;
  } else {
	 printf("FAILED!\n");
	 print_board_verbose();
	 printf("\n");
	 return false;
  }
}

int
main() {
  printf("bit_count(0x34) = %d\n", bit_count(0x34));
  printf("bit_count(0x1ff) = %d\n", bit_count(0x1ff));
  printf("get_nth_set_bit(0x34, 1) = %d\n", get_nth_set_bit(0x34, 1));
  printf("singleton(0x40) = %s\n", singleton(0x40) ? "TRUE" : "FALSE");
  printf("get_singleton(0x40) = %d\n\n", get_singleton(0x40));

  printf("EASY BOARD:\n");
  bool solved = solve(easy_board_init);
  if (solved) {
	 printf("HARD BOARD:\n");
	 solve(hard_board_init);
  }
  printf("THIRD BOARD: \n");
  solve(third_board_init);
  return 0;
}

// ALL your code goes below this line.
// 
// ---------------------------------------------------------------------

int 
bit_count(int value) {
  char count = 0;
  char i;
  for (i = 0; i < GRID_SQUARED; i++) {
    count = count + (value % 2);
    value = value >> 1;
  }
  return count;
}

int 
get_nth_set_bit(int value, int index) {
  char count = 0;
  char i;
  for (i = 0; i < GRID_SQUARED; i++){
    if (value % 2){
      if (count == index){
        return i;
      } else {
        count++;
      }
    }
    value = value >> 1;
  }
  return -1;
}

bool 
singleton(int value) {  // This function checks whether a square has only one possibility
  value = value & 0x1ff;
  return value > 0 && !(value & (value-1));
}

int 
get_singleton(int value) {
  char i;
  for (i = 0; i < GRID_SQUARED; i++){
    if (value % 2){
      return i;
    }
    value = value >> 1;
  }
  return -1;
}

bool
rule2() {
  bool changed = false;
  int value;
  int i;
  int isum;
  int j;
  int jsum;
  int k;
  int ksum;
  int l;
  int x;
  int y;
  for (i = 0; i < GRID_SQUARED; i++) {
    for (j = 0; j < GRID_SQUARED; j++) {
      isum = 0;
      jsum = 0;
      ksum = 0;
      value = board[i][j];
      if (!singleton(value)) {
        for (k = 0; k < GRID_SQUARED; k++) {
	  if (k != i) {
            isum |= board[k][j];
	  }
	}
	if (singleton(~isum)){
	  board[i][j] = ~isum;
	  changed = true;
	}
	for (k = 0; k < GRID_SQUARED; k++) {
	  if (k != j) {
	    jsum |= board[i][k];
	  }
	}
        if (singleton(~jsum)){
	  board[i][j] = ~jsum;
	  changed = true;
	}
	x = get_square_begin(i);
	y = get_square_begin(j);
	for (k = x; k < x + GRIDSIZE; k++) {
	  for (l = y; l < y + GRIDSIZE; l++) {
	    if (!(k == i && l == j)){
	      ksum |= board[k][l];
	    }
	  }
	}
        if (singleton(~ksum)) {
	  board[i][j] = ~ksum;
	  changed = true;
	}
      }
    }
  }
  return changed;
}
