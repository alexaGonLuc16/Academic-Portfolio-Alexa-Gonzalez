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

library ieee; 
use ieee.std_logic_1164.all;
-- Packages use for arithmetic operations
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Testbench entity does not include any Port definition
entity ShiftRows_tb is
end entity ShiftRows_tb;

architecture testbench of ShiftRows_tb is
    -- Component to be simulated declaration
    component ShiftRows
        Port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            enable : in  std_logic;
            finish : out std_logic;
            DataIn : in  std_logic_vector(127 downto 0);
            DataOut: out std_logic_vector(127 downto 0)
        );
    end component;

    -- Declare the input, output and clock signals used to instantiate the DUT
     -- Input Signals for test bench
    signal clk_tb     : std_logic := '0';
    signal rst_tb     : std_logic := '0';
    signal enable_tb  : std_logic := '0';
    signal DataIn_tb  : std_logic_vector(127 downto 0) := (others => '0');
   
    -- Output Signals for test bench
    signal finish_tb  : std_logic;
    signal DataOut_tb : std_logic_vector(127 downto 0);
     
     -- Clock period definitions
    constant clk_period : time := 100 ns;

begin
    -- Instantiate the ShiftRows component
    uut : ShiftRows
        port map (
            clk     => clk_tb,
            rst     => rst_tb,
            enable  => enable_tb,
            finish  => finish_tb,
            DataIn  => DataIn_tb,
            DataOut => DataOut_tb
        );

   -- Clock process to define its waveform, no sensitivity list
   clk_process: process
   begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
   end process;

-- Stimulus process (test cases)
process
begin
    -- hold reset state for 100 ns.
    rst_tb    <= '1';
    wait for clk_period;

    -- Input data, case 1
    -- BEGIN: Case 1
    DataIn_tb <= x"13a77b8100c19ef63f2c0dde4c60303a";
    rst_tb    <= '0';
    enable_tb <= '1'; -- Signal from Master FSM to start transformation
    wait for 200 ns;
    
    -- Master FSM sends an acknowledge signal to send finish signal back to '0'
    enable_tb <= '0';
    wait for 100 ns;

    wait; -- Continue until end of simulation time
    --End: Case 1
		
--		-- Input data, case 2
--		-- BEGIN: Case 2
--        DataIn_tb <= x"72ed6c83al2806d85755fa4d9d953b0c";
--        rst_tb    <= '0';
--        enable_tb <= '1'; -- Signal from Master FSM to start transfomation
--      wait for 200 ns;
--          
--        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
--        enable_tb <= '0';
--        wait for 100 ns;

		  
--      wait; -- Continue until end of simulation time
--		--End: Case 2
		
		-- Input data, case 3
--		-- BEGIN: Case 3
--        DataIn_tb <= x"f5c98952bda3bb6347f1c0bb33714742";
--        rst_tb    <= '0';
--        enable_tb <= '1'; -- Signal from Master FSM to start transfomation
--      wait for 200 ns;
--          
--        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
--        enable_tb <= '0';
--        wait for 100 ns;
		
--
--      wait; -- Continue until end of simulation time
--		--End: Case 3
		
		-- Input data, case 4
--		-- BEGIN: Case 4
--        DataIn_tb <= x"abcdef0123456789abcdef0123456789";
--        rst_tb    <= '0';
--        enable_tb <= '1'; -- Signal from Master FSM to start transfomation
--      wait for 200 ns;
--          
--        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
--        enable_tb <= '0';
--        wait for 100 ns;

--
--      wait; -- Continue until end of simulation time
--		--End: Case 4
		
    end process;

end architecture testbench;
