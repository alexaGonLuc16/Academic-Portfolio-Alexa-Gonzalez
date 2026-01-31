----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2024
-- 
-- Create Date: 		17/04/2024
-- Design Name: 		Sub Bytes TestBench
-- Module Name:		Sub Bytes Module TestBench
-- Target Devices: 	DE10-Lite
-- Description: 		TestBench del módulo Sub Bytes
--
-- Version 0.0 - File Creation
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
      sbIn : in std_logic_vector(127 downto 0);
      start_DECSubBytes  : in std_logic;
      Clk    : in std_logic;
      reset    : in std_logic;
      finish_DECSubBytes : out std_logic;
      sbOut : out std_logic_vector(127 downto 0)
    );
  end component;
  
  -- Declare the input, output, and clock signals used to instantiate the DUT
  signal DECclk_tb    : std_logic := '0';  -- Testbench clock signal
  signal DECrst_tb    : std_logic := '0';  -- Testbench reset signal
  signal DECstart_tb  : std_logic := '0';  -- Start signal to DUT
  signal DECsbIn_tb : std_logic_vector(127 downto 0) := (others => '0');  -- Test data
  
  -- Output Signals for test bench
  signal DECfinish_tb : std_logic;  -- Finish signal from DUT
  signal DECsbOut_tb : std_logic_vector(127 downto 0);  -- Output data from DUT
   
  constant clk_period : time := 100 ns;  -- Clock period for simulation

begin
  uut: SubBytes 
    port map (
      sbIn => DECsbIn_tb,
      start_DECSubBytes  => DECstart_tb,
      Clk    => DECclk_tb,
      reset    => DECrst_tb,
      finish_DECSubBytes => DECfinish_tb,
      sbOut => DECsbOut_tb
    );

  clk_process: process
  begin
      DECclk_tb <= not DECclk_tb after clk_period/2; -- Clock generation
      wait for clk_period/2;
  end process;
  
  -- Stimulus process (test cases)
  stimulus_P: process
  begin
    -- Hold reset state for a few clock cycles.
    DECrst_tb <= '1';
    wait for clk_period * 5; -- Adjusted for 5 clock cycles

    -- Release reset
    DECrst_tb <= '0';
    wait for clk_period;

    -- Input data
	 -- First Case
    --DECsbIn_tb <= x"D4E0B81E27BFB44111985D52AEF1E530";
	 
	 --Second Case
	 --DECsbIn_tb <= x"52096AD53036A538BF40A39E81F3D7FB";
	 
	 --Third Case
	   DECsbIn_tb <= x"E63749BAB7DFA44CF286E4A2E218754A";

    -- Start operation
    DECstart_tb <= '1'; 
    wait for clk_period * 2; -- Adjusted for 2 clock cycles

    -- End operation
    DECstart_tb <= '0'; 
    wait for clk_period * 5; -- Adjusted for 5 clock cycles

    wait; -- Continue until end of simulation time
  end process;

end architecture testbench;



