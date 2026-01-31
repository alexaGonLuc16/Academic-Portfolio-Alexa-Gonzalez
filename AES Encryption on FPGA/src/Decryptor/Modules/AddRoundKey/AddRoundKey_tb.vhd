---------------------------------------------------------------
-- Company: ITESM - Campus Qro.entity
-- Author: Alexa Jimena González Lucio
--         Brisa Itzel Reyes Castro
-- Date: 22/04/2024
-- Desing: ROM 16x4
-- Description:  Add Round Key for Decryption / Test bench 1
-- Tool Version: Altera Quartus Lite v21.2 build 842
-- Target Device: DE10-Lite (Terasic.com)
-- Version: 1.0
---------------------------------------------------------------
-- Library and Packages usage definition
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity AddRoundKey_tb is
end AddRoundKey_tb;

architecture InvAddRoundKey_Arch of AddRoundKey_tb is
  -- Component declaration
  component AddRoundKey
    Port (
      Clk     : in     std_logic;
      Start   : in     std_logic;
      Finish  : out    std_logic;
      DataIn  : in     std_logic_vector (127 downto 0);
      DataOut : out    std_logic_vector (127 downto 0)
    );
  end component;

  -- Constants
  
  constant CLK_PERIOD    : time := 10 ns;  -- clock period (10 ns)
  constant SIM_TIME      : time := 100 us; -- Simulation duration (100 µs)

  -- Signals
  signal Clk       : std_logic := '0';
  signal Start     : std_logic := '0';
  signal Finish    : std_logic;
  signal DataIn    : std_logic_vector(127 downto 0):= "00111001" & "00000010" & "11011100" & "00011001" &
																		"00100101" & "11011100" & "00010001" & "01101010" &
																		"10000100" & "00001001" & "10000101" & "00001011" &
																		"00011101" & "11111011" & "10010111" & "00110010";

  signal Key       : std_logic_vector (127 downto 0):= "11010000" & "11001001" & "11100001" & "10110000" &
																     	 "00010100" & "11101110" & "00111111" & "01100011" &
																	    "11111001" & "00100101" & "00001100" & "00001100" &
																	  	 "10101000" & "10001001" & "11001000" & "10100110";
	signal DataOut   : std_logic_vector(127 downto 0);
	
begin
  -- Instantiate the Unit Under Test (UUT)
  uut: AddRoundKey
    port map (
      Clk     => Clk,
      Start   => Start,
      Finish  => Finish,
      DataIn  => DataIn,
      DataOut => DataOut
    );

  -- Clock process
  Clk_Process: process
  begin
    while now < SIM_TIME loop
      Clk <= '0';
      wait for CLK_PERIOD / 2;  --Wait half of the clock period (5 ns).
      Clk <= '1';
      wait for CLK_PERIOD / 2;  --Wait half of the clock period (5 ns).
    end loop;
    wait;  -- wait till the end of simulation
  end process;

  -- Stimulus process
  Stimulus: process
  begin
	--- hold reset state for 100ns, always include the following statement
	wait for 100 ns;
	
 -- input values
	Start <= '1';
   DataIn <="00111001" & "00000010" & "11011100" & "00011001" &
				"00100101" & "11011100" & "00010001" & "01101010" &
				"10000100" & "00001001" & "10000101" & "00001011" &
				"00011101" & "11111011" & "10010111" & "00110010";
				
  
    wait for 20 ns;

    wait;
  end process;

end InvAddRoundKey_Arch;