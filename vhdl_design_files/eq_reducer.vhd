LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.soc_eq_solver_pack.all;

entity eq_reducer is
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
end eq_reducer;

architecture behave of eq_reducer is 
signal state : integer range 0 to 63 := 0;
signal sign: std_logic := '0'; -- '0' for addition, '1' for subtraction operation
signal inputa,inputb,temp: row_type := (others => 0);
signal const_value :row_type;
signal ovrf : std_logic := '0';
begin
	
	res  <= inputb;
	ovr_flow <= ovrf;
	
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (state = 0) then
				done <= '0';
				ovrf <= '0';
				if (enable = '1') then
					state <= 1;
					inputb <= input_b;	
					inputa <= input_a;
				else
					inputb <= (others => 0);	
					inputa <= (others => 0);
				end if;
			elsif (state = 1) then
				if (input_b(col_index) = 0) then
					state <= 10;
				else
					state <= 2;
				end if;
			elsif (state = 2 ) then
				if (inputb(col_index) = 0 or ovrf = '1') then
					-- Lead variable reduced, goto finish. 
					state <= 10;
				elsif (abs(inputb(col_index)) = 1) then
					-- Multiply by the first value of input_a
					state <= 5;
				elsif ((abs(inputa(col_index)) > abs(inputb(col_index))) or inputa(col_index) = 0) then
--					--Swap lines.
					state <= 7;					
				else
				-- Sign check and perform arithmetic 
					state <= 3;
				end if;				
			elsif (state = 3) then
				if ((inputa(col_index) < 0 and inputb(col_index) < 0 ) or (inputa(col_index) > 0 and inputb(col_index) > 0 ) ) then
					-- If same sign, perform subtraction
					sign <= '1';
				else
					-- else addition
					sign <= '0';
				end if;			
				state <= 4;			
			elsif (state = 4) then
				if (sign = '1') then
					temp <= arr_sub(inputa,inputb);
				else				
					temp <= arr_add(inputa,inputb);					
				end if;				
				state <= 20;
			elsif (state <= 5) then
			-- Multiple
				const_value <= (others => abs(inputa(col_index)));
				state <= 6;
			elsif (state = 6) then
				temp <= arr_mult(const_value,inputb);
				state <= 30;
			elsif (state = 7) then
			-- Start swapping
				temp <= inputb;
				state <= 8;
			elsif (state = 8) then
				inputb <= inputa;
				state <= 9;
			elsif (state = 9) then
				inputa <= temp;
				state <= 2;
			elsif (state = 10) then
				done <= '1';
				if (enable = '0') then
					state <= 0;
				end if;
			elsif (state = 20) then
				if (sign = '1') then
					ovrf <= check_sub_ovrf(inputa,inputb,temp);
				else				
					ovrf <= check_add_ovrf(inputa,inputb,temp);					
				end if;	
				state <= 21;
			elsif (state = 21) then
				inputb <= temp;
				if (ovrf = '1') then
					state <= 10;
				else
					state <= 2;
				end if;
			elsif (state = 30) then			
				ovrf <= check_mult_ovrf(const_value,inputb,temp);							
				state <= 31;
			elsif (state = 31) then
				inputb <= temp;
				if (ovrf = '1') then
					state <= 10;
				else
					state <= 3;
				end if;
			end if;
		end if;
	end process;
end behave;
	