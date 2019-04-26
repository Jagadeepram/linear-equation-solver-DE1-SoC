LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.soc_eq_solver_pack.all;

entity serial_solver is
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
end serial_solver;

architecture behave of serial_solver is

signal ram: ram_type:= (others => (others => 0));
signal rearrange_output: ram_type:= (others => (others => 0));
signal sort_enable : std_logic := '0';
signal sort_done : std_logic := '0';
signal reduce_enable : std_logic := '0';
signal reduce_done: std_logic := '0';
signal state: integer range 0 to 60 := 0;
signal primary_eq, secondary_eq, result_eq: row_type := (others => 0); 
signal row_index,reduce_index: integer range 0 to UINT_MAX := 0;
signal row_max,col_max: integer range 0 to UINT_MAX := 0;
signal overflow : std_logic := '0';

begin	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (state = 0) then
				done <= '0';
				row_index <= 0;
				reduce_index <= 0;
				reduce_enable <= '0';
				sort_enable <= '0';
				row_max <= (row_len-1);
				col_max <= (col_len-1);
				ram_out <= (others => (others => 0));
				if (enable = '1') then
					ram <= ram_in;
					state <= 1;
				else 
					ram <= (others => (others => 0));
				end if;
			elsif (state = 1) then
				if (sort_done = '0') then
					sort_enable <= '1';
					state <= 2;
				end if;
			elsif (state = 2) then
				if (sort_done = '1')	then
					state <= 3;
				end if;
			elsif (state = 3) then
				ram(row_index to NOF_ROW-1) <= rearrange_output(row_index to NOF_ROW-1);
				state <= 4;
			elsif (state = 4) then
				sort_enable <= '0';
				primary_eq <= ram(row_index);
				reduce_index <= row_index + 1;
				state <= 5;
			elsif (state = 5) then
				reduce_enable <= '0';
				if (reduce_index < row_len) then
					secondary_eq <= ram(reduce_index);
					state <= 6;
				else
					row_index <= row_index +1;
					state <= 9;
				end if;
			elsif (state = 6) then				
				if (reduce_done = '0') then
					reduce_enable <= '1';
					state <= 7;
				end if;
			elsif (state = 7) then
				if (reduce_done = '1') then
					ram(reduce_index) <= result_eq;
					state <= 8;
				end if;
			elsif (state = 8) then
				if (overflow = '0') then
					reduce_index <= reduce_index +1;
					state <= 5;
				else
					-- exit upon overflow
					state <= 11;
				end if;
			elsif (state = 9) then
				if (row_index >= col_max ) then
					state <= 11;
				else
					state <= 10;
				end if;
			elsif (state = 10) then
				if (row_index >= row_max ) then
					state <= 11;
				else
					state <= 1;
				end if;
			elsif (state = 11) then
				done <= '1';
				over_flow <= overflow;
				ram_out <= ram;
				if (enable = '0') then
					state <= 0;
				end if;
			end if;
		end if;
	end process;
	
	u1: component eq_rearrange
		port map(
			ram_in => ram,
			ram_out => rearrange_output,
			row_len => row_len,
			row_index => row_index,
			col_index => row_index,
			enable => sort_enable,
			clk => clk, 
			done => sort_done
		);

	u2: component eq_reducer 
		port map (
			input_a => primary_eq,
			input_b => secondary_eq,
			col_index => row_index,
			res => result_eq,
			enable => reduce_enable,
			clk => clk, 
			ovr_flow => overflow,
			done => reduce_done
		);

end behave;