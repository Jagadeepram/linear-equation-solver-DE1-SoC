# linear_equation_solver_DE1_SoC
Accelerate Linear Equation System Solver on DE1-SoC development Board

A set of linear integer equations are solved and accelerated on DE1-SoC board. 
The solver is designed as software solver using resources only from MCU and as hardware solvers also
using resouces from Interconnect bridges and FPGA. The project is designed using VHDL in FPGA and C in MCU.
For more information, refer the Instruction document and thesis report.

The solution is using FIFO and SRAM IPs to transfer data array from MCU to FPGA and vice-versa.

Contents of the repository:
1) Design and source code for software solver.
2) Design and source code for hardware solvers ( serial solver and parallel solver).
3) A detailed instruction file to compile and execute the project.
4) Master thesis report for detailed design and implementation.

This work is performed as master thesis under IT department, Uppsala University, Sweden.


