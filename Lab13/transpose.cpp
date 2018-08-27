#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
	for (int k=0; k < SIZE; k+=32){
    	for (int i = 0; i < SIZE; i ++) {
        	for (int j = k; j < ((k+32)<SIZE?(k+32):SIZE); j++) {
        		dest[i][j] = src[j][i];
    		}
		}
	}
}
