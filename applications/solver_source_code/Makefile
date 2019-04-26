
# Binary name and application for soft solver
SOFT_SOLVER = soft_solver
SOFT_SOLVER_SRC = $(SOFT_SOLVER).c

# Binary name for soc solver
SOC_SOLVER = soc_solver
SOC_SOLVER_SRC = $(SOC_SOLVER).c

# Binary name for measurment application
MEAS_APP = meas_app
MEAS_APP_SRC = $(MEAS_APP).c

OUTPUT = out
SRC_DIR = src
COMPILER_PATH = altera_files/gcc/bin
CROSS_COMPILE = arm-linux-gnueabihf-
CC = $(COMPILER_PATH)/$(CROSS_COMPILE)gcc

APP = $(SOFT_SOLVER) $(SOC_SOLVER) $(MEAS_APP)
TARGETS = $(filter  $(MAKECMDGOALS),$(APP))

ifeq ($(TARGETS),)
	TARGETS = $(APP)
endif

CFLAGS =\
		-g \
		-Wall \
		-Dsoc_cv_av=1
		
CFLAGS += \
		-I altera_files/hwlib/include/soc_cv_av/socal/ \
		-I altera_files/hwlib/include

LDFLAGS =  -g -Wall -lm

ARCH= arm

CFILES = $(SRC_DIR)/solver_functions.c

CFLAGS += -I inc

all: $(TARGETS)

$(SOFT_SOLVER):  
	@mkdir -p $(OUTPUT)
	$(CC) $(CFILES) $(SRC_DIR)/$(SOFT_SOLVER_SRC) $(LDFLAGS) $(CFLAGS) -o $(OUTPUT)/$@  

$(SOC_SOLVER):  
	@mkdir -p $(OUTPUT)
	$(CC) $(CFILES) $(SRC_DIR)/$(SOC_SOLVER_SRC) $(LDFLAGS) $(CFLAGS) -o $(OUTPUT)/$@  

$(MEAS_APP): 
	@mkdir -p $(OUTPUT)
	$(CC) $(CFILES) $(SRC_DIR)/$(MEAS_APP_SRC) $(LDFLAGS) $(CFLAGS) -o $(OUTPUT)/$@  

.PHONY: clean all

clean:
	rm -rf $(OUTPUT)
