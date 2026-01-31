----------------------------------------------------------------------------------
-- Company:          ITESM - IRS 2024
-- Authors:          Tomás Pérez Vera, Ulises Carrizalez Lerín
-- Create Date:      21/04/2024
-- Design Name:      ShiftRow_tb
-- Module Name:      ShiftRow Testbench
-- Target Devices:   DE10-Lite
-- Description:      ShiftRow Component for the AES Encryptor
--
-- Version 3.0 - File Creation
----------------------------------------------------------------------------------

-- Commonly used libraries
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
     -- Use exactly the same names used in the entity section
    component ShiftRows
        Port (
            Clk    : in  std_logic;
            Rst    : in  std_logic;
            Start : in  std_logic;
            Finish : out std_logic;
            TxtIn : in  std_logic_vector(127 downto 0);
            TxtOut: out std_logic_vector(127 downto 0)
        );
    end component;

    -- Declare the input, output and clock signals used to instantiate the DUT
     -- Input Signals for test bench
    signal Clk_tb     : std_logic := '0';
    signal Rst_tb     : std_logic := '0';
    signal Start_tb  : std_logic := '0';
    signal TxtIn_tb  : std_logic_vector(127 downto 0) := (others => '0');
   
    -- Output Signals for test bench
    signal Finish_tb  : std_logic;
    signal TxtOut_tb : std_logic_vector(127 downto 0);
     
     -- Clock period definitions
    constant clk_period : time := 100 ns;

begin
    -- Instantiate the ShiftRows component
    uut : ShiftRows
        port map (
            Clk     => Clk_tb,
            Rst     => Rst_tb,
            Start   => Start_tb,
            Finish  => Finish_tb,
            TxtIn   => TxtIn_tb,
            TxtOut  => TxtOut_tb
        );

   -- Clock process to define its waveform, no sensitivity list
   clk_process: process
   begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for  clk_period/2;
   end process;

    -- Stimulus process (test cases)
    process
    begin
       -- hold reset state for 100 ns.
        Rst_tb    <= '1';
      wait for clk_period;
		
      -- Input data, case 1
		-- BEGIN: Case 1
        TxtIn_tb <= x"D4E0B81E27BFB44111985D52AEF1E530";
        Rst_tb    <= '0';
        Start_tb <= '1'; -- Signal from Master FSM to start transfomation
      wait for 200 ns;
          
        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
        Start_tb <= '0';
        wait for 100 ns;

      wait; -- Continue until end of simulation time
		--End: Case 1
		
--		-- Input data, case 2
--		-- BEGIN: Case 2
--        TxtIn_tb <= x"0123456789ABCDEF0123456789ABCDEF";
--        Rst_tb    <= '0';
--        Start_tb <= '1'; -- Signal from Master FSM to start transfomation
--      wait for 200 ns;
--          
--        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
--        Start_tb <= '0';
--        wait for 100 ns;
--
--      wait; -- Continue until end of simulation time
--		--End: Case 2
		
		-- Input data, case 3
--		-- BEGIN: Case 3
--        TxtIn_tb <= x"FEDCBA9876543210FEDCBA9876543210";
--        Rst_tb    <= '0';
--        Start_tb <= '1'; -- Signal from Master FSM to start transfomation
--      wait for 200 ns;
--          
--        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
--        Start_tb <= '0';
--        wait for 100 ns;
--
--      wait; -- Continue until end of simulation time
--		--End: Case 3
		
		-- Input data, case 4
--		-- BEGIN: Case 4
--        DataIn_tb <= x"ABCDEF0123456789ABCDEF0123456789";
--        Rst_tb    <= '0';
--        Start_tb <= '1'; -- Signal from Master FSM to start transfomation
--      wait for 200 ns;
--          
--        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
--        Start_tb <= '0';
--        wait for 100 ns;
--
--      wait; -- Continue until end of simulation time
--		--End: Case 4
		
		-- Input data, case 5
--		-- BEGIN: Case 4
--        TxtIn_tb <= x"0246813579ACEBDF0246813579ACEBDF";
--        Rst_tb    <= '0';
--        Start_tb <= '1'; -- Signal from Master FSM to start transfomation
--      wait for 200 ns;
--          
--        -- Master FSM sends an acknowledge signal to send finish signal back to '0'
--        Start_tb <= '0';
--        wait for 100 ns;
--
--      wait; -- Continue until end of simulation time
--		--End: Case 5

    end process;

end architecture testbench;
