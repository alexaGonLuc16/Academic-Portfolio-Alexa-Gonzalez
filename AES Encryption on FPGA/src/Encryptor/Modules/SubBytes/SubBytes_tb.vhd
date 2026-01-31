----------------------------------------------------------------------------------
-- Company:             ITESM - IRS 2024
-- Engineer:       		Arturo Lopez García
-- Create Date:         21/04/2024
-- Design Name:         Sub Bytes
-- Module Name:         Sub Bytes Module
-- Target Devices:      DE10-Lite
-- Description:         Sub Bytes Module
--
-- Version 1.0.3
-- Additional Comments: 
--
----------------------------------------------------------------------------------

-- Commonly used libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity declaration
entity SubBytes_tb is
end entity SubBytes_tb;

-- Architecture definition
architecture testbench of SubBytes_tb is
  component SubBytes is
    port (
      TxtIn : in std_logic_vector(127 downto 0);
      Start  : in std_logic;
      Clk    : in std_logic;
      Rst    : in std_logic;
      Finish : out std_logic;
      TxtOut : out std_logic_vector(127 downto 0)
    );
  end component;
  
  -- Declare the input, output, and clock signals used to instantiate the DUT
  signal clk_tb    : std_logic := '0';  -- Testbench clock signal
  signal rst_tb    : std_logic := '0';  -- Testbench reset signal
  signal Start_tb  : std_logic := '0';  -- Start signal to DUT
  signal TxtIn_tb : std_logic_vector(127 downto 0) := (others => '0');  -- Test data
  
  -- Output Signals for test bench
  signal Finish_tb : std_logic;  -- Finish signal from DUT
  signal TxtOut_tb : std_logic_vector(127 downto 0);  -- Output data from DUT
   
  constant clk_period : time := 100 ns;  -- Clock period for simulation

begin
  uut: SubBytes 
    port map (
      TxtIn => TxtIn_tb,
      Start  => Start_tb,
      Clk    => clk_tb,
      Rst    => rst_tb,
      Finish => Finish_tb,
      TxtOut => TxtOut_tb
    );

  clk_process: process
  begin
      clk_tb <= not clk_tb after clk_period/2; -- Clock generation
      wait for clk_period/2;
  end process;
  
  -- Stimulus process (test cases)
  stimulus_process: process
  begin
    -- Hold reset state for a few clock cycles.
    rst_tb <= '1';
    wait for clk_period * 5; -- Adjusted for 5 clock cycles

    -- Release reset
    rst_tb <= '0';
    wait for clk_period;

    -- Input data
    TxtIn_tb <= x"D4E0B81E27BFB44111985D52AEF1E530";

    -- Start operation
    Start_tb <= '1'; 
    wait for clk_period * 2; -- Adjusted for 2 clock cycles

    -- End operation
    Start_tb <= '0'; 
    wait for clk_period * 5; -- Adjusted for 5 clock cycles

    wait; -- Continue until end of simulation time
  end process;

end architecture testbench;

