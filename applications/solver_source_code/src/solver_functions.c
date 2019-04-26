#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <unistd.h>
#include <fcntl.h>

#include <sys/mman.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/time.h>

#include "hwlib.h"
#include "socal.h"
#include "hps.h"
#include "alt_gpio.h"

#include "solver_functions.h"

/**
 * @brief: Fill array with random numbers not greater than int_range
 *
 * @param arr[in/out] Pointer to array
 * @param row_len[in] Row length
 * @param col_len[in] Column length
 * @param int_range[in] Integer range. The coefficients are less than this number.
 */
void fill_arr(int *arr, int row_len, int col_len, int int_range) {
	int i, j;

	for (i = 0; i < row_len; i++) {
		for (j = 0; j < col_len; j++) {
			ARRAY(arr,i,j,col_len) = rand() % int_range;
		}
	}
}

/**
 * @brief: Software equation solver
 *
 * Converts the input coefficient matrix to an upper triangular matrix
 *
 * @param arr[in/out] Pointer to array
 * @param row_len Row length
 * @param col_len Column length
 */
int eq_solver(int* arr, int row_len, int col_len) {
	int i;
	int j;
	int over_flow = 0;
	int min_len = (row_len < col_len) ? row_len : col_len;

	for (i = 0; i < min_len - 1 && over_flow == 0; i++) {
		eq_rearrange(arr, row_len, col_len, i, i);
		for (j = i + 1; j < row_len && over_flow == 0; j++) {
			over_flow = eq_reducer(arr, col_len, i, j);
		}
	}
	return over_flow;
}

/**
 * @brief: Display matrix
 *
 * @param arr[in] Pointer to array
 * @param row_len Row length
 * @param col_len Column length
 */
void disp(int *arr, int row_len, int col_len) {
	int i, j;

	for (i = 0; i < row_len; i++) {
		for (j = 0; j < col_len; j++) {
			printf("%d ", ARRAY(arr, i, j, col_len));
		}
		printf("\n");
	}
}

/**
 * @brief: Swap equations
 *
 * @param a[in/out] Pointer to equation a
 * @param b[in/out] Pointer to equation b
 * @param len Length of pointer a and b
 */
void swap(int *a, int *b, int len) {
	int data_size = sizeof(int) * len;
	int *temp = calloc(sizeof(int), len);

	memcpy(temp, a, data_size);
	memcpy(a, b, data_size);
	memcpy(b, temp, data_size);

	free(temp);
}

/**
 * @brief: Calculate GCD two numbers
 *
 * @param a[in] Input first number
 * @param b[in] Input second number
 *
 * @return int GCD of a and b
 */
int gcd(int a, int b) {
	int temp;
	int r;

	if (abs(a) < abs(b)) {
		temp = a;
		a = b;
		b = temp;
	}

	while (abs(b) > 0) {
		r = a % b;
		a = b;
		b = r;
	}

	return a;
}

/**
 * @brief Perform Post processing
 *
 * @parm arr[in] Pointer to matrix
 * @param row_len[in] Row length of the matrix
 * @param col_len[in] Column length of the matrix
 */
void post_processing(int *arr, int row_len, int col_len) {
	int i;
	int j;
	int *variables = NULL;
	int sum = 0;
	int i_gcd;
	int numerator;
	int denominator;

	variables = (int *) calloc(col_len - 1, sizeof(int));
	if (!variables) {
		printf("Can not allocate %d*4 bytes", col_len);
		return;
	}

	if (row_len >= col_len - 1) {
		/* Possibilities of finding a solution for all variables */
		for (i = row_len - 1; i >= 0; i--) {
			sum = 0;
			if (i >= (col_len - 1)) {
				for (j = 0; j < col_len; j++) {
					sum += ARRAY(arr, i, j, col_len);
				}
				if (sum) {
					printf("NO_SAT\n");
					goto exit;
				}
			} else {
				for (j = 0; j < (col_len - 2 - i); j++) {
					sum += ARRAY(arr, i, col_len - 2 - j, col_len)
							* variables[col_len - 2 - j];
				}

				numerator = ARRAY(arr,i,col_len-1,col_len) + sum;
				denominator = ARRAY(arr, i, i, col_len);

				/* Divisibility test */
				if ((numerator % denominator) == 0) {
					variables[i] = ((-1) * numerator / denominator);
				} else {
					printf("NO_SAT\n");
					goto exit;
				}
			}
		}
		printf("SAT ");
		for (j = 0; j < (col_len - 1); j++) {
			printf("%d ", variables[j]);
		}
		printf("\n");
	} else {
		/* Perform GCD test to see if its satisfiable */
		for (i = row_len - 1; i >= 0; i--) {
			i_gcd = 0;
			for (j = 0; j < (col_len - 1); j++) {
				i_gcd = gcd(ARRAY(arr, i, j, col_len), i_gcd);
			}
			if (ARRAY(arr,i,col_len - 1,col_len) % i_gcd != 0) {
				printf("NO_SAT\n");
				goto exit;
			}
		}
		printf("SAT\n");
	}

exit:
	free(variables);
}

/**
 * @brief: Rearrange equations
 *
 * @param arr[in/out] Pointer to matrix
 * @param row_len[in] Row length
 * @param col_len[in] Column length
 * @param row_index[in] Index of the row of lead coefficient
 * @param col_index[in] Index of the column of lead coefficient
 */
void eq_rearrange(int *arr, int row_len, int col_len, int row_index,
		int col_index) {
	int i;
	int min_val = pow(2, 31) - 1;
	int min_index = row_index;
	int curr_val;

	for (i = row_index; i < row_len; i++) {
		curr_val = abs(ARRAY(arr, i, col_index, col_len));
		if ((min_val > curr_val) && (curr_val > 0)) {
			min_val = curr_val;
			min_index = i;
		}
	}
	swap((arr + (row_index * col_len)), (arr + (min_index * col_len)), col_len);
}

/**
 * @brief Reduce variable
 *
 * @param arr[in/out] Pointer to Matrix
 * @param col_len Column length
 * @param lead_index Index of the variable to reduce
 * @param current_index Index of the secondary equation
 */
int eq_reducer(int *arr, int col_len, int lead_index, int current_index) {
	int col = lead_index;
	int c = current_index;
	int sign = 0;
	int *temp = calloc(sizeof(int), col_len);
	int over_flow = 0;

	int *lead_value = (temp + col);
	int *cur_value = (arr + (c * col_len) + col);
	int i;
	int *lead_row = temp;
	int *cur_row = arr + (c * col_len);
	int res;

	memcpy(temp, (arr + (lead_index * col_len)), (sizeof(int) * col_len));

	if (*cur_value == 0) {
		return 0;
	}

	while (*cur_value != 0) {

		if (((abs(*lead_value) > abs(*cur_value)) || *lead_value == 0)
				&& abs(*cur_value) != 1) {
			swap(lead_row, cur_row, col_len);
		} else {

			if ((*cur_value < 0 && *lead_value < 0)
					|| (*cur_value > 0 && *lead_value > 0)) {
				// perform subtraction
				sign = -1;
			} else {
				// addition
				sign = 1;
			}

			for (i = 0; i < col_len; i++) {

				res = cur_row[i] + (sign * lead_row[i]);
				if (sign == 1) {

					if ((lead_row[i] < 0 && cur_row[i] < 0) && res > 0) {
						over_flow = 1;
					} else if ((lead_row[i] > 0 && cur_row[i] > 0) && res < 0) {
						over_flow = 1;
					}
				} else {

					if ((lead_row[i] > 0 && cur_row[i] < 0) && res > 0) {
						over_flow = 1;
					} else if ((lead_row[i] < 0 && cur_row[i] > 0) && res < 0) {
						over_flow = 1;
					}
				}
				cur_row[i] = res;
			}

			if (over_flow == 1) {
				goto exit;
			}

			if (abs(*cur_value) == 1) {
				for (i = 0; i < col_len; i++) {
					res = cur_row[i] * (abs(*lead_value));
					if ((abs(*lead_value) > 0 && cur_row[i] < 0) && res > 0) {
						over_flow = 1;
					} else if ((abs(*lead_value) > 0 && cur_row[i] > 0)
							&& res < 0) {
						over_flow = 1;
					}
					cur_row[i] = res;
				}
			}

			if (over_flow == 1) {
				goto exit;
			}
		}
	}
exit:
	free(temp);
	return over_flow;
}

/**
 * @brief: Hardware initialization
 *
 * @param ready[in/out] Enable GPIO signal address
 * @param sram_ptr[in/out] SRM address
 * @param fifo_ptr[in/out] FIFO address
 *
 * @return::bool True if initialization is successful
 */
bool hardware_init(void** ready, void** sram_ptr, void** fifo_ptr) {
	int fd;
	void *h2p_virtual_base;
	void *sram_virtual_base;
	void *h2p_lw_virtual_base;

	if ((fd = open("/dev/mem", ( O_RDWR | O_SYNC))) == -1) {
		printf("ERROR: could not open \"/dev/mem\"...\n");
		return false;
	}

	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE),
	MAP_SHARED, fd, HW_REGS_BASE);
	if (h2p_lw_virtual_base == MAP_FAILED) {
		printf("ERROR: mmap1() failed...\n");
		close(fd);
		return false;
	}

	*ready = (void *) (h2p_lw_virtual_base
			+ ((unsigned long) (ALT_LWFPGASLVS_OFST + READY_BASE)
					& (unsigned long) (HW_REGS_MASK)));
	// scratch RAM FPGA parameter addr
	sram_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, (PROT_READ | PROT_WRITE),
	MAP_SHARED, fd, FPGA_ONCHIP_BASE);

	if (sram_virtual_base == MAP_FAILED) {
		printf("ERROR: mmap3() failed...\n");
		close(fd);
		return false;
	}
	// Get the address that maps to the RAM buffer
	*sram_ptr = (void *) (sram_virtual_base);
	// ===========================================

	// FIFO write addr
	h2p_virtual_base = mmap( NULL, FIFO_SPAN, (PROT_READ | PROT_WRITE),
	MAP_SHARED, fd, FIFO_BASE);

	if (h2p_virtual_base == MAP_FAILED) {
		printf("ERROR: mmap3() failed...\n");
		close(fd);
		return false;
	}
	// Get the address that maps to the FIFO
	*fifo_ptr = (void *) (h2p_virtual_base);

	return true;
}

/**
 * @brief: Hardware based matrix converter
 *
 * Returns Row-echeleon matrix for a given coefficient matrix
 *
 * @param enable_hw[in] FPGA enable signal
 * @param fifo_ptr[in] FIFO pointer
 * @param sram_ptr[in] SRAM pointer
 * @param row_len[in] Row length
 * @param col_len[in] Column length
 * @param matrix[in/out] Pointer to matrix
 */
void hardware_solver(vuint *enable_hw, vuint *fifo_ptr, vuint *sram_ptr,
		int row_len, int col_len, int* matrix) {
	int i, j;

	*sram_ptr = 0;
	*enable_hw = 1;

	// Send the length of array
	*fifo_ptr = row_len;
	*fifo_ptr = col_len;

	for (i = 0; i < row_len; i++) {
		for (j = 0; j < col_len; j++) {
			*fifo_ptr = ARRAY(matrix, i, j, col_len);
		}
	}
	while (*sram_ptr == 0);

	*enable_hw = 0;
}
