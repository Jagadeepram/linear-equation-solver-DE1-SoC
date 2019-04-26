--Legal Notice: (C)2019 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library lpm;
use lpm.all;

entity soc_eq_solver_hps_fifo_HPS_to_FPGA_dual_clock_fifo is 
        port (
              -- inputs:
                 signal aclr : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdclk : IN STD_LOGIC;
                 signal rdreq : IN STD_LOGIC;
                 signal wrclk : IN STD_LOGIC;
                 signal wrreq : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdempty : OUT STD_LOGIC;
                 signal rdfull : OUT STD_LOGIC;
                 signal rdusedw : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal wrempty : OUT STD_LOGIC;
                 signal wrfull : OUT STD_LOGIC;
                 signal wrusedw : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
              );
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of soc_eq_solver_hps_fifo_HPS_to_FPGA_dual_clock_fifo : entity is "SUPPRESS_DA_RULE_INTERNAL=R101";
end entity soc_eq_solver_hps_fifo_HPS_to_FPGA_dual_clock_fifo;


architecture europa of soc_eq_solver_hps_fifo_HPS_to_FPGA_dual_clock_fifo is
  component dcfifo is
GENERIC (
      add_ram_output_register : STRING;
        clocks_are_synchronized : STRING;
        intended_device_family : STRING;
        lpm_hint : STRING;
        lpm_numwords : NATURAL;
        lpm_showahead : STRING;
        lpm_type : STRING;
        lpm_width : NATURAL;
        lpm_widthu : NATURAL;
        overflow_checking : STRING;
        rdsync_delaypipe : NATURAL;
        read_aclr_synch : STRING;
        underflow_checking : STRING;
        use_eab : STRING;
        write_aclr_synch : STRING;
        wrsync_delaypipe : NATURAL
      );
    PORT (
    signal wrempty : OUT STD_LOGIC;
        signal rdusedw : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
        signal rdempty : OUT STD_LOGIC;
        signal wrfull : OUT STD_LOGIC;
        signal rdfull : OUT STD_LOGIC;
        signal wrusedw : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
        signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal aclr : IN STD_LOGIC;
        signal rdreq : IN STD_LOGIC;
        signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wrclk : IN STD_LOGIC;
        signal rdclk : IN STD_LOGIC;
        signal wrreq : IN STD_LOGIC
      );
  end component dcfifo;
                signal int_rdfull :  STD_LOGIC;
                signal int_wrfull :  STD_LOGIC;
                signal internal_q1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_rdempty1 :  STD_LOGIC;
                signal internal_rdusedw :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal internal_wrempty :  STD_LOGIC;
                signal internal_wrusedw :  STD_LOGIC_VECTOR (8 DOWNTO 0);

begin

  wrfull <= to_std_logic((((std_logic_vector'("000000000000000000000000") & (internal_wrusedw))>=(std_logic_vector'("000000000000000000000001000000000") - std_logic_vector'("000000000000000000000000000000011"))))) OR int_wrfull;
  rdfull <= to_std_logic((((std_logic_vector'("000000000000000000000000") & (internal_rdusedw))>=(std_logic_vector'("000000000000000000000001000000000") - std_logic_vector'("000000000000000000000000000000011"))))) OR int_rdfull;
  dual_clock_fifo : dcfifo
    generic map(
      add_ram_output_register => "OFF",
      clocks_are_synchronized => "FALSE",
      intended_device_family => "CYCLONEV",
      lpm_hint => "DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT",
      lpm_numwords => 512,
      lpm_showahead => "OFF",
      lpm_type => "dcfifo",
      lpm_width => 32,
      lpm_widthu => 9,
      overflow_checking => "ON",
      rdsync_delaypipe => 4,
      read_aclr_synch => "ON",
      underflow_checking => "ON",
      use_eab => "ON",
      write_aclr_synch => "ON",
      wrsync_delaypipe => 4
    )
    port map(
            aclr => aclr,
            data => data,
            q => internal_q1,
            rdclk => rdclk,
            rdempty => internal_rdempty1,
            rdfull => int_rdfull,
            rdreq => rdreq,
            rdusedw => internal_rdusedw,
            wrclk => wrclk,
            wrempty => internal_wrempty,
            wrfull => int_wrfull,
            wrreq => wrreq,
            wrusedw => internal_wrusedw
    );

  --vhdl renameroo for output signals
  q <= internal_q1;
  --vhdl renameroo for output signals
  rdempty <= internal_rdempty1;
  --vhdl renameroo for output signals
  rdusedw <= internal_rdusedw;
  --vhdl renameroo for output signals
  wrempty <= internal_wrempty;
  --vhdl renameroo for output signals
  wrusedw <= internal_wrusedw;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity soc_eq_solver_hps_fifo_HPS_to_FPGA_dcfifo_with_controls is 
        port (
              -- inputs:
                 signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdclk : IN STD_LOGIC;
                 signal rdclk_control_slave_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal rdclk_control_slave_read : IN STD_LOGIC;
                 signal rdclk_control_slave_write : IN STD_LOGIC;
                 signal rdclk_control_slave_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdreq : IN STD_LOGIC;
                 signal rdreset_n : IN STD_LOGIC;
                 signal wrclk : IN STD_LOGIC;
                 signal wrclk_control_slave_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal wrclk_control_slave_read : IN STD_LOGIC;
                 signal wrclk_control_slave_write : IN STD_LOGIC;
                 signal wrclk_control_slave_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal wrreq : IN STD_LOGIC;
                 signal wrreset_n : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdclk_control_slave_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdempty : OUT STD_LOGIC;
                 signal wrclk_control_slave_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal wrfull : OUT STD_LOGIC
              );
end entity soc_eq_solver_hps_fifo_HPS_to_FPGA_dcfifo_with_controls;


architecture europa of soc_eq_solver_hps_fifo_HPS_to_FPGA_dcfifo_with_controls is
component soc_eq_solver_hps_fifo_HPS_to_FPGA_dual_clock_fifo is 
           port (
                 -- inputs:
                    signal aclr : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdclk : IN STD_LOGIC;
                    signal rdreq : IN STD_LOGIC;
                    signal wrclk : IN STD_LOGIC;
                    signal wrreq : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdempty : OUT STD_LOGIC;
                    signal rdfull : OUT STD_LOGIC;
                    signal rdusedw : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal wrempty : OUT STD_LOGIC;
                    signal wrfull : OUT STD_LOGIC;
                    signal wrusedw : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
                 );
end component soc_eq_solver_hps_fifo_HPS_to_FPGA_dual_clock_fifo;

  component altera_std_synchronizer is
GENERIC (
      depth : NATURAL
      );
    PORT (
    signal dout : OUT STD_LOGIC;
        signal clk : IN STD_LOGIC;
        signal reset_n : IN STD_LOGIC;
        signal din : IN STD_LOGIC
      );
  end component altera_std_synchronizer;
                signal internal_q :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_rdempty :  STD_LOGIC;
                signal internal_wrfull :  STD_LOGIC;
                signal module_input :  STD_LOGIC;
                signal rdclk_control_slave_almostempty_n_reg :  STD_LOGIC;
                signal rdclk_control_slave_almostempty_pulse :  STD_LOGIC;
                signal rdclk_control_slave_almostempty_signal :  STD_LOGIC;
                signal rdclk_control_slave_almostempty_threshold_register :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal rdclk_control_slave_almostfull_n_reg :  STD_LOGIC;
                signal rdclk_control_slave_almostfull_pulse :  STD_LOGIC;
                signal rdclk_control_slave_almostfull_signal :  STD_LOGIC;
                signal rdclk_control_slave_almostfull_threshold_register :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal rdclk_control_slave_empty_n_reg :  STD_LOGIC;
                signal rdclk_control_slave_empty_pulse :  STD_LOGIC;
                signal rdclk_control_slave_empty_signal :  STD_LOGIC;
                signal rdclk_control_slave_event_almostempty_q :  STD_LOGIC;
                signal rdclk_control_slave_event_almostempty_signal :  STD_LOGIC;
                signal rdclk_control_slave_event_almostfull_q :  STD_LOGIC;
                signal rdclk_control_slave_event_almostfull_signal :  STD_LOGIC;
                signal rdclk_control_slave_event_empty_q :  STD_LOGIC;
                signal rdclk_control_slave_event_empty_signal :  STD_LOGIC;
                signal rdclk_control_slave_event_full_q :  STD_LOGIC;
                signal rdclk_control_slave_event_full_signal :  STD_LOGIC;
                signal rdclk_control_slave_event_overflow_q :  STD_LOGIC;
                signal rdclk_control_slave_event_overflow_signal :  STD_LOGIC;
                signal rdclk_control_slave_event_register :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal rdclk_control_slave_event_underflow_q :  STD_LOGIC;
                signal rdclk_control_slave_event_underflow_signal :  STD_LOGIC;
                signal rdclk_control_slave_full_n_reg :  STD_LOGIC;
                signal rdclk_control_slave_full_pulse :  STD_LOGIC;
                signal rdclk_control_slave_full_signal :  STD_LOGIC;
                signal rdclk_control_slave_ienable_register :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal rdclk_control_slave_level_register :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal rdclk_control_slave_read_mux :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal rdclk_control_slave_status_almostempty_q :  STD_LOGIC;
                signal rdclk_control_slave_status_almostempty_signal :  STD_LOGIC;
                signal rdclk_control_slave_status_almostfull_q :  STD_LOGIC;
                signal rdclk_control_slave_status_almostfull_signal :  STD_LOGIC;
                signal rdclk_control_slave_status_empty_q :  STD_LOGIC;
                signal rdclk_control_slave_status_empty_signal :  STD_LOGIC;
                signal rdclk_control_slave_status_full_q :  STD_LOGIC;
                signal rdclk_control_slave_status_full_signal :  STD_LOGIC;
                signal rdclk_control_slave_status_overflow_q :  STD_LOGIC;
                signal rdclk_control_slave_status_overflow_signal :  STD_LOGIC;
                signal rdclk_control_slave_status_register :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal rdclk_control_slave_status_underflow_q :  STD_LOGIC;
                signal rdclk_control_slave_status_underflow_signal :  STD_LOGIC;
                signal rdclk_control_slave_threshold_writedata :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal rdfull :  STD_LOGIC;
                signal rdlevel :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal rdoverflow :  STD_LOGIC;
                signal rdreq_sync :  STD_LOGIC;
                signal rdunderflow :  STD_LOGIC;
                signal rdusedw :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal wrclk_control_slave_almostempty_n_reg :  STD_LOGIC;
                signal wrclk_control_slave_almostempty_pulse :  STD_LOGIC;
                signal wrclk_control_slave_almostempty_signal :  STD_LOGIC;
                signal wrclk_control_slave_almostempty_threshold_register :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal wrclk_control_slave_almostfull_n_reg :  STD_LOGIC;
                signal wrclk_control_slave_almostfull_pulse :  STD_LOGIC;
                signal wrclk_control_slave_almostfull_signal :  STD_LOGIC;
                signal wrclk_control_slave_almostfull_threshold_register :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal wrclk_control_slave_empty_n_reg :  STD_LOGIC;
                signal wrclk_control_slave_empty_pulse :  STD_LOGIC;
                signal wrclk_control_slave_empty_signal :  STD_LOGIC;
                signal wrclk_control_slave_event_almostempty_q :  STD_LOGIC;
                signal wrclk_control_slave_event_almostempty_signal :  STD_LOGIC;
                signal wrclk_control_slave_event_almostfull_q :  STD_LOGIC;
                signal wrclk_control_slave_event_almostfull_signal :  STD_LOGIC;
                signal wrclk_control_slave_event_empty_q :  STD_LOGIC;
                signal wrclk_control_slave_event_empty_signal :  STD_LOGIC;
                signal wrclk_control_slave_event_full_q :  STD_LOGIC;
                signal wrclk_control_slave_event_full_signal :  STD_LOGIC;
                signal wrclk_control_slave_event_overflow_q :  STD_LOGIC;
                signal wrclk_control_slave_event_overflow_signal :  STD_LOGIC;
                signal wrclk_control_slave_event_register :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal wrclk_control_slave_event_underflow_q :  STD_LOGIC;
                signal wrclk_control_slave_event_underflow_signal :  STD_LOGIC;
                signal wrclk_control_slave_full_n_reg :  STD_LOGIC;
                signal wrclk_control_slave_full_pulse :  STD_LOGIC;
                signal wrclk_control_slave_full_signal :  STD_LOGIC;
                signal wrclk_control_slave_ienable_register :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal wrclk_control_slave_level_register :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal wrclk_control_slave_read_mux :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal wrclk_control_slave_status_almostempty_q :  STD_LOGIC;
                signal wrclk_control_slave_status_almostempty_signal :  STD_LOGIC;
                signal wrclk_control_slave_status_almostfull_q :  STD_LOGIC;
                signal wrclk_control_slave_status_almostfull_signal :  STD_LOGIC;
                signal wrclk_control_slave_status_empty_q :  STD_LOGIC;
                signal wrclk_control_slave_status_empty_signal :  STD_LOGIC;
                signal wrclk_control_slave_status_full_q :  STD_LOGIC;
                signal wrclk_control_slave_status_full_signal :  STD_LOGIC;
                signal wrclk_control_slave_status_overflow_q :  STD_LOGIC;
                signal wrclk_control_slave_status_overflow_signal :  STD_LOGIC;
                signal wrclk_control_slave_status_register :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal wrclk_control_slave_status_underflow_q :  STD_LOGIC;
                signal wrclk_control_slave_status_underflow_signal :  STD_LOGIC;
                signal wrclk_control_slave_threshold_writedata :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal wrempty :  STD_LOGIC;
                signal wrlevel :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal wroverflow :  STD_LOGIC;
                signal wrreq_sync :  STD_LOGIC;
                signal wrreq_valid :  STD_LOGIC;
                signal wrunderflow :  STD_LOGIC;
                signal wrusedw :  STD_LOGIC_VECTOR (8 DOWNTO 0);

begin

  --the_dcfifo, which is an e_instance
  the_dcfifo : soc_eq_solver_hps_fifo_HPS_to_FPGA_dual_clock_fifo
    port map(
      q => internal_q,
      rdempty => internal_rdempty,
      rdfull => rdfull,
      rdusedw => rdusedw,
      wrempty => wrempty,
      wrfull => internal_wrfull,
      wrusedw => wrusedw,
      aclr => module_input,
      data => data,
      rdclk => rdclk,
      rdreq => rdreq,
      wrclk => wrclk,
      wrreq => wrreq_valid
    );

  module_input <= NOT ((rdreset_n AND wrreset_n));

  rdreq_sync_i : altera_std_synchronizer
    generic map(
      depth => 4
    )
    port map(
            clk => wrclk,
            din => rdreq,
            dout => rdreq_sync,
            reset_n => wrreset_n
    );

  wrdreq_sync_i : altera_std_synchronizer
    generic map(
      depth => 4
    )
    port map(
            clk => rdclk,
            din => wrreq,
            dout => wrreq_sync,
            reset_n => rdreset_n
    );

  wrlevel <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & wrusedw);
  wrreq_valid <= wrreq AND NOT internal_wrfull;
  wroverflow <= wrreq AND internal_wrfull;
  wrunderflow <= rdreq_sync AND wrempty;
  wrclk_control_slave_threshold_writedata <= A_EXT (A_WE_StdLogicVector(((wrclk_control_slave_writedata<std_logic_vector'("00000000000000000000000000000001"))), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector(((wrclk_control_slave_writedata>std_logic_vector'("00000000000000000000000111111100"))), std_logic_vector'("00000000000000000000000111111100"), (std_logic_vector'("0000000000000000000000") & (wrclk_control_slave_writedata(9 DOWNTO 0))))), 10);
  wrclk_control_slave_event_almostfull_signal <= wrclk_control_slave_almostfull_pulse;
  wrclk_control_slave_event_almostempty_signal <= wrclk_control_slave_almostempty_pulse;
  wrclk_control_slave_status_almostfull_signal <= wrclk_control_slave_almostfull_signal;
  wrclk_control_slave_status_almostempty_signal <= wrclk_control_slave_almostempty_signal;
  wrclk_control_slave_event_full_signal <= wrclk_control_slave_full_pulse;
  wrclk_control_slave_event_empty_signal <= wrclk_control_slave_empty_pulse;
  wrclk_control_slave_status_full_signal <= wrclk_control_slave_full_signal;
  wrclk_control_slave_status_empty_signal <= wrclk_control_slave_empty_signal;
  wrclk_control_slave_event_overflow_signal <= wroverflow;
  wrclk_control_slave_event_underflow_signal <= wrunderflow;
  wrclk_control_slave_status_overflow_signal <= wroverflow;
  wrclk_control_slave_status_underflow_signal <= wrunderflow;
  wrclk_control_slave_empty_signal <= wrempty;
  wrclk_control_slave_empty_pulse <= wrclk_control_slave_empty_signal AND wrclk_control_slave_empty_n_reg;
  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_empty_n_reg <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_empty_n_reg <= NOT(wrclk_control_slave_empty_signal);
    end if;

  end process;

  wrclk_control_slave_full_signal <= internal_wrfull;
  wrclk_control_slave_full_pulse <= wrclk_control_slave_full_signal AND wrclk_control_slave_full_n_reg;
  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_full_n_reg <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_full_n_reg <= NOT(wrclk_control_slave_full_signal);
    end if;

  end process;

  wrclk_control_slave_almostempty_signal <= to_std_logic((wrlevel<=wrclk_control_slave_almostempty_threshold_register));
  wrclk_control_slave_almostempty_pulse <= wrclk_control_slave_almostempty_signal AND wrclk_control_slave_almostempty_n_reg;
  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_almostempty_n_reg <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_almostempty_n_reg <= NOT(wrclk_control_slave_almostempty_signal);
    end if;

  end process;

  wrclk_control_slave_almostfull_signal <= to_std_logic((wrlevel>=wrclk_control_slave_almostfull_threshold_register));
  wrclk_control_slave_almostfull_pulse <= wrclk_control_slave_almostfull_signal AND wrclk_control_slave_almostfull_n_reg;
  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_almostfull_n_reg <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_almostfull_n_reg <= NOT(wrclk_control_slave_almostfull_signal);
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_almostempty_threshold_register <= std_logic_vector'("0000000001");
    elsif wrclk'event and wrclk = '1' then
      if std_logic'((to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000101")))) AND wrclk_control_slave_write)) = '1' then 
        wrclk_control_slave_almostempty_threshold_register <= wrclk_control_slave_threshold_writedata;
      end if;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_almostfull_threshold_register <= std_logic_vector'("0111111100");
    elsif wrclk'event and wrclk = '1' then
      if std_logic'((to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000100")))) AND wrclk_control_slave_write)) = '1' then 
        wrclk_control_slave_almostfull_threshold_register <= wrclk_control_slave_threshold_writedata;
      end if;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_ienable_register <= std_logic_vector'("000000");
    elsif wrclk'event and wrclk = '1' then
      if std_logic'((to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000011")))) AND wrclk_control_slave_write)) = '1' then 
        wrclk_control_slave_ienable_register <= wrclk_control_slave_writedata(5 DOWNTO 0);
      end if;
    end if;

  end process;

  wrclk_control_slave_level_register <= wrlevel;
  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_event_underflow_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      if std_logic'(((wrclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND wrclk_control_slave_writedata(5))) = '1' then 
        wrclk_control_slave_event_underflow_q <= std_logic'('0');
      elsif std_logic'(wrclk_control_slave_event_underflow_signal) = '1' then 
        wrclk_control_slave_event_underflow_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_event_overflow_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      if std_logic'(((wrclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND wrclk_control_slave_writedata(4))) = '1' then 
        wrclk_control_slave_event_overflow_q <= std_logic'('0');
      elsif std_logic'(wrclk_control_slave_event_overflow_signal) = '1' then 
        wrclk_control_slave_event_overflow_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_event_almostempty_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      if std_logic'(((wrclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND wrclk_control_slave_writedata(3))) = '1' then 
        wrclk_control_slave_event_almostempty_q <= std_logic'('0');
      elsif std_logic'(wrclk_control_slave_event_almostempty_signal) = '1' then 
        wrclk_control_slave_event_almostempty_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_event_almostfull_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      if std_logic'(((wrclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND wrclk_control_slave_writedata(2))) = '1' then 
        wrclk_control_slave_event_almostfull_q <= std_logic'('0');
      elsif std_logic'(wrclk_control_slave_event_almostfull_signal) = '1' then 
        wrclk_control_slave_event_almostfull_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_event_empty_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      if std_logic'(((wrclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND wrclk_control_slave_writedata(1))) = '1' then 
        wrclk_control_slave_event_empty_q <= std_logic'('0');
      elsif std_logic'(wrclk_control_slave_event_empty_signal) = '1' then 
        wrclk_control_slave_event_empty_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_event_full_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      if std_logic'(((wrclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND wrclk_control_slave_writedata(0))) = '1' then 
        wrclk_control_slave_event_full_q <= std_logic'('0');
      elsif std_logic'(wrclk_control_slave_event_full_signal) = '1' then 
        wrclk_control_slave_event_full_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  wrclk_control_slave_event_register <= Std_Logic_Vector'(A_ToStdLogicVector(wrclk_control_slave_event_underflow_q) & A_ToStdLogicVector(wrclk_control_slave_event_overflow_q) & A_ToStdLogicVector(wrclk_control_slave_event_almostempty_q) & A_ToStdLogicVector(wrclk_control_slave_event_almostfull_q) & A_ToStdLogicVector(wrclk_control_slave_event_empty_q) & A_ToStdLogicVector(wrclk_control_slave_event_full_q));
  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_status_underflow_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_status_underflow_q <= wrclk_control_slave_status_underflow_signal;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_status_overflow_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_status_overflow_q <= wrclk_control_slave_status_overflow_signal;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_status_almostempty_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_status_almostempty_q <= wrclk_control_slave_status_almostempty_signal;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_status_almostfull_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_status_almostfull_q <= wrclk_control_slave_status_almostfull_signal;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_status_empty_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_status_empty_q <= wrclk_control_slave_status_empty_signal;
    end if;

  end process;

  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_status_full_q <= std_logic'('0');
    elsif wrclk'event and wrclk = '1' then
      wrclk_control_slave_status_full_q <= wrclk_control_slave_status_full_signal;
    end if;

  end process;

  wrclk_control_slave_status_register <= Std_Logic_Vector'(A_ToStdLogicVector(wrclk_control_slave_status_underflow_q) & A_ToStdLogicVector(wrclk_control_slave_status_overflow_q) & A_ToStdLogicVector(wrclk_control_slave_status_almostempty_q) & A_ToStdLogicVector(wrclk_control_slave_status_almostfull_q) & A_ToStdLogicVector(wrclk_control_slave_status_empty_q) & A_ToStdLogicVector(wrclk_control_slave_status_full_q));
  wrclk_control_slave_read_mux <= (((((((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000000")))), 32) AND (std_logic_vector'("0000000000000000000000") & (wrclk_control_slave_level_register)))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000001")))), 32) AND (std_logic_vector'("00000000000000000000000000") & (wrclk_control_slave_status_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010")))), 32) AND (std_logic_vector'("00000000000000000000000000") & (wrclk_control_slave_event_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000011")))), 32) AND (std_logic_vector'("00000000000000000000000000") & (wrclk_control_slave_ienable_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000100")))), 32) AND (std_logic_vector'("0000000000000000000000") & (wrclk_control_slave_almostfull_threshold_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000101")))), 32) AND (std_logic_vector'("0000000000000000000000") & (wrclk_control_slave_almostempty_threshold_register))))) OR ((A_REP(to_std_logic(((((((NOT (((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000000")))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000001"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000011"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000100"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (wrclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000101")))))), 32) AND (std_logic_vector'("0000000000000000000000") & (wrclk_control_slave_level_register))));
  process (wrclk, wrreset_n)
  begin
    if wrreset_n = '0' then
      wrclk_control_slave_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif wrclk'event and wrclk = '1' then
      if std_logic'(wrclk_control_slave_read) = '1' then 
        wrclk_control_slave_readdata <= wrclk_control_slave_read_mux;
      end if;
    end if;

  end process;

  rdlevel <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & rdusedw);
  rdoverflow <= wrreq_sync AND rdfull;
  rdunderflow <= rdreq AND internal_rdempty;
  rdclk_control_slave_threshold_writedata <= A_EXT (A_WE_StdLogicVector(((rdclk_control_slave_writedata<std_logic_vector'("00000000000000000000000000000001"))), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector(((rdclk_control_slave_writedata>std_logic_vector'("00000000000000000000000111111100"))), std_logic_vector'("00000000000000000000000111111100"), (std_logic_vector'("0000000000000000000000") & (rdclk_control_slave_writedata(9 DOWNTO 0))))), 10);
  rdclk_control_slave_event_almostfull_signal <= rdclk_control_slave_almostfull_pulse;
  rdclk_control_slave_event_almostempty_signal <= rdclk_control_slave_almostempty_pulse;
  rdclk_control_slave_status_almostfull_signal <= rdclk_control_slave_almostfull_signal;
  rdclk_control_slave_status_almostempty_signal <= rdclk_control_slave_almostempty_signal;
  rdclk_control_slave_event_full_signal <= rdclk_control_slave_full_pulse;
  rdclk_control_slave_event_empty_signal <= rdclk_control_slave_empty_pulse;
  rdclk_control_slave_status_full_signal <= rdclk_control_slave_full_signal;
  rdclk_control_slave_status_empty_signal <= rdclk_control_slave_empty_signal;
  rdclk_control_slave_event_overflow_signal <= rdoverflow;
  rdclk_control_slave_event_underflow_signal <= rdunderflow;
  rdclk_control_slave_status_overflow_signal <= rdoverflow;
  rdclk_control_slave_status_underflow_signal <= rdunderflow;
  rdclk_control_slave_empty_signal <= internal_rdempty;
  rdclk_control_slave_empty_pulse <= rdclk_control_slave_empty_signal AND rdclk_control_slave_empty_n_reg;
  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_empty_n_reg <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_empty_n_reg <= NOT(rdclk_control_slave_empty_signal);
    end if;

  end process;

  rdclk_control_slave_full_signal <= rdfull;
  rdclk_control_slave_full_pulse <= rdclk_control_slave_full_signal AND rdclk_control_slave_full_n_reg;
  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_full_n_reg <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_full_n_reg <= NOT(rdclk_control_slave_full_signal);
    end if;

  end process;

  rdclk_control_slave_almostempty_signal <= to_std_logic((rdlevel<=rdclk_control_slave_almostempty_threshold_register));
  rdclk_control_slave_almostempty_pulse <= rdclk_control_slave_almostempty_signal AND rdclk_control_slave_almostempty_n_reg;
  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_almostempty_n_reg <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_almostempty_n_reg <= NOT(rdclk_control_slave_almostempty_signal);
    end if;

  end process;

  rdclk_control_slave_almostfull_signal <= to_std_logic((rdlevel>=rdclk_control_slave_almostfull_threshold_register));
  rdclk_control_slave_almostfull_pulse <= rdclk_control_slave_almostfull_signal AND rdclk_control_slave_almostfull_n_reg;
  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_almostfull_n_reg <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_almostfull_n_reg <= NOT(rdclk_control_slave_almostfull_signal);
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_almostempty_threshold_register <= std_logic_vector'("0000000001");
    elsif rdclk'event and rdclk = '1' then
      if std_logic'((to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000101")))) AND rdclk_control_slave_write)) = '1' then 
        rdclk_control_slave_almostempty_threshold_register <= rdclk_control_slave_threshold_writedata;
      end if;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_almostfull_threshold_register <= std_logic_vector'("0111111100");
    elsif rdclk'event and rdclk = '1' then
      if std_logic'((to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000100")))) AND rdclk_control_slave_write)) = '1' then 
        rdclk_control_slave_almostfull_threshold_register <= rdclk_control_slave_threshold_writedata;
      end if;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_ienable_register <= std_logic_vector'("000000");
    elsif rdclk'event and rdclk = '1' then
      if std_logic'((to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000011")))) AND rdclk_control_slave_write)) = '1' then 
        rdclk_control_slave_ienable_register <= rdclk_control_slave_writedata(5 DOWNTO 0);
      end if;
    end if;

  end process;

  rdclk_control_slave_level_register <= rdlevel;
  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_event_underflow_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      if std_logic'(((rdclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND rdclk_control_slave_writedata(5))) = '1' then 
        rdclk_control_slave_event_underflow_q <= std_logic'('0');
      elsif std_logic'(rdclk_control_slave_event_underflow_signal) = '1' then 
        rdclk_control_slave_event_underflow_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_event_overflow_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      if std_logic'(((rdclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND rdclk_control_slave_writedata(4))) = '1' then 
        rdclk_control_slave_event_overflow_q <= std_logic'('0');
      elsif std_logic'(rdclk_control_slave_event_overflow_signal) = '1' then 
        rdclk_control_slave_event_overflow_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_event_almostempty_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      if std_logic'(((rdclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND rdclk_control_slave_writedata(3))) = '1' then 
        rdclk_control_slave_event_almostempty_q <= std_logic'('0');
      elsif std_logic'(rdclk_control_slave_event_almostempty_signal) = '1' then 
        rdclk_control_slave_event_almostempty_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_event_almostfull_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      if std_logic'(((rdclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND rdclk_control_slave_writedata(2))) = '1' then 
        rdclk_control_slave_event_almostfull_q <= std_logic'('0');
      elsif std_logic'(rdclk_control_slave_event_almostfull_signal) = '1' then 
        rdclk_control_slave_event_almostfull_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_event_empty_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      if std_logic'(((rdclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND rdclk_control_slave_writedata(1))) = '1' then 
        rdclk_control_slave_event_empty_q <= std_logic'('0');
      elsif std_logic'(rdclk_control_slave_event_empty_signal) = '1' then 
        rdclk_control_slave_event_empty_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_event_full_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      if std_logic'(((rdclk_control_slave_write AND to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND rdclk_control_slave_writedata(0))) = '1' then 
        rdclk_control_slave_event_full_q <= std_logic'('0');
      elsif std_logic'(rdclk_control_slave_event_full_signal) = '1' then 
        rdclk_control_slave_event_full_q <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  rdclk_control_slave_event_register <= Std_Logic_Vector'(A_ToStdLogicVector(rdclk_control_slave_event_underflow_q) & A_ToStdLogicVector(rdclk_control_slave_event_overflow_q) & A_ToStdLogicVector(rdclk_control_slave_event_almostempty_q) & A_ToStdLogicVector(rdclk_control_slave_event_almostfull_q) & A_ToStdLogicVector(rdclk_control_slave_event_empty_q) & A_ToStdLogicVector(rdclk_control_slave_event_full_q));
  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_status_underflow_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_status_underflow_q <= rdclk_control_slave_status_underflow_signal;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_status_overflow_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_status_overflow_q <= rdclk_control_slave_status_overflow_signal;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_status_almostempty_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_status_almostempty_q <= rdclk_control_slave_status_almostempty_signal;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_status_almostfull_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_status_almostfull_q <= rdclk_control_slave_status_almostfull_signal;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_status_empty_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_status_empty_q <= rdclk_control_slave_status_empty_signal;
    end if;

  end process;

  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_status_full_q <= std_logic'('0');
    elsif rdclk'event and rdclk = '1' then
      rdclk_control_slave_status_full_q <= rdclk_control_slave_status_full_signal;
    end if;

  end process;

  rdclk_control_slave_status_register <= Std_Logic_Vector'(A_ToStdLogicVector(rdclk_control_slave_status_underflow_q) & A_ToStdLogicVector(rdclk_control_slave_status_overflow_q) & A_ToStdLogicVector(rdclk_control_slave_status_almostempty_q) & A_ToStdLogicVector(rdclk_control_slave_status_almostfull_q) & A_ToStdLogicVector(rdclk_control_slave_status_empty_q) & A_ToStdLogicVector(rdclk_control_slave_status_full_q));
  rdclk_control_slave_read_mux <= (((((((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000000")))), 32) AND (std_logic_vector'("0000000000000000000000") & (rdclk_control_slave_level_register)))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000001")))), 32) AND (std_logic_vector'("00000000000000000000000000") & (rdclk_control_slave_status_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010")))), 32) AND (std_logic_vector'("00000000000000000000000000") & (rdclk_control_slave_event_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000011")))), 32) AND (std_logic_vector'("00000000000000000000000000") & (rdclk_control_slave_ienable_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000100")))), 32) AND (std_logic_vector'("0000000000000000000000") & (rdclk_control_slave_almostfull_threshold_register))))) OR ((A_REP(to_std_logic((((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000101")))), 32) AND (std_logic_vector'("0000000000000000000000") & (rdclk_control_slave_almostempty_threshold_register))))) OR ((A_REP(to_std_logic(((((((NOT (((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000000")))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000001"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000010"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000011"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000100"))))) AND (NOT (((std_logic_vector'("00000000000000000000000000000") & (rdclk_control_slave_address)) = std_logic_vector'("00000000000000000000000000000101")))))), 32) AND (std_logic_vector'("0000000000000000000000") & (rdclk_control_slave_level_register))));
  process (rdclk, rdreset_n)
  begin
    if rdreset_n = '0' then
      rdclk_control_slave_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif rdclk'event and rdclk = '1' then
      if std_logic'(rdclk_control_slave_read) = '1' then 
        rdclk_control_slave_readdata <= rdclk_control_slave_read_mux;
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  q <= internal_q;
  --vhdl renameroo for output signals
  rdempty <= internal_rdempty;
  --vhdl renameroo for output signals
  wrfull <= internal_wrfull;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity soc_eq_solver_hps_fifo_HPS_to_FPGA is 
        port (
              -- inputs:
                 signal avalonmm_read_slave_read : IN STD_LOGIC;
                 signal avalonmm_write_slave_write : IN STD_LOGIC;
                 signal avalonmm_write_slave_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdclk_control_slave_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal rdclk_control_slave_read : IN STD_LOGIC;
                 signal rdclk_control_slave_write : IN STD_LOGIC;
                 signal rdclk_control_slave_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal rdclock : IN STD_LOGIC;
                 signal rdreset_n : IN STD_LOGIC;
                 signal wrclk_control_slave_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal wrclk_control_slave_read : IN STD_LOGIC;
                 signal wrclk_control_slave_write : IN STD_LOGIC;
                 signal wrclk_control_slave_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal wrclock : IN STD_LOGIC;
                 signal wrreset_n : IN STD_LOGIC;

              -- outputs:
                 signal avalonmm_read_slave_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal avalonmm_read_slave_waitrequest : OUT STD_LOGIC;
                 signal avalonmm_write_slave_waitrequest : OUT STD_LOGIC;
                 signal rdclk_control_slave_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal wrclk_control_slave_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity soc_eq_solver_hps_fifo_HPS_to_FPGA;


architecture europa of soc_eq_solver_hps_fifo_HPS_to_FPGA is
component soc_eq_solver_hps_fifo_HPS_to_FPGA_dcfifo_with_controls is 
           port (
                 -- inputs:
                    signal data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdclk : IN STD_LOGIC;
                    signal rdclk_control_slave_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal rdclk_control_slave_read : IN STD_LOGIC;
                    signal rdclk_control_slave_write : IN STD_LOGIC;
                    signal rdclk_control_slave_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdreq : IN STD_LOGIC;
                    signal rdreset_n : IN STD_LOGIC;
                    signal wrclk : IN STD_LOGIC;
                    signal wrclk_control_slave_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal wrclk_control_slave_read : IN STD_LOGIC;
                    signal wrclk_control_slave_write : IN STD_LOGIC;
                    signal wrclk_control_slave_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal wrreq : IN STD_LOGIC;
                    signal wrreset_n : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdclk_control_slave_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rdempty : OUT STD_LOGIC;
                    signal wrclk_control_slave_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal wrfull : OUT STD_LOGIC
                 );
end component soc_eq_solver_hps_fifo_HPS_to_FPGA_dcfifo_with_controls;

                signal data :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_rdclk_control_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_wrclk_control_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal q :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal rdclk :  STD_LOGIC;
                signal rdempty :  STD_LOGIC;
                signal rdreq :  STD_LOGIC;
                signal wrclk :  STD_LOGIC;
                signal wrfull :  STD_LOGIC;
                signal wrreq :  STD_LOGIC;

begin

  --the_dcfifo_with_controls, which is an e_instance
  the_dcfifo_with_controls : soc_eq_solver_hps_fifo_HPS_to_FPGA_dcfifo_with_controls
    port map(
      q => q,
      rdclk_control_slave_readdata => internal_rdclk_control_slave_readdata,
      rdempty => rdempty,
      wrclk_control_slave_readdata => internal_wrclk_control_slave_readdata,
      wrfull => wrfull,
      data => data,
      rdclk => rdclk,
      rdclk_control_slave_address => rdclk_control_slave_address,
      rdclk_control_slave_read => rdclk_control_slave_read,
      rdclk_control_slave_write => rdclk_control_slave_write,
      rdclk_control_slave_writedata => rdclk_control_slave_writedata,
      rdreq => rdreq,
      rdreset_n => rdreset_n,
      wrclk => wrclk,
      wrclk_control_slave_address => wrclk_control_slave_address,
      wrclk_control_slave_read => wrclk_control_slave_read,
      wrclk_control_slave_write => wrclk_control_slave_write,
      wrclk_control_slave_writedata => wrclk_control_slave_writedata,
      wrreq => wrreq,
      wrreset_n => wrreset_n
    );


  --in, which is an e_avalon_slave
  --out, which is an e_avalon_slave
  data <= avalonmm_write_slave_writedata;
  wrreq <= avalonmm_write_slave_write;
  avalonmm_read_slave_readdata <= q;
  rdreq <= avalonmm_read_slave_read;
  rdclk <= rdclock;
  wrclk <= wrclock;
  avalonmm_write_slave_waitrequest <= wrfull;
  avalonmm_read_slave_waitrequest <= rdempty;
  --in_csr, which is an e_avalon_slave
  --out_csr, which is an e_avalon_slave
  --vhdl renameroo for output signals
  rdclk_control_slave_readdata <= internal_rdclk_control_slave_readdata;
  --vhdl renameroo for output signals
  wrclk_control_slave_readdata <= internal_wrclk_control_slave_readdata;

end europa;

