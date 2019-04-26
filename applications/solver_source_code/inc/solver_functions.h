/*
 * solver_functions.h
 *
 *  Created on: 2 Aug 2018
 *      Author: Jagadeep
 */

#ifndef SOLVER_FUNCTIONS_H
#define SOLVER_FUNCTIONS_H

#include <stdbool.h>

// main bus; On-Chip RAM
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_ONCHIP_SPAN      0x00001000

// main bus; FIFO address
#define FIFO_BASE             0xC0000000
#define FIFO_SPAN             0x00001000

// lw_bus; PIO address
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000
#define HW_REGS_MASK 		( HW_REGS_SPAN - 1 )

// lw_bus; Enable signal base
#define READY_BASE            0x30
#define READY_SPAN            16

#define ARRAY(arr,i,j,col_len) (*((arr) + ((i) * (col_len)) + (j)))

typedef enum {
	SOLVER_TYPE_NONE = 0,
	SOLVER_TYPE_SERIAL,
	SOLVER_TYPE_PARALLEL
} solver_type_t;

typedef volatile unsigned int vuint;

#define true 1
#define false 0

/*
 * Hardware functions
 */

/* Return true if successful */
bool hardware_init(void** ready, void ** sram_ptr, void** fifo_ptr);

/* Converted matrix is store in sram_ptr */
void hardware_solver(vuint *enable_hw, vuint *fifo_ptr, vuint *sram_ptr,
		int row_len, int col_len, int* matrix);

/*
 * Software functions
 */

void disp(int *arr, int row_len, int col_len);

void swap(int *a, int *b, int len);

void eq_rearrange(int *arr, int row_len, int col_len, int row_index, int col_index);

int eq_reducer(int *arr, int col_len, int lead_index, int current_index);

void post_processing(int *arr, int row_len, int col_len);

int eq_solver(int * arr, int row_len, int col_len);

void fill_arr(int *arr, int row_len, int col_len, int int_range);

int gcd(int a, int b);

#endif /* SOLVER_FUNCTIONS_H */
