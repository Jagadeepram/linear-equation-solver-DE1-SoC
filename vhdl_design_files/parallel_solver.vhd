LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.soc_eq_solver_pack.all;

entity parallel_solver is
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
end parallel_solver;

architecture behave of parallel_solver is

signal ram: ram_type:= (others => (others => 0));
signal reducer_output: ram_type:= (others => (others => 0));
signal rearrange_output: ram_type:= (others => (others => 0));
signal rearrange_enable : std_logic := '0';
signal rearrange_done : std_logic := '0';
signal reducer_enable : std_logic_vector(0 to NOF_ROW-2) := (others => '0');
signal reducer_done: std_logic_vector(0 to NOF_ROW-2) := (others => '0');
signal overflow: std_logic_vector(0 to NOF_ROW-2) := (others => '0');
signal state: integer range 0 to 60 := 0;
signal leading_eq: row_type := (others => 0); 
signal row_index: integer range 0 to UINT_MAX := 0;
signal row_max,col_max: integer range 0 to UINT_MAX := 0;

begin	
	ram_out <= ram;
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (state = 0) then
				done <= '0';
				row_index <= 0;
				reducer_enable <= (others => '0');
				rearrange_enable <= '0';
				row_max <= (row_len-1);
				col_max <= (col_len-1);
				over_flow <= '0';
				leading_eq <= (others => 0);
				if (enable = '1') then
					ram <= ram_in;
					state <= 1;
				else 
					ram <= (others =>(others => 0));
				end if;
			elsif (state = 1) then
				if (rearrange_done = '0') then
					rearrange_enable <= '1';
					state <= 2;
				end if;
			elsif (state = 2) then
				if (rearrange_done = '1')	then
					state <= 3;
				end if;
			elsif (state = 3) then
				ram(row_index to NOF_ROW-1) <= rearrange_output(row_index to NOF_ROW-1);
				leading_eq <= rearrange_output(row_index);
				state <= 4;
			elsif (state = 4) then
				rearrange_enable <= '0';
				state <= 5;
			elsif (state = 5) then				
				if (to_integer(unsigned(reducer_done)) = 0) then
					reducer_enable(row_index to NOF_ROW-2) <= (others => '1');
					state <= 6;
				end if;
			elsif (state = 6) then
				if (reducer_enable = reducer_done) then
					state <= 7;
				end if;
			elsif (state = 7) then
				row_index <= row_index +1;
				state <= 8;
			elsif (state = 8) then
				ram(row_index to NOF_ROW-1) <= reducer_output(row_index to NOF_ROW-1);	
				if (to_integer(unsigned(overflow)) = 0) then
					over_flow <= '0';
					state <= 9;
				else
					over_flow <= '1';
					state <= 11;
				end if;
			elsif (state = 9) then
				reducer_enable <= (others => '0');
				if (row_index = col_max ) then
					state <= 11;
				else
					state <= 10;
				end if;
			elsif (state = 10) then
				if (row_index = row_max ) then
					state <= 11;
				else
					state <= 1;
				end if;
			elsif (state = 11) then
				done <= '1';
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
			enable => rearrange_enable,
			clk => clk, 
			done => rearrange_done
		);
			
	GEN_EQ_REDUCER:
	for I in 0 to NOF_ROW-2 generate
		ERX: eq_reducer port map 
		(
			input_a => leading_eq,
			input_b => ram(I+1),
			col_index => row_index,
			res => reducer_output(I+1),
			enable => reducer_enable(I),
			clk => clk, 
			ovr_flow => overflow(I),
			done => reducer_done(I)
		);
   end generate GEN_EQ_REDUCER;
end behave;