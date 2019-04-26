LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.soc_eq_solver_pack.all;

entity eq_rearrange is
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
end eq_rearrange;

architecture behave of eq_rearrange is
signal ram: ram_type := (others => (others => 0));
signal state: integer range 0 to 20 := 0;
signal counter_i, counter_j : integer range 0 to UINT_MAX:= 0;
signal temp_row: row_type := (others => 0);
signal min_value : integer := 0;
signal min_index : integer range 0 to UINT_MAX:= 0;
begin

	ram_out <= ram;

	process (clk)
	begin
		if (rising_edge (clk)) then
			if (state = 0) then
				done <= '0';	
				if (enable = '1') then
					counter_i <= row_index;
					min_index <= row_index;
					ram <= ram_in;
					min_value <= (2**(INT_WIDTH-1))-1;
					state <= 1;
				else
					counter_i <= 0;
					min_index <= 0;
					min_value <= 0;
					ram <= (others => (others => 0));
				end if;
			elsif (state = 1) then
				if ((min_value >  abs(ram(counter_i)(col_index)))and (abs(ram(counter_i)(col_index)) > 0)) then
					min_index <= counter_i;
					min_value <= abs(ram(counter_i)(col_index));
				end if;
				state <= 2;
			elsif (state = 2) then
				counter_i <= counter_i +1;
				state <= 3;
			elsif (state = 3) then
				if (counter_i >= row_len) then
					state <= 4;
				else
					state <= 1;
				end if;
			elsif (state = 4) then
				temp_row <= ram(row_index);
				state <= 5;
			elsif (state = 5) then
				ram(row_index) <= ram(min_index);
				state <= 6;	
			elsif (state = 6) then
				ram(min_index) <= temp_row ;
				state <= 7;	
			elsif (state = 7) then
				done <= '1';
				if (enable = '0') then
					state <= 0;
				end if;
			end if;
		end if;
	end process;
end behave;