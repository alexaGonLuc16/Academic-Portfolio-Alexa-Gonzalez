----------------------------------------------------------------------------------
-- Company: 		 ITESM - Campus Qro.
-- Engineer: 		 Zoé y Helena
-- 
-- Create Date:    19/04/2024 
-- Design Name: 	 MixColumns_v1
-- Module Name:    Mix Columns - Behavioral 
-- Project Name: 	 AES (Encriptador)
-- Target Devices: DE10-Lite (Terasic.com)
-- Tool versions:  Altera Quartus Lite v21.2 build 842
-- Description: 	 Implementation of Mix Columns Module for AES
--
-- Version: 		 2.0 
-- Note: 			 This is the Testbench file for the Mix Columns Module for AES
----------------------------------------------------------------------------------

-- Commonly used libraries
library IEEE;                       -- VHDL standard library
use IEEE.STD_LOGIC_1164.ALL;        -- Package providing basic data types and logic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;    -- Package providing unsigned arithmetic

-- Entity for the device that will be simulated
entity MixColumns_tb is
end MixColumns_tb;

-- Architecture for the device to be simulated
architecture behavior of MixColumns_tb is
	 -- Component that will be simulated is declared as a component
    component MixColumns
        port(
            Clk 	 : in STD_LOGIC;
				Rst	 : in STD_LOGIC;
				Start	 : in STD_LOGIC;
				TxtIn  : in STD_LOGIC_VECTOR (127 downto 0);
				Finish : out STD_LOGIC;
				TxtOut : out STD_LOGIC_VECTOR (127 downto 0)
        );
    end component;

	 -- Embedded signals that will be used to establish a connection with the component to be simulated
    -- Declare the input, output, and clock signals used to instantiate the DUT
    signal Clk    : std_logic := '0';
	 signal Rst		: std_logic := '0';
	 signal Start  : std_logic := '0';
    signal TxtIn  : std_logic_vector(127 downto 0);

    -- Output Signals for Test Bench	 
	 signal Finish : std_logic;
    signal TxtOut : std_logic_vector(127 downto 0);
	 
	 -- Clk Period
	 constant Clk_period : time := 20 ns; -- Clock constant declaration


begin
    -- Clock process definitions
    Clk_process : process
    begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
    end process;


	 -- Instantiate the component that will be simulated
    dut: MixColumns port map (
        Clk    => Clk,
		  Rst    => Rst,
		  Start  => Start,
        TxtIn  => TxtIn,
		  Finish => Finish,
        TxtOut => TxtOut
    );

    process
    begin
	 
        -- Initialize inputs
        Rst <= '1';
        Start <= '0';
        TxtIn <= (others => '0');
        wait for Clk_period * 2; -- Wait for the system to reset

        Rst <= '0';
        Start <= '1'; -- Start processing

        -- Set the Test Matrix
        TxtIn <= x"d4e0b81ebfb441275d52119830aef1e5";		-- Test Matrix 1
		  --TxtIn <= x"1A2B3C4D5E6F708192A3B4C5D6E7F809";  -- Test Matrix 2
		  --TxtIn <= x"EFBEADDEEDCAFE123456789ABCDEF010"; 	-- Test Matrix 3
        wait for Clk_period * 10; -- Wait for enough clock cycles for processing to potentially complete

        Start <= '0'; -- Disable further processing


		  -- End test cases with a wait statement.
        wait;

    end process;
end behavior;


