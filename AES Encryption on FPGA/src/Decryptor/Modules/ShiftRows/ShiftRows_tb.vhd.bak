----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2024
-- 
-- Create Date: 		17/04/2024
-- Design Name: 		Shift Row TestBench
-- Module Name:		Shift Row Module TestBench
-- Target Devices: 	DE10-Lite
-- Description: 		TestBench del módulo Shift Row 
--
-- Version 0.0 - File Creation
-- Additional Comments: 
--
----------------------------------------------------------------------------------

-- Commonly used libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Entity declaration for testbench
entity ShiftRows_tb is
end ShiftRows_tb;

-- Architecture definition for testbench
architecture tb_architecture of ShiftRows_tb is

     -- Component declaration for DUT (Device Under Test)
    component ShiftRows
        Port (
            input_port_1 : in std_logic;
            input_port_2 : in std_logic;
            output_port_1 : out std_logic;
            output_port_2 : out std_logic
        );
    end component;

    -- Signals declaration
    signal input_port_1_tb : std_logic := '0';  -- Test input signals
    signal input_port_2_tb : std_logic := '0';
    signal output_port_1_tb : std_logic;  -- Test output signals
    signal output_port_2_tb : std_logic;
	 
	 -- Constants declaration
    constant CLK_PERIOD : time := 10 ns;  -- Clock period (adjust as needed)

	-- Instantiate the DUT
    begin
        dut: ShiftRows
            port map (
                input_port_1 => input_port_1_tb,
                input_port_2 => input_port_2_tb,
                output_port_1 => output_port_1_tb,
                output_port_2 => output_port_2_tb
            );
	 
    -- Clock process
	process
	begin
		 while now < 1000 ns loop  -- Simulate for 1000 ns
			  wait for CLK_PERIOD / 2;
			  input_port_1_tb <= not input_port_1_tb;  -- Toggle the clock
		 end loop;
		 wait;
	end process;



    -- Stimulus process
    process
    begin
        -- Stimulus generation here
        -- You can write test vectors or any stimuli for your inputs here
        -- Example:
        input_port_2_tb <= '0';
        wait for 20 ns;
        input_port_2_tb <= '1';
        wait for 40 ns;
        input_port_2_tb <= '0';
        wait;
    end process;

    
end architecture tb_architecture;