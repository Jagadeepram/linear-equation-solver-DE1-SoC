library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.soc_eq_solver_pack.all;

-- SRAM module to write data from address 0x0.
entity write_sram_data is
	port (
	-- Data written to SRAM
	sram_write_data: out std_logic_vector(31 downto 0);
	-- SRAM address
	sram_address: out std_logic_vector(7 downto 0);
	-- Enable SRAM write
	sram_write_enable: out std_logic;
	-- Module clock
	clk: in std_logic;
	-- Module enable
	write_en: in std_logic;
	-- Row length of matrix
	row_len: in integer range 0 to UINT_MAX;
	-- Column length of matrix
	col_len: in integer range 0 to UINT_MAX;
	-- Two D matrix
	ram: in ram_type;
	-- Overflow Indicator
	over_flow : in std_logic;
	-- Write completion indicator
	store_done : out std_logic
	);
end write_sram_data;

architecture behave of write_sram_data is 
-- Internal state
signal state: integer range 0 to 7 := 0;
-- Current row and col index during writing
signal row_index,col_index: integer range 0 to UINT_MAX := 0;
-- Current write address
signal address: integer range 0 to UINT_MAX := 0;
-- Data count register to track end of array
signal data_count : integer range 0 to UINT_MAX := 0;
begin
	sram_address <= std_logic_vector(to_unsigned(address,sram_address'length));
	process(clk)
	begin
		if (rising_edge(clk)) then
			-- Reset state: reset all registers 
			if (state = 0) then
				store_done <= '0';
				row_index <= 0;
				col_index <= 0;
				sram_write_enable <= '0';
				-- Write matrix data from location 1 as status will be written in 0
				address <= 1; 
				data_count <= 0;
				if (write_en = '1') then
					state <= 1;
				end if;
			-- Copy data into SRAM write register and enable SRAM write signal
			elsif (state = 1) then
				sram_write_enable <= '1';
				sram_write_data <= std_logic_vector(to_signed(ram(row_index)(col_index),sram_write_data'length));
				state <= 2;
				data_count <= data_count +1;
			elsif (state = 2) then
			-- Increment address and index
				sram_write_enable <= '0';
				address <= address + 1;
				col_index <= col_index + 1;
				state <= 3;
			elsif (state = 3) then
			-- Increment row index 
				if (col_index = col_len) then
					row_index <= row_index +1;
					state <= 4;
				else
					state <= 1;
				end if;	
			elsif (state = 4) then
			-- Boundary check
				col_index <= 0;
				if (row_index = row_len) then
					state <= 5;
				else
					state <= 1;
				end if;
			elsif (state = 5) then
			-- Update Zero'th location with status
				address <= 0;
				sram_write_enable <= '1';
				state <= 6;
				-- Update data length at location 0x0 when no overflow.
				if (over_flow = '0') then
					sram_write_data <= std_logic_vector(to_signed(data_count,sram_write_data'length));
				else
					sram_write_data <= std_logic_vector(to_signed(-1,sram_write_data'length));
				end if;				
			elsif (state = 6) then
			-- Done state
				store_done <= '1';
				sram_write_enable <= '0';
				-- Return to the reset state while enable signal is zero
				if (write_en = '0') then
					state <= 0;
				end if;
			end if;
		end if;
	end process;
end behave;