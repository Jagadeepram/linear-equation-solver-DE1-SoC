#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>

#include "solver_functions.h"
#define FILE_NAME_LEN 50

#define SIZE(a)  (sizeof(a)/sizeof(a[0]))

#define PARALLEL "\"PARALLEL\""
#define SERIAL "\"SERIAL\""

vuint *enable_hw;
vuint *sram_ptr;
vuint *fifo_ptr;

int test_reducers(int row_len, int col_len, int int_range, int nbr_test, solver_type_t solver_type);

int main(int argc, char **argv)
{
	bool status;
	int res = 0;
	char i_solver_type = 0;
	solver_type_t solver_type = SOLVER_TYPE_NONE;
	int row_arr[] = {3,4,5,6,7};
	int col_arr[] = {3,4,5,6,7};
	int int_range[] = {5,10,15,20,30,50,75,100,150,200,300,400,500};
	int nbr_of_test = 1000;
	int i,j,k;

	if (argc == 2) {
		i_solver_type = argv[1][0];
	} else {
		printf("Enter solver type\n 's' for serial and 'p' for parallel solver \n");
		exit(0);
	}

	if (i_solver_type == 's') {
		solver_type = SOLVER_TYPE_SERIAL;
		printf("Serial solver\n");
	} else if (i_solver_type == 'p') {
		solver_type = SOLVER_TYPE_PARALLEL;
		printf("Parallel solver\n");
	} else {
		printf("Incorrect input \n Enter 's' for serial and 'p' for parallel solver \n");
		exit(0);
	}

	status = hardware_init((void **)&enable_hw, (void **)&sram_ptr,
			(void **)&fifo_ptr);

	if (!status) {
		printf("Hardware initialization failed \n");
		exit(0);
	} else {
		printf("Hardware Initialization done\n");
	}

	for (i = 0; i < SIZE(row_arr) && !res; i++) {
		for (j = 0; j < SIZE(col_arr) && !res; j++) {
			for (k = 0; k < SIZE(int_range) && !res; k++) {
				res = test_reducers(row_arr[i], col_arr[j], int_range[k], nbr_of_test,
						solver_type);
			}
		}
	}

	return 0;
}
int test_reducers(int row_len, int col_len, int int_range, int nbr_test, solver_type_t solver_type)
{
    struct timeval tvalBefore, tvalAfter;
	int *software_input_arr;
	int *hardware_input_arr;
	int i,j,count;
	int verify = 0;
	int res = 0;
	int over_flow = 0;
	char *solver_name = NULL;
	FILE *fptr;
	char output_name[FILE_NAME_LEN] = {0};

	if (solver_type == SOLVER_TYPE_SERIAL) {
		strncpy(output_name, "result/serial_", FILE_NAME_LEN);
		solver_name = (char *)SERIAL;
	} else if (solver_type == SOLVER_TYPE_PARALLEL) {
		strncpy(output_name, "result/parallel_", FILE_NAME_LEN);
		solver_name = (char *)PARALLEL;
	}

	snprintf(output_name + strlen(output_name),
			FILE_NAME_LEN - strlen(output_name), "%d_%d_%d_%d.txt", row_len,
			col_len, int_range, nbr_test);

	fptr = fopen(output_name, "w+");
	if ( fptr == NULL) {
		printf("Create folder \"result\" to store measurement data\n");
		// Program exits if the file pointer returns NULL.
		exit(1);
	}

	software_input_arr = calloc(sizeof(int), row_len*col_len);
	hardware_input_arr = calloc(sizeof(int), row_len*col_len);

	fprintf(fptr, "{\"test_result\": {\n");
	fprintf(fptr, "\t\"row_len\": %d,\n", row_len);
	fprintf(fptr, "\t\"col_len\": %d,\n", col_len);
	fprintf(fptr, "\t\"max_coef\": %d,\n", int_range);
	fprintf(fptr, "\t\"nbr_test\": %d,\n", nbr_test);
	fprintf(fptr, "\t\"solver_type\": %s,\n", solver_name);

	fprintf(fptr, "\t\"test_cases\": [\n");
	*enable_hw = 0;

	for (count = 0; count < nbr_test && res == 0 && verify == 0; count++) {

		res = 0;
		fill_arr((int *) software_input_arr, row_len, col_len, int_range);
		memcpy(hardware_input_arr, software_input_arr, (sizeof(int) * row_len * col_len));

		gettimeofday(&tvalBefore, NULL);
		/* Perform software matrix conversion */
		over_flow = eq_solver((int *) software_input_arr, row_len, col_len);
		gettimeofday(&tvalAfter, NULL);

		fprintf(fptr, "\t\t[{");
		fprintf(fptr, "\"test_nbr\": %d,", count);
		fprintf(fptr, "\"soft\": %ld,",
				((tvalAfter.tv_sec - tvalBefore.tv_sec) * 1000000L
						+ tvalAfter.tv_usec) - tvalBefore.tv_usec); // Added semicolon

		gettimeofday(&tvalBefore, NULL);
		// Send matrix and wait for processed data in RAM
		hardware_solver(enable_hw, fifo_ptr, sram_ptr, row_len, col_len, hardware_input_arr);
		gettimeofday(&tvalAfter, NULL);

		/* Compare two matrix when overflow hasn't occurred */
		for (i = 0; i < row_len && res == 0 && *sram_ptr != -1; i++) {
			for (j = 0; j < col_len; j++) {
				if (ARRAY(software_input_arr,i,j,col_len) != ARRAY(sram_ptr+1,i,j,col_len)) {
					res = 1;
					break;
				}
			}
		}

		if (over_flow == 1 && *sram_ptr != -1) {
			res = 1;
		} else if (over_flow != 1 && *sram_ptr == -1) {
			res = 1;
		}

		fprintf(fptr, "\"hard\": %ld,",
				((tvalAfter.tv_sec - tvalBefore.tv_sec) * 1000000L
						+ tvalAfter.tv_usec) - tvalBefore.tv_usec); // Added semicolon

		if (*sram_ptr != -1) {
			fprintf(fptr, "\"overflow\": \"NO\",");
		} else {
			fprintf(fptr, "\"overflow\": \"YES\",");
		}

		if (res == 0) {
			fprintf(fptr, "\"result\": \"PASS\"");
		} else {
			fprintf(fptr, "\"result\": \"FAIL\"");
		}
		if (count != (nbr_test-1)) {
			fprintf(fptr, "}],\n");
		} else {
			fprintf(fptr, "}]\n");
		}

		if (res == 1) {
			fprintf(fptr, "Input Data \n");
			disp((int *) hardware_input_arr, row_len, col_len);
			fprintf(fptr, "Software Output \n");
			disp((int *) software_input_arr, row_len, col_len);
			fprintf(fptr, "Hardware Output \n");
			disp((int *) (sram_ptr + 1), row_len, col_len);
		}
		verify |= res;
	}

	fprintf(fptr, "\t],\n");
	if (verify == 0) {
		fprintf(fptr, "\t\"result\": \"PASS\" } \n}");
	} else {
		fprintf(fptr, "\t\"result\": \"FAIL\" \n");
		fprintf(fptr, "\t\"HW_ovr_flow\": %d,\n", *(sram_ptr));
		fprintf(fptr, "\t\"SW_ovr_flow\": %d, } \n}", over_flow);
	}
	free(hardware_input_arr);
	free(software_input_arr);
	fclose(fptr);
	return verify;
}
