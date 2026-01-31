----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2024
-- 
-- Create Date: 		17/04/2024
-- Design Name: 		Mix Column TestBench
-- Module Name:		Mix Column Module TestBench
-- Target Devices: 	DE10-Lite
-- Description: 		TestBench del módulo Mix Column 
--
-- Version 0.0 - File Creation
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MixColumns_tb is
end MixColumns_tb;

architecture behavior of MixColumns_tb is
    component MixColumns
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC; -- Reset signal
            enable : in STD_LOGIC; -- Enable signal
            state_in : in STD_LOGIC_VECTOR (127 downto 0);
            state_out : out STD_LOGIC_VECTOR (127 downto 0);
            finish : out STD_LOGIC -- Signal to indicate completion
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal enable : std_logic;
    signal state_in : std_logic_vector(127 downto 0);
    signal state_out : std_logic_vector(127 downto 0);
    signal finish : std_logic;
	 
    constant clk_period : time := 20 ns; -- Clock period declaration

begin
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    uut: MixColumns port map (
        clk => clk,
        rst => rst,
        enable => enable,
        state_in => state_in,
        state_out => state_out,
        finish => finish
    );

    stim_proc: process
    begin
        -- Initialize inputs
        rst <= '1';
        enable <= '0';
        state_in <= (others => '0');
        wait for clk_period * 2; -- Wait for the system to reset

        rst <= '0';
        enable <= '1'; -- Enable processing

        -- Set the test matrix
        state_in <= x"D4BF5D30E0B452AEB84111F11E2798E5"; -- Test matrix input
		  --state_in <= x"1A2B3C4D5E6F708192A3B4C5D6E7F809";  --Matriz prueba 2
		  --state_in <= x"EFBEADDEEDCAFE123456789ABCDEF010"; --Matriz prueba 3
        wait for clk_period * 10; -- Wait for enough clock cycles for processing to potentially complete

        enable <= '0'; -- Disable further processing

        -- Check the result only after the finish signal is asserted
        wait until finish = '1';
        assert state_out = x"79EB2A2A5417705EB20BE9D6889146D5"
		  --assert state_out = x"84CBDC4385FA3D72B2F53A7BD81F5097"; --Matriz prueba 2
	     --assert state_out = x"1CADC8F386E48D132BB8532B1651DEDF"; --Matriz prueba 3
            report "Test failed: output does not match expected value"
            severity error;

        -- Optionally, add more tests here or re-enable with different data

        -- Terminate simulation
        wait;
    end process;
end behavior;
