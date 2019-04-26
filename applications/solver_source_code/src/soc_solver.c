
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "solver_functions.h"

int main( int argc, char **argv )
{
	char *input;
	int row_len, col_len;
	FILE *fp;
	int *matrix;
	int i,j;
	vuint *enable_hw;
	vuint *sram_ptr;
	vuint *fifo_ptr;
	struct timeval tvalBefore, tvalAfter;

	if (hardware_init((void **)&enable_hw, (void **)&sram_ptr,
			(void **)&fifo_ptr) == false) {
		printf("Hardware initialization failed \n");
		exit(0);
	} else {
		printf("Hardware Initialization done\n");
	}

	if (argc == 2) {
		input = argv[1];
	} else {
		printf("Enter problem text file\n");
		exit(0);
	}

	if ((fp = fopen(input, "r")) == NULL) {
		printf("The file %s doesn't exist\n", input);
		exit(0);
	}
	fscanf(fp, "%d %d", &row_len, &col_len);

	matrix = (int *) calloc(row_len*col_len, sizeof(int));
	if (!matrix) {
		printf("Can not allocate %d *4 bytes", row_len*col_len);
		exit(0);
	}

	for (i=0; i < row_len; i++) {
		for (j=0; j < col_len; j++) {
			fscanf(fp, "%d", &ARRAY(matrix,i,j,col_len));
		}
	}

	printf("Problem:\nrow_len = %d\ncol_len = %d \n", row_len, col_len);
	for (i=0; i < row_len; i++) {
		for (j=0; j < col_len; j++) {
			printf("%d ", ARRAY(matrix,i,j,col_len));
		}
		printf("\n");
	}

	gettimeofday(&tvalBefore, NULL);
	hardware_solver(enable_hw, fifo_ptr, sram_ptr, row_len, col_len, matrix);
	gettimeofday(&tvalAfter, NULL);

	if (*sram_ptr != -1) {
		printf("Converted matrix:\n");
		disp((int*)sram_ptr+1, row_len, col_len);
		printf("Result:\n");
		post_processing((int*)sram_ptr+1, row_len, col_len);
	} else {
		printf("Over flow!");
	}

	printf("Execution time (us): %ld \n",
			((tvalAfter.tv_sec - tvalBefore.tv_sec) * 1000000L
					+ tvalAfter.tv_usec) - tvalBefore.tv_usec); // Added semicolon

	free(matrix);
	return 0;
}
