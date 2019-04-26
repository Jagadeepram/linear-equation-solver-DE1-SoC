LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE soc_eq_solver_pack IS

	constant NOF_ROW: integer range 0 to 31 := 7;
	constant NOF_COL: integer range 0 to 15 := 7;
	constant INT_WIDTH: integer := 32;
	constant UINT_MAX: integer range 0 to 1024:= 1024;
	
	type sevenSegCode is array (0 to 15) of STD_LOGIC_VECTOR(6 DOWNTO 0);
	type row_type is array (0 to NOF_COL - 1 ) of integer;
	type ram_type is array (0 to NOF_ROW - 1 ) of row_type;
	
	function ConvertDataToSevSeg(data: STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR;
	function arr_add ( a : in row_type; b : in row_type) return row_type;
	function arr_sub ( a : in row_type; b : in row_type) return row_type;
	function arr_mult( a : in row_type; b : in row_type) return row_type;
	function check_add_ovrf( a : in row_type; b : in row_type; res: in row_type) return std_logic;
	function check_sub_ovrf( a : in row_type; b : in row_type; res: in row_type) return std_logic;
	function check_mult_ovrf( a : in row_type; b : in row_type; res: in row_type) return std_logic;
		
	component read_fifo_data is
		port (
			clk: in std_logic;
			data_ready: in std_logic;
			fifo_out_csr_read : out std_logic;
			fifo_out_csr_readdata : in std_logic_vector(31 downto 0);
			fifo_read : out std_logic;
			fifo_readdata : in std_logic_vector(31 downto 0);
			ram: out ram_type;
			row_len: out integer range 0 to UINT_MAX;
			col_len: out integer range 0 to UINT_MAX;
			HEX0 : OUT STD_LOGIC_VECTOR(6 downto 0);
			HEX1 : OUT STD_LOGIC_VECTOR(6 downto 0);
			store_done : out std_logic
		);
	end component read_fifo_data;
	
	component write_sram_data is
		port (
			sram_write_data: out std_logic_vector(31 downto 0);
			sram_address: out std_logic_vector(7 downto 0);
			sram_write_enable: out std_logic;
			clk: in std_logic;
			write_en: in std_logic;
			row_len: in integer range 0 to UINT_MAX;
			col_len: in integer range 0 to UINT_MAX;
			ram: in ram_type;
			over_flow : in std_logic;
			store_done : out std_logic
		);
	end component write_sram_data;
	
	component eq_reducer is
		port (
			input_a: in row_type;
			input_b: in row_type;
			col_index: in integer range 0 to UINT_MAX;
			res: out row_type;
			enable: in std_logic;
			clk: in std_logic;
			ovr_flow: out std_logic;
			done: out std_logic
		);
	end component eq_reducer;
	
	component eq_rearrange is
		port (
			ram_in: in ram_type;
			ram_out: out ram_type;
			row_len: in integer range 0 to UINT_MAX;
			row_index: in integer range 0 to UINT_MAX;
			col_index: in integer range 0 to UINT_MAX;
			enable: in std_logic;
			clk: in std_logic;
			done: out std_logic
		);
	end component eq_rearrange;
	
	component serial_solver is
		port (
			ram_in: in ram_type;
			enable: in std_logic;
			clk: in std_logic;
			row_len: in integer range 0 to UINT_MAX;
			col_len: in integer range 0 to UINT_MAX;
			ram_out: out ram_type;
			over_flow : out std_logic;
			done: out std_logic	
		);
	end component serial_solver;
	
	component parallel_solver is
		port (
			ram_in: in ram_type;
			enable: in std_logic;
			clk: in std_logic;
			row_len: in integer range 0 to UINT_MAX;
			col_len: in integer range 0 to UINT_MAX;
			ram_out: out ram_type;
			over_flow : out std_logic;
			done: out std_logic	
		);
	end component parallel_solver;

	component soc_eq_solver_hps is
		port (
				clock_bridge_0_in_clk_clk          : in    std_logic                     := 'X';             -- clk
				fifo_hps_to_fpga_out_readdata      : out   std_logic_vector(31 downto 0);                    -- readdata
				fifo_hps_to_fpga_out_read          : in    std_logic                     := 'X';             -- read
				fifo_hps_to_fpga_out_waitrequest   : out   std_logic;                                        -- waitrequest
				fifo_hps_to_fpga_out_csr_address   : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- address
				fifo_hps_to_fpga_out_csr_read      : in    std_logic                     := 'X';             -- read
				fifo_hps_to_fpga_out_csr_writedata : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
				fifo_hps_to_fpga_out_csr_write     : in    std_logic                     := 'X';             -- write
				fifo_hps_to_fpga_out_csr_readdata  : out   std_logic_vector(31 downto 0);                    -- readdata
				hps_io_hps_io_emac1_inst_TX_CLK    : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
				hps_io_hps_io_emac1_inst_TXD0      : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
				hps_io_hps_io_emac1_inst_TXD1      : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
				hps_io_hps_io_emac1_inst_TXD2      : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
				hps_io_hps_io_emac1_inst_TXD3      : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
				hps_io_hps_io_emac1_inst_RXD0      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
				hps_io_hps_io_emac1_inst_MDIO      : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
				hps_io_hps_io_emac1_inst_MDC       : out   std_logic;                                        -- hps_io_emac1_inst_MDC
				hps_io_hps_io_emac1_inst_RX_CTL    : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
				hps_io_hps_io_emac1_inst_TX_CTL    : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
				hps_io_hps_io_emac1_inst_RX_CLK    : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
				hps_io_hps_io_emac1_inst_RXD1      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
				hps_io_hps_io_emac1_inst_RXD2      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
				hps_io_hps_io_emac1_inst_RXD3      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
				hps_io_hps_io_qspi_inst_IO0        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
				hps_io_hps_io_qspi_inst_IO1        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
				hps_io_hps_io_qspi_inst_IO2        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
				hps_io_hps_io_qspi_inst_IO3        : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
				hps_io_hps_io_qspi_inst_SS0        : out   std_logic;                                        -- hps_io_qspi_inst_SS0
				hps_io_hps_io_qspi_inst_CLK        : out   std_logic;                                        -- hps_io_qspi_inst_CLK
				hps_io_hps_io_sdio_inst_CMD        : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
				hps_io_hps_io_sdio_inst_D0         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
				hps_io_hps_io_sdio_inst_D1         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
				hps_io_hps_io_sdio_inst_CLK        : out   std_logic;                                        -- hps_io_sdio_inst_CLK
				hps_io_hps_io_sdio_inst_D2         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
				hps_io_hps_io_sdio_inst_D3         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
				hps_io_hps_io_usb1_inst_D0         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
				hps_io_hps_io_usb1_inst_D1         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
				hps_io_hps_io_usb1_inst_D2         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
				hps_io_hps_io_usb1_inst_D3         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
				hps_io_hps_io_usb1_inst_D4         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
				hps_io_hps_io_usb1_inst_D5         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
				hps_io_hps_io_usb1_inst_D6         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
				hps_io_hps_io_usb1_inst_D7         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
				hps_io_hps_io_usb1_inst_CLK        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
				hps_io_hps_io_usb1_inst_STP        : out   std_logic;                                        -- hps_io_usb1_inst_STP
				hps_io_hps_io_usb1_inst_DIR        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
				hps_io_hps_io_usb1_inst_NXT        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
				hps_io_hps_io_spim1_inst_CLK       : out   std_logic;                                        -- hps_io_spim1_inst_CLK
				hps_io_hps_io_spim1_inst_MOSI      : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
				hps_io_hps_io_spim1_inst_MISO      : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
				hps_io_hps_io_spim1_inst_SS0       : out   std_logic;                                        -- hps_io_spim1_inst_SS0
				hps_io_hps_io_uart0_inst_RX        : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
				hps_io_hps_io_uart0_inst_TX        : out   std_logic;                                        -- hps_io_uart0_inst_TX
				hps_io_hps_io_i2c0_inst_SDA        : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
				hps_io_hps_io_i2c0_inst_SCL        : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
				hps_io_hps_io_i2c1_inst_SDA        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
				hps_io_hps_io_i2c1_inst_SCL        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
				hps_io_hps_io_gpio_inst_GPIO09     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
				hps_io_hps_io_gpio_inst_GPIO35     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
				hps_io_hps_io_gpio_inst_GPIO40     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
				hps_io_hps_io_gpio_inst_GPIO41     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO41
				hps_io_hps_io_gpio_inst_GPIO48     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
				hps_io_hps_io_gpio_inst_GPIO53     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
				hps_io_hps_io_gpio_inst_GPIO54     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
				hps_io_hps_io_gpio_inst_GPIO61     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
				memory_mem_a                       : out   std_logic_vector(14 downto 0);                    -- mem_a
				memory_mem_ba                      : out   std_logic_vector(2 downto 0);                     -- mem_ba
				memory_mem_ck                      : out   std_logic;                                        -- mem_ck
				memory_mem_ck_n                    : out   std_logic;                                        -- mem_ck_n
				memory_mem_cke                     : out   std_logic;                                        -- mem_cke
				memory_mem_cs_n                    : out   std_logic;                                        -- mem_cs_n
				memory_mem_ras_n                   : out   std_logic;                                        -- mem_ras_n
				memory_mem_cas_n                   : out   std_logic;                                        -- mem_cas_n
				memory_mem_we_n                    : out   std_logic;                                        -- mem_we_n
				memory_mem_reset_n                 : out   std_logic;                                        -- mem_reset_n
				memory_mem_dq                      : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
				memory_mem_dqs                     : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
				memory_mem_dqs_n                   : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
				memory_mem_odt                     : out   std_logic;                                        -- mem_odt
				memory_mem_dm                      : out   std_logic_vector(3 downto 0);                     -- mem_dm
				memory_oct_rzqin                   : in    std_logic                     := 'X';             -- oct_rzqin
				onchip_sram_s1_address             : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
				onchip_sram_s1_clken               : in    std_logic                     := 'X';             -- clken
				onchip_sram_s1_chipselect          : in    std_logic                     := 'X';             -- chipselect
				onchip_sram_s1_write               : in    std_logic                     := 'X';             -- write
				onchip_sram_s1_readdata            : out   std_logic_vector(31 downto 0);                    -- readdata
				onchip_sram_s1_writedata           : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
				onchip_sram_s1_byteenable          : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
				ready_external_connection_export   : out   std_logic;                                        -- export
				sdram_clk_clk                      : out   std_logic;                                        -- clk
				system_pll_ref_clk_clk             : in    std_logic                     := 'X';             -- clk
				system_pll_ref_reset_reset         : in    std_logic                     := 'X'              -- reset
			);
		end component soc_eq_solver_hps;
	
		
END soc_eq_solver_pack;

PACKAGE BODY soc_eq_solver_pack IS

	FUNCTION ConvertDataToSevSeg(data: STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
	 VARIABLE arrayCode : sevenSegCode := (
										   "1000000", -- code for 0 , 40
										   "1111001", -- code for 1,  79
										   "0100100", -- code for 2,  24
										   "0110000", -- code for 3,  30
										   "0011001", -- code for 4,  19
										   "0010010", -- code for 5,  12
										   "0000010", -- code for 6,  02
										   "1111000", -- code for 7,  78										   
										   "0000000", -- code for 8,  00
										   "0010000", -- code for 9,  10
										   "0001000", -- code for A,  08
										   "0000011", -- code for B,  03
										   "1000110", -- code for C,  46
										   "0100001", -- code for D,  21
										   "0000110", -- code for E,  06
										   "0001110");-- code for F,  0E
										   
	BEGIN
		RETURN arrayCode(TO_INTEGER(UNSIGNED(data)));
   END FUNCTION;
	
	function arr_add ( a : in row_type; b : in row_type)
	return row_type is
	variable res : row_type := (others => 0);
	begin
		for i in 0 to NOF_COL - 1 loop
		  res(i) := a(i) + b(i);
		end loop;
		return res;		 
	end function arr_add;
	
	function check_add_ovrf( a : in row_type; b : in row_type; res: in row_type)
	return std_logic is
	variable ovrf : std_logic := '0';
	begin
		for i in 0 to NOF_COL - 1 loop
		  if ( ( a(i) < 0 and b(i) < 0 )  and  res(i) > 0 ) then
					ovrf := '1';
		  elsif ( ( a(i) > 0 and b(i) > 0 )  and  res(i) < 0 ) then
		  			ovrf := '1';
		  else
					ovrf := ovrf;
		  end if;
		end loop;
		return ovrf;
	end function check_add_ovrf;

	function arr_sub (
	a    : in row_type; b : in row_type)
	return row_type is
	variable res : row_type := (others => 0);
	begin
		for i in 0 to NOF_COL - 1 loop
		  res(i) := b(i) - a(i);		  
		end loop;
		return res;		 
	end function arr_sub;
			
	function check_sub_ovrf( a : in row_type; b : in row_type; res: in row_type)
	return std_logic is
	variable ovrf : std_logic := '0';
	begin
		for i in 0 to NOF_COL - 1 loop
		  if ( ( a(i) > 0 and b(i) < 0 )  and  res(i) > 0 ) then
					ovrf := '1';
		  elsif ( ( a(i) < 0 and b(i) > 0 )  and  res(i) < 0 ) then
		  			ovrf := '1';
		  else
					ovrf := ovrf;
		  end if;
		end loop;
		return ovrf;
	end function check_sub_ovrf;

	function arr_mult (
	a : in row_type; b : in row_type)
	return row_type is
	variable res : row_type := (others => 0);
	begin
		for i in 0 to NOF_COL - 1 loop
		  res(i) := b(i) * a(i);
		end loop;
		return res;		 
	end function arr_mult;
	
	function check_mult_ovrf( a : in row_type; b : in row_type; res: in row_type) 
	return std_logic is
	variable ovrf : std_logic := '0';
	begin
		for i in 0 to NOF_COL - 1 loop
		  if ( ( a(i) < 0 and b(i) < 0 )  and  res(i) < 0 ) then
					ovrf := '1';
		  elsif ( ( a(i) > 0 and b(i) > 0 )  and  res(i) < 0 ) then
		  			ovrf := '1';
		  elsif ( ( a(i) < 0 and b(i) > 0 )  and  res(i) > 0 ) then
		  			ovrf := '1';
		  elsif ( ( a(i) > 0 and b(i) < 0 )  and  res(i) > 0 ) then
		  			ovrf := '1';
		  else
					ovrf := ovrf;
		  end if;
		end loop;		
		return ovrf;
	end function check_mult_ovrf;
	
END PACKAGE BODY;