-- soc_eq_solver_hps_System_PLL.vhd

-- This file was auto-generated from altera_up_avalon_sys_sdram_pll_hw.tcl.  If you edit it your changes
-- will probably be lost.
-- 
-- Generated using ACDS version 18.1 625

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity soc_eq_solver_hps_System_PLL is
	port (
		ref_clk_clk        : in  std_logic := '0'; --      ref_clk.clk
		ref_reset_reset    : in  std_logic := '0'; --    ref_reset.reset
		sys_clk_clk        : out std_logic;        --      sys_clk.clk
		sdram_clk_clk      : out std_logic;        --    sdram_clk.clk
		reset_source_reset : out std_logic         -- reset_source.reset
	);
end entity soc_eq_solver_hps_System_PLL;

architecture rtl of soc_eq_solver_hps_System_PLL is
	component soc_eq_solver_hps_System_PLL_sys_pll is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk
			outclk_1 : out std_logic;        -- clk
			locked   : out std_logic         -- export
		);
	end component soc_eq_solver_hps_System_PLL_sys_pll;

	component altera_up_avalon_reset_from_locked_signal is
		port (
			reset  : out std_logic;        -- reset
			locked : in  std_logic := 'X'  -- export
		);
	end component altera_up_avalon_reset_from_locked_signal;

	signal sys_pll_locked_export : std_logic; -- sys_pll:locked -> reset_from_locked:locked

begin

	sys_pll : component soc_eq_solver_hps_System_PLL_sys_pll
		port map (
			refclk   => ref_clk_clk,           --  refclk.clk
			rst      => ref_reset_reset,       --   reset.reset
			outclk_0 => sys_clk_clk,           -- outclk0.clk
			outclk_1 => sdram_clk_clk,         -- outclk1.clk
			locked   => sys_pll_locked_export  --  locked.export
		);

	reset_from_locked : component altera_up_avalon_reset_from_locked_signal
		port map (
			reset  => reset_source_reset,    -- reset_source.reset
			locked => sys_pll_locked_export  --       locked.export
		);

end architecture rtl; -- of soc_eq_solver_hps_System_PLL
