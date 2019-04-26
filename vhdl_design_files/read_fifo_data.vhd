library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.soc_eq_solver_pack.all;

-- Module to read fifo data from HPS
entity read_fifo_data is
	port (
		-- Module clock
		clk: in std_logic;
		-- Ready signal from HPS
		data_ready: in std_logic;
		-- CSR read status register
		fifo_out_csr_read : out std_logic;
		-- CSR register to know the number of data in queue
		fifo_out_csr_readdata : in std_logic_vector(31 downto 0);
		-- Enable register to pull data from queue
		fifo_read : out std_logic;
		-- Fifo data 
		fifo_readdata : in std_logic_vector(31 downto 0);
		-- RAM 2 D array
		ram: out ram_type;
		-- Store row length
		row_len: out integer range 0 to UINT_MAX;
		-- Store column length
		col_len: out integer range 0 to UINT_MAX;
		-- Seven segment display
		HEX0 : OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX1 : OUT STD_LOGIC_VECTOR(6 downto 0);
		-- Status to indicate transfer complete
		store_done : out std_logic
	);
end read_fifo_data;

architecture behave of read_fifo_data is

signal state: integer range 0 to 20 := 0;
signal row_index,col_index: integer range 0 to UINT_MAX := 0;
signal data_count : integer range 0 to UINT_MAX := 0;
signal col_len_reg :integer range 0 to UINT_MAX := 0;
signal row_len_reg :integer range 0 to UINT_MAX := 0;
begin

	col_len <= col_len_reg;
	row_len <= row_len_reg;
	
	process (clk) 
	begin
		if (rising_edge(clk)) then
			if (state = 0) then
				store_done <= '0';
				row_len_reg <= 0;
				col_len_reg <= 0;				
				row_index <= 0;				
				col_index <= 0; 
				data_count <= 0;
				ram <= (others => (others => 0));
				if (data_ready = '1') then
					state <= 1;
				end if;
			elsif (state = 1) then
				fifo_out_csr_read <= '1' ;
				state <= 2;
			elsif (state = 2) then
				state <= 3;
			elsif (state = 3) then 
				fifo_out_csr_read <= '0' ;
				if (to_integer(unsigned( fifo_out_csr_readdata )) > 0) then
					fifo_read <= '1' ;						
					state <= 4 ;
				else
					state <= 1 ;
				end if;
			elsif (state = 4) then
				state <= 5; 
				data_count <= data_count + 1;
			elsif (state = 5) then
				fifo_read <= '0';
				if (data_count = 1) then
					state <= 1; 
					row_len_reg <= to_integer(unsigned(fifo_readdata));
				elsif (data_count = 2) then
					state <= 1; 
					col_len_reg <= to_integer(unsigned(fifo_readdata));
				else
					state <= 6;
					ram(row_index)(col_index) <= to_integer(signed(fifo_readdata));
				end if;
			elsif (state = 6) then
				col_index <= col_index +1;
				state <= 7;
			elsif (state = 7) then
				if (col_index = col_len_reg) then
					row_index <= row_index +1;
					state <= 8;
				else
					state <= 1;
				end if;			
			elsif (state = 8) then
				col_index <= 0;
				if (row_index = row_len_reg) then
					state <= 9;
				else
					state <= 1;
				end if;
			elsif (state = 9) then
				store_done <= '1';
				HEX1 <= ConvertDataToSevSeg(std_logic_vector(to_unsigned(row_len_reg,4)));
				HEX0 <= ConvertDataToSevSeg(std_logic_vector(to_unsigned(col_len_reg,4)));
				if (data_ready = '0') then
					state <= 0;		
				end if;
			end if;
		end if;
	end process;
end behave;