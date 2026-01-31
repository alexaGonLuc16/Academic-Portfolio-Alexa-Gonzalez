----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2024
-- Author: 				Ricard Catala Garfias
-- Create Date: 		16/04/2024
-- Design Name: 		Add Round TestBench
-- Module Name:		Add Round Module TestBench
-- Target Devices: 	DE10-Lite
-- Description: 		TestBench del módulo Add Round
--
-- Version 1.2 - File Creation
-- Additional Comments: 
--
----------------------------------------------------------------------------------
-- Commonly used libraries
library ieee; 
use ieee.std_logic_1164.all;
-- Packages use for arithmetic operations
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Testbench entity does not include any Port definition
entity AddRoundKey_tb is
end entity AddRoundKey_tb;

architecture testbench of AddRoundKey_tb is
    -- Component to be simulated declaration
     -- Use exactly the same names used in the entity section
    component AddRoundKey
        Port (
            -- Input ports
			  TxtIn : in std_logic_vector(127 downto 0);
			  KeyIn : in std_logic_vector(127 downto 0);
			  Clk : in std_logic;
			  start : in std_logic;
			  Rst : in std_logic;
			  -- Output ports
			  TxtOut: out std_logic_vector(127 downto 0);
			  Finish : out std_logic
        );
    end component;

    -- Declare the input, output and clock signals used to instantiate the DUT
     -- Input Signals for test bench
    signal Clk_tb     : std_logic := '0';
    signal Rst_tb     : std_logic := '0';
    signal start_tb  : std_logic := '0';
    signal TxtIn_tb  : std_logic_vector(127 downto 0) := (others => '0');
	 signal KeyIn_tb : std_logic_vector(127 downto 0) := (others => '0');
   
    -- Output Signals for test bench
    signal Finish_tb  : std_logic;
    signal TxtOut_tb : std_logic_vector(127 downto 0);
     
     -- Clock period definitions
    constant Clk_period : time := 100 ns;

begin
    -- Instantiate the ShiftRows component
    uut : AddRoundKey
        port map (
				TxtIn  => TxtIn_tb,
				KeyIn => KeyIn_tb,
            Clk     => Clk_tb,
				start  => start_tb,
            Rst     => Rst_tb,
            TxtOut => TxtOut_tb,
				Finish  => Finish_tb
        );

   -- Clock process to define its waveform, no sensitivity list
   Clk_process: process
   begin
        Clk_tb <= '0';
        wait for Clk_period/2;
        Clk_tb <= '1';
        wait for Clk_period/2;
   end process;

    -- Stimulus process (test cases)
	 
	 -- Test process
    process
    begin
       -- hold Rst state for 100 ns.
        Rst_tb    <= '1';
      wait for Clk_period;

      -- Input data
			--test1
        TxtIn_tb <= x"3243f6a8885a308d313198a2e0370734";
		  KeyIn_tb <= x"2b7e151628aed2a6abf7158809cf4f3c";
		  
		  --test2
		  --TxtIn_tb <= x"00112233445566778899aabbccddeeff";
		  --KeyIn_tb <= x"000102030405060708090a0b0c0d0e0f";
		  
		  --test3 
		  --TxtIn_tb <= x"046681e5e0cb199a48f8d37a2806264c";
		  --KeyIn_tb <= x"a0fafe1788542cb123a339392a6c7605";
		  
		  --test4
		  --TxtIn_tb <= x"584dcad11b4b5aacdbe7caa81b6bb0e5";
		  --KeyIn_tb <= x"f2c295f27a96b9435935807a7359f67f";
		  --test5
		  --TxtIn_tb <= x"75ec0993200b633353c0cf7cbb25d0dc";
		  --KeyIn_tb <= x"3d80477d4716fe3e1e237e446d7a883b";
		  
        Rst_tb    <= '0';
        start_tb <= '1'; -- Signal from Master FSM to start transfomation
      wait for 200 ns;
          
        -- Master FSM sends an acknowledge signal to send Finish signal back to '0'
        start_tb <= '0';
        wait for 100 ns;

      wait; -- Continue until end of simulation time
    end process;

end architecture testbench;
